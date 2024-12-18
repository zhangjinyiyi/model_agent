#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   multiround_designer.py
@Time    :   2024/12/03 10:01:38
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from .designer_self_correct import DesignerSelfCorrect
from ..llm.llm_query import LLMQuery
import logging
import json
import os

logger = logging.getLogger(__name__)


class MultiRoundDesigner:
    def __init__(
        self,
        designer: DesignerSelfCorrect,
        llm_query: LLMQuery = LLMQuery(model_name="gpt-4o", json_mode=True),
        tmp_path: str = "./tmp"
    ):
        self.designer = designer
        self.llm_query = llm_query
        self.tmp_path = tmp_path

        self.prompt_intention = """
            you are a modeling and simulation expert. 
            you have deep knowledge in system modeling and simulation softwares, 
            such as matlab/simulink, modelica, aspen plus, etc.
            Here is the user input: {user_input}.
            based on the user's input, you need to determine what the user wants to do:
                - design: design a system
                - improve: improve the current system
                - other: other intentions
            utput the user's intention in json format.
            the json format should be:
            {{"intention": "user's intention, it should be one of the following: design, improve, or other",
              "task": "user's task, 
                it should be a task description if the intention is design, or a feedback if the intention is improve"}}
        """

    def start(self):
        messages = []
        i = 1
        print(f"Start system building with {self.designer.llm_query.model_name}")
        while True:
            task = ""
            user_input = input("User: ")
            messages.append({"role": "user", "content": user_input})
            if user_input.lower() == "exit":
                break
            else:
                try:
                    check_result = self.check_intention(user_input)
                    intention = check_result["intention"]
                    task = check_result.get("task")
                except Exception as e:
                    intention = "other"
                    task = ""
                    logger.warning(f"Failed to check user's intention: {e}")
                    
                if intention == "design":
                    logger.info(f"User's intention is design, task: {user_input}")
                    design = self.designer.execute_design(task=task)
                    save_path_png = os.path.join(self.tmp_path, f"try_{i}_design.png")
                    save_path_json = os.path.join(self.tmp_path, f"try_{i}_design.json")
                    self.designer.draw(design=design, save_path=save_path_png)
                    self.designer.save_design(save_path=save_path_json)
                    messages.append({"role": "assistant", "content": json.dumps(design)})
                    answer = f"""
                        The system structure is saved in {save_path_json}.
                        The system structure is also drawn and saved in {save_path_png}.
                        The given result: {json.dumps(design)}
                        """
                elif intention == "improve":
                    improve_feedback = user_input
                    logger.info(f"User's intention is improve, feedback: {improve_feedback}")
                    design = self.designer.improve_design(task=task, design=self.designer.design, 
                                                          feedback=improve_feedback)
                    save_path_png = os.path.join(self.tmp_path, f"try_{i}_improved.png")
                    save_path_json = os.path.join(self.tmp_path, f"try_{i}_improved.json")
                    self.designer.draw(design=design, save_path=save_path_png)
                    self.designer.save_design(save_path=save_path_json)
                    messages.append({"role": "assistant", "content": json.dumps(design)})
                    answer = f"""
                        The system structure is saved in {save_path_json}.
                        The system structure is also drawn and saved in {save_path_png}.
                        The given result: {json.dumps(design)}
                        """
                else:
                    logger.debug("User's intention is not design or improve, use gpt-4o to answer")
                    answer = self.llm_query.get_completion_messages(
                        messages=messages,
                        json_mode=False
                    )
                    messages.append({"role": "assistant", "content": answer})
                    logger.warning("User's intention is not design or improve, please try again.")
                print(f"Assistant: {answer}")
                i += 1

    def check_intention(self, user_input: str):
        prompt = self.prompt_intention.format(user_input=user_input)
        result = self.llm_query.get_completion_messages(
                    [
                        {"role": "user", "content": prompt}
                    ]
                 )
        try:
            result_dict = json.loads(result)
        except:
            logger.warning(f"json loads failed, llm returns: {result}")
            result_dict = {"intention": "other", "task": ""}
        return result_dict
    
    def clean_tmp_files(self):
        for file in os.listdir(self.tmp_path):
            os.remove(os.path.join(self.tmp_path, file))

    