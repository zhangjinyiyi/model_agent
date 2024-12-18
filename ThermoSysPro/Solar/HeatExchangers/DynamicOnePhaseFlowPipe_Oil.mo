﻿within ThermoSysPro.Solar.HeatExchangers;
model DynamicOnePhaseFlowPipe_Oil "Dynamic one-phase flow pipe Oil"
  parameter Units.SI.Length L=10. "Pipe length";
  parameter Units.SI.Diameter D=0.2 "Internal pipe diameter";
  parameter Real rugosrel=0.0007 "Pipe relative roughness";
  parameter Integer ntubes=1 "Number of pipes in parallel";
  parameter Units.SI.Position z1=0 "Pipe inlet altitude";
  parameter Units.SI.Position z2=0 "Pipe outlet altitude";
  parameter Real dpfCorr=1.00
    "Corrective term for the friction pressure loss (dpf) for each node";
  parameter Real hcCorr=1.00
    "Corrective term for the heat exchange coefficient (hc) for each node";
  parameter Integer Ns=10 "Number of segments";
  parameter Units.SI.Temperature T0[Ns]=fill(290, Ns)
    "Initial fluid temperature (active if steady_state = false and option_temperature = 1)";
  parameter Units.SI.SpecificEnthalpy h0[Ns]=fill(1e5, Ns)
    "Initial fluid specific enthalpy (active if steady_state = false and option_temperature = 2)";
 // parameter Boolean inertia=true
 //   "true: momentum balance equation with inertia - false: without inertia";
  parameter Boolean advection=false
    "true: momentum balance equation with advection terme - false: without advection terme";
 // parameter Boolean dynamic_mass_balance=true
 //   "true: dynamic mass balance equation - false: static mass balance equation";

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

public
  Units.SI.AbsolutePressure P[N + 1](start=fill(1.e5, N + 1), nominal=fill(1.e5,
        N + 1)) "Fluid pressure in node i";
  Units.SI.MassFlowRate Q[N](start=fill(10, N), nominal=fill(10, N))
    "Mass flow rate in node i";
  Units.SI.SpecificEnthalpy h[N + 1](start=fill(1.e5, N + 1), nominal=fill(1.e6,
        N + 1)) "Fluid specific enthalpy in node i";
  Units.SI.SpecificEnthalpy hb[N]
    "Fluid specific enthalpy at the boundary of node i";
  Units.SI.Density rho1[N - 1](start=fill(998, N - 1), nominal=fill(1, N - 1))
    "Fluid density in thermal node i";
  Units.SI.Density rho2[N](start=fill(998, N), nominal=fill(1, N))
    "Fluid density in hydraulic node i";
  Units.SI.Density rhoc[N + 1](start=fill(998, N + 1), nominal=fill(1, N + 1))
    "Fluid density at the boudary of node i";
  Units.SI.Power dW1[N - 1](start=fill(3.e5, N - 1), nominal=fill(3.e5, N - 1))
    "Thermal power exchanged on the water side for node i";
  Units.SI.Power W1t "Total power exchanged on the water side";
  Units.SI.Temperature Tp[N - 1](start=T0) "Wall temperature in node i";
  Units.SI.CoefficientOfHeatTransfer hc[N - 1](start=fill(2000, N - 1), nominal=
       fill(200, N - 1)) "Fluid heat exchange coefficient in node i";
  Units.SI.ReynoldsNumber Re1[N - 1](start=fill(6.e4, N - 1), nominal=fill(
        0.5e4, N - 1)) "Fluid Reynolds number in thermal node i";
  Units.SI.ReynoldsNumber Re2[N](start=fill(6.e4, N), nominal=fill(0.5e4, N))
    "Fluid Reynolds number in hydraulic node i";
  Real Pr[N - 1](start=fill(4, N - 1), nominal=fill(1, N - 1))
    "Fluid Prandtl number in node i";
  Units.SI.ThermalConductivity k[N - 1](start=fill(0.6, N - 1), nominal=fill(
        0.6, N - 1)) "Fluid thermal conductivity in node i";
  Units.SI.DynamicViscosity mu1[N - 1](start=fill(2.e-4, N - 1), nominal=fill(
        2.e-4, N - 1)) "Fluid dynamic viscosity in thermal node i";
  Units.SI.DynamicViscosity mu2[N](start=fill(2.e-4, N), nominal=fill(2.e-4, N))
    "Fluid dynamic viscosity in hydraulic node i";
  Units.SI.SpecificHeatCapacity cp[N - 1](start=fill(4000, N - 1), nominal=fill(
        4000, N - 1)) "Fluid specific heat capacity";
  Units.SI.Temperature T1[N - 1] "Fluid temperature in thermal node i";
  Units.SI.Temperature T2[N] "Fluid temperature in hydraulic node i";
  ThermoSysPro.Units.SI.PressureDifference dpa[N]
    "Advection term for the mass balance equation in node i";
  ThermoSysPro.Units.SI.PressureDifference dpf[N]
    "Friction pressure loss in node i";
  ThermoSysPro.Units.SI.PressureDifference dpg[N]
    "Gravity pressure loss in node i";
  Real khi[N] "Hydraulic pressure loss coefficient in node i";
  Real lambda[N](start=fill(0.03, N), nominal=fill(0.03, N))
    "Friction pressure loss coefficient in node i";
  Units.SI.Area Stot "Internal heat exchange area";

