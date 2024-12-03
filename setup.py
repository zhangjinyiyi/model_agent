#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   setup.py
@Time    :   2024/10/30 11:01:48
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import re
from setuptools import setup
import os
from datetime import datetime


def get_property(prop, project):
    """get project properties

    Args:
        prop (str): property
        project (str): project name

    Returns:
        str: property value
    """
    init_file = os.path.join(project, "__init__.py")
    result = re.search(r'{}\s*=\s*[\'"]([^\'"]*)[\'"]'.format(prop), open(init_file).read())
    return result.group(1)


project_name = 'modelagent'


setup(
    name=project_name,
    version=get_property('__version__', project_name),
    description='a model agent for modeling and simulation',
    author='Jinyi Zhang',
    author_email='zhangjinyi.cn@hotmail.com',
    packages=['modelagent', 'modelagent.llm', 'modelagent.conversation', 'modelagent.designer']
)
            






