﻿within ThermoSysPro.Combustion.CombustionChambers;
model GridFurnace "Combustion furnace"
  parameter Real X2eap=0.1 "Primary air fraction in zone 2";
  parameter Real X3eap=0.1 "Primary air fraction in zone 3";
  parameter Real XCleom=0 "Cl mass fraction in the biomass";
  parameter Real XFeom=0 "F mass fraction in the biomass";
  parameter Real XMACHeom=0 "machefers mass fraction in the biomass";
  parameter Units.SI.Density rhoCENDom=0.5
    "Density of the ashes in the biomass";
  parameter Units.SI.Temperature Tfrecirc=600
    "Temperature of the recirculated flue gases";
  parameter Real XfCO2recirc=0.3
    "CO2 mass fraction in the recirculated flue gases";
  parameter Real XfH2Orecirc=0.1
    "H2O mass fraction in the recirculated flue gases";
  parameter Real XfO2recirc=0.2
    "O2 mass fraction in the recirculated flue gases";
  parameter Real XfSO2recirc=0
    "SO2 mass fraction in the recirculated flue gases";
  parameter Real Xrecirc=0.1 "Recirculated flue gases fraction in Qsf";
  parameter Units.SI.SpecificHeatCapacity CpMACH=500
    "Clinker average specific heat capacity";
  parameter Units.SI.SpecificHeatCapacity CpMACHs2=500
    "Clinker specific heat capacity at the outlet of zone 2";
  parameter Units.SI.SpecificHeatCapacity CpMACHs3=500
    "Clinker specific heat capacity at the outlet of zone 3";
  parameter Units.SI.SpecificHeatCapacity CpMACHs4=500
    "Clinker specific heat capacity at the outlet of zone 4";
  parameter Units.SI.Temperature TsjeMACH=293
    "Clinker temperature at the outlet of the water seal";
  parameter Units.SI.Temperature Teeje=293
    "Water temperature at the outlet of the water seal";
  parameter Real XsjeH2OMACH=0.2
    "Clinker humidity at the outlet of the water seal";
  parameter Real rendje=1 "Water seal efficiency";
  parameter Integer jointeau=0 "1: with water seal - 0: without water seal";
  parameter Real XCvol=0 "Volatile carbon fraction";
  parameter Real XCimb=0 "Unburnt carbon fraction";
  parameter Units.SI.Temperature T1sfm=500
    "Flue gases temperature at the outlet of zone 1";
  parameter Real Eray2=0.1
    "Energy fraction radiated towards zone 2 of the furnace";
  parameter Real Eray5=0.1
    "Energy fraction radiated towards zone 5 of the furnac";
  parameter Real perte=0 "Loss percent of LHV";
  parameter Units.SI.SpecificHeatCapacity Cp3CO=500
    "CO specific heat capacity in zone 3";

public
  Units.SI.MassFlowRate Qsf(start=10) "Flue gases mass flow rate at the outlet";
  Units.SI.AbsolutePressure Psf(start=1e5) "Flue gases pressure at the outlet";
  Units.SI.Temperature Tsf(start=1000) "Flue gases temperature at the outlet";
  Real XsfN2(start=0.6) "Flue gases N2 mass fraction at the outlet";
  Real XsfCO2(start=0.1) "Flue gases CO2 mass fraction at the outlet";
  Real XsfH2O(start=0.1) "Flue gases H2O mass fraction at the outlet";
  Real XsfO2(start=0.1) "Flue gases O2 mass fraction at the outlet";
  Real XsfSO2(start=0.1) "Flue gases SO2 mass fraction at the outlet";
  Units.SI.MassFlowRate Qeap(start=10) "Primary air mass flow rate";
  Units.SI.AbsolutePressure Peap(start=1e5) "Primary air pressure";
  Units.SI.Temperature Teap(start=300) "Primary air temperature";
  Real XeapN2(start=0.6) "Primary air N2 mass fraction";
  Real XeapCO2(start=0.1) "Primary air CO2 mass fraction";
  Real XeapH2O(start=0.1) "Primary air H2O mass fraction";
  Real XeapO2(start=0.1) "Primary air O2 mass fraction";
  Real XeapSO2(start=0.1) "Primary air SO2 mass fraction";
  Units.SI.MassFlowRate Qeas(start=10) "Secondary air mass flow rate";
  Units.SI.AbsolutePressure Peas(start=1e5) "Secondary air pressure";
  Units.SI.Temperature Teas(start=300) "Secondary air temperature";
  Real XeasN2(start=0.6) "Secondary air N2 mass fraction";
  Real XeasCO2(start=0.1) "Secondary air CO2 mass fraction";
  Real XeasH2O(start=0.1) "Secondary air H2O mass fraction";
  Real XeasO2(start=0.1) "Secondaryr O2 mass fraction";
  Real XeasSO2(start=0.1) "Secondary SO2 mass fraction";
  Units.SI.MassFlowRate Qeom(start=10) "Biomass mass flow rate";
  Units.SI.Temperature Teom(start=300) "Biomass temperature";
  Real PCIom(start=1e6) "Biomass LHV (J/kg)";
  Real XCeom(start=0.1) "Biomass C mass fraction";
  Real XHeom(start=0.1) "Biomass H mass fraction";
  Real XOeom(start=0.1) "Biomass O mass fraction";
  Real XNeom(start=0.01) "Biomass N mass fraction";
  Real XSeom(start=0.1) "Biomass S mass fraction";
  Real XCENDeom(start=0.1) "Biomass ashes mass fraction";
  Real XH2Oeom(start=0.1) "Biomass humidity";
  Units.SI.SpecificHeatCapacity Cpom(start=1000)
    "Biomass specific heat capacity";
  Units.SI.MassFlowRate Qerefo(start=10) "Cooling water mass flow rate";
  Units.SI.SpecificEnthalpy Herefo(start=10e3)
    "Cooling water specific enthalpy";
  Units.SI.MassFlowRate Qfrecirc(start=10)
    "Recirculated flue gases mass flow rate";
  Real XsfN2recirc(start=0.1) "Recirculated flue gases N2 mass fraction";
  Real PCIMACH(start=10e6) "Clinker LHV";
  Units.SI.MassFlowRate QsMACH(start=10) "Clinker mass flow rate";
  Units.SI.Temperature TsMACH(start=500) "Clinket temperature";
  Real FVN(start=0.1) "Volatile ashes mass fraction";
  Units.SI.Density rhocend(start=500) "Ashes density in the flue gases";
  Units.SI.Power Wsr(start=10e6) "Radiated power";
  Real excair(start=0.1) "Combustion excess air";

