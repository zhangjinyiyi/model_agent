#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_doc_generator_modelica.py
@Time    :   2024/12/17 22:37:55
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.documentation.doc_generator_modelica import DocGeneratorModelica
import json
from modelagent.llm.llm_query import LLMQuery

if __name__ == "__main__":
    
    code_path = "C:\code\model_agent\ThermoSysPro\InstrumentationAndControl\Blocks\Continu\PI.mo"
    
    doc_generator = DocGeneratorModelica(llm_query=LLMQuery(model_name="claude-3-5-sonnet-20241022", json_mode=True))
    module_ref = doc_generator._get_module_reference(code_path)
    
    desc_dict = doc_generator.generate(code_path=code_path, source="file")
    
    with open("./desc.json", "w") as f:
        json.dump(desc_dict, f, indent=4)

    
    print(module_ref)
