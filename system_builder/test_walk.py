#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_walk.py
@Time    :   2024/11/08 11:42:23
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import os

def list_all_paths(start_dir):
    for root, dirs, files in os.walk(start_dir):
        for file in files:
            print(os.path.join(root, file))

if __name__ == "__main__":
    start_dir = "/Users/yi/Documents/code/model_agent/ThermoSysPro/WaterSteam"
    list_all_paths(start_dir)