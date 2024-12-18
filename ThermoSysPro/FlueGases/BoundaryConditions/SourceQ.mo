within ThermoSysPro.FlueGases.BoundaryConditions;
model SourceQ "Flue gas source with fixed mass flow rate"
  parameter Units.SI.MassFlowRate Q0=100 "Source mass flow rate";
  parameter Units.SI.Temperature T0=400 "Source temperature";
  parameter Real Xco2=0.10 "CO2 mass fraction";
  parameter Real Xh2o=0.05 "H2O mass fraction";
  parameter Real Xo2=0.22 "O2 mass fraction";
  parameter Real Xso2=0.00 "SO2 mass fraction";

public
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.MassFlowRate Q "Mass flow";
  Units.SI.Temperature T "Fluid temperature";
  Real Xn2 "N2 mas fraction";

public
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutlet C
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
public
  InstrumentationAndControl.Connectors.InputReal IMassFlow
    annotation (Placement(transformation(
        origin={0,50},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  InstrumentationAndControl.Connectors.InputReal ITemperature
    annotation (Placement(transformation(
        origin={0,-50},
        extent={{10,-10},{-10,10}},
        rotation=270)));
equation

  C.P = P;
  C.Q = Q;
  C.T = T;

  /* Flue gas composition */
  C.Xco2 = Xco2;
  C.Xh2o = Xh2o;
  C.Xo2 = Xo2;
  C.Xso2 = Xso2;

  Xn2 = 1 - Xco2 - Xh2o - Xo2 - Xso2;

  /* Mass flow rate */
  if (cardinality(IMassFlow) == 0) then
    IMassFlow.signal = Q0;
  end if;

  Q = IMassFlow.signal;

  /* Temperature */
  if (cardinality(ITemperature) == 0) then
    ITemperature.signal = T0;
  end if;

  T = ITemperature.signal;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Line(points={{40,0},{90,0},{72,10}}),
        Line(points={{90,0},{72,-10}}),
        Text(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid,
          textString=
               "Q"),
        Text(
          extent={{-40,60},{-6,40}},
          lineColor={0,0,255},
          textString=
               "Q"),
        Text(
          extent={{-40,-40},{-2,-60}},
          lineColor={0,0,255},
          textString=
               "T")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Line(points={{40,0},{90,0},{72,10}}),
        Line(points={{90,0},{72,-10}}),
        Text(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward,
          textString=
               "Q"),
        Text(
          extent={{-40,60},{-6,40}},
          lineColor={0,0,255},
          textString=
               "Q"),
        Text(
          extent={{-40,-40},{-2,-60}},
          lineColor={0,0,255},
          textString=
               "T")}),
    Window(
      x=0.09,
      y=0.2,
      width=0.66,
      height=0.69),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</HTML>
", revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>"));
end SourceQ;
