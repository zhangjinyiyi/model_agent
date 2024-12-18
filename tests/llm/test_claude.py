#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_claude.py
@Time    :   2024/12/18 16:51:44
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""
import time

from modelagent.llm.claude_bianxie import ClaudeQuery


if __name__ == "__main__":
    print("json model is disabled")
    claude = ClaudeQuery(model="claude-3-5-sonnet-20241022")
    start_time = time.time()
    print(claude.get_completion("where is the capital of France?"))
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")
    
    print("json model is enabled")
    claude = ClaudeQuery(model="claude-3-5-sonnet-20241022", json_mode=True)
    start_time = time.time()
    print(claude.get_completion("where is the capital of France?"))
    end_time = time.time()
    print(f"Time taken: {end_time - start_time} seconds")

