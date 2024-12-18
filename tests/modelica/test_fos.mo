within ;
model test_fos
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Echelon echelon
    annotation (Placement(transformation(extent={{-86,2},{-66,22}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-34,4},{-14,24}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.PI pI
    annotation (Placement(transformation(extent={{12,4},{32,24}})));
  ThermoSysPro.InstrumentationAndControl.Blocks.Continu.FctTrans fctTrans
    annotation (Placement(transformation(extent={{52,4},{72,24}})));
equation
  connect(echelon.y, add.u1) annotation (Line(points={{-65,12},{-40,12},{-40,20},
          {-35,20}}, color={0,0,255}));
  connect(add.y, pI.u)
    annotation (Line(points={{-13,14},{11,14}}, color={0,0,255}));
  connect(pI.y, fctTrans.u)
    annotation (Line(points={{33,14},{51,14}}, color={0,0,255}));
  connect(fctTrans.y, add.u2) annotation (Line(points={{73,14},{78,14},{78,0},{
          -42,0},{-42,8},{-35,8}}, color={0,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(ThermoSysPro(version="4.0")),
    experiment(StopTime=100, __Dymola_Algorithm="Dassl"));
end test_fos;
