#!/usr/bin/env python3
# -*-coding:utf-8 -*-
"""
@File    :   exemple.py
@Time    :   2024/10/30 10:55:51
@Author  :   Jinyi Zhang 
@Version :   1.0
@Contact :   zhangjinyi.cn@hotmail.com
@License :   (C)Copyright 2023-2024, Jinyi Zhang
@Desc    :   None
"""

import reflex as rx  # Hypothetical import, replace with actual framework import
from modelagent.llm.gpt import GPTQuery

# Initialize the Reflex application
app = rx.App()

# Initialize the GPT model
model = "gpt-4o"
gpt = GPTQuery(model=model)

# Function to generate a response from the LLM
def generate_response(user_input):
    return gpt.get_completion(user_input)

# Define the main route
@app.route('/', methods=['GET', 'POST'])
def index():
    if rx.request.method == 'POST':
        user_input = rx.request.form['user_input']
        response = generate_response(user_input)
        return rx.render_template('index.html', response=response)
    return rx.render_template('index.html')

# Run the application
if __name__ == '__main__':
    app.run(debug=True)