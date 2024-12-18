within ThermoSysPro.Fluid.Examples.SimpleExamples;
model TestStaticCentrifugalPump1

  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump StaticCentrifugalPump1(
      fixed_rot_or_power=2, MPower=0.15e6)
    annotation (Placement(transformation(extent={{-20,20},{0,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP
    annotation (Placement(transformation(extent={{-80,20},{-60,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(P0=600000)
    annotation (Placement(transformation(extent={{40,20},{60,40}}, rotation=0)));
equation
  connect(sourceP.C, StaticCentrifugalPump1.C1) annotation (Line(
      points={{-60,30},{-20,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(StaticCentrifugalPump1.C2, sinkP.C) annotation (Line(
      points={{0,30},{40,30}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1000),
    Window(
      x=0.32,
      y=0.02,
      width=0.39,
      height=0.47),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>"));
end TestStaticCentrifugalPump1;
