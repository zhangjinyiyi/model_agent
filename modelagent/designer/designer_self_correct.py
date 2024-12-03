#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   designer_self_correct.py
@Time    :   2024/11/29 12:37:06
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import json
import os
import shutil
import logging
logger = logging.getLogger(__name__)
import pygraphviz as pgv

from ..llm.base_llm_query import BaseLLMQuery
from ..llm.gpt import GPTQuery


class DesignerSelfCorrect():
    def __init__(
        self,
        llm_query: BaseLLMQuery = GPTQuery(),
        max_iter: int = 4,
        save_intermediate_result: bool = True,
        tmp_path: str = os.path.join(os.getcwd(), "tmp"),
    ):
        self.llm_query = llm_query
        self.max_iter = max_iter
        self.save_intermediate_result = save_intermediate_result
        self.tmp_path = tmp_path
        
        if self.save_intermediate_result and not os.path.exists(self.tmp_path):
            os.makedirs(self.tmp_path)
        
        if not hasattr(self.llm_query, "json_mode"):
            logger.warning("llm_query does not have json_mode attribute, may cause error in design process.")
            self.llm_query.json_mode = True
        
        if (hasattr(self.llm_query, "json_mode") and not self.llm_query.json_mode):
           logger.warning("llm_query.json_mode is set to False, may cause error in design process.")
           
           
        self.prompt_design = """
            you are a modeling and simulation expert. 
            you have deep knowledge in system modeling and simulation softwares, 
            such as matlab/simulink, modelica, aspen plus, etc.
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
            
            Here the design tried with its correctness result, reason and fix advices in a list. You need to avoid the 
            error you made before to give a better design result.
            Here is the design candidates: {design_candidates}
        """
        
        self.prompt_check = """
            You are a senoir system modeling and simulation expert. 
            you have deep knowledge in matlab/simulink, modelica, aspen plus, etc.
            You are given a task: {task}.
            Please check if the given system design is correct.
            you need to check the following aspects:
                1. the system has all necessary components to finish the task in the task description
                2. there is no redundant component in the system
                3. the connections between components are correct
                4. the topology of the system is mathematically and physically and logically correct
            the system design is given in the following json format:
            {system_design}
            if the system is correct, return "correct".
            if the system is incorrect, return "incorrect", the reason and your suggestion to fix the system.
            the output should be a json format as following:
            {{"result": "correct" or "incorrect", "reason": "the reason if the system is incorrect", 
                "suggestion": "the suggestion to fix the system if the system is incorrect"}}
        """
        
        """
        design_candidate = {
            "design": design dict,
            "result": "correct" or "incorrect",
            "reason": "the reason if the system is incorrect", 
            "suggestion": "the suggestion to fix the system if the system is incorrect"
        }
        """
        
        self.design_candidates = []
        self.design: dict = None
        self.graph_graphviz = pgv.AGraph(directed=True)
        self.task = ""
        
        
    def check_system(self, design: dict) -> dict:
        prompt_check = self.prompt_check.format(task=self.task, system_design=json.dumps(design))
        check_result = json.loads(self.llm_query.get_completion(prompt_check))
        design_candidate = {"design": design}
        design_candidate["result"] = check_result["result"]
        design_candidate["reason"] = check_result.get("reason")
        design_candidate["suggestion"] = check_result.get("suggestion")
        return design_candidate
    
    def execute_design(self, task: str) -> dict:
        logger.info(f"Start to design system for task: {task}")
        is_success = False
        self.task = task
        for i in range(self.max_iter):
            prompt_design = self.prompt_design.format(task=task, 
                                                      design_candidates=json.dumps(self.design_candidates))
            design = json.loads(self.llm_query.get_completion(prompt_design))
            
            check_result = self.check_system(design)
            
            correctness = check_result.get("result")
            if correctness is None:
                correctness = "unknown"
            
            if self.save_intermediate_result:
                with open(os.path.join(self.tmp_path, f"check_result_{i+1}_{correctness}.json"), "w") as f:
                    json.dump(check_result, f, indent=4)
                try:
                    self.draw(design=design, 
                              save_path=os.path.join(self.tmp_path, f"system_structure_{i+1}_{correctness}.png"))
                except Exception as e:
                    logger.warning(f"Failed to draw system structure: {e}")
            
            if check_result["result"] == "correct":
                self.design = design
                logger.info(f"Found correct system design on try: {i+1}")
                is_success =True
                break
            else:
                self.design_candidates.append(check_result)
                logger.info(f"Failed design on try: {i+1}")
                
        return is_success
                
    def draw(self, design: dict = None, save_path: str = "./system_structure.png"):
        if design is None:
            design = self.design
        if design:
            design_graphviz = self._graph_dict_to_graphviz(design=design)
            G = design_graphviz
            G.node_attr['shape'] = 'box'
            G.edge_attr['color'] = 'blue'
            G.layout(prog='dot')
            G.draw(save_path)
            return True
        else:
            logger.warning("No design found, please run execute_design() first.")
            return False
            
    def clean(self):
        self.design_candidates = []
        
    def _graph_dict_to_graphviz(self, design):
        
        graph = pgv.AGraph(directed=True)
        # Add all modules as nodes
        node_names = [module["name"] for module in design["modules"]]
        graph.add_nodes_from(node_names)
        
        # Add edges with connection information
        for connection in design["connections"]:
            graph.add_edge(
                connection["upstream_module"],
                connection["downstream_module"],
                # input_name=connection["upstream_connector"],
                # output_name=connection["downstream_connector"]
            )
        return graph
    
    def clean_tmp(self):
        if os.path.exists(self.tmp_path):
            shutil.rmtree(self.tmp_path)
            logger.info(f"Temporary directory {self.tmp_path} removed.")
        else:
            logger.warning(f"Temporary directory {self.tmp_path} does not exist.")
