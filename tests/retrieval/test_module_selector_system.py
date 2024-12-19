#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_module_selector_system.py
@Time    :   2024/12/19 22:38:42
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import json

from modelagent.selector import SelectorEmbedding


if __name__ == "__main__":
    with open("../designer/system_structure_self_correct.json", "r") as f:
        system_structure_dict = json.load(f)
        
    with open("../documentation/modelica_doc_gpt-4o.json", "r") as f:
        modules_list = json.load(f)

    test_size = len(modules_list)
    descriptions_list = [json.dumps(v) for _, v in modules_list.items()][:test_size]
    metadata_list = [{"module_ref": k} for k, _ in modules_list.items()][:test_size]
    
    
    module_selector = SelectorEmbedding()
    print("start building vectorstore ...")
    module_selector.build_embedding_vectorstore(descriptions_list, metadata_list)
    
    selected_modules_list = []
    for module in system_structure_dict["modules"]:
        target_description = json.dumps(module)
        selected_modules = module_selector.select(target_description)
        selected_modules_list.append(selected_modules.metadata)
        
        print(f"target module: {module['name']} => {selected_modules.metadata['module_ref']}")
        