within ThermoSysPro.WaterSteam.BoundaryConditions;
model PlugA "Plug"

public
  Units.SI.AbsolutePressure P "Fluid pressure";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy h "Fluid specific enthalpy";

  Connectors.FluidOutlet C                annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
equation

  C.P = P;
  C.Q = Q;
  C.h_vol = h;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{40,0},{90,0},{72,10}}),
        Line(points={{90,0},{72,-10}}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid)}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{40,0},{90,0},{72,10}}),
        Line(points={{90,0},{72,-10}}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid)}),
    Window(
      x=0.23,
      y=0.15,
      width=0.81,
      height=0.71),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2012</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 3.0</b></p>
</HTML>
", revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Baligh El Hefni</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end PlugA;
