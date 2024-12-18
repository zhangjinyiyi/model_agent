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

    with open("../documentation/modelica_doc_gpt-4o.json", "r") as f:
        modules_list = json.load(f)

    test_size = len(modules_list)
    descriptions_list = [json.dumps(v) for _, v in modules_list.items()][:test_size]
    metadata_list = [{"module_ref": k} for k, _ in modules_list.items()][:test_size]

    target_module = {
        "name": "PIDController",
        "description": "A proportional-integral-derivative controller to regulate the system output.",
        "parameters": [
            {
                "name": "Kp",
                "description": "Proportional gain."
            },
            {
                "name": "Ki",
                "description": "Integral gain."
            },
            {
                "name": "Kd",
                "description": "Derivative gain."
            }
        ],
        "input_connectors": [
            {
                "name": "error_input",
                "description": "Input for the error signal (setpoint - process variable)."
            }
        ],
        "output_connectors": [
            {
                "name": "control_signal_output",
                "description": "Outputs the control signal to the plant."
            }
        ]
    }
    target_description = json.dumps(target_module)

    selector = SelectorEmbedding()
    selector.build_embedding_vectorstore(descriptions_list, metadata_list)
    selected_modules = selector.select(target_description)
    print(selected_modules.metadata)