#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   llm_image2table.py
@Time    :   2024/11/17 18:43:19
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from openai import OpenAI
import os
import base64
import requests
import json
import pandas as pd


class LLMImage2Table:
    
    def __init__(self, model="gpt-4o", max_num_tokens=4096, max_retries=3):
        self.model = model
        self.client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
        self.max_num_tokens = max_num_tokens
        self.max_retries = max_retries
        
    def get_table_from_image(self, image_path):
        table_dict = self.get_json_from_image(image_path)
        if table_dict is None:
            return None
        keys = list(table_dict.keys())
        data = []
        for key in keys:
            data.append(table_dict[key])
        df = pd.DataFrame(data).transpose()
        df.rename(columns={df.columns[i]: keys[i] for i in range(len(keys))}, inplace=True)
        return df
        
    def encode_image(self, image_path):
        with open(image_path, "rb") as image_file:
            return base64.b64encode(image_file.read()).decode('utf-8')

    def get_json_from_image(self, image_path):
        """get json from image, 

        Args:
            image_path (_type_): _description_
        """
        base64_image = self.encode_image(image_path)
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {os.environ.get('OPENAI_API_KEY')}"
        }
        payload = {
            "model": "gpt-4o",
            "messages": [
                {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": 
                            """将图中表格中的信息用json的格式返回，
                            格式为\{header1: [value1, value2, ...], header2: [value1, value2, ...]\}。
                            请确保返回的是严格的json格式，不要包含任何其他文字说明。"""
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{base64_image}"
                        }
                    }
                ]
                }
            ],
            "max_tokens": self.max_num_tokens,
            "response_format": {"type": "json_object"}
        }
        
        for i in range(self.max_retries):
            try:
                response = requests.post("https://api.openai.com/v1/chat/completions", headers=headers, json=payload)
                content = response.json()["choices"][0]["message"]["content"]
                table_dict = json.loads(content)
                return table_dict
            except:
                # print(content)
                print(f"Failed to get table from image: try {i}")
        return None
            