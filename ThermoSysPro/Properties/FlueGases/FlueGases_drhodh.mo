within ThermoSysPro.Properties.FlueGases;
function FlueGases_drhodh
  "Derivative of the density wrt. the specific enthalpy at constant pressure"
  input Units.SI.AbsolutePressure PMF "Flue gases average pressure";
  input Units.SI.Temperature TMF "Flue gases average temperature";
  input Real Xco2 "CO2 mass fraction";
  input Real Xh2o "H2O mass fraction";
  input Real Xo2 "O2 mass fraction";
  input Real Xso2 "SO2 mass fraction";

  output Units.SI.DerDensityByEnthalpy drhodh
    "Derivative of the density wrt. the specific enthalpy at constant pressure";

protected
  ThermoSysPro.Properties.ModelicaMediaFlueGases.ThermodynamicState state;
  Units.SI.SpecificEntropy s "Flue gases specific entropy";
  Units.SI.Density rho "Flue gaases density";
  Units.SI.SpecificHeatCapacity cp "Specific heat capacity";
  Units.SI.SpecificHeatCapacity R "gas constant";

  Real Xn2 "N2 mass fraction";

algorithm
  Xn2 := 1 - Xco2 - Xh2o - Xo2 - Xso2;

  /* Computation of the thermodynamic state */
  state := ThermoSysPro.Properties.ModelicaMediaFlueGases.setState_pTX(PMF, TMF, {Xn2,Xo2,Xh2o,Xco2,Xso2});
  s := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificEntropy(state);
  rho := ThermoSysPro.Properties.ModelicaMediaFlueGases.density(state);
  cp := ThermoSysPro.Properties.ModelicaMediaFlueGases.specificHeatCapacityCp(state);
  R := ThermoSysPro.Properties.ModelicaMediaFlueGases.gasConstant(state);

  drhodh := -rho*rho*R/(PMF*cp);

  annotation (
    smoothOrder=2,
    Icon(graphics),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</html>"));
end FlueGases_drhodh;
