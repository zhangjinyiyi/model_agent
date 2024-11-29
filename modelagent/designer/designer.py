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
import matplotlib.image as mpimg
import networkx as nx
import json
import pygraphviz as pgv

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
            you are a modeling and simulation expert. 
            you need to give a system model structure in the format of a graph.
            The node of the sytem model graph represent the module and the edge represent the connection between modules.
            output all the necessary modules names in a list with name, description, paramters, input connectors 
            and output connectors.
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
        
        # list of wrong designs
        # each wrong design is a dict with the following keys:
        # "design": the wrong design
        # "reason": the reason why the design is wrong
        self.wrong_designs = []
        
        self.graph_dict = None
        self.graph = nx.DiGraph()
        self.graph_graphviz = pgv.AGraph(directed=True)
    
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
        self._graph_dict_to_graphviz()
        return self.graph_dict
    
    def draw(self, save_path: str = "./system_structure.png"):
        """draw the system structure graph

        Args:
            save_path (str, optional): the path to save the figure. Defaults to "./system_structure.png".
            
        """
        
        G = self.graph
        node_font_size = 10
        edge_font_size = node_font_size * 0.6
        
        pos = nx.spring_layout(G)
        # pos = nx.layout(G, prog='dot')
        
        # G.layout(prog='dot')

        # Draw nodes
        nx.draw_networkx_nodes(G, pos, node_color='lightblue', node_size=2000, alpha=0.5)

        # Draw edges
        nx.draw_networkx_edges(G, pos, arrowstyle='->', arrowsize=20)

        # Draw node labels
        nx.draw_networkx_labels(G, pos, font_size=node_font_size, font_weight='bold')

        # Draw edge labels
        edge_labels = {(u, v): f"{data['input_name']} -> {data['output_name']}" for u, v, data in G.edges(data=True)}
        nx.draw_networkx_edge_labels(G, pos, edge_labels=edge_labels, font_size=edge_font_size, font_color='red')

        # Display graph
        plt.title("Directed Graph with Named Inputs and Outputs")
        plt.axis('off')
        plt.savefig(save_path)
        plt.show()
        return True
    
    def draw_dot(self, save_path: str = "./system_structure.png"):
        G = self.graph_graphviz
        G.node_attr['shape'] = 'box'
        G.edge_attr['color'] = 'blue'
        G.layout(prog='dot')
        G.draw(save_path)

        # img = mpimg.imread(save_path)
        #  plt.imshow(img)
        # plt.axis('off')
        # plt.show()
        return True
        
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
            
    def _graph_dict_to_graphviz(self):
        # Add all modules as nodes
        node_names = [module["name"] for module in self.graph_dict["modules"]]
        self.graph_graphviz.add_nodes_from(node_names)
        
        # Add edges with connection information
        for connection in self.graph_dict["connections"]:
            self.graph_graphviz.add_edge(
                connection["upstream_module"],
                connection["downstream_module"],
                # input_name=connection["upstream_connector"],
                # output_name=connection["downstream_connector"]
            )
            
    def save_result_in_json(self, file_path: str):
        """save the result in json format

        Args:
            file_path (str): the path to save the json file
            
        Returns:
            bool: True if success, False otherwise
        """
        with open(file_path, 'w') as f:
            json.dump(self.graph_dict, f)
        return True

