#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_naeto.py
@Time    :   2024/11/28 21:18:30
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import networkx as nx

# plain graph
G = nx.complete_graph(5)  # start with K5 in networkx
A = nx.nx_agraph.to_agraph(G)  # convert to a graphviz graph
A.layout()  # neato layout
A.draw("./k5.ps")  # write postscript in k5.ps with neato layout