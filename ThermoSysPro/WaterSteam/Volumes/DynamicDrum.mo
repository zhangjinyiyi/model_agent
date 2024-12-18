﻿within ThermoSysPro.WaterSteam.Volumes;
model DynamicDrum "Dynamic drum"
  parameter Boolean Vertical=true
    "true: vertical cylinder - false: horizontal cylinder";
  parameter Units.SI.Radius R=1.05 "Radius of the drum cross-sectional area";
  parameter Units.SI.Length L=16.27 "Drum length";
  parameter Real Vf0=0.5
    "Fraction of initial water volume in the drum (active if steady_state=false)";
  parameter Units.SI.AbsolutePressure P0=50.e5
    "Fluid initial pressure (active if steady_state=false)";
  parameter Real Ccond=0.01 "Condensation coefficient";
  parameter Real Cevap=0.09 "Evaporation coefficient";
  parameter Real Xlo=0.0025
    "Vapor mass fraction in the liquid phase from which the liquid starts to evaporate";
  parameter Real Xvo=0.9975
    "Vapor mass fraction in the gas phase from which the liquid starts to condensate";
  parameter Real Kvl=1000
    "Heat exchange coefficient between the liquid and gas phases";
  parameter Units.SI.CoefficientOfHeatTransfer Klp=400
    "Heat exchange coefficient between the liquid phase and the wall";
  parameter Units.SI.CoefficientOfHeatTransfer Kvp=100
    "Heat exchange coefficient between the gas phase and the wall";
  parameter Units.SI.CoefficientOfHeatTransfer Kpa=25
    "Heat exchange coefficient between the wall and the outside";
  parameter Units.SI.Mass Mp=117e3 "Wall mass";
  parameter Units.SI.SpecificHeatCapacity cpp=600 "Wall specific heat";
  parameter Boolean steady_state=true
    "true: start from steady state - false: start from (P0, Vf0)";

protected
  constant Real pi=Modelica.Constants.pi "pi";
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Units.SI.Volume V=pi*R^2*L "Drum volume";
  parameter Units.SI.Volume Vmin=1.e-6;

