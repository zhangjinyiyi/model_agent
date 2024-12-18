within ThermoSysPro.Properties.WaterSteamSimple.Entropy;
function s2_Ph "Specific entropy in vapor region for given pressure and specific enthalpy"
  input Units.SI.AbsolutePressure p "Pressure";
  input Units.SI.SpecificEnthalpy h "Specific enthalpy";
  output Units.SI.SpecificEntropy s "Specific entropy";
protected
  s2_Ph_coef coef
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  s := coef.c0 + coef.a*
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.logBase10(abs(p)) + coef.c1
    *h + coef.c2*h^2;

end s2_Ph;
