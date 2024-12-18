within ThermoSysPro.Fluid.Examples.SimpleExamples;
model TestThreeWayValve

  ThermoSysPro.Fluid.BoundaryConditions.SourceP SourceP1
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}}, rotation=
            0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP1
                                          annotation (Placement(transformation(
          extent={{70,-10},{90,10}},rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ThreeWayValve threeWayValve(
    C2(Q(start=-7.902947109890763E-33)),
    C3(Q(start=2716.4138702433384)),
    Valve1(Pm(start=200000.0)),
    VolumeA1(h(start=71016.12237181117)))
    annotation (Placement(transformation(extent={{-10,-6},{10,14}},rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP2
                                          annotation (Placement(transformation(
          extent={{70,-50},{90,-30}},
                                    rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Rampe rampe
                                         annotation (Placement(transformation(
          extent={{-50,30},{-30,50}}, rotation=0)));
equation
  connect(rampe.y, threeWayValve.Ouv)
    annotation (Line(points={{-29,40},{0,40},{0,15}}));
  connect(SourceP1.C, threeWayValve.C1)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,0,0}));
  connect(threeWayValve.C2, PuitsP1.C)
    annotation (Line(points={{10,0},{70,0}}, color={0,0,0}));
  connect(threeWayValve.C3, PuitsP2.C)
    annotation (Line(points={{0,-6},{0,-40},{70,-40}}, color={0,0,0}));
  annotation (experiment(StopTime=5),
    Window(
      x=0.45,
      y=0.01,
      width=0.35,
      height=0.49),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})),
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
end TestThreeWayValve;
