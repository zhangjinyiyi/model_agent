#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_llm_query.py
@Time    :   2024/12/18 17:29:21
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""


from modelagent.llm import LLMQuery
import time


if __name__ == "__main__":
    print("json model is disabled")
    llm = LLMQuery(model_name="claude-3-5-sonnet-20241022", json_mode=False, base_url="https://api.bianxie.ai/v1")
    start_time = time.time()
    res = llm.get_completion(prompt="where is the capital of France?")
    end_time = time.time()
    print(f"time cost: {end_time - start_time} seconds")
    print(res)
    
    print("json model is enabled")
    llm = LLMQuery(model_name="claude-3-5-sonnet-20241022", json_mode=True, base_url="https://api.bianxie.ai/v1")
    start_time = time.time()
    res = llm.get_completion(prompt="where is the capital of France?")
    end_time = time.time()
    print(f"time cost: {end_time - start_time} seconds")
    print(res)

