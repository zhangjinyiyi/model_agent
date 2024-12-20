#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_gpt.py
@Time    :   2024/11/22 22:11:11
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

# Test connection to OpenAI

import time

from modelagent.llm import GPTQuery

if __name__ == "__main__":
    
    print("json model is disabled")
    gpt = GPTQuery(model="gpt-4o")
    start_time = time.time()
    print(gpt.get_completion("where is the capital of France?"))
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")
    
    print("json model is enabled")
    gpt = GPTQuery(model="gpt-4o", json_mode=True)
    start_time = time.time()
    print(gpt.get_completion("where is the capital of France?"))
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")
    
