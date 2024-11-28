graph [
  directed 1
  node [
    id 0
    label "InputSignalGenerator"
  ]
  node [
    id 1
    label "FirstOrderSystem"
  ]
  node [
    id 2
    label "PIDController"
  ]
  node [
    id 3
    label "ErrorCalculator"
  ]
  node [
    id 4
    label "SystemAnalyzer"
  ]
  edge [
    source 0
    target 3
    input_name "output"
    output_name "setpoint"
  ]
  edge [
    source 0
    target 4
    input_name "output"
    output_name "setpoint"
  ]
  edge [
    source 1
    target 3
    input_name "output"
    output_name "process_variable"
  ]
  edge [
    source 1
    target 4
    input_name "output"
    output_name "response"
  ]
  edge [
    source 2
    target 1
    input_name "control_signal"
    output_name "input"
  ]
  edge [
    source 3
    target 2
    input_name "error"
    output_name "process_variable"
  ]
]
