# LLM test log 

## TODO

- [!!!] Multi-agent
    - generate a system structure
- [!!!]better generation of description
- Token number is too high for a complete package
- [!!] long token: 
    - module embedding database?
    - ask llm to generate list of necessary modules and description
    - ranking and selection
    - output final propositions


## Key points
- 

# Setup 

## Preparation
- Library: Thermosyspro, a modelica library for thermodynamic system; Subpackage WaterSteam is used.
- Module list genration: name and description, with a description word limit to 50, token limit. gpt-4o is used.
- automodeling with given graph description

## Test summary
- module list with description in prompt: 1162 modules, too many tokens.
- o1 is better than gpt-4o

## Test 1: gpt-4o

### Prompt
prompt tempelate
```
you are a modeling expert. you need to select all necessary modules from the given list of modules with name and description
    to build a system model to finish a specific task.
    do not forget boundary modules.
    output the necessary modules names in a list.
    output the connections in a list as upstream_module-downstream_module.
    here is the task: {task}.
    here is the module list with description: {modules_list}.
```
#### Task: single pipe system

```build a simple pipe system to test the pressure loss```

Result:

not working, no source or sink is listed.

```
### Necessary Modules:
1. **Connectors.mo**: Necessary for defining the connection interfaces of the water/steam system.
2. **SourceP.mo**: For a water/steam source with fixed pressure to feed into the system.
3. **PipePressureLoss.mo**: To simulate and calculate the pressure loss within the pipe.
4. **Sink.mo**: To serve as the fluid outlet or endpoint of the system.

### Connections:
1. **SourceP.mo-Connectors.mo**: Connect the output of the source with fixed pressure to the input connector.
2. **Connectors.mo-PipePressureLoss.mo**: Connect the inlet of the pipe pressure loss component to the source connector.
3. **PipePressureLoss.mo-Connectors.mo**: Outlet of the pipe connects to another connector.
4. **Connectors.mo-Sink.mo**: Connect the outlet connector to the sink to complete the loop. 
```


## Test2: o1-preview

### Result

Better result, through simple. Still need to improve, source and sink not valid.

```
**Necessary Modules:**

1. Source.mo
2. SensorP.mo (used twice)
3. PipePressureLoss.mo
4. Sink.mo

**Connections:**

1. Source.mo - SensorP.mo (Upstream)
2. SensorP.mo (Upstream) - PipePressureLoss.mo
3. PipePressureLoss.mo - SensorP.mo (Downstream)
4. SensorP.mo (Downstream) - Sink.mo
```