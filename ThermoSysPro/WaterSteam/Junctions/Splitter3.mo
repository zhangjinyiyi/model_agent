﻿within ThermoSysPro.WaterSteam.Junctions;
model Splitter3 "Splitter with three outlets"
  parameter Integer fluid=1 "1: water/steam - 2: C3H3F5";
  parameter Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

public
  Real alpha1 "Extraction coefficient for outlet 1 (<=1)";
  Real alpha2 "Extraction coefficient for outlet 2 (<=1)";
  Units.SI.AbsolutePressure P(start=10e5) "Fluid pressure";
  Units.SI.SpecificEnthalpy h(start=10e5) "Fluid specific enthalpy";
  Units.SI.Temperature T "Fluid temperature";

public
  Connectors.FluidInlet Ce
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}}, rotation=
           0)));
  Connectors.FluidOutlet Cs3
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
  Connectors.FluidOutlet Cs1
    annotation (Placement(transformation(extent={{30,90},{50,110}}, rotation=0)));
  Connectors.FluidOutlet Cs2
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}, rotation=
            0)));
  InstrumentationAndControl.Connectors.InputReal Ialpha1
    "Extraction coefficient for outlet 1 (<=1)"
    annotation (Placement(transformation(extent={{0,50},{20,70}}, rotation=0)));
  InstrumentationAndControl.Connectors.InputReal Ialpha2
    "Extraction coefficient for outlet 2 (<=1)"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}}, rotation=0)));
  InstrumentationAndControl.Connectors.OutputReal Oalpha1
    annotation (Placement(transformation(extent={{60,50},{80,70}}, rotation=0)));
  InstrumentationAndControl.Connectors.OutputReal Oalpha2
    annotation (Placement(transformation(extent={{60,-70},{80,-50}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro
    "Propriétés de l'eau"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
equation

  if (cardinality(Ialpha1) == 0) then
    Ialpha1.signal = 0.3;
  end if;

  if (cardinality(Ialpha2) == 0) then
    Ialpha2.signal = 0.3;
  end if;

  /* Fluid pressure */
  P = Ce.P;
  P = Cs1.P;
  P = Cs2.P;
  P = Cs3.P;

  /* Fluid specific enthalpy (singular if all flows = 0) */
  Ce.h_vol = h;
  Cs1.h_vol = h;
  Cs2.h_vol = h;
  Cs3.h_vol = h;

  /* Mass balance equation */
  0 = Ce.Q - Cs1.Q - Cs2.Q - Cs3.Q;

  /* Energy balance equation */
  0 = Ce.Q*Ce.h - Cs1.Q*Cs1.h - Cs2.Q*Cs2.h - Cs3.Q*Cs3.h;

  /* Mass flows at outlets 1 and 2 */
  if (cardinality(Ialpha1) <> 0) then
    Cs1.Q = Ialpha1.signal*Ce.Q;
  end if;

  if (cardinality(Ialpha2) <> 0) then
    Cs2.Q = Ialpha2.signal*Ce.Q;
  end if;

  alpha1 = Cs1.Q/Ce.Q;
  Oalpha1.signal = alpha1;

  alpha2 =  Cs2.Q/Ce.Q;
  Oalpha2.signal = alpha2;

  /* Fluid thermodynamic properties */
  pro = ThermoSysPro.Properties.Fluid.Ph(P, h, mode, fluid);

  T = pro.T;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={
        Text(extent={{10,-60},{48,-90}}, textString =           "3"),
        Rectangle(
          extent={{44,-27},{50,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-20},{-100,20},{20,20},{20,100},{60,100},{60,20},{100,
              20},{100,-20},{60,-20},{60,-100},{20,-100},{20,-20},{-100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,80},{60,40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "1"),
        Text(
          extent={{20,-40},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "2"),
        Text(
          extent={{60,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "3")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{10,-60},{48,-90}}, textString =           "3"),
        Rectangle(
          extent={{44,-27},{50,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,-20},{-100,20},{20,20},{20,100},{60,100},{60,20},{100,
              20},{100,-20},{60,-20},{60,-100},{20,-100},{20,-20},{-100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{20,80},{60,40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "1"),
        Text(
          extent={{20,-40},{60,-80}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "2"),
        Text(
          extent={{60,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "3")}),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2013</b> </p>
<p><b>ThermoSysPro Version 3.1</h4>
<p>This component model is documented in Sect. 14.8 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </h4>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u> </p>
<ul>
<li>Baligh El Hefni</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end Splitter3;
