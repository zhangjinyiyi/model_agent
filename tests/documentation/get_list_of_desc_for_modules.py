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
import os

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


if __name__ == "__main__":
    
    code_dir = "../../ThermoSysPro/InstrumentationAndControl/Blocks"
    
    module_desc_file_path = "./modelica_doc_gpt-4o.json"
    
    doc_generator = DocGeneratorModelica()
    desc_dict = doc_generator.generate_descs_from_dir(code_dir=code_dir, save_path=module_desc_file_path)
