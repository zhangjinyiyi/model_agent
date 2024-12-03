#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   test_multi_round.py
@Time    :   2024/12/03 11:47:23
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

"""
This test is to test the multi-round designer.
run this example in the terminal:
    python test_multi_round_design.py
"""


from modelagent.designer.designer_multi_round import MultiRoundDesigner
from modelagent.designer.designer_self_correct import DesignerSelfCorrect
from modelagent.llm import LLMQuery

import logging
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("--loglevel", type=int, default=logging.INFO)
args = parser.parse_args()

FORMAT = "%(asctime)s - %(name)s[%(lineno)d] - %(levelname)s - %(message)s"
logging.basicConfig(format=FORMAT, level=args.loglevel)

logger = logging.getLogger(__name__)
logger.info("Start testing designer self correct")
logger.info(f"logging level: {args.loglevel}")


if __name__ == "__main__":
    designer = MultiRoundDesigner(
        designer=DesignerSelfCorrect(llm_query=LLMQuery(model_name="gpt-4o", json_mode=True)),
        llm_query=LLMQuery(model_name="gpt-4o", json_mode=True)
    )
    designer.start()
