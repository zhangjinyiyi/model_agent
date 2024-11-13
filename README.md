# model_agent
an llm-based expert on system modeling and simulation

# features
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


# Tests

## Documentation generation from modelica code
good

## Create models list
- name
- description
    - introduction
    - parameters
    - connectors
    - details
- code

## Create system from task description
- test case
- more complex system

## Modelica code generation from description

- generate documentation for all thermosyspro modules
- ask llm to select necessary modules for a specific task
- boundary conditions
- parameters
- initializations
- automodeling and test