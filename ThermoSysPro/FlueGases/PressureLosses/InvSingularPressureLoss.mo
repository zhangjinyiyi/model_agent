within ThermoSysPro.FlueGases.PressureLosses;
model InvSingularPressureLoss "Inverse singular pressure loss"
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density";

protected
  parameter Real eps=1.e-0 "Small number for pressure loss equation";
  parameter Units.SI.MassFlowRate Qeps=1.e-3 "Small mass flow";

public
  Real K(start=10) "Pressure loss coefficient";
  ThermoSysPro.Units.SI.PressureDifference deltaP(start=1.e2)
    "Singular pressure loss";
  Units.SI.MassFlowRate Q(start=500) "Mass flow";
  Units.SI.Density rho(start=1) "Fluid density";
  Units.SI.Temperature T(start=300) "Fluid temperature";
  Units.SI.AbsolutePressure P(start=1.e5) "Fluid average pressure";

public
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet C1
                          annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}, rotation=0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutlet C2
                          annotation (Placement(transformation(extent={{90,-10},
            {110,10}}, rotation=0)));
equation

  C1.P - C2.P = deltaP;
  C1.T = C2.T;
  C1.Q = C2.Q;

  C2.Xco2 = C1.Xco2;
  C2.Xh2o = C1.Xh2o;
  C2.Xo2  = C1.Xo2;
  C2.Xso2 = C1.Xso2;

  Q = C1.Q;

  /* Pressure loss */
  deltaP = if noEvent(abs(Q) < Qeps) then 1.e10 else K*ThermoSysPro.Functions.ThermoSquare(Q, eps)/rho;

  /* Fluid thermodynamic properties */
  P = (C1.P + C2.P)/2;
  T = C1.T;

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = ThermoSysPro.Properties.FlueGases.FlueGases_rho(P, T, C2.Xco2, C2.Xh2o, C2.Xo2, C2.Xso2);
  end if;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-60,40},{-40,20},{-20,10},{0,8},{20,10},{40,20},{60,40},{-60,
              40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward), Polygon(
          points={{-60,-40},{-40,-20},{-20,-12},{0,-10},{20,-12},{40,-20},{60,
              -40},{-60,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-60,40},{-40,20},{-20,10},{0,8},{20,10},{40,20},{60,40},{-60,
              40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward), Polygon(
          points={{-60,-40},{-40,-20},{-20,-12},{0,-10},{20,-12},{40,-20},{60,
              -40},{-60,-40}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward)}),
    Window(
      x=0.11,
      y=0.04,
      width=0.71,
      height=0.88),
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
end InvSingularPressureLoss;
