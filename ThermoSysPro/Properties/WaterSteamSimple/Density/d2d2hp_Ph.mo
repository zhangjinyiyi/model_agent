within ThermoSysPro.Properties.WaterSteamSimple.Density;
function d2d2hp_Ph
  "Second derivative of density wrt. enthalpy and pressure in vapor region for given pressure and enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
 output Real d2dhp;

protected
  d2_Ph_coef coef annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  d2dhp :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_xy_order5_derivative2_xy(
    coef,
    p,
    h);

end d2d2hp_Ph;
