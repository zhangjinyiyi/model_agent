﻿within ThermoSysPro.WaterSteam.Junctions;
model Mixer2 "Mixer with two inlets"
  parameter Integer fluid=1 "1: water/steam - 2: C3H3F5";
  parameter Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

public
  Real alpha1 "Extraction coefficient for inlet 1 (<=1)";
  Units.SI.AbsolutePressure P(start=10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Temperature T "Fluid temperature";

public
  Connectors.FluidInlet Ce2
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}},
          rotation=0)));
  Connectors.FluidOutlet Cs                annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
public
  Connectors.FluidInlet Ce1
    annotation (Placement(transformation(extent={{-50,90},{-30,110}}, rotation=
            0)));
  InstrumentationAndControl.Connectors.InputReal Ialpha1
    "Extraction coefficient for inlet 1 (<=1)"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}}, rotation=0)));
  InstrumentationAndControl.Connectors.OutputReal Oalpha1
    annotation (Placement(transformation(extent={{-20,50},{0,70}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro
    "Propriétés de l'eau"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
equation

  if (cardinality(Ialpha1) == 0) then
    Ialpha1.signal = 0.5;
  end if;

  /* Fluid pressure */
  P = Ce1.P;
  P = Ce2.P;
  P = Cs.P;

  /* Fluid specific enthalpy (singular if all flows = 0) */
  Ce1.h_vol = h;
  Ce2.h_vol = h;
  Cs.h_vol = h;

  /* Mass balance equation */
  0 = Ce1.Q + Ce2.Q - Cs.Q;

  /* Energy balance equation */
  0 = Ce1.Q*Ce1.h + Ce2.Q*Ce2.h - Cs.Q*Cs.h;

  /* Mass flow at outlet 1 */
  if (cardinality(Ialpha1) <> 0) then
    Ce1.Q = Ialpha1.signal*Cs.Q;
  end if;

  alpha1 = Ce1.Q/Cs.Q;
  Oalpha1.signal = alpha1;

  /* Fluid thermodynamic properties */
  pro = ThermoSysPro.Properties.Fluid.Ph(P, h, mode, fluid);

  T = pro.T;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-60,-100},{-20,-100},{-20,-20},{100,-20},{100,20},{-20,20},{
              -20,100},{-60,100},{-60,-100}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(extent={{-60,80},{-20,40}}, textString=
                                     "1"),
        Text(extent={{-60,-40},{-20,-80}}, textString=
                             "2")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-60,-100},{-20,-100},{-20,-20},{100,-20},{100,20},{-20,20},{
              -20,100},{-60,100},{-60,-100}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(extent={{-60,80},{-20,40}}, textString=
                                     "1"),
        Text(extent={{-60,-40},{-20,-80}}, textString=
                             "2")}),
    Window(
      x=0.33,
      y=0.09,
      width=0.71,
      height=0.88),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2013</b> </p>
<p><b>ThermoSysPro Version 3.1</h4>
<p>This component model is documented in Sect. 14.7 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </h4>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Baligh El Hefni</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end Mixer2;
