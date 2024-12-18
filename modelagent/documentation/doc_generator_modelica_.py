#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   doc_generator_modelica.py
@Time    :   2024/11/08 14:03:25
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from ..llm import LLMQuery
import logging
import time

logger = logging.getLogger(__name__)


class DocGeneratorModelica:
    def __init__(
            self, 
            model_name="gpt-4o",
            max_description_len=100,
            max_trial=3,
            trial_delay=5,
            ) -> None:
        self.llm_query = LLMQuery(model_name=model_name)
        self.max_description_len = max_description_len
        self.max_trial = max_trial
        self.trial_delay = trial_delay

        self.prompt_template = """
            You are a modelica expert. 
               You are ask to write a simple model description based on the given modelica code. 
               keep the description in {} words. 
               output the description in plain text. 
               modelica code : {}
        """

    def generate(self, code_text="", code_path="", source="file"):

        if source not in ["file", "text"]:
            raise ValueError(f"source type not right: {source}")

        is_success = False
        for i in range(self.max_trial):
            try:
                if source == "text":
                    desc = self.generate_from_text(code_text=code_text)
                elif source == "file":
                    desc = self.generate_from_file(code_path=code_path)
                else:
                    pass
                is_success = True
            except:
                time.sleep(self.trial_delay)
                logger.warning(f"Try failed : {i}")
            if is_success:
                break
        if is_success is False:
            desc = None
            
        return desc

    def generate_from_text(self, code_text):
        return self.llm_query.get_completion(prompt=self.prompt_template.format(
            self.max_description_len, code_text))
    
    def generate_from_file(self, code_path):
        with open(code_path, "r") as f:
            code_text = f.read()
        return self.generate_from_text(code_text)
    
    
    
    