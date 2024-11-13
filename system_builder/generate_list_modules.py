#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   generate_list_modules.py
@Time    :   2024/11/08 10:56:30
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import os
from modelagent.documentation.doc_generator_modelica import DocGeneratorModelica
import json
import time


if __name__ == "__main__":

    generator = DocGeneratorModelica(max_description_len=50)
    enable_llm = 0

    #root_path = "/Users/yi/Documents/code/model_agent/ThermoSysPro/WaterSteam"
    root_path = "/Users/yi/Documents/code/model_agent/ThermoSysPro/"
    exclude_fnames = ["package.order", "package.mo", "UsersGuide.mo"]
    module_paths = []
    module_descriptions = {}
    for root, _, files in os.walk(root_path):
        for f in files:
            if f not in exclude_fnames:
                path = os.path.join(root, f)
                module_paths.append(path)
                print(path)
    print(f"Number of modules: {len(module_paths)}")

    if enable_llm:
        for module_path in module_paths:
            module_path:str
            module_name = module_path.split("/")[-1]
            print(module_name)
            desc = generator.generate(code_path=module_path, source="file")
            module_descriptions[module_name] = {
                "path": module_path,
                "description": desc
            }
            
        with open("models_50.json", "w") as f:
            json.dump(module_descriptions, f)