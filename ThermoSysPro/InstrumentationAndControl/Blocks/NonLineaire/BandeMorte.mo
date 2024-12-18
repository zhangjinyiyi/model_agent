﻿within ThermoSysPro.InstrumentationAndControl.Blocks.NonLineaire;
block BandeMorte
  parameter Real uMax=1 "Limite supérieure de la bande morte";
  parameter Real uMin=-uMax "Limite inférieure de la bande morte";

  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal u
                                      annotation (Placement(transformation(
          extent={{-120,-10},{-100,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal y
                                       annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
equation

  y.signal = if (u.signal) > uMax then u.signal - uMax else if (u.signal < uMin) then
          u.signal - uMin else 0;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          pattern=LinePattern.Solid,
          lineThickness=0.25),
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name"),
        Line(points={{0,-90},{0,68}}, color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,-8},{68,8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-60},{-20,0},{20,0},{80,60}}, color={0,0,0})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{0,-60},{0,50}}, color={192,192,192}),
        Polygon(
          points={{0,60},{-5,50},{5,50},{0,60}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-76,0},{74,0}}, color={192,192,192}),
        Polygon(
          points={{84,0},{74,-5},{74,5},{84,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-81,-40},{-38,0},{40,0},{80,40}}, color={0,0,0}),
        Text(
          extent={{62,-5},{88,-23}},
          lineColor={128,128,128},
          textString=
               "u"),
        Text(
          extent={{-34,68},{-3,46}},
          lineColor={128,128,128},
          textString=
               "y"),
        Text(
          extent={{-51,1},{-28,19}},
          lineColor={128,128,128},
          textString=
               "uMin"),
        Text(
          extent={{27,21},{52,5}},
          lineColor={128,128,128},
          textString=
               "uMax")}),
    Window(
      x=0.05,
      y=0.3,
      width=0.6,
      height=0.6),
    Documentation(info="<html>
<p><b>Adapted from the Modelica.Blocks.NonLinear library</b></p>
</HTML>
<html>
<p><b>Version 1.0</b></p>
</HTML>
"));
end BandeMorte;
