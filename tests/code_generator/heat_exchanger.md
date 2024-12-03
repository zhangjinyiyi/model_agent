Creating a complete Modelica code for a heat exchanger involves defining the system equations, parameters, and connecting components like fluid streams and thermal conductors. Below is a simple example of a counterflow heat exchanger using the Modelica language.

```modelica
model CounterflowHeatExchanger
  // Import necessary Modelica libraries
  import Modelica.Fluid.Interfaces.*
    "Importing fluid interfaces for ports";
  import Modelica.Thermal.HeatTransfer.Components.*
    "Importing heat transfer components";

  // Parameters
  parameter Real UA=500 "Heat transfer coefficient times area";
  parameter Real effectiveness=0.8 "Heat exchanger effectiveness";

  // Fluid properties
  parameter Real cp1 = 4184 "Specific heat capacity of fluid 1 [J/kg.K]";
  parameter Real cp2 = 4184 "Specific heat capacity of fluid 2 [J/kg.K]";

  // Connectors
  FluidPort_a hotInlet "Hot fluid inlet";
  FluidPort_b hotOutlet "Hot fluid outlet";
  FluidPort_a coldInlet "Cold fluid inlet";
  FluidPort_b coldOutlet "Cold fluid outlet";

  // State variables
  Real Q "Heat transfer rate [W]";

equation 
  // Calculate heat transfer based on the effectiveness-NTU method
  Q = effectiveness * min(hotInlet.m_flow * cp1, coldInlet.m_flow * cp2) * 
      (hotInlet.p + hotInlet.m_flow/(hotInlet.m_flow * cp1) - 
      coldInlet.p - coldInlet.m_flow/(coldInlet.m_flow * cp2));

  // Energy balances
  hotInlet.m_flow * cp1 * (hotInlet.T - hotOutlet.T) = Q;
  coldInlet.m_flow * cp2 * (coldOutlet.T - coldInlet.T) = Q;

  // Pressure drops assumed to be negligible
  hotOutlet.p = hotInlet.p;
  coldOutlet.p = coldInlet.p;

end CounterflowHeatExchanger;
```

### Explanation

- **Import Statements**: Import necessary components for fluid and thermal modeling using Modelica libraries.
- **Parameters**: Define UA as the product of the heat transfer coefficient and the heat transfer area, and the effectiveness, a measure of the heat exchanger's ability to transfer heat.
- **Fluid Properties**: Specific heat capacities for both fluids, assumed equal in this simplified model.
- **Connectors**: Define fluid ports for the hot and cold sides of the exchanger using `FluidPort_a` and `FluidPort_b` connectors.
- **Equations**: 
  - Calculate the heat transfer `Q` using the effectiveness-NTU method, a common approach in heat exchanger design.
  - Perform energy balance calculations for both fluids.
  - Assume negligible pressure drops.
  
This is a rudimentary example for illustrative purposes. Actual heat exchanger modeling might require more sophisticated handling of properties like variable fluid properties, pressure drop calculations, and more complex heat transfer correlations.