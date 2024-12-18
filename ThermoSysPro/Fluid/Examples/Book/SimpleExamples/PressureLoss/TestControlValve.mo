within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.PressureLoss;
model TestControlValve

  ThermoSysPro.Fluid.BoundaryConditions.SourceP SourceP1
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}}, rotation=
            0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP PuitsP1
                                          annotation (Placement(transformation(
          extent={{44,-10},{64,10}},rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve ControlValve(mode_caract=1, caract=[
        0,0; 0.5,3000; 0.75,7000; 1,8000])
                                          annotation (Placement(transformation(
          extent={{-10,-4},{10,16}},rotation=0)));
  InstrumentationAndControl.Blocks.Tables.Table1DTemps Constante1(Table=[0,
        0.9; 5,0.9; 15,0.5; 25,0.5; 50,0.2; 100,0.2])
    annotation (Placement(transformation(extent={{-30,30},{-10,50}}, rotation=0)));
equation
  connect(ControlValve.C2, PuitsP1.C)
    annotation (Line(points={{10,0},{44,0}},  color={0,0,255}));
  connect(Constante1.y, ControlValve.Ouv)
    annotation (Line(points={{-9,40},{0,40},{0,17}},      color={0,0,255}));
  connect(SourceP1.C, ControlValve.C1)
    annotation (Line(points={{-44,0},{-44,0},{-10,0}},
                                                 color={0,0,255}));
  annotation (experiment(StopTime=80),
    Window(
      x=0.45,
      y=0.01,
      width=0.35,
      height=0.49),
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
<h4>Copyright &copy; EDF 2002 - 2021 </h4>
<h4>ThermoSysPro Version 4.0 </h4>
<p>This model is documented in Sect. 13.8.5 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </p>
<p>The results reported in the ThermoSysPro book were computed using Dymola. </p>
</html>"));
end TestControlValve;
