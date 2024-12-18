#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   doc_generator_modelica.py
@Time    :   2024/11/08 14:03:25
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from ..llm import LLMQuery, GPTQuery
import logging
import time
import json
import os
import re
from tqdm import tqdm

logger = logging.getLogger(__name__)


class DocGeneratorModelica:
    def __init__(
            self, 
            llm_query: LLMQuery = GPTQuery(model="gpt-4o", json_mode=True),
            max_description_len=100,
            max_trial=3,
            trial_delay=5,
            package_name="ThermoSysPro",
            ) -> None:
        self.llm_query = llm_query
        self.max_description_len = max_description_len
        self.max_trial = max_trial
        self.trial_delay = trial_delay
        self.package_name = package_name

        self.prompt_template = """
            You are a modelica expert on modeling and simulation.
            You are ask to write a model description based on the given modelica code. 
            modelica code : {code}.
            Output the description in strict json format as:
            {{
                "description": "description of the model",
                "model_name": "model name found in the modelica code",
                "parameters": [
                    {{"name": "name of parameter", "description": "description of parameter"}},
                    {{"name": "name of parameter", "description": "description of parameter"}},
                    ...
                ],
                "input_connectors": [
                    {{"name": "name of input connector", "description": "description of input connector"}},
                    {{"name": "name of input connector", "description": "description of input connector"}},
                    ...
                ],
                "output_connectors": [
                    {{"name": "name of output connector", "description": "description of output connector"}},
                    {{"name": "name of output connector", "description": "description of output connector"}},
                    ...
                ]
            }}
        """
        
        self.prompt_json = """
            Convert the text into a strict json format text, suitable for json load string.
            If the text is a markdown text, remove all the markdown markers.
            text : {text}.
        """

    def generate(self, code_text="", code_path="", source="file"):
        """
        Generate the model description based on the given modelica code.

        Args:
            code_text (str, optional): The modelica code in text format. Defaults to "".
            code_path (str, optional): The path to the modelica code file. Defaults to "".
            source (str, optional): The source of the modelica code. Defaults to "file".

        Raises:
            ValueError: If the source is not "file" or "text".

        Returns:
            dict: The model description in json format.
        """

        if source not in ["file", "text"]:
            raise ValueError(f"source type not right: {source}")

        is_success = False
        for i in range(self.max_trial):
            try:
                if source == "text":
                    desc = self.generate_from_text(code_text=code_text)
                elif source == "file":
                    desc = self.generate_from_file(code_path=code_path)
                else:
                    pass
                is_success = True
            except:
                time.sleep(self.trial_delay)
                logger.warning(f"Try failed : {i}")
            if is_success:
                break
        if is_success is False:
            desc = None
            
        try:
            desc_dict = json.loads(desc)
        except:
            logger.warning(f"Failed to load json, try to convert the text into a json format text.")
            desc = self.llm_query.get_completion(prompt=self.prompt_json.format(text=desc))
            desc_dict = json.loads(desc)
                        
        return desc_dict


    def generate_from_text(self, code_text):
        return self.llm_query.get_completion(prompt=self.prompt_template.format(code=code_text))
    
    def generate_from_file(self, code_path):
        with open(code_path, "r") as f:
            code_text = f.read()
        return self.generate_from_text(code_text)
    
    def generate_descs_from_dir(self, code_dir, save_path="./module_descriptions.json", 
                                exclude_fnames=["package.order", "package.mo", "UsersGuide.mo"]):
        """
        Generate the model description for all the modules in the given directory.
        
        Args:
            code_dir (str): The directory to the modelica code.
                The directory path should contain the root package name.
            save_path (str, optional): The path to save the module descriptions. 
                Defaults to "./module_descriptions.json".
            exclude_fnames (list, optional): The names of the files to be excluded. 
                Defaults to ["package.order", "package.mo", "UsersGuide.mo"].

        Returns:
            dict: The module descriptions in json format.
        """    
                
        module_paths = []
        module_descriptions = {}
        for root, _, files in os.walk(code_dir):
            for f in files:
                if f not in exclude_fnames:
                    path = os.path.join(root, f)
                    module_paths.append(path)
                    print(path)
        logger.info(f"Number of modules: {len(module_paths)}")

        # i = 0
        for module_path in tqdm(module_paths, desc="Generating descriptions"):
            module_path:str
            module_name = re.split(r"[\\/]+", module_path)[-1]
            logger.info(f"Generating description for module: {module_name}")
            desc = self.generate(code_path=module_path, source="file")
            desc["module_ref"] = self._get_module_reference(module_path)
            if desc["module_ref"] is None:
                desc["module_ref"] = module_name
                logger.warning(f"Module reference not found for {module_name}, use module name as reference")
            logger.info(f"Module reference: {desc['module_ref']}")
            module_descriptions[desc["module_ref"]] = desc
            
            # if i >= 3:
            #     break
            
            # i += 1
            
        with open(save_path, "w") as f:
            json.dump(module_descriptions, f, indent=4)
            
            
    def _get_module_reference(self, module_path):
        """
        Get the reference of the module.

        Args:
            module_path (str): The path to the module. the package name must be included in the path.

        Returns:
            str: The reference of the module.
        """
        module_path_parts = re.split(r"[\\/.]+", module_path)[:-1]

        idx_target = None
        for i in range(len(module_path_parts)):
            idx_cur = -1 - i
            part = module_path_parts[idx_cur]
            if part.lower() == self.package_name.lower():
                idx_target = idx_cur
                break
            
        if idx_target is None:
            logger.error(f"Module reference not found in the path: {module_path}")
            return None
        else:
            return ".".join(module_path_parts[idx_target:])
            
    