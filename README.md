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

## Modelica code generation from description

- generate documentation for all thermosyspro modules
- ask llm to select necessary modules for a specific task
- boundary conditions
- parameters
- initializations
- automodeling and test