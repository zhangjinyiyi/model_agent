within ThermoSysPro.Fluid.BoundaryConditions;
model SourcePQ "MultiFluids source with fixed pressure and mass flow rate"
  extends
    ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidTypeParameterInterface;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  parameter Units.SI.AbsolutePressure P0=300000
    "Fluid pressure (active if IPressure connector is not connected)";
  parameter Units.SI.MassFlowRate Q0=100
    "Mass flow (active if IMassFlow connector is not connected)";
  parameter Units.SI.Temperature T0=290
    "Source temperature (active if option_temperature=true)"
    annotation (Evaluate=true, Dialog(enable=option_temperature));
  parameter Units.SI.SpecificEnthalpy h0=100000
    "Source specific enthalpy (active if option_temperature=false)"
    annotation (Evaluate=true, Dialog(enable=not option_temperature));
  parameter Boolean option_temperature=false
    "true:temperature fixed - false:specific enthalpy fixed";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false
    "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter IF97Region region=IF97Region.All_regions "IF97 regions (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(enable=(ftype==FluidType.WaterSteam), tab="Fluid", group="Fluid properties"));

  parameter ThermoSysPro.Units.SI.MassFraction Xco2=0.01 "CO2 mass fraction"
    annotation (Evaluate=true, Dialog(
      enable=(ftype == FluidType.FlueGases),
      tab="Fluid",
      group="Composition values (active for flue gases only)"));
  parameter ThermoSysPro.Units.SI.MassFraction Xh2o=0.05 "H2O mass fraction"
    annotation (Evaluate=true, Dialog(
      enable=(ftype == FluidType.FlueGases),
      tab="Fluid",
      group="Composition values (active for flue gases only)"));
  parameter ThermoSysPro.Units.SI.MassFraction Xo2=0.22 "O2 mass fraction"
    annotation (Evaluate=true, Dialog(
      enable=(ftype == FluidType.FlueGases),
      tab="Fluid",
      group="Composition values (active for flue gases only)"));
  parameter ThermoSysPro.Units.SI.MassFraction Xso2=0 "SO2 mass fraction"
    annotation (Evaluate=true, Dialog(
      enable=(ftype == FluidType.FlueGases),
      tab="Fluid",
      group="Composition values (active for flue gases only)"));

protected
  parameter Boolean flue_gases=(ftype == FluidType.FlueGases) "Flue gases";
  parameter Integer mode=Integer(region) - 1 "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

public
  Units.SI.MassFlowRate Q "Fluid mass flow rate";
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";
  Units.SI.Temperature T(start=300) "Fluid temperature";

public
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal IMassFlow
    "Fixed mass flow rate"
    annotation (Placement(transformation(
        origin={0,50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal IPressure
    "Fixed pressure"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}}, rotation=
            0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal ISpecificEnthalpyOrTemperature
    "Fixed specific enthalpy or temperature according to option_temperature"
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{10,-10},{-10,10}},
        rotation=270)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet C annotation (Placement(
        transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation

  C.Q = Q;
  C.P = P;

  C.h_vol_1 = h;
  C.diff_res_1 = 0;
  C.diff_on_1 = diffusion;

  ftype = C.ftype;

  if flue_gases then
    C.Xco2 = Xco2;
    C.Xh2o = Xh2o;
    C.Xo2 = Xo2;
    C.Xso2 = Xso2;
  else
    C.Xco2 = 0;
    C.Xh2o = 0;
    C.Xo2 = 0;
    C.Xso2 = 0;
  end if;

  /* Mass flow */
  if (cardinality(IMassFlow) == 0) then
    IMassFlow.signal = Q0;
  end if;

  Q = IMassFlow.signal;

  /* Pressure */
  if (cardinality(IPressure) == 0) then
    IPressure.signal = P0;
  end if;

  P = IPressure.signal;

  /* Specific enthalpy or temperature */
  if (cardinality(ISpecificEnthalpyOrTemperature) == 0) then
    if option_temperature then
      ISpecificEnthalpyOrTemperature.signal = T0;
    else
      ISpecificEnthalpyOrTemperature.signal = h0;
    end if;
  end if;

  if option_temperature then
    T = ISpecificEnthalpyOrTemperature.signal;
    h = ThermoSysPro.Properties.Fluid.SpecificEnthalpy_PT(P, T, fluid, mode, Xco2, Xh2o, Xo2, Xso2);
  else
    h = ISpecificEnthalpyOrTemperature.signal;
    T = ThermoSysPro.Properties.Fluid.Temperature_Ph(P, h, fluid, mode, Xco2, Xh2o, Xo2, Xso2);
  end if;

  /* Flow reversal */
  if continuous_flow_reversal then
    C.h = ThermoSysPro.Functions.SmoothCond(C.Q*C.diff_res_2, C.h_vol_1, C.h_vol_2, 1);
  else
    C.h = if (C.Q > 0) then C.h_vol_1 else C.h_vol_2;
  end if;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{40,0},{90,0},{72,10}}),
        Line(points={{90,0},{72,-10}}),
        Text(extent={{-58,30},{-40,10}}, textString="P"),
        Text(extent={{-28,60},{-10,40}}, textString="Q"),
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,0}),
        Text(
          extent={{-22,20},{20,-24}},
          lineColor={0,0,255},
          textString=
               "P Q"),
        Text(extent={{-40,-40},{-10,-60}}, textString="h / T")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{40,0},{90,0},{72,10}}),
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor=DynamicSelect({255,255,0}, fill_color_static)),
        Line(points={{90,0},{72,-10}}),
        Text(extent={{-30,60},{-10,40}}, textString="Q"),
        Text(extent={{-60,30},{-40,10}}, textString="P"),
        Text(
          extent={{-22,20},{20,-24}},
          lineColor={0,0,255},
          textString=
               "P Q"),
        Text(extent={{-40,-40},{-10,-60}}, textString="h / T")}),
    Window(
      x=0.23,
      y=0.15,
      width=0.81,
      height=0.71),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Baligh El Hefni</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end SourcePQ;
