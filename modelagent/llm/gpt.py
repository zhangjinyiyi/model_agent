#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   gpt.py
@Time    :   2024/10/25 22:31:51
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from openai import OpenAI
import os

from .base_llm_query import BaseLLMQuery


# openai.organization = ""
# openai.api_key = os.getenv("OPENAI_API_KEY")


class GPTQuery(BaseLLMQuery):
    def __init__(
        self, 
        model="gpt-3.5-turbo", 
        max_num_token=4096,
        base_url="https://api.bianxie.ai/v1",
        json_mode=False
    ) -> None:
        
        super().__init__(max_num_tokens=max_num_token)
        self.model = model
        self.client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"), base_url=base_url)
        self.json_mode = json_mode

    def get_completion(self, prompt):
        return self.get_completion_single_round(prompt)
    
    def get_completion_single_round(self, prompt):
        
        if self.model.startswith("o1"):
            response = self.client.chat.completions.create(
                messages=[{"role": "user", "content": prompt}],
                model=self.model,
                response_format={"type": "json_object"} if self.json_mode else None
            )
        else:
            response = self.client.chat.completions.create(
                messages=[{"role": "user", "content": prompt}],
                model=self.model,
                max_tokens=self.max_num_tokens,
                response_format={"type": "json_object"} if self.json_mode else None
            )
        return response.choices[0].message.content
    
    def get_completion_multiple_round(self, messages):
        # TODO
        pass
        
    