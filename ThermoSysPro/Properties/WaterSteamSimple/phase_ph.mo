within ThermoSysPro.Properties.WaterSteamSimple;
function phase_ph "Returns the current phase"
  input Units.SI.Pressure p "pressure";
  input Units.SI.SpecificEnthalpy h "specific enthalpy";

  output Integer phase=0 "phase: 2 for two-phase, 1 for one phase";

protected
  Units.SI.SpecificEnthalpy h1sat "bubble enthalpy";
  Units.SI.SpecificEnthalpy h2sat "dew enthalpy";
  Boolean supercritical;

algorithm
  supercritical := (p > ThermoSysPro.Properties.WaterSteamSimple.critical.PCRIT);
  h1sat := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.h1sat_P(p);
  h2sat := ThermoSysPro.Properties.WaterSteamSimple.Enthalpy.h2sat_P(p);
  phase := if ((h < h1sat) or (h > h2sat) or supercritical) then 1 else 2;

end phase_ph;
