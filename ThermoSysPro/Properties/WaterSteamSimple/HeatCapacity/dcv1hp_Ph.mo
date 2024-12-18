within ThermoSysPro.Properties.WaterSteamSimple.HeatCapacity;
function dcv1hp_Ph
  "Derivative of specific heat capacity wrt. specific enthalpy at constant pressure in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
 output Real dcvhp
    "Derivative of specific heat capacity wrt. specific enthalpy at constant pressure";
protected
  cv1_Ph_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dcvhp :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_y(
    coef,
    p,
    h);

end dcv1hp_Ph;