protected
  constant Units.SI.SpecificEnthalpy H0v=2501551.43
    "Vaporisation energy at 0°C";
  constant Units.SI.SpecificEnthalpy HfCO2=3.2791664e7 "CO2 formation enthalpy";
  constant Units.SI.SpecificEnthalpy HfCO=9.201e6 "CO formation enthalpy";
  constant Units.SI.SpecificEnthalpy HfH2Og=13.433333e6
    "H2Og formation enthalpy";
  constant Units.SI.SpecificEnthalpy HfSO2=4.6302650e6 "SO2 formation enthalpy";
  constant Units.SI.SpecificEnthalpy HfH2Ol=15.883300e6
    "H2Ol formation enthalpy";

public
  Real X1eap(start=0.1) "Primary air fraction in zone 1";
  Units.SI.MassFlowRate Q1eap(start=10) "Primary mass flow rate in zone 1";
  Units.SI.MassFlowRate Q2eap(start=10) "Primary mass flow rate in zone 2";
  Units.SI.MassFlowRate Q3eap(start=10) "Primary mass flow rate in zone 3";
  Real XCvol2(start=0.1) "C mass fraction burnt in zone 2";
  Real XMACHimb(start=0.1) "C mass raction unburnt in the clinker";
  Real XCvol3(start=0.1) "C mass fraction burnt in zone 3";

//Zone1
  Units.SI.SpecificEnthalpy Heap(start=1e3)
    "Humid air specific enthalpy at the primary air temperature";
  Units.SI.SpecificEnthalpy Heas(start=1e3)
    "Humid air specific enthalpy at the secondary air temperature";
  Units.SI.SpecificEnthalpy H1a(start=1e3)
    "Primary air specific enthalpy at T1sfm";
  Units.SI.SpecificEnthalpy Hefrecirc(start=1e3)
    "Specific enthalpy of the incoming recirculated flue gases";
  Units.SI.MassFlowRate Qeasm(start=10)
    "Mass flow rate of the secondary air / recirculated flue gases mixture";
  Units.SI.SpecificEnthalpy Heasm(start=1e3)
    "Specific enthalpy of the secondary air / recirculated flue gases mixture";
  Units.SI.Temperature Teasm(start=500)
    "Temperature of the secondary air / recirculated flue gases mixture";
  Real XeasmO2(start=0.1)
    "O2 mass fraction in the secondary air / recirculated flue gases mixture";
  Real XeasmCO2(start=0.1)
    "CO2 mass fraction in the secondary air / recirculated flue gases mixture";
  Real XeasmH2O(start=0.1)
    "H2O mass fraction in the secondary air / recirculated flue gases mixture";
  Real XeasmSO2(start=0.1)
    "SO2 mass fraction in the secondary air / recirculated flue gases mixture";
  Real XeasmN2(start=0.1)
    "N2 mass fraction in the secondary air / recirculated flue gases mixture";
  Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  Units.SI.SpecificEnthalpy Heauom(start=1e3) "Biomass water specific enthalpy";
  Units.SI.AbsolutePressure Psateom(start=1e5)
    "Water saturation presure at Teom";
  Units.SI.SpecificEnthalpy Hvteom(start=10e3)
    "Steam saturation specific enthalpy at Teom";
  Units.SI.SpecificEnthalpy Hlteom(start=10e3)
    "Water saturation specific enthalpy at Teom";
  Units.SI.SpecificEnthalpy Hvapteom(start=10e3)
    "Phase transition energy at Teom";
  Units.SI.SpecificEnthalpy Hs1vom(start=1e3)
    "Water specific enthalpy of the outgoing biomass at T1sfm vapor";
  Units.SI.SpecificEnthalpy Heom(start=1e3)
    "Biomass specific enthalpy at the inlet";
  Units.SI.Power Wff(start=1e6) "Flue gases formation energy";
  Units.SI.Power Wp(start=1e6) "Biomass pyrolysis power";
  Units.SI.Power Wimbp(start=1e6)
    "Power saved in the combustion flue gases due to the non-destruction of unburnt C";
  Units.SI.Power Wimbm(start=1e6)
    "Power lost by the combustion flue gases due to the non-combustion of unburnt C";
  Units.SI.SpecificEnthalpy Hpyr(start=1e3) "Pyrolysis specific enthalpy";
  Units.SI.SpecificEnthalpy H1om(start=1e3)
    "Specific enthalpy of the dry biomass at the pyrolysis temperature of the biomass";
  Units.SI.MassFlowRate Q1H2O(start=10)
    "H2O mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q1O2(start=10)
    "O2 mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q1N2(start=10)
    "N2 mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q1CO2(start=10)
    "CO2 mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q1SO2(start=10)
    "SO2 mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q1g(start=10)
    "Total mass flow rate at the oultet of zone 1";
  Units.SI.MassFlowRate Q2eom(start=10)
    "Biomass mass flow rate at the inlet of zone 2";
  Real PCI1om(start=1e6) "LHV after drying";
  Real X1MACHom(start=0.1) "Clinker mass fraction in the biomass after drying";
  Real XC1vol2(start=0.1) "Burnt C mass fraction in zone 2 after drying";
  Real XC1vol3(start=0.1) "Burnt C mass fraction in zone 3 after drying";
  Real X1MACHimb(start=0.1)
    "Unburnt C mass fraction in the clinker after drying";
  Real X1H(start=0.1) "H mass fraction in the biomass after drying";
  Real X1O(start=0.1) "O mass fraction in the biomass after drying";
  Real X1N(start=0.1) "N mass fraction in the biomass after drying";
  Real X1Cl(start=0.1) "Cl mass fraction in the biomass after drying";
  Real X1F(start=0.1) "F mass fraction in the biomass after drying";
  Real X1S(start=0.1) "S mass fraction in the biomass after drying";
  Real X1CEND(start=0.1) "Ashes mass fraction in the biomass after drying";
  Units.SI.MassFlowRate Qcendom(start=10) "Ashes mass flow rate";
  Real Xfcend(start=0.1) "Ashes mass fraction in the flue gases";
  Units.SI.Power P1g(start=1e6) "Power saved in zone 1";

