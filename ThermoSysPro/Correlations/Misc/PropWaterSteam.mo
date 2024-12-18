within ThermoSysPro.Correlations.Misc;
function PropWaterSteam "Computation of the water/steam properties"
  input Units.SI.AbsolutePressure Pmc "Water/steam average pressure";
  input Units.SI.SpecificEnthalpy Hmc "Water/steam average specific enthalpy";
  input Real Xmc "Steam average mass fraction";

protected
  constant Units.SI.AbsolutePressure Pc=221.2e5 "Critical pressure";
  Units.SI.Temperature Tsat1 "Saturation temperature at Pmc";
  Units.SI.Temperature T "Water/steam mixture temperature";
  Units.SI.SpecificEnthalpy hlv "Water/steam mixture specific enthalpy";
  Units.SI.Density rholv "Water/steam mixture density";
  Units.SI.Density rhol "Water density";
  Units.SI.Density rhov "Steam density";
  Units.SI.SpecificEnthalpy hl "Water specific enthalpy";
  Units.SI.SpecificEnthalpy hv "Steam specific enthalpy";
  Units.SI.SpecificEnergy lv "Phase transition energy";
  Units.SI.SpecificHeatCapacity cpl "Water specific heat capacity";
  Units.SI.SpecificHeatCapacity cpv "Steam specific heat capacity";
  Units.SI.DynamicViscosity mul "Water dynamic viscosity";
  Units.SI.DynamicViscosity muv "Steam dynamic viscosity";
  Units.SI.ThermalConductivity kl "Water thermal conductivity";
  Units.SI.ThermalConductivity kv "Steam thermal conductivity";
  Units.SI.SurfaceTension tsl "Water surface tensiton";

protected
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsatm
                                   annotation (Placement(transformation(extent=
            {{-40,40},{-20,60}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsatm
                                   annotation (Placement(transformation(extent=
            {{0,40},{20,60}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prol
    annotation (Placement(transformation(extent={{-40,0},{-20,20}}, rotation=0)));
public
  output ThermoSysPro.Correlations.Misc.Pro_TwoPhaseWaterSteam hy
                                           annotation (Placement(transformation(
          extent={{0,0},{20,20}}, rotation=0)));
algorithm

  /* Saturation temperature at Pmc */
  Tsat1 := ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.tsat(Pmc);
  (lsatm, vsatm) := ThermoSysPro.Properties.WaterSteam.IF97.Water_sat_P(Pmc);
  prol := ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Pmc, Hmc, 0);

  if ((0 < Xmc) and (Xmc < 1) and (Pmc < Pc)) then
    T := Tsat1;
    hlv := Hmc;
    rholv := prol.d;
    rhol := lsatm.rho;
    rhov := vsatm.rho;
    hl := lsatm.h;
    hv := vsatm.h;
    cpl := lsatm.cp;
    cpv := vsatm.cp;
  else
    T := prol.T;
    rhol := prol.d;
    rhov := rhol;
    hl := Hmc;
    hv := hl;
    cpl := prol.cp;
    cpv := cpl;
  end if;

  /* Water/steam properties */
  lv := hv - hl;
  mul := ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhol, T);
  muv := ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhov, T);
  kl := ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhol, T, Pmc, 0);
  kv := ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhov, T, Pmc, 0);

  if (Pmc > 220e5) then
    tsl := 6e-6;
  elseif (abs(Pmc) < 1e-6) then
    tsl := 5e-2;
  else
    tsl := ThermoSysPro.Properties.WaterSteam.IF97.SurfaceTension_T(Tsat1);
  end if;

  hy.rhol := rhol;
  hy.rhov := rhov;
  hy.hl := hl;
  hy.hl := hv;
  hy.lv := lv;
  hy.cpl := cpl;
  hy.cpv := cpv;
  hy.mul := mul;
  hy.muv := muv;
  hy.kl := kl;
  hy.kv := kv;
  hy.tsl := tsl;
  hy.rholv := rholv;
  hy.hlv := hlv;

  annotation (
    smoothOrder=2,
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</h4>
</HTML>
"));
end PropWaterSteam;
