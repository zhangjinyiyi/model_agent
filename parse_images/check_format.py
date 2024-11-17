#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   check_format.py
@Time    :   2024/11/15 19:58:29
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from PIL import Image

def check_image_format(image_path):
    try:
        with Image.open(image_path) as img:
            format = img.format
            print(f"The image format is: {format}")
            return format
    except Exception as e:
        print(f"Error: {e}")
        return None

# 使用示例
image_format = check_image_format('./downloaded_images/1.jpg')
print(image_format)