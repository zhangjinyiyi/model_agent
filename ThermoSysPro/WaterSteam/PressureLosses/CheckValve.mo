﻿within ThermoSysPro.WaterSteam.PressureLosses;
model CheckValve "Check valve"
  parameter ThermoSysPro.Units.SI.PressureDifference dPOuvert=10
    "Pressure difference when the valve opens";
  parameter ThermoSysPro.Units.SI.PressureDifference dPFerme=0
    "Pressure difference when the valve closes";
  parameter ThermoSysPro.Units.xSI.PressureLossCoefficient k=1000
    "Pressure loss coefficient";
  parameter Units.SI.MassFlowRate Qmin=1.e-6
    "Mass flow when the valve is closed";
  parameter Boolean continuous_flow_reversal=false
    "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Integer fluid=1 "1: water/steam - 2: C3H3F5";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density";
  parameter Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

protected
  parameter Real eps=1.e-3 "Small number for pressure loss equation";
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Units.SI.MassFlowRate Qeps=1.e-3
    "Small mass flow for continuous flow reversal";

public
  Boolean ouvert(start=true, fixed=true) "Valve state";
  discrete Boolean touvert(start=false, fixed=true);
  discrete Boolean tferme(start=false, fixed=true);
  Units.SI.MassFlowRate Q(start=500) "Mass flow rate";
  ThermoSysPro.Units.SI.PressureDifference deltaP "Singular pressure loss";
  Units.SI.Density rho(start=998) "Fluid density";
  Units.SI.Temperature T(start=290) "Fluid temperature";
  Units.SI.AbsolutePressure Pm(start=1.e5) "Fluid average pressure";
  Units.SI.SpecificEnthalpy h(start=100000) "Fluid specific enthalpy";
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro
    "Propriétés de l'eau"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  Connectors.FluidInlet C1          annotation (Placement(transformation(extent=
           {{-120,-10},{-100,10}}, rotation=0)));
  Connectors.FluidOutlet C2         annotation (Placement(transformation(extent=
           {{100,-10},{120,10}}, rotation=0)));
equation

  C1.Q = C2.Q;
  C1.h = C2.h;

  h = C1.h;
  Q = C1.Q;

  deltaP = C1.P - C2.P;

  /* Flow reversal */
  if continuous_flow_reversal then
    0 = noEvent(if (Q > Qeps) then C1.h - C1.h_vol else if (Q < -Qeps) then
      C2.h - C2.h_vol else C1.h - 0.5*((C1.h_vol - C2.h_vol)*Modelica.Math.sin(pi
      *Q/2/Qeps) + C1.h_vol + C2.h_vol));
  else
    0 = if (Q > 0) then C1.h - C1.h_vol else C2.h - C2.h_vol;
  end if;

  /* Pressure loss */
  if ouvert then
    deltaP - k*ThermoSysPro.Functions.ThermoSquare(Q, eps)/2/rho = 0;
  else
    Q - Qmin = 0;
  end if;

  touvert = (deltaP > dPOuvert);
  tferme = (deltaP < dPFerme);

  when {pre(tferme),pre(touvert)} then
    ouvert = pre(touvert);
  end when;

  /* Fluid thermodynamic properties */
  Pm = (C1.P + C2.P)/2;

  pro = ThermoSysPro.Properties.Fluid.Ph(Pm, h, mode, fluid);

  T = pro.T;

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = pro.d;
  end if;
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Ellipse(
          extent={{-70,70},{-50,50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5),
        Line(points={{-100,0},{-60,0}}),
        Line(points={{60,0},{100,0}})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(
          points={{-60,-60},{-60,60},{60,-60},{60,60}},
          color={0,203,0},
          thickness=0.5),
        Line(points={{-100,0},{-60,0}}),
        Line(points={{60,0},{100,0}}),
        Ellipse(
          extent={{-70,70},{-50,50}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Window(
      x=0.09,
      y=0.05,
      width=0.91,
      height=0.92),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
<p><b>ThermoSysPro Version 2.0</b></p>
<p>This component model is documented in Sect. 13.11 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </h4>
</HTML>
", revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end CheckValve;
