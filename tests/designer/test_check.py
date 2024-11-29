#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_check.py
@Time    :   2024/11/28 22:34:48
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import json
from modelagent.llm.llm_query import LLMQuery


if __name__ == "__main__":
    llm_query = LLMQuery(model_name="gpt-4o", json_mode=True)
    task = "build a system to test the pid controller of a first order system"
    system_design = json.load(open("test.json", "r"))
    prompt = """
        You are a senoir system modeling and simulation expert. 
        you have deep knowledge in matlab/simulink, modelica, aspen plus, etc.
        You are given a task: {task}.
        Please check if the given system design is correct.
        you need to check the following aspects:
            1. the system has all necessary components to finish the task in the task description
            2. there is no redundant component in the system
            3. the connections between components are correct
            4. the topology of the system is mathematically and physically and logically correct
        the system design is given in the following json format:
        {system_design}
        if the system is correct, return "correct".
        if the system is incorrect, return "incorrect", the reason and your suggestion to fix the system.
        the output should be a json format as following:
        {{"result": "correct" or "incorrect", "reason": "the reason if the system is incorrect", 
          "suggestion": "the suggestion to fix the system if the system is incorrect"}}
    """
    result = llm_query.get_completion(
        prompt.format(task=task, system_design=json.dumps(system_design))
    )
    print(result)

