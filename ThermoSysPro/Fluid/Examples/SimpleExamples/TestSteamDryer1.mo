within ThermoSysPro.Fluid.Examples.SimpleExamples;
model TestSteamDryer1

  ThermoSysPro.Fluid.Junctions.SteamDryer steamDryer(
    eta=1,
    h(start=3e6),
    P(start=10000000))
                  annotation (Placement(transformation(extent={{-20,20},{0,40}},
          rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ sourceQ(h0=3000000)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}, rotation=
            0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss
    singularPressureLoss2 annotation (Placement(transformation(extent={{-60,20},
            {-40,40}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP sinkP(P0=100e5)
    annotation (Placement(transformation(extent={{60,20},{80,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss
    singularPressureLoss1 annotation (Placement(transformation(extent={{20,20},
            {40,40}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.SingularPressureLoss
    singularPressureLoss3(K=2.e-3)
                          annotation (Placement(transformation(extent={{0,-20},
            {20,0}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.Sink sink
    annotation (Placement(transformation(extent={{40,-20},{60,0}}, rotation=0)));
equation
  connect(sourceQ.C,singularPressureLoss2. C1) annotation (Line(points={{-80,30},
          {-60,30}}, color={0,0,255}));
  connect(singularPressureLoss1.C2,sinkP. C)
    annotation (Line(points={{40,30},{60,30}}, color={0,0,255}));
  connect(singularPressureLoss3.C2,sink. C)
    annotation (Line(points={{20,-10},{40,-10}}, color={0,0,255}));
  connect(singularPressureLoss2.C2, steamDryer.Cev) annotation (Line(points={{
          -40,30},{-30,30},{-30,34},{-19.9,34}}, color={0,0,255}));
  connect(steamDryer.Csv, singularPressureLoss1.C1) annotation (Line(points={{
          -0.1,34},{10,34},{10,30},{20,30}}, color={0,0,255}));
  connect(steamDryer.Csl, singularPressureLoss3.C1) annotation (Line(points={{
          -9.9,20},{-10,20},{-10,-10},{0,-10}}, color={0,0,255}));
  annotation (experiment(StopTime=1000), Icon(graphics={
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
end TestSteamDryer1;
