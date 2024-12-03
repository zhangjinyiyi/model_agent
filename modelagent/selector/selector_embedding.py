#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   selector_embedding.py
@Time    :   2024/11/27 16:20:49
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

from typing import List
import logging
logger = logging.getLogger(__name__)

OPENAI_EMBEDDING_MODELS = ["text-embedding-3-large", "text-embedding-3-small"]


class SelectorEmbedding:
    """
    SelectorEmbedding is a class to select modules from a list of modules using embedding.
    """
    def __init__(
        self, 
        embedding_model_name: str = "text-embedding-3-large",
        base_url: str = "https://api.bianxie.ai/v1",
        ):
        
        self.base_url = base_url
        self.embedding_model_name = embedding_model_name
        
        if embedding_model_name in OPENAI_EMBEDDING_MODELS:
            from langchain_openai import OpenAIEmbeddings
            self.embedding_model = OpenAIEmbeddings(model=embedding_model_name, base_url=base_url)
        else:
            logger.error(f"Embedding model {embedding_model_name} not supported")

        self.vectorstore = None
        self.retriever = None
        
    def build_embedding_vectorstore(self, model_candidates: List[str], metadata: List[dict]=None) -> List[str]:
        from langchain_core.vectorstores import InMemoryVectorStore
        self.vectorstore = InMemoryVectorStore.from_texts(
            model_candidates,
            embedding=self.embedding_model,
            metadatas=metadata
        )
        self.retriever = self.vectorstore.as_retriever()
        
    def select(self, query: str, top_k: int = 1) -> str:
        retrieved_model = self.retriever.invoke(query)
        if top_k == 1:
            return retrieved_model[0]
        else:
            return retrieved_model[:top_k]
