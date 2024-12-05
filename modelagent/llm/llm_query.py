#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   llm_query.py
@Time    :   2024/11/08 13:58:15
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""
from .gpt import GPTQuery
from .base_llm_query import BaseLLMQuery


openai_models = ["gpt-4o", "o1-preview", "o1-mini", "gpt-3.5-turbo"]

class LLMQuery(BaseLLMQuery):
    def __init__(self, model_name="gpt-4o", **kwargs) -> None:
        self.model_name = model_name
        self.kwargs = kwargs
        for key, value in kwargs.items():
            setattr(self, key, value)
        if self.model_name in openai_models:
            self.llm_model = GPTQuery(model=self.model_name, **self.kwargs)
        else:
            self.llm_model = GPTQuery(model="gpt-4o", **self.kwargs)

    def get_completion(self, prompt):
        return self.llm_model.get_completion(prompt=prompt)
    
    def get_completion_messages(self, messages: list[dict], **kwargs):
        return self.llm_model.get_completion_messages(messages=messages, **kwargs)
