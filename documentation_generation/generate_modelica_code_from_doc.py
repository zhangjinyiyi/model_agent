#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   generate_modelica_code_from_doc.py
@Time    :   2024/10/29 13:33:40
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.llm.gpt import GPTQuery

if __name__ == "__main__":
    fpath = "./doc.md"
    with open(fpath, "r") as f:
        content = f.read()
    print(content)

    gpt = GPTQuery(model="gpt-4o")
    prompt = f"Here is a documentation of a model: {content}. \
               write a modelica model based on this documentation."
    resp = gpt.get_completion(prompt)

    with open("./modelica_code.mo", "w") as f:
        f.write(resp)
    print(resp)
