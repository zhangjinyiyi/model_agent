#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   claude.py
@Time    :   2024/12/18 16:13:50
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import os
import requests

from .base_llm_query import BaseLLMQuery


class ClaudeQuery(BaseLLMQuery):
    """Claude query class for Anthropic's Claude models"""
    
    def __init__(
        self, 
        model="claude-3-5-sonnet-20241022",
        json_mode=False,
        max_tokens=4096,
        base_url="https://api.bianxie.ai/v1"
    ):
        super().__init__(max_num_tokens=max_tokens)
        self.model = model
        self.json_mode = json_mode
        self.base_url = base_url
        
        if self.json_mode:
            self.system_prompt = "You are a helpful assistant designed to output JSON."
        else:
            self.system_prompt = "You are a helpful assistant."

    def get_completion(self, prompt):
        return self.get_completion_single_round(prompt)
    
    def get_completion_single_round(self, prompt):
        """get the completion of the prompt

        Args:
            prompt (str): the prompt to get the completion

        Returns:
            str: the completion of the prompt
        """
        
        messages = [
            {'role': 'system', 'content': self.system_prompt},
            {'role': 'user', 'content': prompt}
        ]
        response = self.get_completion_messages(messages, json_mode=self.json_mode)
        return response
    
    def get_completion_messages(self, messages: list[dict], json_mode=None):
        """get the completion of the messages

        Args:
            messages (list[dict]): the messages to get the completion
            json_mode (bool, optional): whether to enforce the json mode. Defaults to self.json_mode.

        Returns:
            str: the completion of the messages
        """
        if json_mode is None:
            json_mode = self.json_mode
            
        url = self.base_url + '/chat/completions'

        headers = {
            'Content-Type': 'application/json',
            'Authorization': f'Bearer {os.environ.get("ANTHROPIC_API_KEY")}'
        }

        data = {
            'model': self.model,
            'messages': messages,
            'max_tokens': self.max_num_tokens,
            'response_format': {'type': 'json_object'} if json_mode else None
        }

        response = requests.post(url, headers=headers, json=data)
        response_json = response.json()
        
        response_text = response_json["choices"][0]["message"]["content"]
            
        if json_mode:
            response_text = self.enforce_json_mode(response_text)
            
        return response_text

