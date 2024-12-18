within ThermoSysPro.Fluid.HeatExchangers;
model StaticCondenserHEI "HEI static condenser"
  extends
    ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.WaterSteamFluidTypeParameterInterface;
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.IF97Region;

  parameter Real Kf=0 "Friction pressure loss coefficient for the cold side";
  parameter Units.SI.Position z1c=0 "Hot inlet altitude";
  parameter Units.SI.Position z2c=0 "Hot outlet altitude";
  parameter Units.SI.Position z1f=0 "Cold inlet altitude";
  parameter Units.SI.Position z2f=0 "Cold outlet altitude";
  parameter Real Ucorr=1.00 "Corrective term for the heat transfert coefficient (U) for calibration";
  parameter Units.SI.Density p_rhoc=0
    "If > 0, fixed fluid density for the hot side";
  parameter Units.SI.Density p_rhof=0
    "If > 0, fixed fluid density for the cold side";
  parameter Integer Tube_Material1=1 "Material of the tubes type 1. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Integer Tube_Material2=1 "Material of the tubes type 2. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Integer Tube_Material3=1 "Material of the tubes type 3. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Integer Tube_Material4=1 "Material of the tubes type 4. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Integer Tube_Material5=1 "Material of the tubes type 5. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Integer Tube_Material6=1 "Material of the tubes type 6. 1:Cu Fe 194 - 2:Arsenical Cu - 3:Admiralty - 4:Al Brass - 5:Al Bronze - 6:Carbon Steel 
    - 7:Cu Ni 90-10 - 8:Cu Ni 70-30 - 9:SS (UNS S43035) - 10:Titanium Grades 1 & 2 - 11:SS (UNS S44660) 
    - 12:SS (UNS S44735) - 13:SS TP 304 - 14:SS TP 316/317 - 15:SS (UNS N08367)";
  parameter Real nb_pass=2 "Number of water passes";
  parameter Real nb_tube1=12000 "Number of tubes type 1. For exemple tubes of the condensing zone";
  parameter Real nb_tube2=900 "Number of tubes type 2. For exemple gaz removal tubes";
  parameter Real nb_tube3=700 "Number of tubes type 3. For exemple impingement tubes";
  parameter Real nb_tube4=200 "Number of tubes type 4";
  parameter Real nb_tube5=200 "Number of tubes type 5";
  parameter Real nb_tube6=200 "Number of tubes type 6";
  parameter Units.SI.Thickness e_tube1=0.7e-3 "Tubes thickness type 1";
  parameter Units.SI.Thickness e_tube2=0.7e-3 "Tubes thickness type 2";
  parameter Units.SI.Thickness e_tube3=1e-3 "Tubes thickness type 3";
  parameter Units.SI.Thickness e_tube4=1e-3 "Tubes thickness type 4";
  parameter Units.SI.Thickness e_tube5=1e-3 "Tubes thickness type 5";
  parameter Units.SI.Thickness e_tube6=1e-3 "Tubes thickness type 6";
  parameter Units.SI.Diameter D_tube1=25.4e-3
    "External diameter of tubes type 1";
  parameter Units.SI.Diameter D_tube2=25.4e-3
    "External diameter of tubes type 2";
  parameter Units.SI.Diameter D_tube3=25.4e-3
    "External diameter of tubes type 3";
  parameter Units.SI.Diameter D_tube4=25.4e-3
    "External diameter of tubes type 4";
  parameter Units.SI.Diameter D_tube5=25.4e-3
    "External diameter of tubes type 5";
  parameter Units.SI.Diameter D_tube6=25.4e-3
    "External diameter of tubes type 6";
  parameter Units.SI.Length L_tube1=10 "Tubes length type 1";
  parameter Units.SI.Length L_tube2=10 "Tubes length type 2";
  parameter Units.SI.Length L_tube3=10 "Tubes length type 3";
  parameter Units.SI.Length L_tube4=10 "Tubes length type 4";
  parameter Units.SI.Length L_tube5=10 "Tubes length type 5";
  parameter Units.SI.Length L_tube6=10 "Tubes length type 6";
  parameter Real FC=0.95 "Correction factor for cleanless";
  parameter Units.SI.Pressure Poffset=0
    "Offset applied on the pressure provided by HEI";
  parameter Units.SI.MassFlowRate gamma_diff=1e-4
    "Air diffusion conductance (active if diffusion=true in neighbouring volumes)";
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";
  parameter IF97Region region_c=IF97Region.All_regions "IF97 region for the hot side (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(enable=(ftype==FluidType.WaterSteam), tab="Fluid", group="Fluid properties"));
  parameter IF97Region region_cs=IF97Region.All_regions "IF97 region at the outlet of the hot side (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(enable=(ftype==FluidType.WaterSteam), tab="Fluid", group="Fluid properties"));
  parameter IF97Region region_f=IF97Region.All_regions "IF97 region for the cold side (active for IF97 water/steam only)" annotation(Evaluate=true, Dialog(enable=(ftype==FluidType.WaterSteam), tab="Fluid", group="Fluid properties"));

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Integer fluid=Integer(ftype) "Water fluid number";
  parameter Integer mode_c=Integer(region_c) - 1 "IF97 region for the hot side. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  parameter Integer mode_cs=Integer(region_cs) - 1 "IF97 region at the outlet of the hot side. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  parameter Integer mode_f=Integer(region_f) - 1 "IF97 region for the cold side. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  parameter Units.SI.MassFlowRate gamma0=1.e-4
    "Pseudo-diffusion conductance use for continuous flow reversal (active if diffusion=false and continuous_flow_reversal = true)";
  parameter Real eps=1.e-0 "Small number for pressure loss equation";

