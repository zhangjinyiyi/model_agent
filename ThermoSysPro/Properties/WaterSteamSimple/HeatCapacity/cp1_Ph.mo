within ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity;
function cp1_Ph
  "Specific heat capacity at constant presure in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output Units.SI.SpecificHeatCapacity cp
    "Specific heat capacity at constant presure";
protected
  cp1_Ph_coef coef
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  cp := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5(
    coef,
    p,
    h);

end cp1_Ph;
