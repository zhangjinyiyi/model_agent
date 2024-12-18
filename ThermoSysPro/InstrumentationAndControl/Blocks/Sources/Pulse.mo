﻿within ThermoSysPro.InstrumentationAndControl.Blocks.Sources;
block Pulse
  parameter Real amplitude=1 "Amplitude des impulsions";
  parameter Real width=0.5 "Largeur des impulsions (s)";
  parameter Real period=1 "Periode des impulsions (s)";
  parameter Real offset=0 "Décalage de la sortie";
  parameter Real startTime=0 "Instant de départ des impulsions";

protected
  Real T0;
public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal y
                                       annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
equation

  when sample(startTime, period) then
    T0 = time;
  end when;

  y.signal = offset + (if time < startTime or time >= T0 + width then 0 else
    amplitude);

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{-40,44},{0,44},{0,-70},{40,-70},{40,
              44},{79,44}}, color={0,0,0}),
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name")}),
    Window(
      x=0.08,
      y=0.05,
      width=0.79,
      height=0.77),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,1},{-37,-12},{-30,-12},{-34,1}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-34,-1},{-34,-70}},
          color={192,192,192},
          pattern=LinePattern.Solid,
          thickness=0.25,
          arrow={Arrow.None,Arrow.None}),
        Polygon(
          points={{-33,-70},{-36,-57},{-30,-57},{-33,-70},{-33,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-78,-24},{-35,-36}},
          lineColor={160,160,164},
          textString=
               "offset"),
        Text(
          extent={{-31,-69},{15,-87}},
          lineColor={160,160,164},
          textString=
               "startTime"),
        Text(
          extent={{-82,93},{-41,73}},
          lineColor={160,160,164},
          textString=
               "y"),
        Text(
          extent={{70,-80},{94,-100}},
          lineColor={160,160,164},
          textString=
               "temps"),
        Line(
          points={{-10,0},{-10,-70}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{-80,0},{-10,0},{-10,50},{30,50},{30,0},{50,0},{50,50},{90,50}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,88},{-10,49}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{30,74},{30,50}},
          color={160,160,164},
          pattern=LinePattern.Dash),
        Line(
          points={{50,88},{50,50}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(points={{-10,83},{51,83}}, color={192,192,192}),
        Line(points={{-10,69},{30,69}}, color={192,192,192}),
        Text(
          extent={{0,97},{46,85}},
          lineColor={160,160,164},
          textString=
               "period"),
        Text(
          extent={{-9,81},{30,69}},
          lineColor={160,160,164},
          textString=
               "width"),
        Line(
          points={{-43,50},{-10,50}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{-34,50},{-34,1}},
          color={192,192,192},
          pattern=LinePattern.Solid,
          thickness=0.25,
          arrow={Arrow.None,Arrow.None}),
        Text(
          extent={{-78,34},{-37,20}},
          lineColor={160,160,164},
          textString=
               "amplitude"),
        Polygon(
          points={{-34,49},{-37,36},{-30,36},{-34,49}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,1},{-37,14},{-31,14},{-34,1},{-34,1}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{90,50},{90,0},{100,0}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-10,69},{-1,71},{-1,67},{-10,69}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{30,69},{22,71},{22,67},{30,69}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,83},{-1,85},{-1,81},{-10,83}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,83},{42,85},{42,81},{50,83}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p><b>Adapted from the Modelica.Blocks.Sources library</b></p>
</HTML>
<html>
<p><b>Version 1.0</b></p>
</HTML>
"));
end Pulse;
