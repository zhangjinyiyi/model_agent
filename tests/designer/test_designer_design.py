#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_designer_design.py
@Time    :   2024/11/25 21:40:07
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.designer.designer import Designer
from modelagent.llm.gpt import GPTQuery

if __name__ == "__main__":
    designer = Designer(llm_query=GPTQuery(model="gpt-4o", json_mode=True))
    task = "build a system to test the pid controller of a first order system"
    # task = "build a chua circuit system"
    result = designer.design(task)
    # result2 = designer.recheck(task)
    designer.draw()
    designer.save("test.gml")

