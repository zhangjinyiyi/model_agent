#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_designer_design_self_correct.py
@Time    :   2024/11/29 13:13:32
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.designer.designer_self_correct import DesignerSelfCorrect
from modelagent.llm import LLMQuery

import logging
logging.basicConfig(level=logging.INFO)


if __name__ == "__main__":
    model_name = "gpt-4o"
    llm = LLMQuery(model_name=model_name, json_mode=True, max_tokens=10000)
    designer = DesignerSelfCorrect(llm_query=llm)
    task = "build a system to test the pid controller of a first order system with a step reference"
    result = designer.execute_design(task)
    designer.draw(save_path="./system_structure_self_correct.png")
    designer.save_design(save_path="./system_structure_self_correct.json")
