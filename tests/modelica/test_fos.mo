within ;
model test_fos
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-34,4},{-14,24}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.PI pI(Ti = 1, k = 5)
    annotation (Placement(transformation(extent={{12,4},{32,24}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.PT1 pt1(Ti = 10)  annotation(
    Placement(visible = true, transformation(origin = {62, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon echelon(startTime = 10)  annotation(
    Placement(visible = true, transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(add.y, pI.u) annotation(
    Line(points = {{-13, 14}, {11, 14}}, color = {0, 0, 255}));
  connect(pI.y, pt1.u) annotation(
    Line(points = {{34, 14}, {52, 14}}, color = {0, 0, 255}));
  connect(pt1.y, add.u2) annotation(
    Line(points = {{74, 14}, {84, 14}, {84, -18}, {-46, -18}, {-46, 8}, {-34, 8}}, color = {0, 0, 255}));
  connect(echelon.y, add.u1) annotation(
    Line(points = {{-59, 20}, {-34, 20}}, color = {0, 0, 255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(ThermoSysPro(version="4.0")),
    experiment(StopTime=100, __Dymola_Algorithm="Dassl"));
end test_fos;
