﻿within ThermoSysPro.Properties.Oil_TherminolVP1;
record TherminolVP1_Data "Data for Oil from STEPHANIE Library"

// STEPHANIE TherminolVP1
  String mediumName = "TherminolVP1" "Name of the medium";
 // Temperature limits
  Units.SI.Temperature maximum_temperature=405 + 273.15
    "maximum fluid operating temperature allowed (K)";
  Units.SI.Temperature minimum_temperature=15 + 273.15
    "minimum fluid operating temperature allowed (K)";
 // Reference State
  Units.SI.AbsolutePressure reference_pressure=101325
    "Reference pressure of Medium: default 1 atmosphere";
  Units.SI.SpecificEnthalpy reference_enthalpy=0
    "Reference enthalpy of Medium: default @ 0 deg Celsius";
  Units.SI.Temperature reference_temperature=323 + 273.15
    "Reference Temperature of Medium: default 0 deg Celsius";
 // Default values (for initialization)
  Units.SI.AbsolutePressure pressure_default=101325
    "Default value for pressure of medium (for initialization)";
  Units.SI.SpecificEnthalpy enthalpy_default=
      ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_T(temp=323 + 273.15)
    "Default value for enthalpy (@ 323ºC) of medium (for initialization)";
  Units.SI.Temperature temperature_default=
      ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h=enthalpy_default)
    "Default value for temperature of medium (for initialization)";
  Units.SI.Density density_default=
      ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(temp=
      temperature_default)
    "Default value for density of medium (for initialization)";
  Units.SI.DynamicViscosity dynamicViscosity_default=
      ThermoSysPro.Properties.Oil_TherminolVP1.DynamicViscosity_T(temp=
      temperature_default)
    "Default value for dynamic viscosity of medium (for initialization)";
 //
  Boolean compressible = false "Wheter density depends on pressure or not";
  Boolean usePartialDensityDerivatives = false
    "=true if partial density derivatives with respect to state variables (e.g. pressure and enthalpy) are explicitely given as functions";

end TherminolVP1_Data;
