within ThermoSysPro.Fluid.Machines;
model HeatPumpCompressor "Heat pump compressor "
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  parameter Real pi=10.0 "Compression factor (Ps/Pe)";
  parameter Real eta=0.85 "Isentropic efficiency";
  parameter Units.SI.Power W_fric=0.0
    "Power losses due to hydrodynamic friction (percent)";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Diffusion conductance (active if diffusion=true in neighbouring volumes)";

public
  Units.SI.Power W "Mechanical power delivered to the compressor";
  Units.SI.MassFlowRate Q "Mass flow rate";
  Units.SI.SpecificEnthalpy His
    "Fluid specific enthalpy after isentropic compression";
  Units.SI.AbsolutePressure Pe(start=10e5) "Inlet pressure";
  Units.SI.AbsolutePressure Ps(start=10e5) "Outlet pressure";
  Units.SI.Temperature Te "Inlet temperature";
  Units.SI.Temperature Ts "Outlet temperature";
  Real xm(start=1.0) "Average vapor mass fraction";
  FluidType ftype "Fluid type";
  Integer fluid=Integer(ftype) "Fluid number";

  Interfaces.Connectors.FluidInlet C1 annotation (Placement(transformation(
          extent={{-110,-10},{-90,10}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet C2 annotation (Placement(transformation(
          extent={{90,-10},{110,10}}, rotation=0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proe
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pros
    annotation (Placement(transformation(extent={{80,80},{100,100}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ps props
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}},
          rotation=0)));
equation

  /* Check that the fluid type is C3H3F5 */
  assert(ftype == FluidType.C3H3F5, "HeatPumpCompressor: the fluid type must be C3H3F5");

  C1.Q = C2.Q;

  C1.h_vol_1 = C2.h_vol_1;
  C1.h_vol_2 = C2.h_vol_2;

  C2.diff_on_1 = if (gamma_diff > 0) then C1.diff_on_1 else false;
  C1.diff_on_2 = if (gamma_diff > 0) then C2.diff_on_2 else false;

  C2.diff_res_1 = C1.diff_res_1 + (if (gamma_diff > 0) then 1/gamma_diff else 0);
  C1.diff_res_2 = C2.diff_res_2 + (if (gamma_diff > 0) then 1/gamma_diff else 0);

  C1.ftype = C2.ftype;

  C1.Xco2 = C2.Xco2;
  C1.Xh2o = C2.Xh2o;
  C1.Xo2  = C2.Xo2;
  C1.Xso2 = C2.Xso2;

  Q = C1.Q;
  Pe = C1.P;
  Ps = C2.P;

  ftype = C1.ftype;

  /* Mechnical power delivered to the compressor */
  W = Q*(C2.h - C1.h) / (1 - W_fric/100);

  /* Compression factor */
  pi = Ps/Pe;

  /* Average vapor mass fraction */
  xm = (proe.x + pros.x)/2.0;

  /* Compression efficiency */
  His - C1.h = max(xm, 0.01)*eta*(C2.h - C1.h);

  /* Fluid thermodynamic properties before the compression */
  proe = ThermoSysPro.Properties.Fluid.Ph(Pe, C1.h, 0, fluid);
  Te = proe.T;

  /* Fluid thermodynamic properties after the compression */
  pros = ThermoSysPro.Properties.Fluid.Ph(Ps, C2.h, 0, fluid);
  Ts = pros.T;

  /* Fluid thermodynamic properties after the identropic compression */
  props = ThermoSysPro.Properties.Fluid.Ps(Ps, proe.s, 0, fluid);
  His = props.h;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid), Line(points={{-60,80},{60,20},{60,-20},
              {-60,-80}}, color={0,0,255})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor=DynamicSelect({127,255,0}, fill_color_singular),
          fillPattern=FillPattern.Solid),Line(points={{-60,80},{60,20},{60,-20},
              {-60,-80}}, color={0,0,255})}),
    Window(
      x=0.17,
      y=0.1,
      width=0.76,
      height=0.76),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Beno&icirc;t Bride</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end HeatPumpCompressor;
