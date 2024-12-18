within ThermoSysPro.Properties.WaterSteamSimple.Temperature;
function dT2hp_Ph "Derivative of temperature wrt. specific enthalpy at constant pressure in vapor region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";

  output Real dThp "Derivative of temperature wrt. specific enthalpy at constant pressure";
protected
  T2_Ph_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dThp := ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_y(coef, p, h);

end dT2hp_Ph;
