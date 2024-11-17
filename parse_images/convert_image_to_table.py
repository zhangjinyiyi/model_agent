#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   convert_image_to_table.py
@Time    :   2024/11/16 15:19:03
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""
import sys
sys.path.append("..")
import pandas as pd
from modelagent.llm.llm_image2table import LLMImage2Table


if __name__ == "__main__":

    llm_image2table = LLMImage2Table(max_retries=5)

    df = pd.DataFrame()
    for i in range(61, 64):
      df_ = llm_image2table.get_table_from_image(f"./downloaded_images/{i}.jpg")
      if df_ is not None:
          df_.to_csv(f"./downloaded_images/table_{i}.csv", index=False)
          df = pd.concat([df, df_], axis=0)
      else:
          print(f"failed {i}")
      print(f"finished {i}")
      
    df.to_csv("./downloaded_images/table.csv", index=False)
      
      
