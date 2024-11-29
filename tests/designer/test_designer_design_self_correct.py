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
from modelagent.llm.gpt import GPTQuery\
    
    
import logging

FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
logging.basicConfig(format=FORMAT, level=logging.INFO)


if __name__ == "__main__":
    designer = DesignerSelfCorrect(llm_query=GPTQuery(model="gpt-4o", json_mode=True))
    task = "build a system to test the pid controller of a first order system"
    result = designer.execute_design(task)
    designer.draw(save_path="./system_structure_self_correct.png")