public
  Units.SI.Diameter D_tubes "Weight average diameter of the tubes";
  Units.SI.Thickness e_tubes "Weight average thickness of the tubes";
  Units.SI.Area S_pass(start=3) "Passage section of the cold water";
  Units.SI.Area S_ech1(start=10000) "Heat exchange surface of tubes type 1";
  Units.SI.Area S_ech2(start=10000) "Heat exchange surface of tubes type 2";
  Units.SI.Area S_ech3(start=10000) "Heat exchange surface of tubes type 3";
  Units.SI.Area S_ech4(start=10000) "Heat exchange surface of tubes type 4";
  Units.SI.Area S_ech5(start=10000) "Heat exchange surface of tubes type 5";
  Units.SI.Area S_ech6(start=10000) "Heat exchange surface of tubes type 6";
  Real FM1 "Correction factor for material and gauge of tubes type 1";
  Real FM2 "Correction factor for material and gauge of tubes type 2";
  Real FM3 "Correction factor for material and gauge of tubes type 3";
  Real FM4 "Correction factor for material and gauge of tubes type 4";
  Real FM5 "Correction factor for material and gauge of tubes type 5";
  Real FM6 "Correction factor for material and gauge of tubes type 6";
  Units.SI.Power W(start=1e6)
    "Power exchanged from the hot side to the cold side";
  Units.SI.Temperature Tec(start=500)
    "Fluid temperature at the inlet of the hot side";
  Units.SI.Temperature Tsc(start=400)
    "Fluid temperature at the outlet of the hot side";
  Units.SI.Temperature Tef(start=350)
    "Fluid temperature at the inlet of the cold side";
  Units.SI.Temperature Tsf(start=350)
    "Fluid temperature at the outlet of the cold side";
  Units.SI.Pressure DPgc(start=1e2) "Gravity pressure loss in the hot side";
  Units.SI.Pressure DPff(start=1e3) "Friction pressure loss in the cold side";
  Units.SI.Pressure DPgf(start=1e2) "Gravity pressure loss in the cold side";
  Units.SI.Pressure DPf(start=1e3) "Total pressure loss in the cold side";
  Units.SI.Density rhof(start=998) "Density of the fluid in the cold side";
  Units.SI.Density rho_ex(start=950) "Water density at the extraction point";
  Units.SI.MassFlowRate Qc(start=100) "Hot fluid mass flow rate";
  Units.SI.MassFlowRate Qf(start=100) "Cold fluid mass flow rate";
  Units.SI.Area S_ech(start=10000) "Heat exchange surface";
  Units.SI.Velocity Vf "Velocity of the cold water";
  Real Fw "Correction factor for water";
  Units.SI.CoefficientOfHeatTransfer U1
    "Uncorrected heat transfert coefficient";
  Real FM "Overall correction factor for material and gauge";
  Units.SI.CoefficientOfHeatTransfer U "Heat transfert coefficient";
  Units.SI.Temperature Tcut_off "Saturation temperature at pressure cut-off";
  Units.SI.Pressure Psat_att(start=6000) "Expected HEI saturation pressure";
  Units.SI.Pressure Pcut_off "Pressure cut-off";
  Units.SI.Pressure Pzero_load "Zero-load pressure ";
  Units.SI.Pressure Pcond(start=6000)
    "Expected corrected HEI saturation pressure";
  Units.SI.Temperature Tsat(start=310)
    "Expected corrected HEI saturation temperature";
  Units.SI.Power Wcut_off(start=5e5)
    "Power exchanged from the hot side to the cold side at Pcut_off";
  Units.SI.Temperature TTD "Terminal Temperature Difference";
  Integer HEI "Applicability of the HEI standard. 0:No - 1:Yes";
  Units.SI.Temperature Tsat_att(start=310)
    "Expected HEI saturation temperature";
  Units.SI.SpecificHeatCapacity Cpmf(start=950)
    "Average specific heat capacity of the cold water";
  Units.SI.SpecificEnthalpy Hmv(start=2500000)
    "Fluid inlets average specific enthalpy";
  Units.SI.SpecificEnthalpy Hml(start=100000)
    "Extraction water average specific enthalpy";
  Units.SI.SpecificEnthalpy Hex(start=100000)
    "Drain specific enthalpy at the outlet";
  FluidType fluids[5] "Fluids mixing in volume";
  Units.SI.Power Jvt "Thermal power diffusion from inlet Cvt";
  Units.SI.Power Jev "Thermal power diffusion from inlet Cev";
  Units.SI.Power Jep "Thermal power diffusion from inlet Cep";
  Units.SI.Power Jex "Thermal power diffusion from outlet Cex";
  Units.SI.Power J "Total thermal power diffusion for the liquid in the cavity";
  Units.SI.MassFlowRate gamma_vt "Diffusion conductance for inlet Cvt";
  Units.SI.MassFlowRate gamma_ev "Diffusion conductance for inlet Cev";
  Units.SI.MassFlowRate gamma_ep "Diffusion conductance for inlet Cep";
  Units.SI.MassFlowRate gamma_ex "Diffusion conductance for outlet Cex";
  Real rvt "Value of r(Q/gamma) for inlet Cvt";
  Real rev "Value of r(Q/gamma) for inlet Cev";
  Real rep "Value of r(Q/gamma) for inlet Cep";
  Real rex "Value of r(Q/gamma) for outlet Cex";
  FluidType ftype_p "Cooling pipe fluid type";
  Integer fluid_p=Integer(ftype_p) "Cooling pipe fluid number";