public
  Units.SI.AbsolutePressure P "Fluid average pressure";
  Units.SI.AbsolutePressure Pfond "Fluid pressure at the bottom of the drum";
  Units.SI.SpecificEnthalpy hl "Liquid phase specific enthalpy";
  Units.SI.SpecificEnthalpy hv "Gas phase specific enthalpy";
  Units.SI.Temperature Tl "Liquid phase temperature";
  Units.SI.Temperature Tv "Gas phase temperature";
  Units.SI.Temperature Tp(start=550) "Wall temperature";
  Units.SI.Temperature Ta "External temperature";
  Units.SI.Volume Vl "Liquid phase volume";
  Units.SI.Volume Vv "Gas phase volume";
  Units.SI.Area Alp "Liquid phase surface on contact with the wall";
  Units.SI.Area Avp "Gas phase surface on contact with the wall";
  Units.SI.Area Ape "Wall surface on contact with the outside";
  Real xl(start=0.5) "Mass vapor fraction in the liquid phase";
  Real xv(start=0) "Mass vapor fraction in the vapor phase";
  Real xmv(start=0.5) "Mass vapor fraction in the ascending tube";
  Units.SI.Density rhol(start=996) "Liquid phase density";
  Units.SI.Density rhov(start=1.5) "Gas phase density";
  Units.SI.MassFlowRate BQl
    "Right hand side of the mass balance equation of the liquid phase";
  Units.SI.MassFlowRate BQv
    "Right hand side of the mass balance equation of the gas phase";
  Units.SI.Power BHl
    "Right hand side of the energy balance equation of the liquid phase";
  Units.SI.Power BHv
    "Right hand side of the energy balance equation of the gas phase";
  Units.SI.MassFlowRate Qcond
    "Condensation mass flow rate from the vapor phase";
  Units.SI.MassFlowRate Qevap
    "Evaporation mass flow rate from the liquid phase";
  Units.SI.MassFlowRate Qv "Steam mass flow rate from the riser";
  Units.SI.Power Wlv
    "Thermal power exchanged from the gas phase to the liquid phase";
  Units.SI.Power Wpl
    "Thermal power exchanged from the liquid phase to the wall";
  Units.SI.Power Wpv "Thermal power exchanged from the gas phase to the wall";
  Units.SI.Power Wpa "Thermal power exchanged from the outside to the wall";
  Units.SI.Position zl(start=1.05) "Liquid level in drum";
  Units.SI.Area Al "Cross sectional area of the liquid phase";
  Units.SI.Angle theta "Angle";
  Units.SI.Area Avl(start=1.0)
    "Heat exchange surface between the liquid and gas phases";

  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prol
    "Propriétés de l'eau dans le ballon" annotation (Placement(transformation(
          extent={{-60,40},{-20,80}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prov
    "Propriétés de la vapeur dans le ballon" annotation (Placement(
        transformation(extent={{0,40},{40,80}}, rotation=0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prom
    annotation (Placement(transformation(extent={{-60,-20},{-20,20}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat
    annotation (Placement(transformation(extent={{-60,-80},{-20,-40}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat
                                           annotation (Placement(transformation(
          extent={{0,-80},{40,-40}}, rotation=0)));
  Connectors.FluidInlet Ce1 "Feedwater input 1"
                                    annotation (Placement(transformation(extent=
           {{-110,90},{-90,110}}, rotation=0)));
  Connectors.FluidInlet Cm "Evaporation loop outlet"
                                    annotation (Placement(transformation(extent=
           {{90,-110},{110,-90}}, rotation=0)));
  Connectors.FluidOutlet Cd "Evaporation loop inlet"
                                    annotation (Placement(transformation(extent=
           {{-110,-110},{-90,-90}}, rotation=0)));
  Connectors.FluidOutlet Cv "Steam outlet"
                                    annotation (Placement(transformation(extent=
           {{90,90},{110,110}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal yLevel
    "Water level "
    annotation (                            layer="icon", Placement(
        transformation(extent={{100,-10},{120,10}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort Cth "Thermal input to the liquid"
                                     annotation (Placement(transformation(
          extent={{-10,-60},{10,-40}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort Cex "Thermal input to the wall"
                           annotation (Placement(transformation(extent={{-10,90},
            {10,110}}, rotation=0)));
public
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prod
    annotation (Placement(transformation(extent={{0,-20},{40,20}}, rotation=0)));
  Connectors.FluidInlet Ce2 "Feedwater input 2"
                                    annotation (Placement(transformation(extent=
           {{-110,30},{-90,50}}, rotation=0)));
  Connectors.FluidInlet Ce3 "Feedwater input 3"
                                    annotation (Placement(transformation(extent=
           {{-110,-50},{-90,-30}}, rotation=0)));
  Connectors.FluidOutlet Cs "Water outlet"
                                    annotation (Placement(transformation(extent=
           {{90,-50},{110,-30}}, rotation=0)));
initial equation
  if steady_state then
    der(hl) = 0;
    der(hv) = 0;
    der(P) = 0;
    der(Vl) = 0;
    der(Tp) = 0;
  else
    hl = lsat.h;
    hv = vsat.h;
    P = P0;
    Vl = Vf0*V;
    der(Tp) = 0;
  end if;

equation
  /* Unconnected connectors */
  if (cardinality(Ce1) == 0) then
    Ce1.Q = 0;
    Ce1.h = 1.e5;
    Ce1.b = true;
  end if;

  if (cardinality(Ce2) == 0) then
    Ce2.Q = 0;
    Ce2.h = 1.e5;
    Ce2.b = true;
  end if;

  if (cardinality(Ce3) == 0) then
    Ce3.Q = 0;
    Ce3.h = 1.e5;
    Ce3.b = true;
  end if;

  if (cardinality(Cd) == 0) then
    Cd.Q = 0;
    Cd.h = 1.e5;
    Cd.a = true;
  end if;

  if (cardinality(Cs) == 0) then
    Cs.Q = 0;
    Cs.h = 1.e5;
    Cs.a = true;
  end if;

  if (cardinality(Cm) == 0) then
    Cm.Q = 0;
    Cm.h = 1.e5;
    Cm.b = true;
  end if;

  if (cardinality(Cv) == 0) then
    Cv.Q = 0;
    Cv.h = 1.e5;
    Cv.a = true;
  end if;

  Ce1.P = P;
  Ce2.P = P;
  Ce3.P = P;
  Cv.P = P;
  Cd.P = Pfond;
  Cs.P = P;
  Cm.P = P;

  /* Liquid volume */
  if Vertical then
     theta = 1;
     Al = pi*R^2;
     Vl = Al*zl;
     Avl = Al;
  else
     theta = Modelica.Math.asin(max(-0.9999,min(0.9999,(R - zl)/R)));
     Al = (pi/2 - theta)*R^2 - R*(R - zl)*Modelica.Math.cos(theta);
     Vl = Al*L;
     Avl = 2*R*Modelica.Math.cos(theta)*L;
  end if;

  /* Drum volume */
  Vl + Vv = V;

  /* Liquid level */
  yLevel.signal = zl;

  /* Liquid surface and vapor surface on contact with wall */
  Alp = if Vertical then 2*pi*R*zl + Al else (pi - 2*theta)*R*L + 2*Al;
  Avp = if Vertical then 2*pi*R*(L - zl) + Al else (pi + 2*theta)*R*L + 2*Al;

  /* Wall surface on contact with the outside */
  Ape = Alp + Avp;

  /* Pressure at the bottom of the drum */
  Pfond = P + prod.d*g*zl;

  /* Liquid phase mass balance equation */
  BQl = Ce1.Q + Ce2.Q + Ce3.Q - Cd.Q - Cs.Q + (1 - xmv)*Cm.Q + Qcond - Qevap;
  rhol*der(Vl) + Vl*(prol.ddph*der(P) + prol.ddhp*der(hl)) = BQl;

  /* Gas phase mass balance equation */
  BQv = xmv*Cm.Q - Cv.Q + Qevap - Qcond;
  rhov*der(Vv) + Vv*(prov.ddph*der(P) + prov.ddhp*der(hv)) = BQv;

  /* Liquid phase energy balance equation */
  BHl = Ce1.Q*(Ce1.h - (hl - P/rhol)) + Ce2.Q*(Ce2.h - (hl - P/rhol)) + Ce3.Q*(Ce3.h - (hl - P/rhol))
    - Cd.Q*(Cd.h - (hl - P/rhol)) - Cs.Q*(Cs.h - (hl - P/rhol))
    + (1 - xmv)*Cm.Q*((if (xmv > 0) then lsat.h else Cm.h) - (hl - P/rhol))
    + Qcond*(lsat.h - (hl - P/rhol)) - Qevap*(vsat.h - (hl - P/rhol)) + Wlv - Wpl + Cth.W;

  Vl*((P/rhol*prol.ddph - 1)*der(P) + (P/rhol*prol.ddhp + rhol)*der(hl)) = BHl;

  Ce1.h_vol = hl;
  Ce2.h_vol = hl;
  Ce3.h_vol = hl;
  Cd.h_vol = noEvent(min(lsat.h, hl));
  Cs.h_vol = hl;

  /* Gas phase energy balance equation */
  BHv = xmv*Cm.Q*((if (xmv < 1) then vsat.h else Cm.h) - (hv - P/rhov))
     - Cv.Q*(Cv.h - (hv - P/rhov)) + Qevap*(vsat.h - (hv - P/rhov)) - Qcond*(lsat.h - (hv - P/rhov))
     - Wlv - Wpv;

  Vv*((P/rhov*prov.ddph - 1)*der(P) + (P/rhov*prov.ddhp + rhov)*der(hv)) = BHv;

  Cm.h_vol = hl;
  Cv.h_vol = hv;

  /* Energy balance equation at the wall */
  Mp*cpp*der(Tp) = Wpl + Wpv + Wpa;

  /* Heat exchange between liquid and gas phases */
  Wlv = Kvl*Avl*(Tv - Tl);

  /* Heat exchange between the liquid phase and the wall */
  Wpl = Klp*Alp*(Tl - Tp);

  /* Heat exchange between the gas phase and the wall */
  Wpv = Kvp*Avp*(Tv - Tp);

  /* Heat exchange between the wall and the outside */
  Wpa = Kpa*Ape*(Ta - Tp);

  /* Condensation and evaporation mass flow rates */
  Qcond = if noEvent(xv < Xvo) then Ccond*rhov*Vv*(Xvo - xv) else 0;
  Qevap = if noEvent(xl > Xlo) then Cevap*rhol*Vl*(xl - Xlo) else 0;

  /* Fluid thermodynamic properties */
  prol = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P, hl);
  prov = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P, hv);
  prod = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Pfond, Cd.h);
  prom = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P, Cm.h);
  (lsat,vsat) = ThermoSysPro.Properties.WaterSteam.IF97.Water_sat_P(P);

  Tl = prol.T;
  rhol = prol.d;
  xl = prol.x;

  Tv = prov.T;
  rhov = prov.d;
  xv = prov.x;

  xmv = if noEvent(Cm.Q > 0) then prom.x else 0;
  Qv = Cm.Q*xmv;

  Cth.T = Tl;
  Cex.T = Ta;
  Cex.W = Wpa;
  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-90,100},{-68,100},{-60,80}}),
        Line(points={{-90,-100},{-68,-100},{-60,-80}}),
        Line(points={{62,80},{70,100},{90,100}}),
        Polygon(
          points={{0,100},{-20,98},{-40,92},{-60,80},{-80,60},{-92,40},{-98,20},
              {-100,0},{-98,-20},{98,-20},{100,0},{98,20},{92,40},{80,60},{60,
              80},{40,92},{20,98},{0,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(points={{60,-80},{72,-100},{90,-100}}),
        Polygon(
          points={{0,100},{-20,98},{-40,92},{-60,80},{-80,60},{-92,40},{-98,20},
              {-100,0},{-98,-20},{98,-20},{100,0},{98,20},{92,40},{80,60},{60,
              80},{40,92},{20,98},{0,100}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Window(
      x=0.16,
      y=0.04,
      width=0.78,
      height=0.88),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2013</b> </p>
<p><b>ThermoSysPro Version 3.1</h4>
<p>This component model is documented in Sect. 14.2 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </h4>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Daniel Bouskela</li>
<li>Baligh El Hefni </li>
</ul>
</html>"));
end DynamicDrum;
