﻿within ThermoSysPro.WaterSteam.HeatExchangers;
model DynamicTwoPhaseFlowRiser "Riser: Dynamic two-phase flow pipe"
  parameter Units.SI.Length L=10. "Pipe length";
  parameter Units.SI.Diameter D=0.02 "Hydraulic diameter";
  parameter Units.SI.Length rugosrel=0.0007 "Pipe relative roughness";
  parameter Integer ntubes=1 "Number of pipes in parallel";
  parameter Units.SI.Position z1=0 "Pipe inlet altitude";
  parameter Units.SI.Position z2=0 "Pipe outlet altitude";
  parameter Real rgliss=1 "Phase slip coefficient";
  parameter Integer a=4200 "Phase pressure loss coefficient";
  parameter Real dpfCorr=1.00
    "Corrective term for the friction pressure loss (dpf) for each node";
  parameter Real hcCorr=1.00
    "Corrective term for the heat exchange coefficient (hc) for each node";
  parameter Integer Ns=10 "Number of segments";
  parameter Units.SI.Temperature T0[Ns]=fill(300, Ns)
    "Initial fluid temperature (active if steady_state = false and option_temperature = 1)"
    annotation (Evaluate=false);
  parameter Units.SI.SpecificEnthalpy h0[Ns]=fill(1e5, Ns)
    "Initial fluid specific enthalpy (active if steady_state = false and option_temperature = 2)";
  parameter Boolean inertia=true
    "true: momentum balance equation with inertia - false: without inertia";
  parameter Boolean advection=false
    "true: momentum balance equation with advection terme - false: without advection terme";
  parameter Boolean dynamic_mass_balance=true
    "true: dynamic mass balance equation - false: static mass balance equation";
  parameter Boolean simplified_dynamic_energy_balance=true
    "true: simplified dynamic energy balance equation - false: full dynamic energy balance equation (active if dynamic_mass_balance=true)";
  parameter Boolean steady_state=true
    "true: start from steady state - false: start from T0 (if option_temperature=1) or h0 (if option_temperature=2)";
  parameter Integer option_temperature=1
    "1:initial temperature is fixed - 2:initial specific enthalpy is fixed (active if steady_state = false)";
  parameter Boolean continuous_flow_reversal=true
    "true: continuous flow reversal - false: discontinuous flow reversal";
   parameter Integer mode=0
    "IF97 region. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

protected
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  constant Real pi=Modelica.Constants.pi "pi";
  parameter Real eps=1.e-0 "Small number for pressure loss equation";
  parameter Units.SI.MassFlowRate Qeps=1.e-3
    "Small mass flow rate for continuous flow reversal";
  parameter Integer N=Ns + 1
    "Number of hydraulic nodes (= number of thermal nodes + 1)";
  parameter Units.SI.Area A=ntubes*pi*D^2/4
    "Internal cross sectional pipe area";
  parameter Units.SI.Diameter Di=ntubes*D "Internal pipe diameter";
  parameter Units.SI.PathLength dx1=L/(N - 1) "Length of a thermal node";
  parameter Units.SI.PathLength dx2=L/N "Length of a hydraulic node";
  parameter Units.SI.Area dSi=pi*Di*dx1
    "Internal heat exchange area for a node";
  parameter Real Mmol=18.015 "Water molar mass";
  parameter Units.SI.AbsolutePressure pcrit=ThermoSysPro.Properties.WaterSteam.BaseIF97.data.PCRIT
    "Critical pressure";
  parameter Units.SI.Temperature Tcrit=ThermoSysPro.Properties.WaterSteam.BaseIF97.data.TCRIT
    "Critical temperature";
  parameter Units.SI.AbsolutePressure ptriple=ThermoSysPro.Properties.WaterSteam.BaseIF97.triple.ptriple
    "Triple point pressure";
  parameter Real xb1=0.0002 "Min value for vapor mass fraction";
  parameter Real xb2=0.85 "Max value for vapor mass fraction";

