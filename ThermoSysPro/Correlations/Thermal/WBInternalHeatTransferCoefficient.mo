within ThermoSysPro.Correlations.Thermal;
function WBInternalHeatTransferCoefficient
  "Internal water/steam flow heat transfer coefficient"

  input ThermoSysPro.Correlations.Misc.Pro_TwoPhaseWaterSteam hy
                                                            annotation (Placement(
        transformation(extent={{-26,-74},{-6,-54}}, rotation=0)));
  input Real geomt[6] "Geometrical data vector";
  input Real Gm "Water mass velocity at the inlet (kg/m2s)";
  input Real Xmc "Steam average mass fraction";
  input Units.SI.Power flux "Heat flux";
  input Units.SI.AbsolutePressure Pmc "Water average pressure";
  input Units.SI.Area Si "Internal exchnage surface over dz";

  output Units.SI.CoefficientOfHeatTransfer hi
    "Internal heat transfer coefficient";

protected
  constant Units.SI.AbsolutePressure Pc=221.2e5 "Critical pressure";
  Units.SI.Density rhol "Density of the liquid phase";
  Units.SI.Density rhov "Density of the steam phase";
  Units.SI.DynamicViscosity mul "Dynamic viscosity of the liquid phase";
  Units.SI.DynamicViscosity muv "Dynamic viscosity of the vapor phase";
  Units.SI.ThermalConductivity kl "Thermal conductivity of the liquid phase";
  Units.SI.ThermalConductivity kv "Thermal conductivity of the vapor phase";
  Units.SI.SpecificHeatCapacity cpl
    "Specific heat capacity of the liquid phase";
  Units.SI.SpecificHeatCapacity cpv "Specific heat capacity of the vapor phase";
  Units.SI.SpecificEnergy lv "Phase transition change energy";
  Units.SI.Diameter dtin "Pipes internal diameter";
  Real Xmc0 "Steam average mass fraction";
  Real Frl "Froude number for the computation of hi";
  Real Frl0 "Froude number for the computation of hi";
  Real Xtt "Martinelli number";
  Real Rel "Reynolds number for the computation of hi";
  Real Prl "Prandtl number for the computation of hi";
  Units.SI.CoefficientOfHeatTransfer hc
    "Convective heat transfer coefficient for the compuation of hi";
  Real Bo "Boiling number";
  Real E "Variable for the compuation of hi";
  Real pred "Variable for the compuation of hi";
  Units.SI.CoefficientOfHeatTransfer heb "Boiling heat transfer coefficient";
  Real S "Corrective term for the removal of nucleation";
  Real Rev "Reynolds number for the computation of hi";
  Real Prv "Prandtl number for the computation of hi";
  Units.SI.CoefficientOfHeatTransfer hvi
    "Heat transfer coefficient for the drying of the wall";

algorithm
  rhol := hy.rhol;
  rhov := hy.rhov;
  lv := hy.lv;
  cpl := hy.cpl;
  cpv := hy.cpv;
  mul := hy.mul;
  muv := hy.muv;
  kl := hy.kl;
  kv := hy.kv;
  dtin := geomt[2];

  if (Xmc > 0.85) then
    Xmc0 := 0.85;
  else
    Xmc0 := Xmc;
  end if;

  if ((0.0 < Xmc) and (Xmc < 1)) then
    /* Froude number */
    Frl0 := Gm^2/(Modelica.Constants.g_n*dtin*rhol^2);
    if (Frl0 <= 0.05) then
      Frl := 0.1;
    else
      Frl := Frl0;
    end if;

    /* Martinelli number */
    Xtt := (((1 - Xmc0)/Xmc0)^0.9)*((rhov/rhol)^0.5)*((mul/muv)^0.1);

    /* Convection heat transfer coefficient */
    Rel := Gm*dtin*(1 - Xmc0)/mul;
    Prl := mul*cpl/kl;
    hc := (0.023*kl/dtin)*(Rel^0.8)*(Prl^0.4);

    /* Boiling number */
    Bo := max(flux/Si/(lv*Gm),0);
    E := 1 + (24000*(Bo^1.16)) + (1.37*((1/Xtt)^0.86));

    /* Boiling heat transfer coefficient */
    pred := -Modelica.Math.log10(Pmc/Pc);
    heb := 55*(((Pmc/Pc)^0.12)*(pred^(-0.55))*(18.015^(-0.5))*(max((flux/Si),0)^(0.67)));

    /* Corrective term for the removal of nucleation */
    S := 1/(1 + (1.15e-6*E^2*Rel^1.17));

    /* Internal heat transfer coefficient */
    hi := (E*hc) + (S*heb);

    if (Xmc > 0.85) then
      /* Wall drying zone */
      Rev := Gm*dtin/muv;
      Prv := muv*cpv/kv;
      hvi := (0.023*kv/dtin)*(Rev^0.8)*(Prv^0.4);
      hi := hi*((1 - Xmc)/0.15) + hvi*((Xmc - 0.85)/0.15);
    end if;
  else
    /* Reynolds number */
    Rel := Gm*dtin/mul;

    /* Prandl number */
    Prl := mul*cpl/kl;

    /* Internal heat transfer coefficient */
    hi := (0.023*kl/dtin)*(Rel^0.8)*(Prl^0.4);
  end if;

  annotation (
    smoothOrder=2,
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2012</b> </p>
<p><b>ThermoSysPro Version 3.0</h4>
</html>"));
end WBInternalHeatTransferCoefficient;
