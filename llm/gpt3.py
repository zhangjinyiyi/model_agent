# !/usr/lib/env python3
"""
-*- coding: utf-8 -*-
@Time : 2023/09/02 11:00 上午
@Author : Jinyi Zhang
@Department : Baidu ACG
@File : base_llm_query.py
"""
import openai
import os

from ..modelagent.llm.base_llm_query import BaseLLMQuery


openai.organization = ""
openai.api_key = os.getenv("OPENAI_API_KEY")


class GPT3Query(BaseLLMQuery):
    def __init__(self, max_num_token=4096) -> None:
        super().__init__(max_num_tokens=max_num_token)
    
    def get_completion_single_round(self, prompt):
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=[
                    {"role": "user", "content": prompt},
                ]
        )
        msg = response["choices"][0]["message"]["content"]
        return msg
    
    def get_completion_multiple_round(self, messages):
        response = openai.ChatCompletion.create(
            model="gpt-3.5-turbo",
            messages=messages
        )
        msg = response["choices"][0]["message"]["content"]
        return msg
        
    