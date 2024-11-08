# !/usr/lib/env python3
"""
-*- coding: utf-8 -*-
@Time : 2023/09/02 11:00 上午
@Author : Jinyi Zhang
@Department : Baidu ACG
@File : base_llm_query.py
"""

class BaseLLMQuery:
    def __init__(self, max_num_tokens=4096) -> None:
        self.max_num_tokens = max_num_tokens
    
    def get_completion_single_round(self, prompt):
        raise NotImplementedError
    
    def get_completion_multiple_round(self, messages):
        raise NotImplementedError
    
    