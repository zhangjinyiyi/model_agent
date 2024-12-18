within ThermoSysPro.Properties.WaterSteamSimple.Viscosity;
function dmu1ph_Ph
  "Derivative of viscosity wrt. pressure at constant specific enthalpy in liquid region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output Real dmuph
    "Derivative of viscosity wrt. pressure at constant specific enthalpy";
protected
  mu1_Ph_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  dmuph :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative_x(
    coef,
    p,
    h);

end dmu1ph_Ph;
