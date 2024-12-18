﻿within ThermoSysPro.Properties.Fluid;
function Reynolds_PhvD
  "Reynolds number computation for all fluids (inputs: P, h, fluid, v, D)"

  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy (J/kg)";
  input Integer fluid
    "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";
  input Units.SI.Velocity v "Mean velocity of fluid flow";
  input Units.SI.Length D
    "Characteristic dimension (hydraulic diameter of pipes)";

  output Units.SI.ReynoldsNumber Re "Reynolds number";

// fluid==1 - Water/Steam
protected
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro annotation (Placement(
        transformation(extent={{-80,40},{-40,80}}, rotation=0)));

algorithm
  // Water/Steam  /// FONCTIONNE EN DIPHASIQUE ???
  if fluid==1 then
    pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      P,
      h,
      mode);
  Re := abs(v)*pro.d*D / ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rho=pro.d,T=pro.T);

  // // C3H3F5
  // elseif fluid==2 then
  //   T := ThermoSysPro.Properties.C3H3F5.Temperature_Ph(P=P, h=h);
  //
  // // FlueGas
  // elseif fluid==3 then
  //   assert(Xco2+Xh2o+Xo2+Xso2>0, "Wrong mass fraction definition");  /// Commentaire ajouté (si fluid==2, vérifie que les fractions massiques sont bien fournies en Input)
  //   T := ThermoSysPro.Properties.FlueGases.FlueGases_T(
  //     PMF=P,
  //     HMF=h,
  //     Xco2=Xco2,
  //     Xh2o=Xh2o,
  //     Xo2=Xo2,
  //     Xso2=Xso2);
  //
  // // MoltenSalt
  // elseif fluid==4 then
  //   T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h=h);
  //
  // // Oil
  // elseif fluid==5 then
  //   T := ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h=h);
  //
  // // Dry Air Ideal Gas
  // elseif fluid==6 then
  //   T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h=h);

  elseif fluid==7 then
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
      P,
      h,
      mode);
    Re := abs(v)*pro.d*D / ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.DynamicViscosity_rhoT(rho=pro.d,T=pro.T);

  else
    assert(false, "incorrect fluid number");  ///
  end if;

end Reynolds_PhvD;