//Zone 2
  Units.SI.MassFlowRate Q2eo(start=10)
    "Mass flow rate of the oxygen carried by the air and the biomass at the inlet of zone 2";
  Units.SI.MassFlowRate Q2HCl(start=10)
    "Combustion HCl mass fraction in zone 2";
  Units.SI.MassFlowRate Q2HF(start=10)
    "Combustion HF mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2SO2(start=10)
    "Combustion SO2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2H2O(start=10)
    "Combustion H2O mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2CO(start=10)
    "Combustion CO mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2N2(start=10)
    "Combustion N2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2O2(start=10)
    "Combustion O2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2cend(start=10)
    "Combustion ashes mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2CO2(start=10)
    "Combustion CO2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q2g(start=10)
    "Elements total mass flow rate after combustion";
  Real Epsivol(start=0.1) "Volatile matter mass fraction produced in zone 2";
  Units.SI.MassFlowRate Q3eom(start=10) "Solid matter at the inlet of zone 3";
  Real X2MACHom(start=0.1)
    "Clinker mass fraction of the biomass after volatilisation";
  Real XC2vol3(start=0.1)
    "C mass fraction burnt in zone 3 after volatilisation";
  Real X2MACHimb(start=0.1)
    "Unburnt C mas fraction in the clinker after volatilisation";
  Real PCICsol(start=1e6) "LHV of the solid outgoing carbon";
  Real PCICvol(start=1e6) "LHV of the volatile carbon transformed into CO";
  Units.SI.SpecificEnthalpy H2(start=1e3) "Enthalpy released in zone 2";
  Units.SI.Power P2g(start=1e6) "Power released by the combustion in zone 2";
  Units.SI.Power P1o(start=1e6) "Power captured by the biomass";
  Units.SI.Power P1v(start=1e6) "Power captured by the steam";
  Units.SI.Power P1a(start=1e6) "Power captured by the air";
  Units.SI.Power P1r(start=1e6) "Power captured by the cooling water";
  Real Eray0(start=0.2)
    "Fraction of the radiated power from zone 2 unused for the drying";
  Real X2O2(start=0.1) "O2 mass fraction at the oultet of zone 2";
  Real X2SO2(start=0.1) "SO2 mass fraction at the oultet of zone 2";
  Real X2CO2(start=0.1) "CO2 mass fraction at the oultet of zone 2";
  Real X2H2O(start=0.1) "H2O mass fraction at the oultet of zone 2";
  Real X2N2(start=0.1) "N2 mass fraction at the oultet of zone 2";
  Units.SI.SpecificEnthalpy H2g(start=1200000)
    "Flue gases specific enthalpy at the oultet of zone 2";
  Units.SI.Temperature T2(start=1000)
    "Flue gases temperature at the oultet of zone 2";

//Zone 3
  Units.SI.MassFlowRate Q3od(start=10)
    "O mass flow rate available for the oxydation of the clinker in CO and/or CO2";
  Units.SI.MassFlowRate Q3cd(start=10)
    "C mass flow rate available for the oxydation of the clinker in CO and/or CO2";
  Real taux3oc(start=0.1)
    "Ratio of the mass flow rates O/C available for the oxydation of the clinker";
  Units.SI.MassFlowRate Q3CO2(start=10)
    "CO2 mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q3CO(start=10)
    "CO mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q3O2(start=10)
    "O2 mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q3N2(start=10)
    "N2 mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q3H2O(start=10)
    "H2O mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q3SO2(start=10)
    "SO2 mass flow rate at the outlet of zone 3";
  Units.SI.Power P3s(start=1e6) "Power captured by solid matter in zone 3";
  Units.SI.Power P3g(start=1e6) "Power captured by gaseous matter in zone 3";
  Units.SI.SpecificEnthalpy H3s(start=1e3)
    "Gaseous matter specific enthalpy at T3g";
  Units.SI.SpecificEnthalpy H3g(start=1e3)
    "Solid matter specific enthalpy at T3o";
  Real XC2vol31(start=0.1)
    "C mass fraction burnt in zone 3 after volatilisation";
  Real XC2vol4(start=0.1) "C mass fraction burnt at the inlet of zone 4";
  Units.SI.MassFlowRate Q3g(start=10)
    "Flue gases mass flow rate at the outlet of zone 3";
  Units.SI.MassFlowRate Q4eom(start=10)
    "Clinker mass flow rate at the inlet of zone 4";
  Real X4MACHom(start=0.1)
    "Mass flow rate of the biomass clinker after C volatilisation in zone 3";
  Real X4MACHimb(start=0.1)
    "Unburnt C mass fraction in the clinker after C volatilisation in zone 3";
  Units.SI.SpecificHeatCapacity Cp3a(start=1000)
    "Average specific heat capacity at the inlet of zone 3";
  Units.SI.Temperature T3o(start=500)
    "Clinker temperature at the outlet of zone 3";
  constant Units.SI.SpecificHeatCapacity Cp3g=1100
    "Average flue gases specific heat capacity at T3g";
  Units.SI.Power P3ac(start=1e6) "Air power heated at (T2 + T3o)/2";
  Units.SI.Power P3co(start=1e6) "CO power heated at (T2 + T3o)/2";
  Units.SI.Power P3(start=1e6) "Total flue gases power at the outlet of zone 3";

