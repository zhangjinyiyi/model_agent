within ThermoSysPro.Properties.WaterSteamSimple.Conductivity;
function dlambda1Td_dT
  "Derivative of conductivity wrt. specific enthalpy at constant pressure in liquid region for given density and temperature"
  input Units.SI.Density d "Density";
  input Units.SI.Temperature T "Temperature";
  output Real dlambdaTd
    "Derivative of conductivity wrt. temperature at constant density";
protected
  lambda1_dT_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dlambdaTd :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_y(
    coef,
    d,
    T);

end dlambda1Td_dT;
