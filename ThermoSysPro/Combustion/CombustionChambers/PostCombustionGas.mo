﻿within ThermoSysPro.Combustion.CombustionChambers;
model PostCombustionGas "Post-combustion"
  parameter Real XClfuel=0 "Chloride mass fraction in fuel";
  parameter Real XFfuel=0 "Fluoride mass fraction in fuel";
  parameter Real Xrad=0 "Fraction of radiated power";
  parameter Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

protected
  constant Real HfCO2=3.275e+07 "CO2 formation specific enthalpy";
  constant Real HfCO=9.201e+06 "CO formation specific enthalpy";
  constant Real HfH2O=2.418e+08 "H2O steam formation specific enthalpy";
  constant Units.SI.SpecificEnthalpy H0v=2501551.43
    "Vaporisation specific enthalpy at 0°C";
  constant Units.SI.MassFlowRate Qeps=0.0001 "Minimum value for Qmel";
  Units.SI.MassFlowRate Qmelc(start=10)
    "Intermediate variable for the computation of Qmel";
  Real Keq0(start=0.1) "Intermediate variable for the compuation of Keq";
  Real delta(start=0.1)
    "Intermediate variable to compute the progress of stage 4";

public
  Units.SI.MassFlowRate Qef(start=10) "Flue gases mass flow rate at the inlet";
  Units.SI.Temperature Tef(start=1700) "Flue gases temperature at the inlet";
  Real XefCO2(start=0.5) "CO2 mass fraction at the flue gases inlet";
  Real XefH2O(start=0) "H2O mass fraction at the flue gases inlet";
  Real XefO2(start=0.5) "O2 mass fraction at the flue gases inlet";
  Real XefSO2(start=0) "SO2 mass fraction at the flue gases inlet";
  Units.SI.MassFlowRate Qsf(start=10) "Flue gases mass flow rate at the outlet";
  Units.SI.Temperature Tsf(start=1700) "Flue gases temperature at the outlet";
  Units.SI.AbsolutePressure Psf(start=1e5) "Flue gases pressure at the outlet";
  Real XsfCO2(start=0.2) "CO2 mass fraction at the flue gases outlet";
  Real XsfCO(start=0.1) "CO mass fraction at the flue gases outlet";
  Real XsfH2O(start=0.2) "H2O mass fraction at the flue gases outlet";
  Real XsfH2(start=0.1) "H2 mass fraction at the flue gases outlet";
  Real XsfO2(start=0.1) "O2 mass fraction at the flue gases outlet";
  Real XsfN2(start=0.2) "N2 mass fraction at the flue gases outlet";
  Real XsfSO2(start=0.1) "SO2 mass fraction at the flue gases outlet";
  Units.SI.MassFlowRate Qea(start=0.2) "Air mass flow rate at the inlet";
  Units.SI.Temperature Tea(start=300) "Air temperature at the inlet";
  Units.SI.AbsolutePressure Pea(start=1e5) "Air pressure at the inlet";
  Real XeaCO2(start=0.2) "CO2 mass fraction at the air inlet";
  Real XeaH2O(start=0.2) "H20 mass fraction at the air inlet";
  Real XeaO2(start=0.2) "O2 mass fraction at the air inlet";
  Real XeaSO2(start=0.2) "SO2 mass fraction at the air inlet";
  Units.SI.MassFlowRate Qec(start=0.1) "Fuel mass flow rate at the inlet";
  Units.SI.Temperature Tec(start=1700) "Fuel temperature at the inlet";
  Units.SI.SpecificHeatCapacity Cpfuel(start=1000)
    "Fuel specific heat capacity";
  Units.SI.SpecificEnergy LHVfuel(start=1e6) "Fuel LHV";
  Real XH2Ofuel(start=0) "H2O mass fraction in fuel";
  Real XCfuel(start=0.25) "C mass fraction in fuel";
  Real XHfuel(start=0.75) "H mass fraction in fuel";
  Real XOfuel(start=0) "O mass fraction in fuel";
  Real XNfuel(start=0) "N mass fraction in fuel";
  Real XSfuel(start=0) "S mass fraction in fuel";
  Units.SI.Power Wrad(start=1e6) "Power radiated";
  Units.SI.SpecificEnthalpy Hea(start=1e3)
    "Humid air specific enthalpy at the temperature of the input air";
  Units.SI.SpecificEnthalpy Hef(start=1e3)
    "Flue gases specific enthalpy at the inlet";
  Units.SI.MassFlowRate Qmel(start=10)
    "Mass flow rate of the air/flue gases mixture";
  Real XmelO2(start=0.1) "O2 pass fraction in the air/flue gases mixture";
  Real XmelCO2(start=0.1) "CO2 pass fraction in the air/flue gases mixture";
  Real XmelH2O(start=0.1) "H2O pass fraction in the air/flue gases mixture";
  Real XmelSO2(start=0.1) "SO2 pass fraction in the air/flue gases mixture";
  Real XmelN2(start=0.1) "N2 pass fraction in the air/flue gases mixture";
  Units.SI.SpecificEnthalpy Hmel(start=1e3)
    "Specific enthalpy of the air/flue gases mixture";
  Units.SI.Temperature Tmel(start=500)
    "Temperature of the air/flue gases mixture";
  Units.SI.SpecificEnthalpy Hwfuel(start=1e3)
    "Specific enthalpy of the water in fuel";
  Units.SI.SpecificEnthalpy Hfuel(start=1e3) "Fuel specific enthalpy";
  Units.SI.MassFlowRate Q1H2O(start=10)
    "H2O mass flow rate at the outlet of zone 1";
  Units.SI.MassFlowRate Q1O2(start=10)
    "O2 mass flow rate at the outlet of zone 1";
  Units.SI.MassFlowRate Q1N2(start=10)
    "N2 mass flow rate at the outlet of zone 1";
  Units.SI.MassFlowRate Q1CO2(start=10)
    "CO2 mass flow rate at the outlet of zone 1";
  Units.SI.MassFlowRate Q1SO2(start=10)
    "SO2 mass flow rate at the outlet of zone 1";
  Real X1Cfuel(start=0.1) "C mass fraction in fuel after drying";
  Real X1Hfuel(start=0.1) "H mass fraction in fuel after drying";
  Real X1Ofuel(start=0.1) "O mass fraction in fuel after drying";
  Real X1Nfuel(start=0.1) "N mass fraction in fuel after drying";
  Real X1Clfuel(start=0.1) "Cl mass fraction in fuel after drying";
  Real X1Ffuel(start=0.1) "F mass fraction in fuel after drying";
  Real X1Sfuel(start=0.1) "S mass fraction in fuel after drying";
  Units.SI.MassFlowRate Q1ec(start=10) "Fuel mass flow rate after drying";
  Units.SI.SpecificEnergy LHVfuel1(start=1e6) "Fuel LHV after drying";
  Units.SI.MassFlowRate Q2eO(start=10)
    "O2 mass flow rate at the inlet of zone 2";
  Units.SI.MassFlowRate Q21HCl(start=10)
    "HCl mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q21HF(start=10)
    "HF mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q21SO2(start=10)
    "SO2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q21N2(start=10)
    "N2 mass flow rate at the outlet of zone 2";
  Units.SI.MassFlowRate Q22CO(start=10) "CO mass flow rate produced in stage 2";
  Units.SI.MassFlowRate Q22O2(start=10) "O2 mass flow rate left after stage 2";
  Units.SI.MassFlowRate Q22H2(start=10) "H2 mass flow rate produced at stage 2";
  Real etaO2(start=0.1) "O2 fraction at the end of the combustion";
  Units.SI.MassFlowRate Q23CO2(start=10)
    "CO2 mass flow rate at the end of stage 3";
  Units.SI.MassFlowRate Q23H2O(start=10)
    "H2O mass flow rate at the end of stage 3";
  Units.SI.MassFlowRate Q23CO(start=10)
    "CO mass flow rate at the end of stage 3";
  Units.SI.MassFlowRate Q23H2(start=10)
    "H2 mass flow rate at the end of stage 3";
  Units.SI.MassFlowRate Q23O2(start=10)
    "O2 mass flow rate at the end of stage 3";
  Units.SI.MassFlowRate Q24eg(start=10)
    "Mass flow rate of the volatile elements at the end of zone 2";
  Units.SI.MassFlowRate Q24sg(start=10)
    "Mass flow rate of the volatile elements at the outlet of zone 2";
  Real X24O2(start=0.1) "O2 mass fraction in flue gases of zone 4";
  Real X24SO2(start=0.1) "SO2 mass fraction in flue gases of zone 4";
  Real X24H2O(start=0.1) "H2O mass fraction in flue gases of zone 4";
  Real X24CO(start=0.1) "CO mass fraction in flue gases of zone 4";
  Real X24CO2(start=0.1) "CO2 mass fraction in flue gases of zone 4";
  Real X24C(start=0.1) "C mass fraction in flue gases of zone 4";
  Real X24N2(start=0.1) "N2 mass fraction in flue gases of zone 4";
  Real Keq(start=0.1) "Equilibrium constant for stage 4";
  Real Mm4e(start=0.1) "Molar mass of the gases entering stage 4";
  Real Mm4s(start=0.1) "Molar mass of the gases leaving stage 4";
  Real X24eCOvol(start=0.1) "CO volume fraction before stage 4";
  Real X24eCO2vol(start=0.1) "CO2 volume fraction before stage 4";
  Real X24eH2vol(start=0.1) "H2 volume fraction before stage 4";
  Real X24eH2Ovol(start=0.1) "H2 volume fraction before stage 4";
  Real X24eN2vol(start=0.1) "N2 volume fraction before stage 4";
  Real X24eHClvol(start=0.1) "HCl volume fraction before stage 4";
  Real X24eHFvol(start=0.1) "HF volume fraction before stage 4";
  Real X24eSO2vol(start=0.1) "SO2 volume fraction before stage 4";
  Real X24sCOvol(start=0.1) "CO volume fraction after stage 4";
  Real X24sCO2vol(start=0.1) "CO2 volume fraction after stage 4";
  Real X24sH2vol(start=0.1) "H2 volume fraction after stage 4";
  Real X24sH2Ovol(start=0.1) "H2O volume fraction after stage 4";
  Real AVE(start=0.1) "Progress of stage 4";
  Units.SI.MassFlowRate Q24H2O(start=10)
    "H2O mass flow rate at the ned of stage 4";
  Units.SI.MassFlowRate Q24H2(start=10)
    "H2 mass flow rate at the ned of stage 4";
  Units.SI.MassFlowRate Q24CO(start=10)
    "CO mass flow rate at the ned of stage 4";
  Units.SI.MassFlowRate Q24CO2(start=10)
    "CO2 mass flow rate at the ned of stage 4";
  Real PciCvol(start=1e6) "Power released by the combustion";
  Units.SI.Power P2g(start=1e6) "Power released by the combustion";
  Real XsfC(start=0.1) "C mass fraction in the flue gases";
  Units.SI.Power P2t(start=1e6) "Total flue gases power at the outlet";

