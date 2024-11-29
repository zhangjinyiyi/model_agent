#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_dot.py
@Time    :   2024/11/28 21:20:27
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""


import pygraphviz as pgv
import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# 创建一个新的有向图
G = pgv.AGraph(directed=True)

# 添加节点和边
G.add_nodes_from(["ref", "error", "pid", "first_order"])
# G.add_node('first_order')

G.add_edge('ref', 'error')
G.add_edge('error', 'pid')
G.add_edge('pid', 'first_order')
G.add_edge('first_order', 'error')

# 设置节点和边的属性
G.node_attr['shape'] = 'box'
G.edge_attr['color'] = 'blue'

# 布局图形
G.layout(prog='dot')

# 将图形保存为文件
G.draw('flowchart.png')

# 使用matplotlib显示图形
img = mpimg.imread('flowchart.png')
plt.imshow(img)
plt.axis('off')
plt.show()