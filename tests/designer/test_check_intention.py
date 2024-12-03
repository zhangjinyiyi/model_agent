#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_check_intention.py
@Time    :   2024/12/03 12:05:13
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.designer import MultiRoundDesigner, DesignerSelfCorrect
from modelagent.llm import LLMQuery

import logging

FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
logging.basicConfig(format=FORMAT, level=logging.INFO)

if __name__ == "__main__":
    designer = MultiRoundDesigner(
        designer=DesignerSelfCorrect(), 
        llm_query=LLMQuery(model_name="gpt-4o", json_mode=True))
    user_input = "build a system to test the pid controller of a first order system"
    result = designer.check_intention(user_input=user_input)
    print(result)