//Zone 4
  Units.SI.Temperature T4o(start=600)
    "Clinker temperature at the outlet for the water seal";
  Units.SI.Temperature T4er(start=600)
    "Water temperature at the inlet of the water seal";
  Real X4H2O(start=0.1)
    "H2O mass fraction in the clinker at the outlet of the water seal";
  Units.SI.SpecificHeatCapacity Cp4liq(start=1000)
    "Water specific heat capacity at TEej";
  Units.SI.Power P4m(start=1e6) "Power lost by the clinker during vaporisation";
  Units.SI.Power P4h(start=1e6) "Power associated to the clinker humidity";
  Units.SI.MassFlowRate Q4v(start=10)
    "Steam mass flow rate generated by the water seal";
  Units.SI.SpecificEnthalpy H4(start=1e3) "Enthalpy in zone 4";
  Units.SI.Power P4v(start=1e6) "Power captured by the steam in zone 4";
  constant Units.SI.SpecificEnthalpy Hvapo=2501600 "Vaporisation energy";

//Zone 5
  Units.SI.MassFlowRate QO2p(start=10)
    "Flue gases O2 mass flow rate at the outlet";
  Units.SI.MassFlowRate Qairp(start=10)
    "Excess air mass flow rate for data Qo2p";
  Units.SI.MassFlowRate Qairs(start=10) "Stoechiometric air mass flow rate";
  Units.SI.MassFlowRate Q5eH2O(start=10)
    "Steam mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eCO(start=10)
    "CO mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eCO2(start=10)
    "CO2 mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eO2(start=10)
    "O2 mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eN2(start=10)
    "N2 mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eSO2(start=10)
    "SO2 mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eHCl(start=10)
    "HCl mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eHF(start=10)
    "HF mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5ecend(start=10)
    "Ashes mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5eam(start=10)
    "Total mass flow rate at the inlet of zone 5";
  Units.SI.MassFlowRate Q5od(start=10) "O mass flow rate available in zone 5";
  Units.SI.MassFlowRate Q5cd(start=10) "C mass flow rate available in zone 5";
  Units.SI.MassFlowRate Q5hd(start=10) "H mass flow rate available in zone 5";
  Units.SI.MassFlowRate Q5ost(start=10)
    "Stoechiométrique O mass flow rate for zone 5";
  Real exc5(start=0.1) "Air excess for zone 5";
  Units.SI.Power P5(start=1e6) "Power released by oxydation in zone 5";
  Units.SI.MassFlowRate Q5sCO2(start=10)
    "CO2 mass flow rate at the outlet of zone 5";
  Units.SI.MassFlowRate Q5sO2(start=10)
    "O2 mass flow rate at the outlet of zone 5";
  Units.SI.MassFlowRate Q5sCO(start=10)
    "CO mass flow rate at the outlet of zone 5";
  Units.SI.Power P5s(start=1e6) "Power released by oxydation in zone 5";
  Real XsfCO(start=0.1) "Flue gases CO mass fraction at the outlet of zone 5";
  Real XsfN21(start=0.1) "Flue gases N2 mass fraction at the outlet of zone 5";
  Real XsfHCl(start=0.1) "Flue gases HCl mass fraction at the outlet of zone 5";
  Real XsfHF(start=0.1) "Flue gases HF mass fraction at the outlet of zone 5";
  Real XsfCEND(start=0.1) "Ashes mass fraction at the outlet of zone 5";
  Units.SI.Power P5a(start=1e6) "Power brought by secondary air";
  Units.SI.Power P5t(start=1e6) "Power accumulated in the flue gases";
  Real Xcor(start=0.1) "Corrective factor for the flue gases mass fractions";
  Real X5sH2OC(start=0.1) "Corrected flue gases H2O mass fraction";
  Real X5sCO2C(start=0.1) "Corrected flue gases CO2 mass fraction";
  Real X5sO2C(start=0.1) "Corrected flue gases O2 mass fraction";
  Real X5sSO2C(start=0.1) "Corrected flue gases SO2 mass fraction";
  Real X5sN2C(start=0.1) "Corrected flue gases N2 mass fraction";
  Units.SI.Density rhonorm(start=1000)
    "Density of the outgoing flue gases Masse at 0 deg C and 1 atm";
  Real FVN0(start=0.1)
    "Ashes normal volume fraction for the computation of FVN";

