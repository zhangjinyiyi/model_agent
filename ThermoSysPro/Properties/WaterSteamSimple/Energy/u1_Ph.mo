within ThermoSysPro.Properties.WaterSteamSimple.Energy;
function u1_Ph "Specific inner energy in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";

  output Units.SI.SpecificEnergy u "Specific inner energy";
protected
  u1_Ph_coef coef
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  u := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order3(coef, p, h);

end u1_Ph;
