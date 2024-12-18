﻿within ThermoSysPro.HeatNetworksCooling;
model LatentHeatStorage "Latent heat storage"
  parameter Units.SI.Area S=1 "Exchange surface";
  parameter Units.SI.Area Samb=1 "Exchange surface with the ambient air";
  parameter Units.SI.Volume V=1 "Storage volume";
  parameter Units.SI.SpecificHeatCapacity CpL=4.18
    "Fluid specific heat capacity";
  parameter Units.SI.SpecificHeatCapacity CpS=4.18
    "Storage specific heat capacity";
  parameter Units.SI.ThermalConductivity Lambda=0.585
    "PCM (phase change material) thermal conductivity";
  parameter Units.SI.ThermalConductivity LambdaC=0.585
    "Insulation thermal conductivity";
  parameter Units.SI.Length ep=0.1 "PCM thickness";
  parameter Units.SI.Length epC=0.1 "Insulation thickness";
  parameter Units.SI.Density rhom=1000 "PCM density";
  parameter Units.SI.CoefficientOfHeatTransfer h=20
    "Convective heat exchange coefficient with the water";
  parameter Units.SI.CoefficientOfHeatTransfer ha=20
    "Convective heat exchange coefficient with the ambient air";
  parameter Units.SI.Temperature Tamb "Ambient air temperature";
  parameter Units.SI.Temperature Tsl0
    "Initial storage temperature (active if steady_state=false)";
  parameter Real xL0=0.5 "Initial liquid PCM fraction";
  parameter Units.SI.Temperature Tfusion=293 "PCM fusion temperature";
  parameter Units.SI.SpecificEnergy hfus "PCM fusion specific enthalpy";
  parameter Real Fremp=0.5 "Volume fraction of the storage filled by the PCM";
  parameter Boolean steady_state=false
    "true: start from steady state - false: start from Tsl0";
  parameter Integer mode_e=0
    "IF97 region at the inlet. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  parameter Integer mode_s=0
    "IF97 region at the outlet. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

protected
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Units.SI.MassFlowRate Qeps=1.e-3
    "Small mass flow for continuous flow reversal";

public
  Units.SI.MassFlowRate Q "Water mass flow rate";
  Units.SI.Mass m "PCM mass";
  Units.SI.Temperature Tsl "Storage average temperature";
  Real xL "Liquid PCM fraction in the storage";
  Units.SI.Temperature T1 "Water temperature at the inlet";
  Units.SI.Temperature T2 "Water temperature at the outlet";
  Units.SI.Power Ws "Stored power";
  Units.SI.Power We "Power exchanged with the water";
  Units.SI.Power Wa "Power exchanged with the ambient air";
  Units.SI.SpecificEnthalpy Hsl "Storage specific enthalpy";
  Units.SI.SpecificEnthalpy HsatL
    "Storage specific enthalpy at the liquid saturation temperature";
  Units.SI.SpecificEnthalpy HsatS
    "Storage specific enthalpy at the solid saturation temperature";
  Units.SI.Temperature Tm(start=293) "Water average temperature";
  Units.SI.AbsolutePressure Pm(start=1.e5) "Water average pressure";
  Units.SI.SpecificEnthalpy hm(start=100000) "Water average specific enthalpy";
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proe
    "Propriétés de l'eau"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.WaterSteam.Connectors.FluidInlet Ce
                                     annotation (Placement(transformation(
          extent={{-100,20},{-80,40}}, rotation=0)));
  ThermoSysPro.WaterSteam.Connectors.FluidOutlet Cs
                                     annotation (Placement(transformation(
          extent={{80,-40},{100,-20}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pros
    "Propriétés de l'eau"
    annotation (Placement(transformation(extent={{80,80},{100,100}}, rotation=0)));
initial equation
  if steady_state then
    der(Hsl) = 0;
  else
    if (Tsl0 < Tfusion) then
      Hsl = CpS*(Tsl0 - 273);
    elseif (Tsl0 > Tfusion) then
      Hsl = CpS*(Tfusion - 273) + hfus + CpL * (Tsl0 - Tfusion);
    else
      Hsl = CpS*(Tfusion - 273) + hfus*xL0;
    end if;
  end if;

equation

  /* Unconnected connectors */
  if (cardinality(Ce) == 0) then
    Ce.Q = 0;
    Ce.h = 1.e5;
    Ce.b = true;
  end if;

  if (cardinality(Cs) == 0) then
    Cs.Q = 0;
    Cs.h = 1.e5;
    Cs.a = true;
  end if;

  Ce.P = Cs.P;
  Ce.Q = Cs.Q;

  Q = Ce.Q;

  /* Flow reversal */
  0 = noEvent(if (Q > Qeps) then Ce.h - Ce.h_vol else if (Q < -Qeps) then
      Cs.h - Cs.h_vol else Ce.h - 0.5*((Ce.h_vol - Cs.h_vol)*Modelica.Math.sin(pi
      *Q/2/Qeps) + Ce.h_vol + Cs.h_vol));

  /* Water average specific enthalpy */
  Pm = Ce.P;
  if (abs(Q) < Qeps) then
    Tm = T2;
  else
    Tm = (T1 + T2)/2;
  end if;

  hm = ThermoSysPro.Properties.WaterSteam.IF97.SpecificEnthalpy_PT(Pm, Tm, 0);

  /* Water temperature at the inlet and at the outlet */
  proe = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Ce.P, Ce.h, mode_e);
  pros = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Cs.P, Cs.h, mode_s);
  T1 = proe.T;
  T2 = pros.T;

  /* Liquid and solid specific enthalpies at the saturation point */
  HsatL = CpS*(Tfusion - 273) + hfus;
  HsatS = CpS*(Tfusion - 273);

  /* Storage differential equation */
  Ws = m*der(Hsl);
  Ws = We + Wa;

  /* PCM (phase change material) fraction */
  if (Hsl < HsatS) then
    xL = 0;
    Tsl = 273 + Hsl/CpS;
  elseif (Hsl > HsatL) then
    xL = 1;
    Tsl = Tfusion + (Hsl - HsatL)/CpL;
  else
    xL = (Hsl - HsatS)/(HsatL - HsatS);
    Tsl = Tfusion;
  end if;

  /* Power exchanged with the water */
  if (abs(Q) < Qeps) then
    We = 0;
    Tm = Tsl;
  else
    We = Q*(Ce.h - Cs.h);
    Tm = Tsl + We*(ep/Lambda + 1/h)/S;
  end if;

  /* Power exchanged with ambient air */
  Wa = 1/(epC/LambdaC + 1/ha)*Samb*(Tamb - Tsl);

  /* PCM mass */
  m = rhom*V*Fremp;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-80,50},{-40,100},{40,100},{80,52},{80,-50},{40,-100},{-40,
              -100},{-80,-48},{-80,50}},
          lineColor={0,0,0},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid,
          textString=
               "L")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Polygon(
          points={{-80,50},{-40,100},{40,100},{80,52},{80,-50},{40,-100},{-40,
              -100},{-80,-48},{-80,50}},
          lineColor={0,0,0},
          fillColor={120,255,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          textString=
               "L")}),
    Window(
      x=0.16,
      y=0.03,
      width=0.81,
      height=0.9),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</HTML>
", revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Beno&icirc;t Bride </li>
</ul>
</html>"));
end LatentHeatStorage;
