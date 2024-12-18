within ThermoSysPro.Fluid.Examples.SimpleExamples;
model TestIdealCheckValve

  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP1
                                     annotation (Placement(transformation(
          extent={{-60,-80},{-40,-60}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP puitsP1(
                                   P0=6e5) annotation (Placement(transformation(
          extent={{80,-80},{100,-60}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Pulse pulse(
    amplitude=6e5,
    width=50,
    period=100,
    offset=3e5) annotation (Placement(transformation(extent={{-100,-80},{-80,
            -60}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.IdealCheckValve idealCheckValve3
    annotation (Placement(transformation(extent={{10,-80},{30,-60}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe perteDP2
                                        annotation (Placement(transformation(
          extent={{-30,-80},{-10,-60}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe perteDP3
                                        annotation (Placement(transformation(
          extent={{50,-80},{70,-60}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP              sourceP
                                    annotation (Placement(transformation(extent=
           {{-104,20},{-84,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP              puitsP(
                                  P0=6e5) annotation (Placement(transformation(
          extent={{84,20},{104,40}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump              staticCentrifugalPump1
    annotation (Placement(transformation(extent={{-30,60},{-10,80}}, rotation=0)));
  ThermoSysPro.Fluid.Machines.StaticCentrifugalPump              staticCentrifugalPump2
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}}, rotation=0)));
  ThermoSysPro.Fluid.Volumes.VolumeD              volumeD annotation (Placement(
        transformation(extent={{-50,20},{-30,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.IdealCheckValve              idealCheckValve1
    annotation (Placement(transformation(extent={{10,60},{30,80}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.IdealCheckValve              idealCheckValve2
    annotation (Placement(transformation(extent={{8,-20},{28,0}}, rotation=0)));
  ThermoSysPro.Fluid.Volumes.VolumeC              volumeC annotation (Placement(
        transformation(extent={{30,20},{50,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe              perteDP
                                        annotation (Placement(transformation(
          extent={{-80,20},{-60,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe              perteDP1
                                         annotation (Placement(transformation(
          extent={{60,20},{80,40}}, rotation=0)));
equation
  connect(sourceP1.C, perteDP2.C1)
    annotation (Line(points={{-40,-70},{-30,-70}}, color={0,0,255}));
  connect(perteDP2.C2, idealCheckValve3.C1)
    annotation (Line(points={{-10,-70},{10,-70}}, color={0,0,255}));
  connect(idealCheckValve3.C2, perteDP3.C1)
    annotation (Line(points={{30,-70},{50,-70}}, color={0,0,255}));
  connect(perteDP3.C2, puitsP1.C)
    annotation (Line(points={{70,-70},{80,-70}}, color={0,0,255}));
  connect(pulse.y, sourceP1.IPressure) annotation (Line(points={{-79,-70},{-55,
          -70}}));
  connect(staticCentrifugalPump1.C2,idealCheckValve1. C1) annotation (Line(
        points={{-10,70},{-2,70},{-2,70},{10,70}}, color={0,0,255}));
  connect(staticCentrifugalPump2.C2,idealCheckValve2. C1) annotation (Line(
        points={{-10,-10},{0,-10},{0,-10},{8,-10}}, color={0,0,255}));
  connect(perteDP1.C2,puitsP. C)
    annotation (Line(points={{80,30},{84,30}}, color={0,0,255}));
  connect(sourceP.C,perteDP. C1)
    annotation (Line(points={{-84,30},{-80,30}}, color={0,0,255}));
  connect(perteDP.C2, volumeD.Ce)
    annotation (Line(points={{-60,30},{-50,30}}, color={0,0,0}));
  connect(volumeD.Cs1, staticCentrifugalPump1.C1)
    annotation (Line(points={{-40,40},{-40,70},{-30,70}}, color={0,0,0}));
  connect(volumeD.Cs2, staticCentrifugalPump2.C1)
    annotation (Line(points={{-40,20},{-40,-10},{-30,-10}}, color={0,0,0}));
  connect(idealCheckValve1.C2, volumeC.Ce2)
    annotation (Line(points={{30,70},{40,70},{40,40}}, color={0,0,0}));
  connect(volumeC.Cs, perteDP1.C1)
    annotation (Line(points={{50,30},{60,30}}, color={0,0,0}));
  connect(idealCheckValve2.C2, volumeC.Ce3)
    annotation (Line(points={{28,-10},{40,-10},{40,20}}, color={0,0,0}));
  annotation (experiment(StopTime=1000),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2})),
    Window(
      x=0.28,
      y=0.03,
      width=0.5,
      height=0.6),
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
end TestIdealCheckValve;
