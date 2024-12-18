#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   conversation.py
@Time    :   2024/12/03 09:39:15
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from ..llm.llm_query import LLMQuery


class SimpleConversation:
    def __init__(
        self, 
        llm_query: LLMQuery = LLMQuery(model_name="gpt-4o"),
        user_name: str = "User",
        assistant_name: str = "Assistant",
        max_num_rounds: int = 10
    ):
        self.llm_query = llm_query
        self.user_name = user_name
        self.assistant_name = assistant_name
        self.max_num_rounds = max_num_rounds

    def start(self):
        print(f"Start the conversation with {self.llm_query.model_name}")
        messages = []
        while True:
            user_input = input(f"{self.user_name}: ")
            messages.append(
                {"role": "user", "content": user_input}
            )
            if user_input.lower() == "exit":
                break
            else:
                answer = self.llm_query.get_completion_messages(messages[-self.max_num_rounds:])
                messages.append(
                    {"role": "assistant", "content": answer}
                )
                print(f"{self.assistant_name}: {answer}")
    
    def end(self):
        pass