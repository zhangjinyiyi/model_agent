within ThermoSysPro.Fluid.Examples.SimpleExamples;
model TestCombustionTurbine
  parameter Real is_eff_n1(fixed=false,start=0.85) "Nominal isentropic efficiency";
  parameter Real Qred1(fixed=false,start=0.01) "Reduced mass flow rate";

  ThermoSysPro.Fluid.Machines.CombustionTurbine CombustionTurbine(
    tau_n=0.065,
    is_eff_n=is_eff_n1,
    Qred=Qred1,
    Pe(fixed=true, start=1500000),
    Ts(fixed=true, start=830)) annotation (Placement(transformation(extent={{
            -42,-42},{36,42}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceQ SourceQ1(
    Xso2=0,
    Q0=430,
    Xco2=0.06,
    Xh2o=0.06,
    Xo2=0.14,
    ftype=ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType.FlueGases,
    T0=1500,
    option_temperature=true)
    annotation (Placement(transformation(extent={{-106,-10},{-86,10}},
          rotation=0)));

  ThermoSysPro.Fluid.BoundaryConditions.SinkP SinkP1(P0=1e5)
    annotation (Placement(transformation(
        origin={94,0},
        extent={{10,-10},{-10,10}},
        rotation=180)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Wc1(k=-1.8e8)
    annotation (Placement(transformation(extent={{-100,-42},{-80,-22}},
          rotation=0)));
equation
  connect(SourceQ1.C, CombustionTurbine.Ce) annotation (Line(
      points={{-86,0},{-42,0}},
      color={0,0,0},
      thickness=1));
  connect(CombustionTurbine.Cs, SinkP1.C) annotation (Line(
      points={{36,0},{84,0}},
      color={0,0,0},
      thickness=1));
  connect(Wc1.y, CombustionTurbine.CompressorPower)
    annotation (Line(points={{-79,-32},{-45.9,-32},{-45.9,-16.8}}));
  annotation (Diagram(graphics), Icon(graphics={
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
end TestCombustionTurbine;
