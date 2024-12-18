within ThermoSysPro.Properties.WaterSteamSimple.Conductivity;
function dlambda1hp_Ph
  "Derivative of conductivity wrt. specific enthalpy at constant pressure in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output Real dlambdahp
    "Derivative of conductivity wrt. specific enthalpy at constant pressure";
protected
  lambda1_Ph_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dlambdahp :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_y(
    coef,
    p,
    h);

end dlambda1hp_Ph;
