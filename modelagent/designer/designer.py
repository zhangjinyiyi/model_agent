#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   designer.py
@Time    :   2024/11/25 21:17:10
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import logging
logger = logging.getLogger(__name__)
import matplotlib.pyplot as plt
import networkx as nx
import json

from ..llm.base_llm_query import BaseLLMQuery
from ..llm.gpt import GPTQuery

class Designer:
    def __init__(
        self,
        llm_query: BaseLLMQuery = GPTQuery()
    ):
        self.llm_query = llm_query
        
        if not hasattr(self.llm_query, "json_mode"):
            logger.warning("llm_query does not have json_mode attribute, may cause error in design process.")
            self.llm_query.json_mode = True
        
        if (hasattr(self.llm_query, "json_mode") and not self.llm_query.json_mode):
           logger.warning("llm_query.json_mode is set to False, may cause error in design process.")
                               
        self.prompt = """
            you are a modeling and simulation expert. you need to give a system model structure in the format of a graph.
            The node of the sytem model graph represent the module and the edge represent the connection between modules.
            output all the necessary modules names in a list with name, description, paramters, input connectors and output connectors.
            output all the connections in a list as upstream_module-downstream_module.
            The given modules and connections should be able to build a complete system model to finish the task.
            Here is the task: {task}.
            the output should be in json format, same as :
            {{
                "modules": [
                    {{"name": "module_name", "description": "module_description", 
                      "parameters": "module_parameters", 
                      "input_connectors": "module_input_connectors",
                      "output_connectors": "module_output_connectors"
                    }},
                ],
                "connections": [
                    {{"upstream_module": "upstream_module", "upstream_connector": "upstream_connector", 
                      "downstream_module": "downstream_module", "downstream_connector": "downstream_connector"}},
                    {{"upstream_module": "upstream_module", "upstream_connector": "upstream_connector", 
                    "downstream_module": "downstream_module", "downstream_connector": "downstream_connector"}}
                ]
            }}.
        """
        
        self.graph_dict = None
        self.graph = nx.DiGraph()
    
    def design(self, task: str):
        """design the system model structure

        Args:
            task (str): the task description

        Returns:
            dict: the ststpm:mo_dl etrustuce_
        """
        prompt = self.prompt.format(task=task)
        resp = self.llm_query.get_completion(prompt)
        self.graph_dict = json.loads(resp)
        self._graph_dict_to_graph()
        return self.graph_dict
    
    def recheck(self, task: str):
        prompt = """
            you are a senior modeling and simulation expert. You are ask to check if the given system structure can 
            finish the task in a simulation environment described as follows: {task}.
            Here is the system structure: {graph_dict}.
            if not: you need to give a new system structure that can finish the task based on the given system structure, 
            the format should be the same as the output of the design function.
            if yes: you need to output the system structure in json format, same as the given one.
        """
        prompt = prompt.format(task=task, graph_dict=json.dumps(self.graph_dict))
        resp = self.llm_query.get_completion(prompt)
        self.graph_dict = json.loads(resp)
        self._graph_dict_to_graph()
        return self.graph_dict
    
    def draw(self):
        
        G = self.graph
        node_font_size = 10
        edge_font_size = node_font_size * 0.6
        
        # 绘制图形
        pos = nx.spring_layout(G)  # 使用 spring 布局

        # 绘制节点
        nx.draw_networkx_nodes(G, pos, node_color='lightblue', node_size=2000, alpha=0.5)

        # 绘制边
        nx.draw_networkx_edges(G, pos, arrowstyle='->', arrowsize=20)

        # 绘制节点标签
        nx.draw_networkx_labels(G, pos, font_size=node_font_size, font_weight='bold')

        # 绘制边标签
        edge_labels = {(u, v): f"{data['input_name']} -> {data['output_name']}" for u, v, data in G.edges(data=True)}
        nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=edge_font_size, font_color='red')

        # 显示图形
        plt.title("Directed Graph with Named Inputs and Outputs")
        plt.axis('off')  # 关闭坐标轴
        plt.show()
        plt.savefig("./system_structure.png")
        
    def save(self, file_path: str):
        nx.write_gml(self.graph, file_path)
    
    def _graph_dict_to_graph(self):
        # Add all modules as nodes
        node_names = [module["name"] for module in self.graph_dict["modules"]]
        self.graph.add_nodes_from(node_names)
        
        # Add edges with connection information
        for connection in self.graph_dict["connections"]:
            self.graph.add_edge(
                connection["upstream_module"],
                connection["downstream_module"],
                input_name=connection["upstream_connector"],
                output_name=connection["downstream_connector"]
            )
            

