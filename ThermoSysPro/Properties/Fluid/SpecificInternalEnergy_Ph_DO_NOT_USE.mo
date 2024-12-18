﻿within ThermoSysPro.Properties.Fluid;
function SpecificInternalEnergy_Ph_DO_NOT_USE
  "Specific Internal Energy computation for all fluids (inputs: P, h, fluid). DO NOT USE (does not work with use-case 'DistributedVolumePartialModel'. Use u = h - P/rho instead)"

  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  input Integer fluid
    "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";

  output Units.SI.SpecificEnergy u "Specific Internal Energy (J/kg)";

protected
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro
    annotation (Placement(transformation(extent={{-80,40},{-40,80}}, rotation=0)));
  ThermoSysPro.Properties.DryAirIdealGas.DryAirIdealGas Data6
    annotation (Placement(transformation(extent={{-20,40},{0,60}}, rotation=0)));

algorithm
  // Water/Steam
  if fluid==1 then
    pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
      P,
      h,
      mode);
    u:=pro.u;

  // // C3H3F5
  // elseif fluid==2 then
  //   u := ThermoSysPro.Properties.C3H3F5.SpecificInternalEnergy_Ph__NonFonctionnel(
  //     P=P, h=h);
  //

  // // FlueGas
   elseif fluid==3 then
     assert(Xco2+Xh2o+Xo2+Xso2>0, "Wrong mass fraction definition");  /// Commentaire ajouté (si fluid==2, vérifie que les fractions massiques sont bien fournies en Input)
  //   u := ThermoSysPro.Properties.FlueGases.FlueGases_u__NonFonctionnel(
  //     PMF=P,
  //     TMF=ThermoSysPro.Properties.FlueGases.FlueGases_T(
  //       PMF=P,
  //       HMF=h,
  //       Xco2=Xco2,
  //       Xh2o=Xh2o,
  //       Xo2=Xo2,
  //       Xso2=Xso2),
  //     Xco2=Xco2,
  //     Xh2o=Xh2o,
  //     Xo2=Xo2,
  //     Xso2=Xso2);
    u := h - P/( ThermoSysPro.Properties.FlueGases.FlueGases_rho(
      PMF=P,
      TMF=ThermoSysPro.Properties.FlueGases.FlueGases_T(
        PMF=P,
        HMF=h,
        Xco2=Xco2,
        Xh2o=Xh2o,
        Xo2=Xo2,
        Xso2=Xso2),
      Xco2=Xco2,
      Xh2o=Xh2o,
      Xo2=Xo2,
      Xso2=Xso2));

  // MoltenSalt
  elseif fluid==4 then
    u := h - P/( ThermoSysPro.Properties.MoltenSalt.Density_T(T=
      ThermoSysPro.Properties.MoltenSalt.Temperature_h(h=h)));

  // Oil
  elseif fluid==5 then
    u := h - P/( ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(
      temp=ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h=h)));

  // DryAirIdealGas
  elseif fluid==6 then
    //u := h - P/( ThermoSysPro.Properties.DryAirIdealGas.Density_PT(
    //  P=P,T=ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h=h)));  /// Solution 1
    u := h - Data6.specificGasConstant * ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h=h);

  elseif  fluid==7 then
    pro := ThermoSysPro.Properties.WaterSteamSimple.SimpleWater.Water_Ph(
      P,
      h,
      mode);
    u:=pro.u;

  else
    assert(false, "incorrect fluid number");  ///
  end if;

annotation(derivative=derSpecificInternalEnergy_derP_derh);
end SpecificInternalEnergy_Ph_DO_NOT_USE;
