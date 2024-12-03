#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test.py
@Time    :   2024/12/03 09:31:31
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""


if __name__ == "__main__":

    while True:
        user_input = input("You: ")
        if user_input == "exit":
            break
        else:
            print(f"Assistant: {user_input}")
