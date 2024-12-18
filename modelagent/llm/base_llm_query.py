# !/usr/lib/env python3
"""
-*- coding: utf-8 -*-
@Time : 2023/09/02 11:00 上午
@Author : Jinyi Zhang
@Department : Baidu ACG
@File : base_llm_query.py
"""
import json
import re
import logging

logger = logging.getLogger(__name__)


class BaseLLMQuery:
    def __init__(self, max_num_tokens=4096) -> None:
        self.max_num_tokens = max_num_tokens

    def get_completion(self, prompt):
        raise NotImplementedError
    
    def get_completion_single_round(self, prompt):
        raise NotImplementedError
    
    def get_completion_multiple_round(self, messages):
        raise NotImplementedError
    
    def enforce_json_mode(self, text):
        """enforce the json mode for the text

        Args:
            text (str): the text to enforce the json mode

        Returns:
            str: the text in json mode, none if returned if the text is not in json mode and cannot be cleaned
        """
        try:
            json.loads(text)
            return text
        except:
            text_cleaned = self.clean_json_string(text)
            try:
                json.loads(text_cleaned)
                return text_cleaned
            except:
                logger.error(f"The text is not in json mode: {text}, None is returned")
                return None
    
    def clean_json_string(self, json_string):
        """deal with the json string that is wrapped in markerdown marker ```json and ```"""
        pattern = r'^```json\s*(.*?)\s*```$'
        cleaned_string = re.sub(pattern, r'\1', json_string, flags=re.DOTALL)
        return cleaned_string.strip()
    
    