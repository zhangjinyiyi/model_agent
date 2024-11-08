# FuelMassFlowSensor Model Documentation

## Overview
The `FuelMassFlowSensor` is a Modelica model designed to measure and output the mass flow rate of fuel. It is part of the ThermoSysPro library, specifically within the combustion sensors package. This component is typically used in simulations involving combustion systems where precise monitoring of fuel flow is crucial for performance and safety assessments.

## Component Details

### Parameters
- **MassFlowRate Q**: Represents the mass flow rate of the fuel. It has an initial starting value of 20 (in SI units).

### Connectors
- **Mesure**: An output connector of type `OutputReal` that provides the sensor signal corresponding to the measured fuel mass flow rate.
- **C1 (FuelInlet)**: An inlet connector for the fuel, with properties such as temperature, pressure, lower heating value (LHV), specific heat capacity (cp), humidity, and fuel composition parameters.
- **C2 (FuelOutlet)**: An outlet connector mirroring the properties of the inlet to maintain continuity and consistency across the sensor.

### Equations
The model employs several equations to ensure the transfer and conservation of fuel properties between the inlet (C1) and the outlet (C2):
- **Mass flow rate**: \( C1.Q = C2.Q \)
- **Temperature**: \( C1.T = C2.T \)
- **Pressure**: \( C1.P = C2.P \)
- **Lower Heating Value**: \( C1.LHV = C2.LHV \)
- **Specific Heat Capacity**: \( C1.cp = C2.cp \)
- **Humidity**: \( C1.hum = C2.hum \)
- **Fuel Composition**: 
  - Carbon content: \( C1.Xc = C2.Xc \)
  - Hydrogen content: \( C1.Xh = C2.Xh \)
  - Oxygen content: \( C1.Xo = C2.Xo \)
  - Nitrogen content: \( C1.Xn = C2.Xn \)
  - Sulfur content: \( C1.Xs = C2.Xs \)
  - Ash content: \( C1.Xashes = C2.Xashes \)
- **Molar Volume**: \( C1.VolM = C2.VolM \)
- **Density**: \( C1.rho = C2.rho \)

The sensor captures the mass flow rate by assigning the value of \( Q \) from the inlet to the output signal as follows:
- **Sensor Signal**: \( \text{Mesure.signal} = Q \)

### Annotations
Annotations in the model provide graphical representations and documentation:
- **Icon and Diagram**: Graphical symbols and lines depict the sensor in both icon and diagram views, including a blue-outline ellipse with a cross-diagonal green fill, symbolizing the sensing area.
- **Documentation**: Metadata includes copyright information for EDF (2002-2010) and details on the ThermoSysPro Version 2.0, with contributor acknowledgment to Salimou Gassama.

## Use Cases
The `FuelMassFlowSensor` can be integrated into various combustion systems to:
- Monitor real-time fuel flow rate.
- Ensure fuel supply consistency in combustion processes.
- Analyze system performance and efficiency.

## Notes
Ensure compatibility with the ThermoSysPro library's other components for seamless integration into larger system models. Consider adjusting the initial mass flow rate (\( Q \)) based on specific application requirements.

For further details, consult the ThermoSysPro documentation or reach out to the author mentioned in the revisions section.