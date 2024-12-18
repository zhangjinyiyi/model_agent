within ThermoSysPro.Properties.WaterSteamSimple.Viscosity;
function dmu1Td_dT
  "Derivative of viscosity wrt. specific enthalpy at constant pressure in liquid region for given density and temperature"
  input Units.SI.Density d "Density";
  input Units.SI.Temperature T "Temperature";
  output Real dmuTd
    "Derivative of viscosity wrt. temperature at constant density";
protected
  mu1_dT_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dmuTd :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_x_order7_derivative(
    coef,
    T);

end dmu1Td_dT;
