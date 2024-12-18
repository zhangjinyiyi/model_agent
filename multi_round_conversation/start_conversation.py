#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   start_conversation.py
@Time    :   2024/12/03 09:49:13
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from modelagent.conversation.simple_conversation import Conversation

import sys


if __name__ == "__main__":
    conversation = Conversation()
    conversation.start()
    