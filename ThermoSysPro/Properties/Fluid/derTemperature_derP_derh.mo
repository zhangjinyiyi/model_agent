﻿within ThermoSysPro.Properties.Fluid;
function derTemperature_derP_derh
  "der(Temperature) computation for all fluids (inputs: P, h, fluid, der(P), der(h))"

  input Units.SI.AbsolutePressure P "Pressure (Pa)";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  input Integer fluid
    "<html>Fluid number: <br>1 - Water/Steam <br>2 - C3H3F5 <br>3 - FlueGases <br>4 - MoltenSalt <br>5 - Oil <br>6 - DryAirIdealGas <br>7 - WaterSteamSimple </html>";
  input Integer mode "IF97 region - 0:automatic computation";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";
  input Real der_P "Pressure time derivative (J/(kg*s))";
  input Real der_h "Specific Enthalpy time derivative (J/(kg*s))";
  input Real der_Xco2=0 "CO2 mass fraction";
  input Real der_Xh2o=0 "H2O mass fraction";
  input Real der_Xo2=0 "O2 mass fraction";
  input Real der_Xso2=0 "SO2 mass fraction";

  output Real der_T "Temperature time derivative (K/s)";

  //ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro annotation (extent=[-80,40; -40,80]);

///annotation(derivative(order=2)=derderTemperature_derderP_derderh);

algorithm
//   // Water/Steam
//   if fluid==1 then
//     pro := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(
//       P,
//       h,
//       mode);
//     T:=pro.T;
//
//   // C3H3F5
//   elseif fluid==2 then
//     T := ThermoSysPro.Properties.C3H3F5.Temperature_Ph(P=P, h=h);
//
//   // FlueGas
//   elseif fluid==3 then
//     assert(Xco2+Xh2o+Xo2+Xso2>0, "Wrong mass fraction definition");  /// Commentaire ajouté (si fluid==2, vérifie que les fractions massiques sont bien fournies en Input)
//     T := ThermoSysPro.Properties.FlueGases.FlueGases_T(
//       PMF=P,
//       HMF=h,
//       Xco2=Xco2,
//       Xh2o=Xh2o,
//       Xo2=Xo2,
//       Xso2=Xso2);
//
//   // MoltenSalt
//   elseif fluid==4 then
//     T := ThermoSysPro.Properties.MoltenSalt.Temperature_h(h=h);

  // Oil
  //elseif fluid==5 then
  if fluid==5 then
    der_T := ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_derh(h=h,der_h=der_h);

//   // Dry Air Ideal Gas
//   elseif fluid==6 then
//     T := ThermoSysPro.Properties.DryAirIdealGas.Temperature_h(h=h);

  else
    assert(false, "incorrect fluid number");  ///
  end if;

end derTemperature_derP_derh;