public
  WaterSteam.Connectors.FluidInlet C1
                                    annotation (Placement(transformation(extent=
           {{-110,-10},{-90,10}}, rotation=0)));
  WaterSteam.Connectors.FluidOutlet C2
                                    annotation (Placement(transformation(extent=
           {{90,-10},{110,10}}, rotation=0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort CTh[Ns]
    annotation (Placement(transformation(extent={{-10,20},{10,40}}, rotation=0)));
initial equation
  if steady_state then
    for i in 2:N loop
      der(h[i]) = 0;
    end for;
  else
    Tp = T0;

    if (option_temperature == 1) then
      for i in 2:N loop
//EEEEEEEEEreur
        //h[i] = ThermoSysPro.Properties.WaterSteam.IF97.SpecificEnthalpy_PT(P[i], T0[i - 1], mode);
        h[i] = ThermoSysPro.Properties.Oil_TherminolVP1.Enthalpy_T( T0[i - 1]);
      end for;
    elseif (option_temperature == 2) then
      for i in 2:N loop
        h[i] = h0[i - 1];
      end for;
    else
      assert(false, "DynamicOnePhaseFlowPipe: incorrect option");
    end if;
  end if;

//  if dynamic_mass_balance then
//    for i in 2:N loop
//      der(P[i]) = 0;
//    end for;
//  end if;

//  if inertia then
//    if dynamic_mass_balance then
//      for i in 1:N loop
//        der(Q[i]) = 0;
//      end for;
//    else
//      der(Q[1]) = 0;
//    end if;
//  end if;

equation

  /* Wall temperature */
  Tp = CTh.T;
  CTh.W = dW1;

  /* Pipe boundaries */
  P[1] = C1.P;
  P[N + 1] = C2.P;

  Q[1] = C1.Q;
  Q[N] = C2.Q;

  hb[1] = C1.h;
  hb[N] = C2.h;

  h[1] = C1.h_vol;
  h[N + 1] = C2.h_vol;

  /* Mass and energy balance equations (thermal nodes) */
  for i in 1:N - 1 loop
    /* Mass balance equation */
//    if dynamic_mass_balance then
//      A*(pro1[i].ddph*der(P[i + 1]) + pro1[i].ddhp*der(h[i + 1]))*dx1 = Q[i] - Q[i + 1];
//    else
      0 = Q[i] - Q[i + 1];
//    end if;

    /* Energy balance equation */
//    if dynamic_mass_balance then
//      A*(-der(P[i + 1]) + rho1[i]*der(h[i + 1]))*dx1 = hb[i]*Q[i] - hb[i + 1]*Q[i + 1] + dW1[i];
//    else
      A*rho1[i]*der(h[i + 1])*dx1 = hb[i]*Q[i] - hb[i + 1]*Q[i + 1] + dW1[i];
//    end if;

    /* Heat transfer at the wall */
    dW1[i] = hc[i]*dSi*(Tp[i] - T1[i]);

    /* Fluid thermodynamic properties */
    T1[i] = ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(h[i + 1]);
    rho1[i] = ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(T1[i]);
    cp[i] =ThermoSysPro.Properties.Oil_TherminolVP1.SpecificHeatCp_T( T1[i]);
    mu1[i] = ThermoSysPro.Properties.Oil_TherminolVP1.DynamicViscosity_T(T1[i]);
    k[i] = ThermoSysPro.Properties.Oil_TherminolVP1.ThermalConductivity_T(T1[i]);

    /* Heat exchange coefficient (using the Dittus-Boelter correlation) */
    //hc[i] = noEvent(if ((Re1[i] > 1.e-6) and (Pr[i] > 1.e-6)) then hcCorr*0.023*k[i]/D*Re1[i]^0.8*Pr[i]^0.4 else 0);
    if noEvent( Re1[i] > 2000) then
      hc[i] = noEvent(if (Pr[i] > 1.e-6) then hcCorr*0.023*k[i]/D*Re1[i]^0.8*Pr[i]^0.4 else 200);
    else
      // Lévêque equation
      hc[i] = hcCorr*3.66*k[i]/D;
    end if;

    Pr[i] = mu1[i]*cp[i]/k[i];
    Re1[i] = noEvent(abs(4*(Q[i] + Q[i + 1])/2/(pi*Di*mu1[i])));

  end for;

  /* Momentum balance equations (hydraulic nodes) */
  for i in 1:N loop
    /* Flow reversal */
    if continuous_flow_reversal then
      0 = noEvent(if (Q[i] > Qeps) then hb[i] - h[i] else if (Q[i] < -Qeps) then
        hb[i] - h[i + 1] else hb[i] - 0.5*((h[i] - h[i + 1])*Modelica.Math.sin(pi
        *Q[i]/2/Qeps) + h[i + 1] + h[i]));
    else
      0 = if (Q[i] > 0) then hb[i] - h[i] else hb[i] - h[i + 1];
    end if;

    /* Momentum balance equation */
//    if inertia then
//      1/A*der(Q[i])*dx2 = P[i] - P[i + 1] - dpf[i] - dpg[i] - dpa[i];
//    else
      P[i] - P[i + 1] - dpf[i] - dpg[i] - dpa[i] = 0;
//    end if;

    /* Advection term */
    if advection then
      dpa[i] = noEvent(Q[i]*abs(Q[i])*(1/rhoc[i + 1] - 1/rhoc[i])/A^2);
    else
      dpa[i] = 0;
    end if;

    /* Gravity pressure losses */
    dpg[i] = rho2[i]*g*(z2 - z1)*dx2/L;

    /* Friction pressure losses */
    dpf[i] = noEvent(dpfCorr*khi[i]*Q[i]*abs(Q[i])/(2*A^2*rho2[i]));

    khi[i] = lambda[i]*dx2/D;

    lambda[i] = if noEvent(Re2[i] > 1) then 0.25*(Modelica.Math.log10(13/Re2[i] + rugosrel/3.7/D))^(-2) else 0.01;

    Re2[i] = noEvent(abs(4*Q[i]/(pi*Di*mu2[i])));

    /* Fluid thermodynamic properties */
    T2[i] = ThermoSysPro.Properties.Oil_TherminolVP1.Temperature_h(hb[i]);
    rho2[i] = ThermoSysPro.Properties.Oil_TherminolVP1.Density_T(T2[i]);
    mu2[i] = ThermoSysPro.Properties.Oil_TherminolVP1.DynamicViscosity_T(T2[i]);

  end for;

  /* Fluid densities at the boundaries of the nodes */
  for i in 2:N loop
    rhoc[i] = rho1[i - 1];
  end for;

  //proc[1] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P[1], h[1], mode);
  //proc[2] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(P[N + 1],h[N + 1], mode);
  //rhoc[1] = proc[1].d;
  //rhoc[N + 1] = proc[2].d;

  rhoc[1] = rho1[1];
  rhoc[N + 1] = rhoc[N];

  W1t = sum(dW1);

  Stot = dSi*Ns;

  annotation (
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-60,20},{-60,-20}}),
        Line(points={{-20,20},{-20,-20}}),
        Line(points={{20,20},{20,-20}}),
        Line(points={{60,20},{60,-20}}),
        Line(points={{-60,20},{-60,-20}}),
        Line(points={{-20,20},{-20,-20}}),
        Line(points={{20,20},{20,-20}}),
        Line(points={{60,20},{60,-20}}),
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={28,108,200},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{60,20},{60,-20}}, color={255,255,255}),
        Line(points={{20,20},{20,-20}}, color={255,255,255}),
        Line(points={{-20,20},{-20,-20}}, color={255,255,255}),
        Line(points={{-60,20},{-60,-20}}, color={255,255,255})}),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,20},{-60,-20}}, color={255,255,255}),
        Line(points={{-20,20},{-20,-20}}, color={255,255,255}),
        Line(points={{20,20},{20,-20}}, color={255,255,255}),
        Line(points={{60,20},{60,-20}}, color={255,255,255})}),
    Window(
      x=0.18,
      y=0.05,
      width=0.68,
      height=0.94),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2012</h4></p>
<p><b>ThermoSysPro Version 3.1</h4>
</html>",
   revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>"));
end DynamicOnePhaseFlowPipe_Oil;
