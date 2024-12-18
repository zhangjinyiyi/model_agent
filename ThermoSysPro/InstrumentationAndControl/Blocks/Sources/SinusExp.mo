﻿within ThermoSysPro.InstrumentationAndControl.Blocks.Sources;
block SinusExp
  parameter Real amplitude=1 "Amplitude du sinus";
  parameter Real frequence=2 "Fréquence du sinus (Hz)";
  parameter Real phase=0 "Phase du sinus (rad)";
  parameter Real damping=1 "Coefficient d'amortissement du sinus";
  parameter Real offset=0 "Décalage de la sortie";
  parameter Real startTime=0 "Instant de départ de l'échelon";

protected
  constant Real pi=Modelica.Constants.pi;

public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal y
                                       annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
equation

  y.signal = offset + (if time < startTime then 0 else amplitude*
    Modelica.Math.exp(-(time - startTime)*damping)*Modelica.Math.sin(2*pi*
    frequence*(time - startTime) + phase));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name"),
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
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{-75.2,32.3},{-72,50.3},{-68.7,64.5},{-65.5,74.2},
              {-62.3,79.3},{-59.1,79.6},{-55.9,75.3},{-52.7,67.1},{-48.6,52.2},
              {-43,25.8},{-35,-13.9},{-30.2,-33.7},{-26.1,-45.9},{-22.1,-53.2},
              {-18.1,-55.3},{-14.1,-52.5},{-10.1,-45.3},{-5.23,-32.1},{8.44,
              13.7},{13.3,26.4},{18.1,34.8},{22.1,38},{26.9,37.2},{31.8,31.8},{
              38.2,19.4},{51.1,-10.5},{57.5,-21.2},{63.1,-25.9},{68.7,-25.9},{
              75.2,-20.5},{80,-13.8}}, color={0,0,0}),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString=
               "freqHz=%freqHz")}),
    Window(
      x=0.16,
      y=0.34,
      width=0.6,
      height=0.6),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-80,-90},{-80,84}}, color={192,192,192}),
        Polygon(
          points={{-80,100},{-86,84},{-74,84},{-80,100}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-99,-40},{85,-40}}, color={192,192,192}),
        Polygon(
          points={{101,-40},{85,-34},{85,-46},{101,-40}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-50,0},{-46.1,28.2},{-43.5,44},{-40.9,56.4},{-38.2,64.9},{
              -35.6,69.4},{-33,69.6},{-30.4,65.9},{-27.8,58.7},{-24.5,45.7},{
              -19.9,22.5},{-13.4,-12.2},{-9.5,-29.5},{-6.23,-40.1},{-2.96,-46.5},
              {0.302,-48.4},{3.57,-45.9},{6.83,-39.6},{10.8,-28.1},{21.9,12},{
              25.8,23.1},{29.7,30.5},{33,33.3},{36.9,32.5},{40.8,27.8},{46,16.9},
              {56.5,-9.2},{61.7,-18.6},{66.3,-22.7},{70.9,-22.6},{76.1,-18},{80,
              -12.1}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-106,10},{-83,-10}},
          lineColor={160,160,164},
          textString=
               "offset"),
        Text(
          extent={{-72,-36},{-26,-54}},
          lineColor={160,160,164},
          textString=
               "startTime"),
        Text(
          extent={{84,-52},{108,-72}},
          lineColor={160,160,164},
          textString=
               "time"),
        Text(
          extent={{-79,104},{-39,87}},
          lineColor={160,160,164},
          textString=
               "y"),
        Line(
          points={{-50,0},{18,0}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{-50,0},{-81,0}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-50,77},{-50,0}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{18,-1},{18,76}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(points={{18,73},{-50,73}}, color={192,192,192}),
        Text(
          extent={{-42,88},{9,74}},
          lineColor={160,160,164},
          textString=
               "1/frequence"),
        Polygon(
          points={{-49,73},{-40,75},{-40,71},{-49,73}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,73},{10,75},{10,71},{18,73}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-50,-61},{-19,-61}}, color={192,192,192}),
        Polygon(
          points={{-18,-61},{-26,-59},{-26,-63},{-18,-61}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-51,-63},{-27,-75}},
          lineColor={160,160,164},
          textString=
               "t"),
        Text(
          extent={{-82,-67},{108,-96}},
          lineColor={160,160,164},
          textString=
               "amplitude*exp(-damping*t)*sin(2*pi*frequence*t+phase)"),
        Line(
          points={{-50,0},{-50,-40}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{-50,-54},{-50,-72}},
          color={192,192,192},
          pattern=LinePattern.Dash),
        Line(
          points={{-15,-77},{-1,-48}},
          color={192,192,192},
          pattern=LinePattern.Dash)}),
    Documentation(info="<html>
<p><b>Adapted from the Modelica.Blocks.Sources library</b></p>
</HTML>
<html>
<p><b>Version 1.7</b></p>
</HTML>
"));
end SinusExp;
