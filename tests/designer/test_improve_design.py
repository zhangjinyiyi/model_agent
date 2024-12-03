#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_improve_design.py
@Time    :   2024/12/03 10:58:42
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.designer.designer_self_correct import DesignerSelfCorrect
from modelagent.llm.gpt import GPTQuery
import json

if __name__ == "__main__":
    designer = DesignerSelfCorrect(llm_query=GPTQuery(model="gpt-4o", json_mode=True))
    task = "build a system to test the pid controller of a first order system"
    feedback = "change summing junction to a subtractor"
    with open("./system_structure_self_correct.json", "r") as f:
        design = json.load(f)
    result = designer.improve_design(feedback=feedback, design=design, task=task)
    designer.draw(save_path="./system_structure_self_correct_improved.png")
    designer.save_design(save_path="./system_structure_self_correct_improved.json")
