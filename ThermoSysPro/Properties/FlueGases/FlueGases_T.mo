within ThermoSysPro.Properties.FlueGases;
function FlueGases_T "Temperature"
  //extends ThermoSysPro.Properties.FlueGases.unSafeForJacobian;
  input Units.SI.AbsolutePressure PMF "Flue gases average pressure";
  input Units.SI.SpecificEnthalpy HMF "Flue gases specific enthalpy";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";

  output Units.SI.Temperature T "Temperature";

protected
  ThermoSysPro.Properties.ModelicaMediaFlueGases.ThermodynamicState state;
  ThermoSysPro.Properties.ModelicaMediaFlueGases.ThermodynamicState state0;
  Units.SI.SpecificEnthalpy H0
    "Flue gases specific enthalpy at the reference state";
  Real Xn2 "N2 mass fraction";
  constant Real Hlat=2501.5999019e3 "Phase transition energy";

algorithm
  Xn2 := 1 - Xco2 - Xh2o - Xo2 - Xso2;

  /* Computation of the reference thermodynamic state */
  state0 :=ThermoSysPro.Properties.ModelicaMediaFlueGases.setState_pTX(0.006112*1e5, 273.16, {Xn2,Xo2,Xh2o,Xco2,Xso2});
  H0 := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificEnthalpy(state0);

  /* Computation of the thermodynamic state */
  state :=ThermoSysPro.Properties.ModelicaMediaFlueGases.setState_phX(PMF, HMF + H0 - Xh2o*Hlat, {Xn2,Xo2,Xh2o,Xco2,Xso2});

  /* Computation of the temperature */
  T := ThermoSysPro.Properties.ModelicaMediaFlueGases.temperature(state);

  annotation (Icon(graphics),
                    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</HTML>
"));
end FlueGases_T;
