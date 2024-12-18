within ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity;
function cv1_Ph
  "Specific heat capacity at constant volume in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output Units.SI.SpecificHeatCapacity cv
    "Specific heat capacity at constant volume";
protected
  cv1_Ph_coef coef
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  cv := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5(
    coef,
    p,
    h);

end cv1_Ph;
