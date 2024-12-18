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
from .claude_bianxie import ClaudeQuery

import logging
logger = logging.getLogger(__name__)
openai_models = ["gpt-4o", "o1-preview", "o1-mini", "gpt-3.5-turbo"]


class LLMQuery(BaseLLMQuery):
    """llm query class
    
    TODO:
        - add support to claude
    
    Supported models:
        - gpt-4o
        - o1-preview
        - o1-mini
        - gpt-3.5-turbo

    Attributes:
        model_name (str): the name of the model to use
        kwargs (dict): the keyword arguments to pass to the model
    """
    def __init__(
        self, 
        model_name="gpt-4o", 
        json_mode=False,
        max_tokens=4096,
        **kwargs
    ) -> None:
        self.model_name = model_name
        self.json_mode = json_mode
        self.max_tokens = max_tokens
        self.kwargs = kwargs
        
        for key, value in kwargs.items():
            setattr(self, key, value)
        
        if self.model_name in openai_models:
            self.llm_model = GPTQuery(model=self.model_name, json_mode=self.json_mode, 
                                      max_num_token=self.max_tokens, **self.kwargs)
            
        elif self.model_name.startswith("claude"):
            self.llm_model = ClaudeQuery(model=self.model_name, json_mode=self.json_mode, 
                                         max_tokens=self.max_tokens, **self.kwargs)
        else:
            self.llm_model = GPTQuery(model="gpt-4o", json_mode=self.json_mode, 
                                      max_num_token=self.max_tokens, **self.kwargs)
            
        logger.info(f"Using model: {self.llm_model.model}")
            
        

    def get_completion(self, prompt):
        return self.llm_model.get_completion(prompt=prompt)
    
    def get_completion_messages(self, messages: list[dict], **kwargs):
        return self.llm_model.get_completion_messages(messages=messages, **kwargs)
