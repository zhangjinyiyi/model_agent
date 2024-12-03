#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   gererate.py
@Time    :   2024/12/03 20:02:36
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.llm import GPTQuery


if __name__ == "__main__":
    gpt = GPTQuery(model="gpt-4o", json_mode=False)
    prompt = "write a heat exchanger modelica code, the code should be a complete modelica code."
    resp = gpt.get_completion(prompt)
    with open("./heat_exchanger.md", "w") as f:
        f.write(resp)
