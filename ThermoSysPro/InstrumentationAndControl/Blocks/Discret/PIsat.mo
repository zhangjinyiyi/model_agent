﻿within ThermoSysPro.InstrumentationAndControl.Blocks.Discret;
block PIsat
  parameter Real Kp=1 "Gain";
  parameter Real Ti=1 "Constante de temps";
  parameter Real initialCond=0 "Condition initiale";

  parameter Real maxval=1 "Valeur maximale de la sortie";
  parameter Real minval=0 "Valeur minimale de la sortie";

  parameter Real SampleOffset=0 "Instant de départ de l'échantillonnage (s)";
  parameter Real SampleInterval=0.01 "Période d'échantillonnage (s)";
  ThermoSysPro.InstrumentationAndControl.Connectors.InputReal u
                                      annotation (Placement(transformation(
          extent={{-120,-10},{-100,10}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal y
                                       annotation (Placement(transformation(
          extent={{100,-10},{120,10}}, rotation=0)));
  Math.Add Add1       annotation (Placement(transformation(extent={{-60,-6},{
            -40,14}}, rotation=0)));
  PI PI1(
    k=Kp,
    Ti=Ti,
    initialCond=initialCond,
    SampleOffset=SampleOffset,
    SampleInterval=SampleInterval) annotation (Placement(transformation(extent=
            {{-20,-6},{0,14}}, rotation=0)));
  NonLineaire.Limiteur Limiteur1(maxval=maxval, minval=minval)
    annotation (Placement(transformation(extent={{60,-10},{80,10}}, rotation=0)));
  Math.Gain Gain1(Gain=1/Kp)       annotation (Placement(transformation(extent=
            {{-40,60},{-60,80}}, rotation=0)));
  Math.Add Add2(k2=-1)       annotation (Placement(transformation(extent={{20,
            60},{0,80}}, rotation=0)));
  Pre Pre1(SampleOffset=SampleOffset, SampleInterval=SampleInterval)
                        annotation (Placement(transformation(
        origin={-80,38},
        extent={{-10,-10},{10,10}},
        rotation=270)));
equation
  connect(u, Add1.u2)
    annotation (Line(points={{-110,0},{-85.5,0},{-85.5,-2},{-61,-2}}));
  connect(Add1.y, PI1.u) annotation (Line(points={{-39,4},{-21,4}}));
  connect(PI1.y, Limiteur1.u) annotation (Line(points={{1,4},{40,4},{40,0},{59,
          0}}));
  connect(Limiteur1.y, y) annotation (Line(points={{81,0},{110,0}}));
  connect(PI1.y, Add2.u2) annotation (Line(points={{1,4},{40,4},{40,64},{21,64}}));
  connect(Limiteur1.y, Add2.u1)
    annotation (Line(points={{81,0},{90,0},{90,76},{21,76}}));
  connect(Gain1.u, Add2.y) annotation (Line(points={{-39,70},{-1,70}}));
  connect(Gain1.y, Pre1.u) annotation (Line(points={{-61,70},{-80,70},{-80,49}}));
  connect(Pre1.y, Add1.u1) annotation (Line(points={{-80,27},{-80,10},{-61,10}}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-74,64},{-74,-80}}, color={0,0,0}),
        Line(points={{-74,-80},{70,-80}}, color={0,0,0}),
        Polygon(
          points={{92,-80},{70,-72},{70,-88},{92,-80}},
          lineColor={192,192,192},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,-68},{-74,2},{24,42}},
          color={0,0,255},
          thickness=0.25),
        Text(
          extent={{-32,70},{0,42}},
          lineColor={160,160,164},
          textString=
               "PI"),
        Line(points={{24,42},{76,42}}),
        Text(extent={{-150,150},{150,110}}, textString=
                                                "%name"),
        Polygon(
          points={{-74,86},{-82,64},{-66,64},{-74,86}},
          lineColor={192,192,192},
          fillColor={128,128,128},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-36,-34},{54,-74}},
          lineColor={0,0,0},
          textString=
               "Ti=%Ti"),
        Text(
          extent={{-38,10},{52,-30}},
          lineColor={0,0,0},
          textString=
               "K=%Kp")}),
    Window(
      x=0.16,
      y=0.19,
      width=0.72,
      height=0.79),
    Documentation(info="<html>
<p><b>Version 1.0</b></p>
</HTML>
"));
end PIsat;
