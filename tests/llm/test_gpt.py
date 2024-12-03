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

import sys
print(sys.path)


from modelagent.llm import GPTQuery

gpt = GPTQuery()
print(gpt.get_completion("Hello, how are you?"))
