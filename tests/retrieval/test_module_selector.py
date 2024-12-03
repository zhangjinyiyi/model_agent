#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_module_selector.py
@Time    :   2024/12/03 20:10:43
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import os
import json
from modelagent.selector import SelectorEmbedding

if __name__ == "__main__":

    with open(os.path.abspath("./models_50.json"), "r") as f:
        modules_list = json.load(f)

    test_size = 10
    descriptions_list = [modules_list[key]["description"] for key in modules_list][:test_size]
    metadata_list = [
        {
            "path": modules_list[key]["path"], 
            "name": key, 
            "description": modules_list[key]["description"]
        } 
        for key in modules_list
    ][:test_size]

    target_description = "For a water/steam source with fixed pressure to feed into the system"

    selector = SelectorEmbedding()
    selector.build_embedding_vectorstore(descriptions_list, metadata_list)
    selected_modules = selector.select(target_description)
    print(selected_modules.metadata)