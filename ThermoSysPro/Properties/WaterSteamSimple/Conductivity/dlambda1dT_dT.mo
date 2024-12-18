within ThermoSysPro.Properties.WaterSteamSimple.Conductivity;
function dlambda1dT_dT
  "Derivative of conductivity wrt. pressure at constant specific enthalpy in liquid region for given density and temperature"
  input Units.SI.Density d "Density";
  input Units.SI.Temperature T "Temperature";
  output Real dlambdadT
    "Derivative of conductivity wrt. density at constant temperature";
protected
  lambda1_dT_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dlambdadT :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_x(
    coef,
    d,
    T);

end dlambda1dT_dT;