public
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet Ca2
    annotation (Placement(transformation(extent={{-60,50},{-40,70}}, rotation=0)));
  ThermoSysPro.Combustion.Connectors.FuelInlet Com
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}}, rotation=
            0)));
  ThermoSysPro.WaterSteam.Connectors.FluidInlet port_eau_refroid
    annotation (Placement(transformation(extent={{70,20},{90,40}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro1
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro2
    annotation (Placement(transformation(extent={{-100,60},{-80,80}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro3
    annotation (Placement(transformation(extent={{-100,40},{-80,60}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro4
    annotation (Placement(transformation(extent={{-100,20},{-80,40}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro5
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
public
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet Ca1
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}}, rotation=
           0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutlet Cfg "Flue gases outlet"
    annotation (Placement(transformation(extent={{-10,80},{10,100}}, rotation=0)));
equation

  /* Flue gases outlet */
  Qsf = Cfg.Q;
  Tsf = Cfg.T;
  Psf = Cfg.P;
  XsfCO2 = Cfg.Xco2;
  XsfH2O = Cfg.Xh2o;
  XsfO2 = Cfg.Xo2;
  XsfSO2 = Cfg.Xso2;

  /* Primary air inlet */
  Qeap = Ca1.Q;
  Peap = Ca1.P;
  Peap = Psf;
  Teap = Ca1.T;
  XeapCO2 = Ca1.Xco2;
  XeapH2O = Ca1.Xh2o;
  XeapO2 = Ca1.Xo2;
  XeapN2 = 1 - Ca1.Xco2 - Ca1.Xh2o - Ca1.Xo2 - Ca1.Xso2;
  XeapSO2 = Ca1.Xso2;

  /* Secondary air inlet */
  Qeas = Ca2.Q;
  Peas = Ca2.P;
  Peas = Psf;
  Teas = Ca2.T;
  XeasCO2 = Ca2.Xco2;
  XeasH2O = Ca2.Xh2o;
  XeasO2 = Ca2.Xo2;
  XeasN2 = 1 - Ca2.Xco2 - Ca2.Xh2o - Ca2.Xo2 - Ca2.Xso2;
  XeasSO2 = Ca2.Xso2;

  /* Biomass */
  Qeom = Com.Q;
  Teom = Com.T;
  PCIom = Com.LHV;
  XCeom = Com.Xc;
  XHeom = Com.Xh;
  XOeom = Com.Xo;
  XNeom = Com.Xn;
  XSeom = Com.Xs;
  XCENDeom = Com.Xashes;
  XH2Oeom = Com.hum;
  Cpom = Com.cp;

  /* Cooling water */
  Qerefo = port_eau_refroid.Q;
  Herefo = port_eau_refroid.h;
  port_eau_refroid.h = port_eau_refroid.h_vol;

  /* Primary air mass flow rates */
  X1eap = 1 - X2eap - X3eap;
  Q1eap = Qeap*X1eap;
  Q2eap = Qeap*X2eap;
  Q3eap = Qeap*X3eap;

  /* Recirculated flue gases fow rates */
  Qfrecirc = Qsf*Xrecirc;

  /* Carbon distribution */
  XCvol2 = XCeom*XCvol;
  XMACHimb = XCeom*XCimb;
  XCvol3 = XCeom*(1 - XCvol - XCimb);

  //--------------------------------------------------------------------
  // 1st zone : Drying
  //------------------

  /* Primary air specific enthalpy at Teap */
  Heap = ThermoSysPro.Properties.FlueGases.FlueGases_h(Peap, Teap, XeapCO2, XeapH2O, XeapO2, XeapSO2);

  /* Secondary air specific enthalpy at à Teas */
  Heas = ThermoSysPro.Properties.FlueGases.FlueGases_h(Peap, Teas, XeasCO2, XeasH2O, XeasO2, XeasSO2);

  /* Primary air specific enthalpy at T1sfm */
  H1a = ThermoSysPro.Properties.FlueGases.FlueGases_h(Peap, T1sfm, XeapCO2, XeapH2O, XeapO2, XeapSO2);

  /* Specific enthalpy of the incoming recirculated flue gases */
  XsfN2recirc = 1 - XfCO2recirc - XfH2Orecirc - XfO2recirc - XfSO2recirc;
  Hefrecirc = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tfrecirc, XfCO2recirc, XfH2Orecirc, XfO2recirc, XfSO2recirc);

  /* Mass flow rate of the secondary air / flue gases recirculated mixture */
  Qeasm = Qeas + Qfrecirc;

  /* Mixture */
  if (Qeasm <= 0) then
    XeasmO2 = 0;
    XeasmCO2 = 0;
    XeasmH2O = 0;
    XeasmSO2 = 0;
    XeasmN2 = 0;
    Heasm = 1e3;
    Teasm = 274.15;
  else
    XeasmO2 = (XfO2recirc*Qfrecirc + XeasO2*Qeas)/Qeasm;
    XeasmCO2 = (XfCO2recirc*Qfrecirc)/Qeasm;
    XeasmH2O = (XfH2Orecirc*Qfrecirc + XeasH2O*Qeas)/Qeasm;
    XeasmSO2 = (XfSO2recirc*Qfrecirc)/Qeasm;
    XeasmN2 = 1 - XeasmO2 - XeasmSO2 - XeasmH2O - XeasmSO2;
    Heasm = (Qeasm*Heas+Qfrecirc*Hefrecirc)/Qeasm;
    // Changed from FlueGases_T to FlueGases_h to provide a differentiable function
    Heasm = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Teasm, XeasmCO2, XeasmH2O, XeasmO2, XeasmSO2);
  end if;

  /* Specific enthalpy of the water in the biomass */
  pro1 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Peap, Teom, mode);
  Heauom = pro1.h;

  /* Water phase transition energy at Teom */
  Psateom = ThermoSysPro.Properties.WaterSteam.BaseIF97.Basic.psat(Teom);
  pro2 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Psateom, Teom, 2);
  Hvteom = pro2.h;
  pro3 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Psateom, Teom, 1);
  Hlteom = pro3.h;

  Hvapteom = Hvteom - Hlteom;

  /* Specific enthalpy of the water in the biomass */
  pro4 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Psf, T1sfm, 0);
  Hs1vom = pro4.h;

  /* Specific enthalpy of the biomass at Teom */
  Heom = Cpom*(Teom - 273.15);

  /* Flue gases formation energy */
  Wff = Qeom*(HfCO2*XCeom + HfH2Og*XHeom*9 + HfSO2*XSeom/32.1*64.1 + HfH2Og*XH2Oeom);

  /* Pyrolisis power of the biomass */
  Wp = Wff - Qeom*PCIom/(1 - perte) - Qeom*HfH2Ol*XH2Oeom;

  /* Power saved by the combustion gases due to the non-destruction of unburnty particles */
  Wimbp = Wp*XCimb;

  /* Power lost by the combustion gases due to the non-combusiton of C */
  Wimbm = Qeom*XCeom*HfCO2*XCimb;

  /* Pyrolisis enthalpy */
  Hpyr = Wp/(Qeom*(1 - XH2Oeom));

  /* Specific enthalpy of the dry biomasss at the biomass pyrolysis temperature */
  H1om = Hpyr + Heom;

  /* Mass flow rates at the outlet of zone 1 */
  Q1H2O = Qeom*XH2Oeom + Q1eap*XeapH2O + Qerefo;
  Q1O2 = Q1eap*XeapO2;
  Q1N2 = Q1eap*XeapN2;
  Q1CO2 = Q1eap*XeapCO2;
  Q1SO2 = Q1eap*XeapSO2;
  Q1g = Q1H2O + Q1O2 + Q1N2 + Q1CO2 + Q1SO2;
  Q2eom = Qeom*(1 - XH2Oeom);

  /* Correction after drying */
  PCI1om = PCIom/(1 - XH2Oeom);
  X1MACHom = XMACHeom/(1 - XH2Oeom);
  XC1vol2 = XCvol2/(1 - XH2Oeom);
  XC1vol3 = XCvol3/(1 - XH2Oeom);
  X1MACHimb = XMACHimb/(1 - XH2Oeom);
  X1H = XHeom/(1 - XH2Oeom);
  X1O = XOeom/(1 - XH2Oeom);
  X1N = XNeom/(1 - XH2Oeom);
  X1Cl = XCleom/(1 - XH2Oeom);
  X1F = XFeom/(1 - XH2Oeom);
  X1S = XSeom/(1 - XH2Oeom);
  X1CEND = XCENDeom/(1 - XH2Oeom);

  /* Ashes mass flow rate in the biomass */
  Qcendom = XCENDeom*Qeom;

  /* Ashes mass fraction in the flue gases */
  Xfcend = Qcendom/Qsf;

  /* Power captured in zone 1 */
  P1g = Qeom*XH2Oeom*Hs1vom + Qeom*XH2Oeom*Hvapteom + Q1eap*H1a + Qerefo*Hs1vom;

  //--------------------------------------------------------------------
  // 2nd zone : Combustion
  //----------------------

  /* Outgoing flue gases mass flow rate after combustion */
  /* Oxygen brought by air and the biomass */
  Q2eo = Q2eom*X1O + Q2eap*XeapO2;

  /* Outgoing mass flow rates */
  Q2HCl = 36.5/35.5*Q2eom*X1Cl;
  Q2HF = 20/19*Q2eom*X1F;
  Q2SO2 = 64/32*Q2eom*X1S + Q2eap*XeapSO2;
  Q2H2O = 18/2*Q2eom*(X1H - 1/35.5*X1Cl - 1/19*X1F) + Q2eap*XeapH2O;
  Q2CO = 28/12*Q2eom*XC1vol2;
  Q2N2 = Q2eo*X1N + Q2eap*XeapN2;
  Q2O2 = Q2eo - Q2eom*(X1S + 16/2*(X1H - 1/35.5*X1Cl - 1/19*X1F) + 16/12*XC1vol2);
  Q2cend = Q2eom*X1CEND;
  Q2CO2 = Q2eap*XeapCO2;

  /* Total mass flow rate after combustion */
  Q2g = Q2HCl + Q2HF + Q2SO2 + Q2H2O + Q2CO + Q2N2 + Q2O2 + Q2cend + Q2CO2;

  /* Correction after combustion */
  Epsivol = XC1vol2 + X1H + X1O + X1S + X1Cl + X1F + X1N + X1CEND;
  Q3eom = Q2eom*(1 - Epsivol);
  X2MACHom = X1MACHom/(1 - Epsivol);
  XC2vol3 = XC1vol3/(1 - Epsivol);
  X2MACHimb = X1MACHimb/(1 - Epsivol);

  /* Power released by the combustion */
  PCICsol = (XC1vol3 + X1MACHimb)*HfCO2;
  PCICvol = XC1vol2*(HfCO2 - HfCO);
  H2 = PCI1om - PCICsol - PCICvol;
  P2g = H2*Q2eom+(Q2H2O - (Q2eap*XeapH2O))*H0v + Wimbp;

  P1o = Qeom*(1 - XH2Oeom)*(H1om - Heom);
  P1v = Qeom*XH2Oeom*(Hs1vom - Hlteom);
  P1a = Q1eap*(H1a - Heap);
  P1r = Qerefo*(Hs1vom - Herefo);

  Eray0 = (P1o + P1v + P1a + P1r)/P2g;

  /* Temperature at the outlet of zone 2 */
  /* Mass fraction at the outlet */
  X2O2 = Q2O2/Q2g;
  X2SO2 = Q2SO2/Q2g;
  X2CO2 = Q2CO/Q2g;
  X2H2O = Q2H2O/Q2g;
  X2N2 = 1 - (X2O2 + X2SO2 + X2CO2 + X2H2O);

  /* Specific enthalpy and temperature at the outlet of zone 2 */
  H2g = (Q2eap*Heap + Q2eom*H1om + P2g*(1 - Eray0 - Eray2) - Q3eom*CpMACHs2*(T2 - 273.15))/Q2g;
  // Changed from FlueGases_T to FlueGases_h to provide a differentiable function
  H2g = ThermoSysPro.Properties.FlueGases.FlueGases_h(Peap, T2, X2CO2, X2H2O, X2O2, X2SO2);

  //--------------------------------------------------------------------
  // 3rd zone : Clinker cooling
  //---------------------------

  /* Oxydation of the clinkler carbon into CO and/or CO2 */
  Q3od = Q3eap*XeapO2;
  Q3cd = Q3eom*XC2vol3;
  taux3oc = Q3od/Q3cd;

  /* taux3oc >= 32/12 => all C is transformed into CO2 */
  if (taux3oc >= 32/12) then
    /* Mass flow rates */
    Q3CO2 = 44/12*Q3cd + Q3eap*XeapCO2;
    Q3CO = 0;
    Q3O2 = Q3od - 32/12*Q3cd;
    Q3N2 = Q3eap*XeapN2;
    Q3H2O = Q3eap*XeapH2O;
    Q3SO2 = Q3eap*XeapSO2;

    /* Power released */
    P3s = Q3cd*HfCO;
    P3g = Q3cd*(HfCO2 - HfCO);

    /* Enthalpy released */
    H3s = P3s/Q3eom;
    H3g = P3g/Q3eom;
    XC2vol31 = XC2vol3;
    XC2vol4 = XC2vol3;

  /* 16/12 <= taux3oc <= 32/12 => all C is transformed into CO plus a fraction into CO2 */
  elseif ((taux3oc >= 16/12) and (taux3oc < 32/12)) then
    /* Mass flow rates */
    Q3CO2 = 44/12*(Q3od - 16/12*Q3cd) + Q3eap*XeapCO2;
    Q3CO = 28/12*Q3cd - 28/16*(Q3od - 16/12*Q3cd);
    Q3O2 = 0;
    Q3N2 = Q3eap*XeapN2;
    Q3H2O = Q3eap*XeapH2O;
    Q3SO2 = Q3eap*XeapSO2;

    /* Power released */
    P3s = Q3cd*HfCO;
    P3g = (12/16*Q3od - Q3cd)*(HfCO2 - HfCO);

    /* Enthalpy released */
    H3s = P3s/Q3eom;
    H3g = P3g/Q3eom;
    XC2vol31 = XC2vol3;
    XC2vol4 = XC2vol3;

  /* taux3oc < 16/12 => partial oxydation into CO */
  else
    /* Mass flow rates */
    Q3CO2 = 0;
    Q3CO = 28/16*Q3od;
    Q3O2 = 0;
    Q3N2 = Q3eap*XeapN2;
    Q3H2O = Q3eap*XeapH2O;
    Q3SO2 = Q3eap*XeapSO2;

    /* Power released */
    P3s = 12/16*Q3od*HfCO;
    P3g = 0;

    /* Enthalpy released */
    H3s = P3s/Q3eom;
    H3g = P3g/Q3eom;
    XC2vol31 = XC2vol3*12/16*taux3oc;
    XC2vol4 = XC2vol3;
end if;

  /* Correction after coke combustion */
  Q3g = Q3CO2 + Q3CO + Q3H2O + Q3O2 + Q3N2 + Q3SO2;
  Q4eom = Q3eom*(1 - XC2vol31);
  X4MACHom = X2MACHom/(1 - XC2vol31);
  X4MACHimb = X2MACHimb/(1 - XC2vol31) + (XC2vol4 - XC2vol31)/(1 - XC2vol31);

  /* Clinker temperature at the outlet of zone 3 */
  Cp3a = (ThermoSysPro.Properties.FlueGases.FlueGases_h(Peap, (T2 + Teap)/2, X2CO2, X2H2O, X2O2, X2SO2))/((T2 + Teap)/2);
  T3o - 273.15 = (Q3eap*Heap + Q3eom*CpMACHs2*(T2 - 273.15)-
      (Q3eap - (16/12)*Q3eom*XC2vol31)*Cp3a*(T2 - 273.15)/2-
      (28/12)*Q3eom*XC2vol31*Cp3CO*(T2 - 273.15)/2 + P3s)/
      (Q3eap*Cp3a/2 + (28/12)*Q3eom*XC2vol31*Cp3CO/2 + Q4eom*CpMACHs3);
  P3ac = (Q3eap - (16/12)*Q3eom*XC2vol31)*Cp3a*((T2 - 273.15) + (T3o - 273.15))/2;
  P3co = (28/12)*Q3eom*XC2vol31*Cp3CO*((T2 - 273.15) + (T3o - 273.15))/2;
  P3 = P3g + P3ac + P3co;

  //--------------------------------------------------------------------
  // 4th zone : Water seal
  //----------------------

  /* Steam mass flow rate generated by the water seal */
  if (jointeau == 1) then
    T4o = TsjeMACH;
    TsMACH = TsjeMACH;
    T4er = Teeje;
    X4H2O = XsjeH2OMACH;
    Cp4liq = 4180;
    P4m = Q4eom*CpMACHs4*((T3o - 273.15) - (T4o - 273.15));
    P4h = Q4eom*X4H2O*Cp4liq*((T4o - 273.15) - (T4er - 273.15));
    Q4v = rendje*(P4m - P4h)/(Cp4liq*(373.15 - (T4er - 273.15)) + Hvapo);
    pro5 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Peap, 373.15, 2);
    H4 = pro5.h;
    P4v = Q4v*pro5.h;
  else
    T4o = 273.15;
    TsMACH = T3o;
    T4er = 273.15;
    X4H2O = 0;
    Cp4liq = 0;
    P4m = 0;
    P4h = 0;
    Q4v = 0;
    pro5 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Peap, 373.15, 2);
    H4 = pro5.h;
    P4v = 0;
  end if;

  /* Clinker mass flow rate at the outlet */
  QsMACH = Q4eom;

  /* Clinker LHV at the outlet */
  PCIMACH = (Wimbm - Wimbp)/QsMACH;

  //--------------------------------------------------------------------
  // 5th zone : Post-combustion
  //---------------------------

  /* Excess air of the combustion */
  QO2p = Qsf*XsfO2;
  Qairp = QO2p/XeapO2*(1 - XeapH2O);
  Qairs = (Qeap + Qeas) - Qairp;
  excair = (Qairp/Qairs)*100;

  /* Gases mass flow rates before mixing in zone 5 */
  Q5eH2O = Q1H2O + Q2H2O + Q3H2O + Q4v + Qeasm*XeasmH2O;
  Q5eCO = Q2CO + Q3CO;
  Q5eCO2 = Q3CO2 + Q1CO2 + Q2CO2 + Qeasm*XeasmCO2;
  Q5eO2 = Q1O2 + Q2O2 + Q3O2 + Qeasm*XeasmO2;
  Q5eN2 = Q1N2 + Q2N2 + Q3N2 + Qeasm*XeasmN2;
  Q5eSO2 = Q1SO2 + Q2SO2 + Q3SO2 + Qeasm*XeasmSO2;
  Q5eHCl = Q2HCl;
  Q5eHF = Q2HF;
  Q5ecend = Q2cend;
  Q5eam = Q5eH2O + Q5eCO + Q5eCO2 + Q5eO2 + Q5eN2 + Q5eSO2 + Q5eHCl + Q5eHF + Q5ecend;

  /* Oxydation of the CO remaining in zone 5 */
  Q5od = Q5eO2 + 16/18*Q5eH2O + 32/44*Q5eCO2 + 16/28*Q5eCO;
  Q5cd = 12/44*Q5eCO2 + 12/28*Q5eCO;
  Q5hd = 2/18*Q5eH2O;
  Q5ost = 16/2*Q5hd + 32/12*Q5cd;
  exc5 = Q5od/Q5ost;

  /* Total oxydation of the remaining CO */
  if (exc5 > 1) then
    P5 = 12/28*Q5eCO*(HfCO2 - HfCO);
    Q5sCO2 = Q5eCO2 + 44/28*Q5eCO;
    Q5sO2 = Q5eO2 - 16/28*Q5eCO;
    Q5sCO = 0;

  /* Partial oxydation of the remaining CO */
  else
    P5 = Q5eO2*12/16*(HfCO2 - HfCO);
    Q5sCO2 = Q5eCO2 + 44/16*Q5eO2;
    Q5sO2 = 0;
    Q5sCO = Q5eCO - 28/16*Q5eO2;
  end if;

  /* Flue gases total mass flow rate at the outlet */
  Qsf = Q5eH2O + Q5sCO + Q5sCO2 + Q5sO2 + Q5eN2 + Q5eSO2 + Q5eHCl + Q5eHF + Q5ecend;

  /* Power available in the flue gases */
  P5s = P5*(1 - Eray5);

  /* Flue gases mass fractions at the outlet */
  XsfH2O = Q5eH2O/Qsf;
  XsfCO = Q5sCO/Qsf;
  XsfCO2 = Q5sCO2/Qsf;
  XsfO2 = Q5sO2/Qsf;
  XsfSO2 = Q5eSO2/Qsf;
  XsfN21 = Q5eN2/Qsf;
  XsfHCl = Q5eHCl/Qsf;
  XsfHF = Q5eHF/Qsf;
  XsfCEND = Q5ecend/Qsf;
  XsfN2 = 1 - (XsfCO2 + XsfH2O + XsfO2 + XsfSO2);

  /* Power accumulated by the flue gases in zone 5 */
  P5a = Qeasm*Heasm;
  P5t = P1g + H2g*Q2g + P3 + P4v + P5s + P5a;

  /* Power radiated */
  Wsr = P5s*Eray5/(1 - Eray5) + P2g*Eray2;

  /* Flue gases temperature at the outlet */
  // Changed from FlueGases_T to FlueGases_h to provide a differentiable function
  P5t/Qsf = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tsf, XsfCO2, XsfH2O, XsfO2, XsfSO2);

  /* Ashes volume mass */
  rhocend = rhoCENDom;

  /* Normal voulme fraction of the volatile ashes */
  Xcor = 1/(1 - XsfH2O);
  X5sH2OC = 0;
  X5sCO2C = XsfCO2*Xcor;
  X5sO2C = XsfO2*Xcor;
  X5sSO2C = XsfSO2*Xcor;
  X5sN2C = 1 - (X5sH2OC + X5sCO2C + X5sO2C + X5sSO2C);
  rhonorm = ThermoSysPro.Properties.FlueGases.FlueGases_rho(1.01325e5, 273.15, X5sCO2C, X5sH2OC, X5sO2C, X5sSO2C);
  FVN0 = (Qcendom/rhocend)/(Qsf/rhonorm);
  0 = if ((FVN0 < 0) or (FVN0 > 0.1)) then (FVN - 0.001) else (FVN - FVN0);

  annotation (Diagram(graphics={Polygon(
          points={{-80,20},{-80,-80},{100,-80},{100,20},{62,20},{20,40},{20,80},
              {-40,80},{-40,40},{-80,20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-80,0},{60,-40},{80,-80},{-80,-80},{-80,0}},
          lineColor={0,0,255},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
                            Icon(graphics={Polygon(
          points={{-80,20},{-80,-80},{100,-80},{100,20},{62,20},{20,40},{20,80},
              {-40,80},{-40,40},{-80,20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-80,0},{60,-40},{80,-80},{-80,-80},{-80,0}},
          lineColor={0,0,255},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
    DymolaStoredErrors,
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
<p><b>ThermoSysPro Version 2.0</h4>
</HTML>
"));
end GridFurnace;
