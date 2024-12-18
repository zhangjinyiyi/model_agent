within ThermoSysPro.Properties.WaterSteamSimple.Enthalpy;
function dh1ps_Ps
  "Derivative of specific enthalpy wrt. pressure at constant specific enthalpy in liquid region for given pressure and specific entropy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEntropy s "Specific entropy";
  output Real dhps
    "Derivative of specific enthalpy wrt. pressure at constant specific entropy";
protected
  h1_Ps_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dhps :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order3_derivative_x(
    coef,
    p,
    s);

end dh1ps_Ps;
