# modelagent
an llm-based package to ease system modeling and simulation

## Key features
- system topology building from task description
    - design, check, correct and improve
    - simple support on multi-round interaction
    - [ongoing] finetune, topology optimization
    - topology visualization based on pygraphviz, better package to be found?
- module retrival based on embedding similarity search, realized based on langchain and openai embeddings
- [ongoing, modify from automodeling package, omc-based] modelica code generation
- doc generation from modelica code, test on ThermoSysPro
- [ongoing, result not good] code generation from text descriptions
- [planned] parameter search and assignment from documents
- [planned] test case generation based on previous features


# TODO
- multiple round q&a
- multiple agent interaction


# features

- new design
- improve from current design


- module level
    - generate module modelica code from text descriptions
    - check validity of generated modelica code, with compiler integration
    - generate test cases for the modelica code
    - generate documentation html pages for the modelica code
    - recommend 
- system level
    - generate topology from task descriptions
- parameterization from documents
- system initialization 

# How to build a system model?
- analyze the task, propose a model structure
- for each module in the system, select a module for it
- check system closure
- assign parameters, initial conditions
- simulate
- postprocessing
- analysis



## Installation

`pip install -r requirements.txt`

ATTENTION: if pygraphviz is not installed, you can install it by:
`conda install --channel conda-forge pygraphviz`

please refer to [link](https://pygraphviz.github.io/documentation/stable/install.html) for more installation instructions.


## Usage

- set OPENAI_API_KEY in your environment variables
- set base_url in llm object, e.g. `gpt = GPTQuery(base_url="https://api.bianxie.ai/v1")`


## examples
### design a simple system
- [design a simple system](./tests/designer/test_designer_design_self_correct.py)
![Alt text](tests/designer/fos_show.png?raw=true "Title")
