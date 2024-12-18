﻿within ThermoSysPro.InstrumentationAndControl.Blocks.Tables;
block Table1DTempsBool
  parameter Real Table[:, 2]=[0, 0]
    "Table (temps = première colonne, sequence strictement croissante).";
protected
  parameter Integer iMax=size(Table, 1);
  Integer index(start=1, fixed=true);
  discrete Boolean val(start=(Table[1,2]>0.5), fixed=true);

public
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputLogical yL
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
algorithm

  when (time >= Table[index,1]) then
    val := (Table[index, 2] > 0.5);
    index := if (pre(index) < iMax) then pre(index) + 1 else pre(index);
  end when;

  yL.signal := val;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,255}),
        Text(extent={{-24,54},{0,44}}, textString=
                                            "temps"),
        Line(points={{0,40},{28,40}}, color={0,0,0}),
        Rectangle(
          extent={{-26,40},{0,20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,20},{0,0}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,0},{0,-20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,-20},{0,-40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{28,40},{28,-40}}, color={0,0,0}),
        Line(points={{0,20},{28,20}}, color={0,0,0}),
        Line(points={{0,0},{28,0}}, color={0,0,0}),
        Line(points={{0,-20},{28,-20}}, color={0,0,0}),
        Text(extent={{80,10},{100,0}}, textString=
                                         "Bool"),
        Line(points={{80,0},{100,0}}),
        Line(points={{0,-40},{28,-40}}, color={0,0,0}),
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name"),
        Text(extent={{6,54},{26,44}}, textString=
                                        "Bool")}),
    Window(
      x=0.24,
      y=0.35,
      width=0.73,
      height=0.6),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(extent={{-80,80},{80,-80}}, lineColor={0,0,255}),
        Text(extent={{-24,56},{-2,42}}, textString=
                                          "temps"),
        Text(extent={{2,56},{26,44}}, textString=
                                          "Bool"),
        Line(points={{0,40},{28,40}}, color={0,0,0}),
        Rectangle(
          extent={{-26,40},{0,20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,20},{0,0}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,0},{0,-20}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,-20},{0,-40}},
          lineColor={0,0,0},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{28,40},{28,-40}}, color={0,0,0}),
        Line(points={{0,20},{28,20}}, color={0,0,0}),
        Line(points={{0,0},{28,0}}, color={0,0,0}),
        Line(points={{0,-20},{28,-20}}, color={0,0,0}),
        Line(points={{80,0},{100,0}}),
        Line(points={{0,-40},{28,-40}}, color={0,0,0})}),
    Documentation(info="<html>
<p><b>Adapted from the ModelicaAdditions.Blocks.Tables library</b></p>
</HTML>
<html>
<p><b>Version 1.6</b></p>
</HTML>
"));
end Table1DTempsBool;
