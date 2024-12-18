within ThermoSysPro.Properties.WaterSteamSimple.Validation;
model calculette_T
  parameter Units.SI.Temperature T_min=275;
  parameter Units.SI.Temperature T_max=350;
  parameter Units.SI.Density d=15;
  Units.SI.Temperature T;

  Units.SI.Density d1sat;
  Units.SI.Density d2sat;
  Units.SI.SurfaceTension sigma_polynomial;
  Units.SI.SurfaceTension sigma_IF97;

  Units.SI.Pressure Psat;
  Units.SI.DynamicViscosity mu1;
  Units.SI.DynamicViscosity mu2;
  Units.SI.DynamicViscosity mu_polynomial "Dynamic viscosity";
  Units.SI.DynamicViscosity mu_IF97 "Dynamic viscosity";
  Real titre;
protected
  parameter Units.SI.Time dt=10000;
  Real x = time/dt;

equation
  T = T_min + x*(T_max - T_min);

  d1sat = ThermoSysPro.Properties.WaterSteamSimple.Density.d1sat_T(T);
  d2sat = ThermoSysPro.Properties.WaterSteamSimple.Density.d2sat_T(T);

  sigma_polynomial = ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.SurfaceTension_T(T);
  sigma_IF97 = ThermoSysPro.Properties.WaterSteam.IF97_packages.IF97_wAJ.SurfaceTension_T(T);

  Psat = ThermoSysPro.Properties.WaterSteamSimple.Pressure.psat_T(T);
  mu1 = ThermoSysPro.Properties.WaterSteamSimple.Viscosity.mu1_dT(d, T);
  mu2 = ThermoSysPro.Properties.WaterSteamSimple.Viscosity.mu2_dT(d, T);

    mu_polynomial =
    ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.DynamicViscosity_rhoT(
    d, T);
    mu_IF97 = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(d,T);
    titre = min(1,max(0,d2sat*(1-d1sat/d)/(d2sat - d1sat)));
     annotation (Icon(graphics={
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
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})},
                      coordinateSystem(preserveAspectRatio=false)), Diagram(graphics,
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=10000, __Dymola_NumberOfIntervals=50000),
    __Dymola_experimentSetupOutput);
end calculette_T;