public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cee "Cooling water inlet"
    annotation (Placement(transformation(extent={{-112,-72},{-88,-50}},
          rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cse
    "Cooling water outlet" annotation (Placement(transformation(extent={{90,-72},
            {114,-50}}, rotation=0)));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidOutlet Cex "Extraction water"
    annotation (Placement(transformation(extent={{-12,-112},{14,-88}}, rotation=
           0), iconTransformation(extent={{-12,-112},{14,-88}})));
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cvt "Turbine outlet"
    annotation (Placement(transformation(extent={{-13,88},{13,114}}, rotation=0),
        iconTransformation(extent={{-13,88},{13,114}})));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph profs
    "Proprietes eau"
    annotation (Placement(transformation(extent={{50,80},{70,100}}, rotation=0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph profe
    "Proprietes eau"
    annotation (Placement(transformation(extent={{20,80},{40,100}}, rotation=0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proce
    "Proprietes eau"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}},
          rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cep "Drain inlet"
    annotation (Placement(transformation(extent={{-112,8},{-88,30}}, rotation=0)));
public
  ThermoSysPro.Fluid.Interfaces.Connectors.FluidInlet Cev "Vapor inlet"
    annotation (Placement(transformation(extent={{-112,50},{-88,72}}, rotation=
            0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph procs
    "Proprietes eau"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph promf
    "Proprietes eau"
    annotation (Placement(transformation(extent={{80,80},{100,100}}, rotation=0)));
equation

  /* Check that incoming fluids are compatible with fluid in volume */
  fluids[1] = ftype;
  fluids[2] = Cvt.ftype;
  fluids[3] = Cev.ftype;
  fluids[4] = Cep.ftype;
  fluids[5] = Cex.ftype;

  /* Check that the fluid type for the cooling pipe is water/steam */
  assert((ftype_p == FluidType.WaterSteam) or (ftype_p == FluidType.WaterSteamSimple), "StaticCondenserHEI: the fluid type for the cooling pipe must be water/steam");

  /* Unconnected connectors */
  if (cardinality(Cev) == 0) then
    Cev.Q = 0;
    Cev.h = 1.e5;
    Cev.h_vol_1 = 1.e5;
    Cev.diff_res_1 = 0;
    Cev.diff_on_1 = false;
    Cev.ftype = ftype;
    Cev.Xco2 = 0;
    Cev.Xh2o = 1;
    Cev.Xo2 = 0;
    Cev.Xso2 = 0;
  end if;

  if (cardinality(Cep) == 0) then
    Cep.Q = 0;
    Cep.h = 1.e5;
    Cep.h_vol_1 = 1.e5;
    Cep.diff_res_1 = 0;
    Cep.diff_on_1 = false;
    Cep.ftype = ftype;
    Cep.Xco2 = 0;
    Cep.Xh2o = 1;
    Cep.Xo2 = 0;
    Cep.Xso2 = 0;
  end if;

  // Water/steam cavity
  //-------------------

  /* Mixer: mass balance equation */
  0 = Cvt.Q + Cev.Q + Cep.Q - Cex.Q;

  Qc = Cex.Q;

  /* Extraction water pressure */
  Cex.P = Pcond + rho_ex*g*(z2c - z1c);

  /* Fluid pressure */
  Pcond = Cvt.P;
  Pcond = Cev.P;
  Pcond = Cep.P;

  /* Energy balance equation */
  0 = Cvt.Q* Cvt.h + Cev.Q*Cev.h + Cep.Q*Cep.h - Cex.Q*Cex.h - W + J;
  // 0 = Cvt.Q*(Cvt.h - lsat.h) + Cev.Q*(Cev.h - lsat.h) + Cep.Q*(Cep.h - lsat.h) -  W;

  /* Extraction water average specific enthalpy */
  Hml = lsat.h;
  // Hml = (lsat.h + Hex)/2;

  Cvt.h_vol_2 = Hml;
  Cev.h_vol_2 = Hml;
  Cep.h_vol_2 = Hml;
  Cex.h_vol_1 = Hml;

  /* Average specific enthalpies of the inlets */
  Hmv = (Cvt.Q*Cvt.h + Cev.Q*Cev.h + Cep.Q*Cep.h)/Qc;

  // Cvt.h_vol_2 = Hmv;
  // Cev.h_vol_2 = Hmv;
  // Cep.h_vol_2 = Hmv;
  // Cex.h_vol_1 = Hex;

  /* Extraction water specific enthalpy */
  Hex = noEvent(if (rho_ex > 0) then lsat.h + ((Cex.P - Pcond)/rho_ex) else lsat.h);

  /* Gravity pressure losses in the hot side */
  DPgc = rho_ex*g*(z2c - z1c);

  /* Fluid composition in the cavity (no balance equations) */
  Cex.ftype = ftype;

  Cex.Xco2 = 0;
  Cex.Xh2o = 1;
  Cex.Xo2  = 0;
  Cex.Xso2 = 0;

  /* Flow reversal */
  if continuous_flow_reversal then
    Cex.h = ThermoSysPro.Functions.SmoothCond(Cex.Q/gamma_ex, Cex.h_vol_1, Cex.h_vol_2, 1);
  else
    Cex.h = if (Cex.Q > 0) then Cex.h_vol_1 else Cex.h_vol_2;
  end if;

  /* Diffusion power */
  if diffusion then
    rvt = if Cvt.diff_on_1 then exp(-0.033*(Cvt.Q*Cvt.diff_res_1)^2) else 0;
    rev = if Cev.diff_on_1 then exp(-0.033*(Cev.Q*Cev.diff_res_1)^2) else 0;
    rep = if Cep.diff_on_1 then exp(-0.033*(Cep.Q*Cep.diff_res_1)^2) else 0;
    rex = if Cex.diff_on_2 then exp(-0.033*(Cex.Q*Cex.diff_res_2)^2) else 0;

    gamma_vt = if Cvt.diff_on_1 then 1/Cvt.diff_res_1 else gamma0;
    gamma_ev = if Cev.diff_on_1 then 1/Cev.diff_res_1 else gamma0;
    gamma_ep = if Cep.diff_on_1 then 1/Cep.diff_res_1 else gamma0;
    gamma_ex = if Cex.diff_on_2 then 1/Cex.diff_res_2 else gamma0;

    Jvt = if Cvt.diff_on_1 then rvt*gamma_vt*(Cvt.h_vol_1 - Cvt.h_vol_2) else 0;
    Jev = if Cev.diff_on_1 then rev*gamma_ev*(Cev.h_vol_1 - Cev.h_vol_2) else 0;
    Jep = if Cep.diff_on_1 then rep*gamma_ep*(Cep.h_vol_1 - Cep.h_vol_2) else 0;
    Jex = if Cex.diff_on_2 then rex*gamma_ex*(Cex.h_vol_2 - Cex.h_vol_1) else 0;
  else
    rvt = 0;
    rev = 0;
    rep = 0;
    rex = 0;

    gamma_vt = gamma0;
    gamma_ev = gamma0;
    gamma_ep = gamma0;
    gamma_ex = gamma0;

    Jvt = 0;
    Jev = 0;
    Jep = 0;
    Jex = 0;
   end if;

  J = Jvt + Jev + Jep + Jex;

  Cvt.diff_res_2 = 0;
  Cev.diff_res_2 = 0;
  Cep.diff_res_2 = 0;
  Cex.diff_res_1 = 0;

  Cvt.diff_on_2 = diffusion;
  Cev.diff_on_2 = diffusion;
  Cep.diff_on_2 = diffusion;
  Cex.diff_on_1 = diffusion;

  // Cooling pipe
  //-------------

  /* Cooling pipe inlet and outlet */
  Cee.Q = Cse.Q;

  Cee.h_vol_1 = Cse.h_vol_1;
  Cee.h_vol_2 = Cse.h_vol_2;

  Cse.diff_on_1 = Cee.diff_on_1;
  Cee.diff_on_2 = Cse.diff_on_2;

  Cse.diff_res_1 = Cee.diff_res_1 + 1/gamma_diff;
  Cee.diff_res_2 = Cse.diff_res_2 + 1/gamma_diff;

  Cee.ftype = Cse.ftype;

  Cee.Xco2 = Cse.Xco2;
  Cee.Xh2o = Cse.Xh2o;
  Cee.Xo2  = Cse.Xo2;
  Cee.Xso2 = Cse.Xso2;

  ftype_p = Cee.ftype;

  Qf = Cee.Q;

  /* Pressure losses in the cold side */
  Cee.P - Cse.P = DPf;

  DPff = Kf*ThermoSysPro.Functions.ThermoSquare(Qf, eps)/rhof;
  DPgf = rhof*g*(z2f - z1f);
  DPf = DPff + DPgf;

  /* Power released from the hot side to the cold side */
  W = Qf*(Cse.h - Cee.h);

  /* Fluid thermodynamic properties of the hot side */
  proce = ThermoSysPro.Properties.Fluid.Ph(Cvt.P, Hmv, mode_c, fluid);
  procs = ThermoSysPro.Properties.Fluid.Ph(Cex.P, Cex.h, mode_cs, fluid);
  //procs = ThermoSysPro.Properties.Fluid.Ph(Pcond + Cex.P)/2, (lsat.h + Cex.h)/2, modecs);

  Tec = proce.T;
  Tsc = procs.T;

  (lsat,vsat) = ThermoSysPro.Properties.Fluid.Water_sat_P(Pcond, fluid);

  if (p_rhoc > 0) then
    rho_ex = p_rhoc;
  else
    rho_ex = procs.d;
  end if;

  /* Fluid thermodynamic properties of the cold side */
  profe = ThermoSysPro.Properties.Fluid.Ph(Cee.P, Cee.h, mode_f, fluid_p);
  profs = ThermoSysPro.Properties.Fluid.Ph(Cse.P, Cse.h, mode_f, fluid_p);
  promf = ThermoSysPro.Properties.Fluid.Ph((Cee.P + Cse.P)/2, (Cee.h + Cse.h)/2, mode_f, fluid_p);

  Tef = profe.T;
  Tsf = profs.T;

  if (p_rhof > 0) then
    rhof = p_rhof;
  else
    rhof = promf.d;
  end if;

  /* Calculation of the heat exchange surface */
  S_ech1 = pi*D_tube1*L_tube1*nb_tube1;
  S_ech2 = pi*D_tube2*L_tube2*nb_tube2;
  S_ech3 = pi*D_tube3*L_tube3*nb_tube3;
  S_ech4 = pi*D_tube4*L_tube4*nb_tube4;
  S_ech5 = pi*D_tube5*L_tube5*nb_tube5;
  S_ech6 = pi*D_tube6*L_tube6*nb_tube6;
  S_ech = S_ech1 + S_ech2 + S_ech3 + S_ech4 + S_ech5 + S_ech6;

 /* Calculation of the passage section of the cold water */
  S_pass = (D_tube1/2 - e_tube1)^2*pi*nb_tube1/nb_pass + (D_tube2/2 - e_tube2)^2*pi*nb_tube2/nb_pass + (D_tube3/2 - e_tube3)^2*pi*nb_tube3/nb_pass + (D_tube4/2 - e_tube4)^2*pi*nb_tube4/nb_pass + (D_tube5/2 - e_tube5)^2*pi*nb_tube5/nb_pass +(D_tube6/2 - e_tube6)^2*pi*nb_tube6/nb_pass;

  /* Calculation of the velocity of the cold water */
  Vf = Qf/rhof/S_pass;

  /* Calculation of the correction factor for the water according to the HEI standard, 10th edition */
  Fw = -2.104072e-04*(Tef - 273.15)^2 + 1.974994e-02*(Tef - 273.15) + 6.639699e-01;

  /* Calculation of the weight average diameter of the tubes */
  D_tubes = (D_tube1*nb_tube1 + D_tube2*nb_tube2 + D_tube3*nb_tube3 + D_tube4*nb_tube4 + D_tube5*nb_tube5 + D_tube6*nb_tube6)/(nb_tube1 + nb_tube2 + nb_tube3 + nb_tube4 + nb_tube5 + nb_tube6);

  /* Calculation of the uncorrected heat transfert coefficient according to the HEI standard, 10th edition */
  U1 = ThermoSysPro.Correlations.Thermal.Function_U1(D_tubes, Vf);

  /* Calculation of the weight average thickness of the tubes */
  e_tubes = (e_tube1*nb_tube1 + e_tube2*nb_tube2 + e_tube3*nb_tube3 + e_tube4*nb_tube4 + e_tube5*nb_tube5 + e_tube6*nb_tube6)/(nb_tube1 + nb_tube2 + nb_tube3 + nb_tube4 + nb_tube5 + nb_tube6);

  /* Calculation of the correction factor for material and gauge according to the HEI standard, 10th edition */
  FM1 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube1, Tube_Material1);
  FM2 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube2, Tube_Material2);
  FM3 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube3, Tube_Material3);
  FM4 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube4, Tube_Material4);
  FM5 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube5, Tube_Material5);
  FM6 = ThermoSysPro.Correlations.Misc.Function_FM(e_tube6, Tube_Material6);
  FM = (FM1*S_ech1 + FM2*S_ech2 + FM3*S_ech3 + FM4*S_ech4 + FM5*S_ech5 + FM6*S_ech6)/S_ech;

  /* Calculation of the heat transfert coefficient according to the HEI standard, 10th edition */
  U = Ucorr*U1*FM*FC*Fw;

  /* Calculation of the average specific heat capacity of the cold water */
  Cpmf = promf.cp;

  /* Calculation of the expected HEI saturation temperature  */
  Tsat_att = Tef + (W/(Qf*Cpmf))*(1/(1 - Modelica.Math.exp(-(U*S_ech)/(Qf*Cpmf))));

  /* Calculation of expected HEI saturation pressure  */
  Psat_att = ThermoSysPro.Properties.Fluid.P_sat(Tsat_att, fluid);

  /* Calculation of the HEI pressure cut-off */
  Pcut_off = (5.752433E-04*(Tef-273.15)^3 + 1.735162E-02*(Tef-273.15)^2 + 8.052739E-02*(Tef-273.15) + 2.109159E+01)*100;

  /* Calculation of the HEI saturation temperature at pressure cut-off  */
  Tcut_off = ThermoSysPro.Properties.Fluid.T_sat(Pcut_off, fluid);

  /* Calculation of HEI zero-load  pressure */
  Pzero_load = (5.008000E-04*(Tef - 273.15)^3 + 2.039549E-02*(Tef - 273.15)^2 + 2.277566E-01*(Tef - 273.15) + 1.027824E+01)*100;

  /* Calculation of power exchanged from the hot side to the cold side at Pcut_off */
  Tcut_off = Tef + (Wcut_off/(Qf*Cpmf))*(1/(1-Modelica.Math.exp(-(U*S_ech)/(Qf*Cpmf))));

  /* Calculation of the expected HEI corrected saturation pressure*/
  if (Psat_att < Pcut_off) then
    Pcond = (Pcut_off - Pzero_load)/Wcut_off*W + Pzero_load + Poffset;
  else
    Pcond = Psat_att + Poffset;
  end if;

  /* Calculation of the expected HEI corrected saturation pressure */
  Tsat = ThermoSysPro.Properties.Fluid.T_sat(Pcond, fluid);

  /* Calculation of the Terminal Temperature Difference */
  TTD = Tsat - Tsf;

  /* The standards HEI are not applicable if the terminal temperature difference is less than 2,78 K */
  if (TTD > 2.78) then
    HEI = 1;
  else
    HEI = 0;
  end if;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{100,-82},{100,80},{-100,80},{-100,-82},{100,-82}},
          lineColor={28,108,200},
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-22,88},{20,70}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Turbine outlet"),
        Text(
          extent={{-82,24},{-52,16}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Drain inlet"),
        Text(
          extent={{-24,-52},{26,-72}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Extraction water"),
        Text(
          extent={{38,-58},{86,-66}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Cooling water outlet"),
        Text(
          extent={{-86,-52},{-32,-74}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Cooling water inlet"),
        Text(
          extent={{-86,66},{-50,54}},
          lineColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0},
          textString=
               "Vapor inlet"),
        Line(
          points={{0,8},{0,-70}},
          color={0,0,0},
          thickness=1),
        Polygon(
          points={{0,-90},{-11,-70},{11,-70},{0,-90}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0}),
        Line(
          points={{-100,8},{100,8}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-100,-14},{80,-14},{80,-20},{-90,-20},{-90,-26},{80,-26},{80,
              -32},{-90,-32},{-90,-38},{100,-38}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-80,60},{72,12}},
          lineColor={28,108,200},
          textString="HEI")}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Polygon(
          points={{100,-86},{100,100},{-100,100},{-100,-86},{100,-86}},
          lineColor={0,0,0},
          fillColor= DynamicSelect({255,255,0},
          if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=FillPattern.Solid,
                    lineThickness=0),
        Line(
          points={{-100,-14},{80,-14},{80,-20},{-90,-20},{-90,-26},{80,-26},{80,
              -32},{-90,-32},{-90,-38},{100,-38}},
          color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{0,-86},{-11,-66},{11,-66},{0,-86}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillPattern=FillPattern.Sphere,
          fillColor={191,0,0}),
        Line(
          points={{0,8},{0,-66}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-100,8},{100,8}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-78,74},{74,26}},
          lineColor={28,108,200},
          textString="HEI")}),
    Window(
      x=0.09,
      y=0.08,
      width=0.76,
      height=0.76),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>",
   revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>"));
end StaticCondenserHEI;
