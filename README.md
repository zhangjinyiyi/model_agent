# modelagent
an llm-based package to ease system modeling and simulation

## Key features
- system topology building from task description
    - design, check, correct and improve
    - simple support on multi-round interaction
    - [ongoing] finetune, topology optimization
    - topology visualization based on pygraphviz, better package to be found?
- module retrival based on embedding similarity search, realized based on langchain and openai embeddings
- [planned] module level modelica code generation with detailed description on function, parameters and equations
- [ongoing, modify from automodeling package, omc-based] modelica code generation
- doc generation from modelica code, test on ThermoSysPro
- [ongoing, result not good] code generation from text descriptions
- [planned] parameter search and assignment from documents
- [planned] test case generation based on previous features


# TODO
- multiple round q&a
- multiple agent interaction


## Installation

### Linux or MacOS

`./install.sh`

### Windows

Run the following commands:

`pip install -r requirements.txt`

`pip install -e .`

ATTENTION: if pygraphviz is not installed, you can install it by:

`conda install --channel conda-forge pygraphviz`

please refer to [link](https://pygraphviz.github.io/documentation/stable/install.html) for more pygraphviz installation instructions.


## Usage

- set OPENAI_API_KEY in your environment variables
- set base_url in llm object, e.g. `gpt = GPTQuery(base_url="https://api.openai.com/v1")`


## Examples
### Design a simple system topologywith a task description
For a simple task, such as "build a system to test the pid controller of a first order system", it can design a system as follows:

![Alt text](tests/designer/fos_show.png?raw=true "Title")

[Example code link](./tests/designer/test_designer_design_self_correct.py)

Feel free to test more complex tasks, but it may not work well.

For this task, gpt-4o outperforms significantly gpt-3.5-turbo. 

Fine tune will be tested later.

Another alternative is to use few-shot prompting with a few tricks.

### Iterative design

It uses multi-round interaction to improve the design.

[Example code link](./tests/designer/test_designer_multi_round.py)

Use the following command to run the example in an interactive way:

`python test_designer_multi_round.py`

Use `exit` to exit the interactive mode.

User: 

build a system to test the pid controller of a first order system

Assistant:                         

The system structure is saved in ./tmp\try_2_design.json.
                        The system structure is also drawn and saved in ./tmp\try_2_design.png.
                        The given result: {"modules": [{"name": "FirstOrderSystem", "description": "A module representing a first-order linear system characterized by a time constant and gain.", "parameters": {"time_constant": "T", "gain": "K"}, "input_connectors": ["input_signal"], "output_connectors": ["output_signal"]}, {"name": "PIDController", "description": "A PID controller with adjustable proportional, integral, and derivative gains.", "parameters": {"proportional_gain": "Kp", "integral_gain": "Ki", "derivative_gain": "Kd"}, "input_connectors": ["error_signal"], "output_connectors": ["control_signal"]}, {"name": "SummationBlock", "description": "A summation block to compute the error signal (setpoint - process_variable).", "parameters": {}, "input_connectors": ["input1", "input2"], "output_connectors": ["output"]}, {"name": "SetpointGenerator", "description": "A module that generates a reference setpoint value for the system.", "parameters": {"setpoint_value": "value"}, "input_connectors": [], "output_connectors": ["setpoint"]}, {"name": "Scope", "description": "A scope to visualize system responses over time.", "parameters": {}, "input_connectors": ["input_signal"], "output_connectors": []}], "connections": [{"upstream_module": "SetpointGenerator", "upstream_connector": "setpoint", "downstream_module": "SummationBlock", "downstream_connector": "input1"}, {"upstream_module": "FirstOrderSystem", "upstream_connector": "output_signal", "downstream_module": "SummationBlock", "downstream_connector": "input2"}, {"upstream_module": "SummationBlock", "upstream_connector": "output", "downstream_module": "PIDController", "downstream_connector": "error_signal"}, {"upstream_module": "PIDController", "upstream_connector": "control_signal", "downstream_module": "FirstOrderSystem", "downstream_connector": "input_signal"}, {"upstream_module": "FirstOrderSystem", "upstream_connector": "output_signal", "downstream_module": "Scope", "downstream_connector": "input_signal"}]}
    ![Alt text](tests/designer/demo_imgs/try_2_design.png?raw=true "Title")

User: 

the scope is not necessary, remove it; rename summation block to difference; change setpoint generator to sin generator

Assistant:

Assistant:
                        The system structure is saved in ./tmp\try_3_improved.json.
                        The system structure is also drawn and saved in ./tmp\try_3_improved.png.
                        The given result: {"modules": [{"name": "FirstOrderSystem", "description": "A module representing a first-order linear system characterized by a time constant and gain.", "parameters": {"time_constant": "T", "gain": "K"}, "input_connectors": ["input_signal"], "output_connectors": ["output_signal"]}, {"name": "PIDController", "description": "A PID controller with adjustable proportional, integral, and derivative gains.", "parameters": {"proportional_gain": "Kp", "integral_gain": "Ki", "derivative_gain": "Kd"}, "input_connectors": ["error_signal"], "output_connectors": ["control_signal"]}, {"name": "DifferenceBlock", "description": "A block to compute the error signal (setpoint - process_variable).", "parameters": {}, "input_connectors": ["input1", "input2"], "output_connectors": ["output"]}, {"name": "SinGenerator", "description": "A module that generates a sinusoidal reference setpoint value for the system.", "parameters": {}, "input_connectors": [], "output_connectors": ["setpoint"]}], "connections": [{"upstream_module": "SinGenerator", "upstream_connector": "setpoint", "downstream_module": "DifferenceBlock", "downstream_connector": "input1"}, {"upstream_module": "FirstOrderSystem", "upstream_connector": "output_signal", "downstream_module": "DifferenceBlock", "downstream_connector": "input2"}, {"upstream_module": "DifferenceBlock", "upstream_connector": "output", "downstream_module": "PIDController", "downstream_connector": "error_signal"}, {"upstream_module": "PIDController", "upstream_connector": "control_signal", "downstream_module": "FirstOrderSystem", "downstream_connector": "input_signal"}]}

![Alt text](tests/designer/demo_imgs/try_3_improved.png?raw=true "Title")




