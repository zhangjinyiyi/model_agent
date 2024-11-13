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


class LLMQuery:
    def __init__(self, model_name="gpt-4o") -> None:
        self.model_name = model_name
        if self.model_name == "gpt-4o":
            self.llm_model = GPTQuery(model=self.model_name)
        else:
            self.llm_model = GPTQuery(model="gpt-4o")

    def get_completion(self, prompt):
        return self.llm_model.get_completion(prompt=prompt)