public
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet Ca "Air inlet"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutlet Cfg2 "Flue gases outlet"
    annotation (Placement(transformation(extent={{80,0},{100,20}}, rotation=0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet Cfg1 "Flue gases inlet"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}}, rotation=0)));
  ThermoSysPro.Combustion.Connectors.FuelInlet Cfuel "Fuel inlet"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}},
          rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_pT pro1
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
equation
  /* Flue gases outlet */
  Qsf = Cfg2.Q;
  Tsf = Cfg2.T;
  Psf = Cfg2.P;
  XsfCO2 = Cfg2.Xco2;
  XsfH2O = Cfg2.Xh2o;
  XsfO2 = Cfg2.Xo2;
  XsfSO2 = Cfg2.Xso2;

  /* Air inlet */
  Qea = Ca.Q;
  Pea = Ca.P;
  Pea = 1.01e+5;
  Tea = Ca.T;
  XeaCO2 = Ca.Xco2;
  XeaH2O = Ca.Xh2o;
  XeaO2 = Ca.Xo2;
  XeaSO2 = Ca.Xso2;

  /* Flue gases inlet */
  Qef = Cfg1.Q;
  Tef = Cfg1.T;
  Cfg1.P = Cfg2.P;
  XefCO2 = Cfg1.Xco2;
  XefH2O = Cfg1.Xh2o;
  XefO2 = Cfg1.Xo2;
  XefSO2 = Cfg1.Xso2;

  /* Fuel inlet */
  Qec = Cfuel.Q;
  Tec = Cfuel.T;
  LHVfuel = Cfuel.LHV;
  XH2Ofuel = Cfuel.hum;
  XCfuel = Cfuel.Xc;
  XHfuel = Cfuel.Xh;
  XOfuel = Cfuel.Xo;
  XNfuel = Cfuel.Xn;
  XSfuel = Cfuel.Xs;
  Cpfuel = Cfuel.cp;

  // 1st zone : Mixing air - flue gases - water in fuel
  // --------------------------------------------------

  /* Humid air specific enthalpy at the temperature of the input air */
  Hea = ThermoSysPro.Properties.FlueGases.FlueGases_h(Pea, Tea, XeaCO2, XeaH2O, XeaO2, XeaSO2);

  /* Flue gases specific enthalpy at the inlet */
  Hef = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tef, XefCO2, XefH2O, XefO2, XefSO2);

  // Air - flue gases mixing
  // - - - - - - - - - - - -

  /* Mixture flow rate */
  Qmelc = Qea + Qef;
  0 = if (Qmelc - Qeps <= 0) then (Qmel - Qeps) else (Qmelc - Qmel);

  /* Mixture composition */
  XmelO2 = (XefO2*Qef + XeaO2*Qea)/Qmel;
  XmelCO2 = (XefCO2*Qef)/Qmel;
  XmelH2O = (XefH2O*Qef + XeaH2O*Qea)/Qmel;
  XmelSO2 = (XefSO2*Qef)/Qmel;
  XmelN2 = 1 - XmelO2 - XmelCO2 - XmelH2O - XmelSO2;

  /* Mixture specific enthalpy */
  Hmel = (Qea*Hea + Hef*Qef)/Qmel;

  /* Mixture temperature */
  // Changed from FlueGases_T to FlueGases_h to provide a differentiable function
  Hmel = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tmel, XmelCO2, XmelH2O, XmelO2, XmelSO2);

  // Fuel
  // - -

  /* Specific entahlpy of the water in fuel */
  pro1 = ThermoSysPro.Properties.WaterSteam.IF97.Water_PT(Pea, Tec, mode);
  Hwfuel = pro1.h;

  /* Fuel specific enthalpy */
  Hfuel = Cpfuel*(Tec - 273.16);

  // Mass flow rates leaving zone 1
  // - - - - - - - - - - - - - - - -
  Q1H2O = Qec*XH2Ofuel + Qmel*XmelH2O;
  Q1O2 = Qmel*XmelO2;
  Q1N2 = Qmel*XmelN2;
  Q1CO2 = Qmel*XmelCO2;
  Q1SO2 = Qmel*XmelSO2;

  /* After fuel drying */
  Q1ec = Qec*(1 - XH2Ofuel);
  LHVfuel1 = LHVfuel*(1 - XH2Ofuel);
  X1Cfuel = XCfuel*(1 - XH2Ofuel);
  X1Hfuel = XHfuel*(1 - XH2Ofuel);
  X1Ofuel = XOfuel*(1 - XH2Ofuel);
  X1Nfuel = XNfuel*(1 - XH2Ofuel);
  X1Clfuel = XClfuel*(1 - XH2Ofuel);
  X1Ffuel = XFfuel*(1 - XH2Ofuel);
  X1Sfuel = XSfuel*(1 - XH2Ofuel);

  // 2nd zone : Combustion
  // ---------------------

  // Stage 1 : Combustion of trace elements
  // - - - - - - - - - - - - - - - - - - - -

  /* Oxygen mass flow rate */
  Q2eO = Q1ec*X1Ofuel + Qmel*XmelO2;

  /* Other exiting mass flow rates */
  Q21HCl = 36.5/35.5*Q1ec*X1Clfuel;
  Q21HF = 20/19*Q1ec*X1Ffuel;
  Q21SO2 = 64.06/32.06*Q1ec*X1Sfuel + Qmel*XmelSO2;
  Q21N2 = Q1N2 + Q1ec*X1Nfuel;

  // Etape 2 : CH4 oxydation into CO : CH4+1/2O2=>2H2+CO
  // - - - - - - - - - - - - - - - - - - - - - - - - - -

  /* Mass flow rate of CO produced */
  Q22CO = 28/12*Q1ec*X1Cfuel;

  /* Oxygen mass flow rate */
  Q22O2 = Q2eO - Q1ec*(X1Sfuel/32.06*32.06 + 32/12/2*X1Cfuel);

  /* Mass flow rate of H2 produced */
  Q22H2 = Q1ec*(X1Hfuel - 1/35.5*X1Clfuel - 1/19*X1Ffuel);

  /* O2 fraction */
  etaO2 = Q2eO - Q1ec*(X1Sfuel + 16/2*(X1Hfuel - 1/35.5*X1Clfuel - 1/19*X1Ffuel) + 16/12*X1Cfuel*2);

  if (etaO2 < 1e-6) then
    //---------------
    // Lack of oxygen
    //---------------

    // Stage 3 : CO oxydation into CO2 : 2H2+CO+3/2O2=>CO2+2H2O
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Q23CO2 = Q1CO2 + 2/3*Q22O2/32*44;
    Q23H2O = Qmel*XmelH2O + 4/3*Q22O2/32*18 + Qec*XH2Ofuel;
    Q23CO = Q22CO - 2/3*Q22O2/32*28;
    Q23H2 = Q22H2 - 4/3*Q22O2/32*2;
    Q23O2 = 0;

    // Stage 4 :Equilibrium reaction CO/CO2
    // - - - - - - - - - - - - - - - - - - -

    /* Total mass flow rate of the volatile elements in zone 2 */
    Q24eg = Q23H2 + Q21HCl + Q21HF + Q21SO2 + Q23H2O + Q23CO + Q21N2 + Q23O2 + Q23CO2;

    /* Composition */
    X24O2 = Q23O2/Q24eg;
    X24SO2 = Q21SO2/Q24eg;
    X24H2O = Q23H2O/Q24eg;
    X24CO = Q23CO/Q24eg;
    X24CO2 = Q23CO2/Q24eg;
    X24C = X24CO + X24CO2;
    X24N2 = 1 - (X24O2 + X24SO2 + X24H2O + X24CO + X24CO2);

    /* Equilibrium constant */
    Keq0 = 0.0042*(Tmel - 273.15) - 2.4555;
    0 = if (Keq0 > 0) then (Keq - Keq0) else Keq;

    /* Molar mass of the incoming gases */
    Mm4e = (Q23CO/28 + Q23H2O/18 + Q23CO2/44 + Q23H2/2 + Q21N2/28)/Q24eg;

    /* Volume fractions at the inlet of stage 4 */
    X24eCOvol = Q23CO/Q24eg/Mm4e/28;
    X24eCO2vol = Q23CO2/Q24eg/Mm4e/44;
    X24eH2vol = Q23H2/Q24eg/Mm4e/2;
    X24eH2Ovol = Q23H2O/Q24eg/Mm4e/18;
    X24eN2vol = Q21N2/Q24eg/Mm4e/28;
    X24eHClvol = Q21HCl/Q24eg/Mm4e/36.5;
    X24eHFvol = Q21HF/Q24eg/Mm4e/20;
    X24eSO2vol = Q21SO2/Q24eg/Mm4e/64.06;

    /* Reaction progress */
    delta = ((X24eCOvol + X24eH2Ovol) + Keq*(X24eCO2vol + X24eH2vol))^2 - 4*(Keq - 1)*(Keq*X24eCO2vol*X24eH2vol - X24eCOvol*X24eH2Ovol);
    AVE = ((X24eCOvol + X24eH2Ovol) + Keq*(X24eCO2vol + X24eH2vol) - (delta)^0.5)/2/(Keq - 1);

    /* Volume fractions at the outlet of stage 4 */
    X24sCOvol = X24eCOvol + AVE;
    X24sCO2vol = X24eCO2vol - AVE;
    X24sH2vol = X24eH2vol - AVE;
    X24sH2Ovol = X24eH2Ovol + AVE;

    /* Molar mass of the outgoing gases */
    Mm4s = X24sCOvol*28 + X24sCO2vol*44 + X24sH2vol*2 + X24sH2Ovol*18 + X24eN2vol*28;

    /* Mass flow rates */
    Q24CO = X24sCOvol*28/Mm4s*Q24eg;
    Q24CO2 = X24sCO2vol*44/Mm4s*Q24eg;
    Q24H2O = X24sH2Ovol*18/Mm4s*Q24eg;
    Q24H2 = X24sH2vol*2/Mm4s*Q24eg;

    Q24sg = Q24H2 + Q21HCl + Q21HF + Q21SO2 + Q24H2O + Q24CO + Q21N2 + Q23O2 + Q24CO2;

  else
    //-----------------
    // Excess of oxygen
    //-----------------

    // Stage 3 : CO oxydation into CO2 : 2H2+CO+3/2O2=>CO2+2H2O
    // - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    Q23CO2 = Q1CO2 + Q1ec*X1Cfuel/12*44;
    Q23H2O = Qmel*XmelH2O+Q1ec*(X1Hfuel - 1/35.5*X1Clfuel - 1/19*X1Ffuel)*18/2 + Qec*XH2Ofuel;
    Q23CO = 0;
    Q23H2 = 0;
    Q23O2 = Q2eO - Q1ec*(X1Sfuel + 16/2*(X1Hfuel - 1/35.5*X1Clfuel - 1/19*X1Ffuel) + 16/12*X1Cfuel*2);

    // Stage 4 : Eaquilibrium reaction CO/CO2
    // - - - - - - - - - - - - - - - - - - -
    Q24eg = Q23H2 + Q21HCl + Q21HF + Q21SO2 + Q23H2O + Q23CO + Q21N2 + Q23O2 + Q23CO2;
    X24O2 = 0;
    X24SO2 = 0;
    X24H2O = 0;
    X24CO = 0;
    X24CO2 = 0;
    X24C = 0;
    X24N2 = 0;
    Keq0 = 0;
    0 = if (Keq0 > 0) then (Keq - Keq0) else Keq;
    Mm4e = 0;
    X24eCOvol = 0;
    X24eCO2vol = 0;
    X24eH2vol = 0;
    X24eH2Ovol = 0;
    X24eN2vol = 0;
    X24eHClvol = 0;
    X24eHFvol = 0;
    X24eSO2vol = 0;
    delta = 0;
    AVE = 0;
    X24sCOvol = 0;
    X24sCO2vol = 0;
    X24sH2vol = 0;
    X24sH2Ovol = 0;
    Mm4s = 0;
    Q24CO = Q23CO;
    Q24CO2 = Q23CO2;
    Q24H2O = Q23H2O;
    Q24H2 = Q23H2;
    Q24sg = Q24eg;
  end if;

  /* Mass flow rate at the outlet */
  Qsf = Q24sg;

  /* Power released by the combustion */
  0 = if (Q1ec >= 1e-6) then PciCvol - (Q24CO/28/Q1ec*12*(HfCO2 - HfCO) + Q24H2/2*(HfH2O)/Q1ec) else PciCvol;

  /* Power released by the combustion in zone 2 */
  P2g = (LHVfuel1 - PciCvol)*Q1ec;

  /* Composition at the outlet */
  XsfO2 = Q23O2/Qsf;
  XsfSO2 = Q21SO2/Qsf;
  XsfH2O = Q24H2O/Qsf;
  XsfH2 = Q24H2/Qsf;
  XsfCO = Q24CO/Qsf;
  XsfCO2 = Q24CO2/Qsf;
  XsfC = XsfCO2 + XsfCO;
  XsfN2 = 1 - (XsfO2 + XsfSO2 + XsfH2O + XsfCO2 + XsfCO);

  /* Power accumukated by the gases in zone 2 */
  P2t = ((Q24H2O - (Qmel*XmelH2O))*H0v + Qmel*Hmel + Q1ec*Hfuel + P2g)*(1 - Xrad);
  // Changed from FlueGases_T to FlueGases_h to provide a differentiable function
  P2t/Qsf = ThermoSysPro.Properties.FlueGases.FlueGases_h(Psf, Tsf, XsfC, XsfH2O, XsfO2, XsfSO2);

  Wrad = P2t*Xrad;

  annotation (Diagram(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,62},{46,46},{2,30},{58,18},{6,0},{48,-16},{2,-32},{54,
              -44},{-20,-60},{-20,62}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-20,80},{-20,-80}}, color={0,0,255})}),
                                       Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,62},{46,46},{2,30},{58,18},{6,0},{48,-16},{2,-32},{54,
              -44},{-20,-60},{-20,62}},
          lineColor={0,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.CrossDiag),
        Line(points={{-20,80},{-20,-80}}, color={0,0,255})}),
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2013</b> </p>
<p><b>ThermoSysPro Version 3.1</h4>
</html>"));
end PostCombustionGas;
