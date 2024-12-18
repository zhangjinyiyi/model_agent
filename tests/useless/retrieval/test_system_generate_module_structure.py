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
    you are a modeling expert. you need to give a system model structure in the format of a graph.
    The node of the graph represent the sub-model and the edge represent the connection between submodels.
    output the necessary modules names in a list with name, description, paramters, input connectors and output connectors.
    output the connections in a list as upstream_module-downstream_module.
    here is the task: {}.
    the output should be in json format, same as :
    {{
        "modules": [
            {{"name": "module_name", "description": "module_description", 
             "parameters": "module_parameters", 
             "input_connectors": "module_input_connectors",
             "output_connectors": "module_output_connectors"
            }},
        ],
        "connections": [
            {{"upstream_module": "upstream_module", "upstream_connector": "upstream_connector", "downstream_module": "downstream_module", "downstream_connector": "downstream_connector"}},
            {{"upstream_module": "upstream_module", "upstream_connector": "upstream_connector", "downstream_module": "downstream_module", "downstream_connector": "downstream_connector"}}
        ]
    }}.
    """

    task = "build a system to test the pid controller of a first order system"
    prompt = prompt_template.format(task)
    gpt = GPTQuery(model="gpt-4o", json_mode=True)
    resp = gpt.get_completion(prompt)
    print(resp)