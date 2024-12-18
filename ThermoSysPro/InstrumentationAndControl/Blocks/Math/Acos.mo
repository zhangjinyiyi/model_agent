within ThermoSysPro.InstrumentationAndControl.Blocks.Math;
block Acos


  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal u
                                      annotation (Placement(transformation(
          extent={{-120,-10},{-100,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal y
                                       annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
equation

  y.signal = Modelica.Math.acos(u.signal);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name"),
        Rectangle(extent={{-100,100},{100,-100}}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{-79.2,72.8},{-77.6,67.5},{-73.6,59.4},{-66.3,
              49.8},{-53.5,37.3},{-30.2,19.7},{37.4,-24.8},{57.5,-40.8},{68.7,
              -52.7},{75.2,-62.2},{77.6,-67.5},{80,-80}}, color={0,0,0}),
        Line(points={{0,-88},{0,68}}, color={192,192,192}),
        Line(points={{-90,-80},{68,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,-14},{-14,-62}},
          lineColor={192,192,192},
          textString=
               "acos")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{0,80},{-8,80}}, color={192,192,192}),
        Line(points={{0,-80},{-8,-80}}, color={192,192,192}),
        Line(points={{0,-90},{0,84}}, color={192,192,192}),
        Text(
          extent={{3,98},{32,80}},
          lineColor={160,160,164},
          textString=
               "y"),
        Polygon(
          points={{0,100},{-6,84},{6,84},{0,100}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,-80},{84,-80}}, color={192,192,192}),
        Polygon(
          points={{100,-80},{84,-74},{84,-86},{100,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,80},{-79.2,72.8},{-77.6,67.5},{-73.6,59.4},{-66.3,
              49.8},{-53.5,37.3},{-30.2,19.7},{37.4,-24.8},{57.5,-40.8},{68.7,
              -52.7},{75.2,-62.2},{77.6,-67.5},{80,-80}}, color={0,0,0}),
        Text(extent={{-30,88},{-5,72}}, textString=
                                            " pi"),
        Text(extent={{-94,-57},{-74,-77}}, textString=
                                               "-1"),
        Text(extent={{80,-45},{100,-65}}, textString=
                                              "+1"),
        Text(
          extent={{76,-84},{102,-102}},
          lineColor={160,160,164},
          textString=
               "u")}),
    Window(
      x=0.03,
      y=0.35,
      width=0.35,
      height=0.49),
    Documentation(info="<html>
<p><b>Adapted from the Modelica.Blocks.Math library</b></p>
</HTML>
<html>
<p><b>Version 1.0</b></p>
</HTML>
"));
end Acos;
