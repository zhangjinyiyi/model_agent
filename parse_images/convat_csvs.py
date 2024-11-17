#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   convat_csvs.py
@Time    :   2024/11/17 19:53:44
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import pandas as pd

if __name__ == "__main__":
    
    df = pd.DataFrame()
    for i in range(1, 61):
        df_ = pd.read_csv(f"./downloaded_images/table_{i}.csv")
        df_.rename(columns={"省(区,市)": "省区市", "省(区、市)": "省区市", "省（区、市）":"省区市"}, inplace=True)
        df = pd.concat([df, df_], axis=0)
    df.to_csv("./downloaded_images/table_concat_all.csv", index=False)
