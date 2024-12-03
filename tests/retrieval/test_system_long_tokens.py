#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test-system.py
@Time    :   2024/11/08 14:46:25
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""
import json
from modelagent.llm.llm_query import GPTQuery

if __name__ == "__main__":
    prompt_template = """
    you are a modeling expert. you need to give all necessary modules from a modelica packages not known yet.
    to build a system model to finish a specific task.
    do not forget boundary modules.
    remember to check the closure of system equations.
    output the necessary modules names and description in a list.
    output the connections in a list as upstream_module-downstream_module.
    here is the task: {}.
    """
    with open("./models_50.json", "r") as f:
        module_list_text = f.read()
    task = "build a simple pipe network system to test the system pressure loss"
    prompt = prompt_template.format(task, module_list_text)
    gpt = GPTQuery(model="gpt-4o")
    resp = gpt.get_completion(prompt)
    print(resp)