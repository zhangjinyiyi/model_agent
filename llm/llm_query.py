# !/usr/lib/env python3
"""
-*- coding: utf-8 -*-
@Time : 2023/09/02 11:00 上午
@Author : Jinyi Zhang
@Department : Baidu ACG
@File : llm_query.py
"""
import json
import re
import tiktoken

from .gpt3 import GPT3Query
from ..modelagent.llm.base_llm_query import BaseLLMQuery


prompt_filter_json_default = ("The previous answer output given by the assistant is not in standard "
                              "json format. Based on the previous response from assisistant, filter and output a standar json format output. " 
                              "Do not add any additional leading message other than json content.")



def num_tokens_from_string(string: str, encoding_name: str = "cl100k_base") -> int:
    """Returns the number of tokens in a text string.

    Args:
        string (str): string to calculate number of tokens
        encoding_name (str, optional): encoding name. Defaults to "cl100k_base".
            cl100k_base	gpt-4, gpt-3.5-turbo, text-embedding-ada-002

    Returns:
        int: number of tokens
    """
    encoding = tiktoken.get_encoding(encoding_name)
    num_tokens = len(encoding.encode(string))
    return num_tokens


class LLMQuery(BaseLLMQuery):
    """LLM Query entry
    """
    def __init__(self, max_try_json=3, prompt_filter_json=None, max_num_token=4096, model="gpt3.5") -> None:
        
        if model == "gpt3.5":
            self.model_instance: BaseLLMQuery = GPT3Query(max_num_token=max_num_token)
        else:
            raise ValueError(f"Model not implemented.")
        
        self.max_try_json = max_try_json
        if prompt_filter_json is None:
            self.prompt_filter_json = prompt_filter_json_default
        else:
            self.prompt_filter_json = prompt_filter_json
    
    def get_completion_single_round(self, prompt):
        return self.model_instance.get_completion_single_round(prompt=prompt)
        
    def get_completion_multiple_round(self, messages):
        return self.model_instance.get_completion_multiple_round(messages)
        
    def query_for_json_single(self, prompt):
        """query gpt for json-like output"""
        num_try = 1
        target_json = None
        while num_try <= self.max_try_json and not target_json:
            try:
                response = self.get_completion_single_round(prompt=prompt)
                try:
                    response_init = response
                    target_json = json.loads(response_init)
                except:
                    # use llm to further filter the json file
                    print(f"Failed with json output: {num_try}")
                    messages = [
                        {"role": "user", "content": prompt},
                        {"role": "assistant", "content": response_init},
                        {"role": "user", "content": self.prompt_filter_json}
                    ]
                    response = self.get_completion_multiple_round(messages=messages)
                    target_json = json.loads(response)
            except Exception as e:
                pass
            num_try += 1
        return target_json
        
    def build_prompts(self, prompt_template, context, identifier):
        
        # build prompt without context
        prompt = prompt_template
        prompt_without_context = prompt
        
        # if prompt without context > max prompt, fail
        num_tokens_prompt_wo_context = num_tokens_from_string(prompt_without_context)
        if num_tokens_prompt_wo_context > self.max_num_token:
            print(f"Number of tokens without context still exceeds the max number of tokens: "
                  f"{num_tokens_prompt_wo_context} > {self.max_num_token}\n"
                  f"Try to reduce prompt tempelate size")
            return False
        
        prompt = re.sub(f"({identifier})", context, prompt, count=0, flags=0)
        # to be checked
        prompt = re.sub(r"([\s]{2,1000})|(\n\.)+", " ", prompt, count=0, flags=0)
        
        num_tokens_prompt = num_tokens_from_string(prompt)
        if num_tokens_prompt <= self.max_num_token:
            self.prompts = [prompt]
            return True
        
        num_tokens_context = num_tokens_prompt - num_tokens_prompt_wo_context
        num_tokens_for_context = self.max_num_token - num_tokens_prompt_wo_context
        num_prompts = num_tokens_context // num_tokens_for_context + 1
        context = re.sub(r"([\s]{2,1000})|(\n\.)+", " ", context, count=0, flags=0)
        if num_prompts > self.max_prompts:
            clip_ratio = 1 - (num_tokens_for_context * self.max_prompts) / num_tokens_context
            max_context_len = int((1 - clip_ratio) * len(context))
            context_clip = context[:max_context_len]
            print(f"Context keeped ratio: {1-clip_ratio}:.2f")
            context = context_clip
        
        self.prompts = []
        context_size_per_prompt = len(context) // min(num_prompts, self.max_prompts)
        for i in range(min(num_prompts, self.max_prompts)):
            slice_st = context_size_per_prompt * i
            slice_end = context_size_per_prompt * (i + 1)
            context_slice = context[slice_st:slice_end]
            prompt = re.sub(f"({identifier})", context_slice, prompt_without_context, count=0, flags=0)
            self.prompts.append(prompt)