public
  Units.SI.AbsolutePressure P[N + 1](start=fill(1.e5, N + 1), nominal=fill(1.e5,
        N + 1)) "Fluid pressure in node i";
  Units.SI.MassFlowRate Q[N](start=fill(10, N), nominal=fill(10, N))
    "Mass flow rate in node i";
  Units.SI.SpecificEnthalpy h[N + 1](start=fill(1.e5, N + 1), nominal=fill(1.e6,
        N + 1)) "Fluid specific enthalpy in node i";
  Units.SI.SpecificEnthalpy hb[N]
    "Fluid specific enthalpy at the boundary of node i";
  Units.SI.AbsolutePressure Pb[N + 1](start=fill(1.e5, N + 1), nominal=fill(
        1.e5, N + 1)) "Bounded fluid pressure in node i";
  Units.SI.Density rho1[N - 1](start=fill(998, N - 1), nominal=fill(1, N - 1))
    "Fluid density in thermal node i";
  Units.SI.Density rho2[N](start=fill(998, N), nominal=fill(1, N))
    "Fluid density in hydraulic node i";
  Units.SI.Density rhoc[N + 1](start=fill(998, N + 1), nominal=fill(1, N + 1))
    "Fluid density at the boudary of node i";
  Units.SI.Power dW1[N - 1](start=fill(3.e5, N - 1), nominal=fill(3.e5, N - 1))
    "Thermal power exchanged on the liquid side for node i";
  Units.SI.Power dW2[N - 1](start=fill(3.e5, N - 1), nominal=fill(3.e5, N - 1))
    "Thermal power exchanged on the liquid side for node i";
  Units.SI.Power W1t "Total power exchanged on the liquid side";
  Units.SI.Temperature Tp1[N - 1](each start=500.0)
    "Wall temperature in node i";
  Units.SI.Temperature Tp2[N - 1](each start=500.0)
    "Wall temperature in node i";
  Units.SI.CoefficientOfHeatTransfer hi[N - 1](start=fill(2000, N - 1), nominal=
       fill(2.e4, N - 1)) "Fluid heat exchange coefficient in node i";
  Units.SI.CoefficientOfHeatTransfer hcl[N - 1](start=fill(2000, N - 1),
      nominal=fill(200, N - 1))
    "Fluid heat exchange coefficient in node i for the liquid fraction";
  Units.SI.CoefficientOfHeatTransfer hcv[N - 1](start=fill(0, N - 1), nominal=
        fill(200, N - 1))
    "Fluid heat exchange coefficient in node i for the vapor fraction";
  Real S[N - 1] "Corrective terme correctif for nucleation removal";
  Real E[N - 1] "Corrective term for hcl";
  Units.SI.CoefficientOfHeatTransfer heb[N - 1](start=fill(0, N - 1), nominal=
        fill(5.e5, N - 1))
    "Fluid heat exchange coefficient for vaporization in thermal node i";
  Units.SI.ReynoldsNumber Rel1[N - 1](start=fill(6.e4, N - 1), nominal=fill(
        0.5e4, N - 1)) "Reynolds number in thermal node i for the liquid";
  Units.SI.ReynoldsNumber Rel2[N](start=fill(6.e4, N), nominal=fill(0.5e4, N))
    "Reynolds number in hydraulic node i for the liquid";
  Units.SI.ReynoldsNumber Rev1[N - 1](start=fill(0.1e4, N - 1), nominal=fill(
        5.e5, N - 1)) "Reynolds number in thermal node i for the vapor";
  Units.SI.ReynoldsNumber Rev2[N](start=fill(0.1e4, N), nominal=fill(5.e5, N))
    "Reynolds number in hydraulic node i for the vapor";
  Real Prl[N - 1](start=fill(4, N - 1), nominal=fill(1, N - 1))
    "Fluid Prandtl number in node i for the liquid";
  Real Prv[N - 1](start=fill(1, N - 1), nominal=fill(1, N - 1))
    "Fluid Prandtl number in node i for the vapor";
  Units.SI.ThermalConductivity kl[N - 1](start=fill(0.6, N - 1), nominal=fill(
        0.6, N - 1)) "Thermal conductivity in node i for the liquid";
  Units.SI.ThermalConductivity kv[N - 1](start=fill(0.03, N - 1), nominal=fill(
        0.03, N - 1)) "Thermal conductivity in node i for the vapor";
  Real xv1[N - 1] "Vapor mass fraction in thermal node i";
  Real xv2[N] "Vapor mass fraction in hydraulic node i";
  Real xbs[N - 1] "Bounded upper value for the vapor mass fraction";
  Real xbi[N - 1] "Bounded lower value for the vapor mass fraction";
  Units.SI.DynamicViscosity mul1[N - 1](start=fill(2.e-4, N - 1), nominal=fill(
        2.e-4, N - 1)) "Dynamic viscosity in thermal node i for the liquid";
  Units.SI.DynamicViscosity mul2[N](start=fill(2.e-4, N), nominal=fill(2.e-4, N))
    "Dynamic viscosity in hydraulic node i for the liquid";
  Units.SI.DynamicViscosity muv1[N - 1](start=fill(1.e-5, N - 1), nominal=fill(
        1.e-4, N - 1)) "Dynamic viscosity in thermal node i for the vapor";
  Units.SI.DynamicViscosity muv2[N](start=fill(1.e-5, N), nominal=fill(1.e-4, N))
    "Dynamic viscosity in hydraulic node i for the vapor";
  Units.SI.SpecificHeatCapacity cpl[N - 1](start=fill(4000, N - 1), nominal=
        fill(4000, N - 1)) "Specific heat capacity for the liquid";
  Units.SI.SpecificHeatCapacity cpv[N - 1](start=fill(2000, N - 1), nominal=
        fill(2000, N - 1)) "Specific heat capacity for the vapor";
  Real Bo[N - 1](start=fill(0, N - 1), nominal=fill(4.e-4, N - 1))
    "Boiling number";
  Real Xtt[N - 1](start=fill(1, N - 1), nominal=fill(1, N - 1))
    "Martinelli number";
  Units.SI.SpecificEnthalpy lv[N - 1](start=fill(2.e6, N - 1), nominal=fill(
        2.e6, N - 1)) "Specific enthalpy for vaporisation";
  Units.SI.Density rhol1[N - 1](start=fill(998, N - 1), nominal=fill(998, N - 1))
    "Fluid density in thermal node i for the liquid";
  Units.SI.Density rhol2[N](start=fill(998, N), nominal=fill(998, N))
    "Fluid density in hydraulic node i for the liquid";
  Units.SI.Density rhov1[N - 1](start=fill(1, N - 1), nominal=fill(1, N - 1))
    "Fluid density in thermal node i for the vapor";
  Units.SI.Density rhov2[N](start=fill(1, N), nominal=fill(1, N))
    "Fluid density in hydraulic node i for the vapor";
  Units.SI.Temperature T1[N - 1] "Fluid temperature in thermal node i";
  Units.SI.Temperature T2[N] "Fluid temperature in hydraulic node i";
  ThermoSysPro.Units.SI.PressureDifference dpa[N]
    "Advection term for the mass balance equation in node i";
  ThermoSysPro.Units.SI.PressureDifference dpf[N]
    "Friction pressure loss in node i";
  ThermoSysPro.Units.SI.PressureDifference dpg[N]
    "Gravity pressure loss in node i";
  Real khi[N] "Hydraulic pressure loss coefficient in node i";
  Real lambdal[N](start=fill(0.03, N), nominal=fill(0.03, N))
    "Friction pressure loss coefficient in node i for the liquid";
  Real lambdav[N](start=fill(0.03, N), nominal=fill(0.03, N))
    "Friction pressure loss coefficient in node i for the vapor)";
  Real filo[N] "Pressure loss coefficient for two-phase flow";
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro1[
                                                              N - 1]
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proc[
                                                              2]
    annotation (Placement(transformation(extent={{80,80},{100,100}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph pro2[
                                                              N]
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat2[
                                                         N]
    annotation (Placement(transformation(extent={{80,-100},{100,-80}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat2[
                                                         N]
    annotation (Placement(transformation(extent={{40,-100},{60,-80}}, rotation=
            0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat vsat1[
                                                         N - 1]
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}},
          rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.PropThermoSat lsat1[
                                                         N - 1]
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}},
          rotation=0)));
public
  Connectors.FluidInlet C1          annotation (Placement(transformation(extent=
           {{-110,0},{-90,20}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort CTh1[Ns]
    annotation (Placement(transformation(extent={{-10,60},{10,80}}, rotation=0)));
  Connectors.FluidOutlet C2         annotation (Placement(transformation(extent=
           {{90,0},{110,20}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort CTh2[Ns]
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}}, rotation=
            0)));
initial equation
  if steady_state then
    for i in 2:N loop
      der(h[i]) = 0;
    end for;
  else
    if (option_temperature == 1) then
      for i in 2:N loop
        h[i] = ThermoSysPro.Properties.WaterSteam.IF97.SpecificEnthalpy_PT(Pb[i], T0[i - 1], mode);
      end for;
    elseif (option_temperature == 2) then
      for i in 2:N loop
        h[i] = h0[i - 1];
      end for;
    else
      assert(false, "DynamicTwoPhaseFlowPipe: incorrect option");
    end if;
  end if;

  if dynamic_mass_balance then
    for i in 2:N loop
      der(P[i]) = 0;
    end for;
  end if;

  if inertia then
    if dynamic_mass_balance then
      for i in 1:N loop
        der(Q[i]) = 0;
      end for;
    else
      der(Q[1]) = 0;
    end if;
  end if;

equation

  /* Wall temperature */
  Tp1 = CTh1.T;
  CTh1.W = dW1;

  Tp2 = CTh2.T;
  CTh2.W = dW2;

  /* Pipe boundaries */
  P[1] = C1.P;
  P[N + 1] = C2.P;

  Q[1] = C1.Q;
  Q[N] = C2.Q;

  hb[1] = C1.h;
  hb[N] = C2.h;

  h[1] = C1.h_vol;
  h[N + 1] = C2.h_vol;

  Pb[1] = max(min(P[1], pcrit - 1), ptriple);
  Pb[N + 1] = max(min(P[N + 1], pcrit - 1), ptriple);

  /* Mass and energy balance equations (thermal nodes) */
  for i in 1:N - 1 loop
    /* Mass balance equation */
    if dynamic_mass_balance then
      A*(pro1[i].ddph*der(P[i + 1]) + pro1[i].ddhp*der(h[i + 1]))*dx1 = Q[i] - Q[i + 1];
    else
      0 = Q[i] - Q[i + 1];
    end if;

    /* Energy balance equation */
    if dynamic_mass_balance then
      if simplified_dynamic_energy_balance then
        A*(-der(P[i + 1]) + rho1[i]*der(h[i + 1]))*dx1 = hb[i]*Q[i] - hb[i + 1]*Q[i + 1] + dW1[i] + dW2[i];
      else
        A*((h[i + 1]*pro1[i].ddph - 1)*der(P[i + 1]) + (h[i + 1]*pro1[i].ddhp + rho1[i])*der(h[i + 1]))*dx1 = hb[i]*Q[i] - hb[i + 1]*Q[i + 1] + dW1[i] + dW2[i];
      end if;
    else
      A*rho1[i]*der(h[i + 1])*dx1 = hb[i]*Q[i] - hb[i + 1]*Q[i + 1] + dW1[i] + dW2[i];
    end if;

    /* Heat transfer at the wall */
    dW1[i] = hcCorr*hi[i]*dSi*(Tp1[i] - T1[i]);
    dW2[i] = hcCorr*hi[i]*dSi*(Tp2[i] - T1[i]);

    //*** Calcul de la corrélation d'échange thermique
    // Corrélation de Thom
    //hi_1[i] =  max(1970*exp(P[i + 1]/43.5e5)*(Tp1[i] - Tsat[i]), 5000);
    //hi_2[i] =  max(1970*exp(P[i + 1]/43.5e5)*(Tp2[i] - Tsat[i]), 5000);

    if noEvent(xv1[i] < xb1) then
      hi[i] = if noEvent((P[i+1] > pcrit) or (T1[i] > Tcrit)) then hcl[i] else (1 - xv1[i]/xb1)*hcl[i] + xv1[i]/xb1*(E[i]*hcl[i] + S[i]*heb[i]);
      Xtt[i] = ((1 - xb1)/xb1)^0.9*(rhov1[i]/rhol1[i])^0.5*(mul1[i]/muv1[i])^
        0.1;
    elseif noEvent(xv1[i] > xb2) then
      hi[i] = (xv1[i] - xb2)/(1 - xb2)*hcv[i] + (1 - xv1[i])/(1 - xb2)*(E[i]*
        hcl[i] + S[i]*heb[i]);
      Xtt[i] = ((1 - xb2)/xb2)^0.9*(rhov1[i]/rhol1[i])^0.5*(mul1[i]/muv1[i])^
        0.1;
    else
      hi[i] = E[i]*hcl[i] + S[i]*heb[i];
      Xtt[i] = ((1 - xv1[i])/xv1[i])^0.9*(rhov1[i]/rhol1[i])^0.5*(mul1[i]/muv1[
        i])^0.1;
    end if;

    E[i] = if noEvent(Bo[i] > 0) then 1 + 24000*Bo[i]^1.16 + 1.37*Xtt[i]^(-0.86) else 1;

    Bo[i] = noEvent(if (abs((Q[i] + Q[i + 1])/2) > 1.e-3) then abs(dW1[i]*D/(4
      *(Q[i] + Q[i + 1])/2*lv[i]*dx1)) else 1.e-5);

    S[i] = noEvent(if (Rel1[i] > 1.e-6) then 1/(1 + 1.15e-6*E[i]^2*Rel1[i]^1.17) else 0);

    heb[i] = noEvent(if (Pb[i] > 1) then 55*(abs(Pb[i])/pcrit)^0.12*(-
      Modelica.Math.log10(abs(Pb[i])/pcrit))^(-0.55)*Mmol^(-0.5)*(abs(dW1[i])/dSi)
      ^0.67 else 100);

    hcl[i] = noEvent(if ((Rel1[i] > 1.e-6) and (Prl[i] > 1.e-6)) then 0.023*kl[
      i]/D*Rel1[i]^0.8*Prl[i]^0.4 else 0);

    hcv[i] = noEvent(if ((Rev1[i] > 1.e-6) and (Prv[i] > 1.e-6)) then 0.023*kv[
      i]/D*Rev1[i]^0.8*Prv[i]^0.4 else 0);

    Prl[i] = mul1[i]*cpl[i]/kl[i];
    Prv[i] = muv1[i]*cpv[i]/kv[i];

    Rel1[i] = noEvent(abs(4*(Q[i] + Q[i + 1])/2*(1 - xbs[i])/(pi*Di*mul1[i])));
    Rev1[i] = noEvent(abs(4*(Q[i] + Q[i + 1])/2*xbi[i]/(pi*Di*muv1[i])));

    /* Fluid thermodynamic properties */
    pro1[i] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P[i + 1], h[i + 1]);

    rho1[i] = pro1[i].d;
    T1[i] = pro1[i].T;
    xv1[i] = if noEvent((P[i+1] > pcrit) or (T1[i] > Tcrit)) then 1 else pro1[i].x;

    (lsat1[i],vsat1[i]) = ThermoSysPro.Properties.WaterSteam.IF97.Water_sat_P(P[i + 1]);

    if noEvent((P[i+1] > pcrit) or (T1[i] > Tcrit)) then
      xbs[i]   = 0;
      xbi[i]   = 1;
      rhol1[i] = pro1[i].d;
      rhov1[i] = pro1[i].d;
      cpl[i]   = pro1[i].cp;
      cpv[i]   = pro1[i].cp;
      lv[i]    = 1;
    else
      xbs[i]   = min(pro1[i].x, 0.90);
      xbi[i]   = max(pro1[i].x, 0.10);
      rhol1[i] = max(pro1[i].d, lsat1[i].rho);
      rhov1[i] = min(pro1[i].d, vsat1[i].rho);
      cpl[i]   = if noEvent(xv1[i] <= 0.0) then pro1[i].cp else lsat1[i].cp;
      cpv[i]   = if noEvent(xv1[i] >= 1.0) then pro1[i].cp else vsat1[i].cp;
      lv[i]    = vsat1[i].h - lsat1[i].h;
    end if;

    mul1[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhol1[i], T1[i]);
    muv1[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhov1[i], T1[i]);

    kl[i] = ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhol1[i], T1[i], P[i + 1]);
    kv[i] = ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhov1[i], T1[i], P[i + 1]);

    Pb[i + 1] = max(min(P[i + 1], pcrit - 1), ptriple);

  end for;

  /* Momentum balance equations (hydraulic nodes) */
  for i in 1:N loop
    /* Flow reversal */
    if continuous_flow_reversal then
      0 = noEvent(if (Q[i] > Qeps) then hb[i] - h[i] else if (Q[i] < -Qeps) then
              hb[i] - h[i + 1] else hb[i] - 0.5*((h[i] - h[i + 1])*
        Modelica.Math.sin(pi*Q[i]/2/Qeps) + h[i + 1] + h[i]));
    else
      0 = if (Q[i] > 0) then hb[i] - h[i] else hb[i] - h[i + 1];
    end if;

    /* Momentum balance equation */
    if inertia then
      1/A*der(Q[i])*dx2 = P[i] - P[i + 1] - dpf[i] - dpg[i] - dpa[i];
    else
      P[i] - P[i + 1] - dpf[i] - dpg[i] - dpa[i] = 0;
    end if;

    /* Advection term */
    if advection then
      dpa[i] = Q[i]^2*(1/rhoc[i + 1] - 1/rhoc[i])/A^2;
    else
      dpa[i] = 0;
    end if;

    /* Gravity pressure losses */
    dpg[i] = rho2[i]*g*(z2 - z1)*dx2/L;

    /* Friction pressure losses */
    dpf[i] = noEvent(dpfCorr*khi[i]*Q[i]*abs(Q[i])/(2*A^2*rhol2[i]));

    khi[i] = filo[i]*lambdal[i]*dx2/D;

    lambdal[i] = if noEvent(Rel2[i] > 1) then 0.25*(Modelica.Math.log10(13/Rel2[i] + rugosrel/3.7/D))^(-2) else 0.01;
    lambdav[i] = if noEvent(Rev2[i] > 1) then 0.25*(Modelica.Math.log10(13/Rev2[i] + rugosrel/3.7/D))^(-2) else 0.01;

    Rel2[i] = noEvent(abs(4*Q[i]/(pi*Di*mul2[i])));
    Rev2[i] = noEvent(abs(4*Q[i]/(pi*Di*muv2[i])));

    if noEvent(xv2[i] < 0) then
      filo[i] = 1;
    else
      if noEvent((xv2[i] >= 0) and (xv2[i] < 0.8)) then
        filo[i] = 1 + a*xv2[i]*rgliss/(19 + Pb[i]*1.e-5)/exp(Pb[i]*1.e-5/84);
      else
        filo[i] = (1 - xv2[i]*rgliss)/0.2*(1 + a*xv2[i]*rgliss/(19 + Pb[i]*1.e-5)
        /exp(Pb[i]*1.e-5/84)) + (xv2[i]*rgliss - 0.8)/0.2*rhol2[i]/rhov2[i]*lambdav[i]/lambdal[i];
      end if;
    end if;

    /* Fluid thermodynamic properties */
    pro2[i] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph((P[i] + P[i + 1])/2, hb[i]);

    rho2[i] = pro2[i].d;
    xv2[i] = if noEvent(((P[i] + P[i + 1])/2 > pcrit) or (T2[i] > Tcrit)) then 1 else pro2[i].x;
    T2[i] = pro2[i].T;

    (lsat2[i],vsat2[i]) = ThermoSysPro.Properties.WaterSteam.IF97.Water_sat_P((P[i] + P[i + 1])/2);

    rhol2[i] = if noEvent((P[i+1] > pcrit) or (T2[i] > Tcrit)) then pro2[i].d else max(pro2[i].d, lsat2[i].rho);
    rhov2[i] = if noEvent((P[i+1] > pcrit) or (T2[i] > Tcrit)) then pro2[i].d else min(pro2[i].d, vsat2[i].rho);

    mul2[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhol2[i], T2[i]);
    muv2[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhov2[i], T2[i]);

  end for;

  /* Fluid densities at the boundaries of the nodes */
  for i in 2:N loop
    rhoc[i] = rho1[i - 1];
  end for;

  proc[1] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P[1], h[1]);
  proc[2] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P[N + 1], h[N + 1]);

  rhoc[1] = proc[1].d;
  rhoc[N + 1] = proc[2].d;

  W1t = sum(dW1);

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,-20},{100,-40}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,0},{100,-20}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{-60,-40}}),
        Line(points={{-20,0},{-20,-40}}),
        Line(points={{20,0},{20,-40}}),
        Line(points={{60,0},{60,-40}}),
        Rectangle(
          extent={{-100,60},{100,40}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,40},{100,20}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,0}},
          lineColor={28,108,200},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,60},{-60,20}}),
        Line(points={{-20,60},{-20,20}}),
        Line(points={{20,60},{20,20}}),
        Line(points={{60,60},{60,20}})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,0},{100,-20}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-20},{100,-40}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,0},{-60,-40}}),
        Line(points={{-20,0},{-20,-40}}),
        Line(points={{20,0},{20,-40}}),
        Line(points={{60,0},{60,-40}}),
        Rectangle(
          extent={{-100,60},{100,40}},
          lineColor={28,108,200},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,40},{100,20}},
          lineColor={28,108,200},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,0}},
          lineColor={28,108,200},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,60},{-60,20}}),
        Line(points={{-20,60},{-20,20}}),
        Line(points={{20,60},{20,20}}),
        Line(points={{60,60},{60,20}})}),
    Window(
      x=0.16,
      y=0.07,
      width=0.71,
      height=0.85),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2019</b> </p>
<p><b>ThermoSysPro Version 3.2</h4>
</html>",
   revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Baligh El Hefni</li>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end DynamicTwoPhaseFlowRiser;
