#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   generate_thermosyspro_doc.py
@Time    :   2024/10/29 13:16:30
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.llm.gpt import GPTQuery

if __name__ == "__main__":
    fpath = "/Users/yi/Documents/code/model_agent/ThermoSysPro/Combustion/Sensors/FuelMassFlowSensor.mo"
    with open(fpath, "r") as f:
        content = f.read()
    print(content)

    model = "gpt-4o"
    gpt = GPTQuery(model=model)
    prompt = f"You are a modelica expert. You are ask to write a detailed documentation of modelica model. \
               Here is the modelica code: {content}. \
               write a documentation for it. \
               output the result in json format with field code and doc."
    resp = gpt.get_completion(prompt)

    with open(f"./modelica_doc_{model}.md", "w") as f:
        f.write(resp)
    print(resp)
