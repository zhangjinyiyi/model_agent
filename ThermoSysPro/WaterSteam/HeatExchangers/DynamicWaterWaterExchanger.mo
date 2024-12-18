﻿within ThermoSysPro.WaterSteam.HeatExchangers;
model DynamicWaterWaterExchanger "Dynamic plate heat exchanger"
  parameter Units.SI.ThermalConductivity lambdam=15.0
    "Metal thermal conductivity";
  parameter Units.SI.CoefficientOfHeatTransfer p_hc=6000
    "Heat transfer coefficient for the hot side if not computed by the correlations";
  parameter Units.SI.CoefficientOfHeatTransfer p_hf=3000
    "Heat transfer coefficient for the cold side if not computed by the correlations";
  parameter Real p_Kc=100
    "Pressure loss coefficient for the hot side if not computed by the correlations";
  parameter Real p_Kf=100
    "Pressure loss coefficient for the cold side if not computed by the correlations";
  parameter Units.SI.Volume Vc=1 "Hot side volume";
  parameter Units.SI.Volume Vf=1 "Cold side volume";
  parameter Units.SI.Thickness emetal=0.0006 "Wall thickness";
  parameter Units.SI.Area Sp=2 "Plate area";
  parameter Real nbp=499 "Number of plates";
  parameter Real c1=1.12647 "Correction coefficient";
  parameter Integer N=10 "Number of segments";
  parameter Boolean steady_state=true "true: start from steady state";
  parameter Units.SI.Density p_rhoc=0
    "If > 0, fixed fluid density for the hot fluid";
  parameter Units.SI.Density p_rhof=0
    "If > 0, fixed fluid density for the cold fluid";
  parameter Integer modec=0
    "IF97 region for the hot fluid. 1:liquid - 2:steam - 4:saturation line - 0:automatic";
  parameter Integer modef=0
    "IF97 region for the cold fluid. 1:liquid - 2:steam - 4:saturation line - 0:automatic";

  parameter Integer heat_exchange_correlation=1
    "Correlation for the computation of the heat exchange coefficient - 0: no correlation. 1: SRI correlations";
  parameter Integer pressure_loss_correlation=1
    "Correlation for the computation of the pressure loss coefficient - 0: no correlation. 1: SRI correlations";

public
  Units.SI.Power dW[N] "Thermal power exchanged between the two sides";
  ThermoSysPro.Units.SI.PressureDifference DPc[N]
    "Pressure loss of the hot fluid";
  ThermoSysPro.Units.SI.PressureDifference DPf[N]
    "Pressure loss of the cold fluid";
  Units.SI.CoefficientOfHeatTransfer hc[N]
    "Heat transfer coefficient of the hot fluid";
  Units.SI.CoefficientOfHeatTransfer hf[N]
    "Heat transfer coefficient of the cold fluid";
  Units.SI.CoefficientOfHeatTransfer K[N] "Global heat transfer coefficient";
  Units.SI.Area dS "Heat exchange surface";
  Units.SI.Temperature Tec "Fluid temperature at the hot inlet";
  Units.SI.Temperature Tsc "Fluid temperature at the hot outlet";
  Units.SI.Temperature Tef "Fluid temperature at the cold inlet";
  Units.SI.Temperature Tsf "Fluid temperature at the cold outlet";
  Units.SI.AbsolutePressure Pcc[N + 1]
    "Hot fluid pressure at the boundary of section i";
  Units.SI.MassFlowRate Qcc[N + 1]
    "Hot fluid mass flow rate at the boundary of section i";
  Units.SI.SpecificEnthalpy Hcc[N + 1]
    "Hot fluid specific enthalpy at the boundary of section i";
  Units.SI.AbsolutePressure Pcf[N + 1]
    "Cold fluid pressure at the boundary of section i";
  Units.SI.MassFlowRate Qcf[N + 1]
    "Cold fluid mass flow rate at the boundary of section i";
  Units.SI.SpecificEnthalpy Hcf[N + 1]
    "Cold fluid specific enthalpy at the boundary of section i";
  Units.SI.MassFlowRate Qc[N](start=fill(500, N))
    "Mass flow rate of the hot fluid";
  Units.SI.MassFlowRate Qf[N](start=fill(500, N))
    "Mass flow rate of the cold fluid";
  Real qmc[N];
  Real qmf[N];
  Real quc[N];
  Real quf[N];
  Real M;
  Units.SI.Density rhoc[N](start=fill(998, N)) "Hot fluid density";
  Units.SI.Density rhof[N](start=fill(998, N)) "Cold fluid density";
  Units.SI.DynamicViscosity muc[N](start=fill(1.e-3, N))
    "Hot fluid dynamic viscosity";
  Units.SI.DynamicViscosity muf[N](start=fill(1.e-3, N))
    "Cold fluid dynamic viscosity";
  Units.SI.ThermalConductivity lambdac[N](start=fill(0.602698, N))
    "Hot fluid thermal conductivity";
  Units.SI.ThermalConductivity lambdaf[N](start=fill(0.597928, N))
    "Cold fluid thermal conductivity";
  Units.SI.Temperature Tmc[N](start=fill(290, N))
    "Hot fluid average temperature";
  Units.SI.Temperature Tmf[N](start=fill(290, N))
    "Cold fluid average temperature";
  Units.SI.AbsolutePressure Pmc[N](start=fill(1.e5, N))
    "Hot fluid average pressure";
  Units.SI.AbsolutePressure Pmf[N](start=fill(1.e5, N))
    "Cold fluid average pressure";
  Units.SI.SpecificEnthalpy Hmc[N](start=fill(100000, N))
    "Hot fluid average specific enthalpy";
  Units.SI.SpecificEnthalpy Hmf[N](start=fill(100000, N))
    "Cold fluid average specific enthalpy";
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proc[
                                                              N]
    "Propriétés du fluide chaud" annotation (Placement(transformation(extent={{
            -60,-100},{-40,-80}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph prof[
                                                              N]
    "Propriétés du fluide froid" annotation (Placement(transformation(extent={{
            -100,-100},{-80,-80}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph proce
    "Propriétés du fluide chaud en entrée" annotation (Placement(transformation(
          extent={{-20,80},{0,100}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph procs
    "Propriétés du fluide chaud en sortie" annotation (Placement(transformation(
          extent={{20,80},{40,100}}, rotation=0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph profe
    "Propriétés du fluide froid en entrée"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}}, rotation=
           0)));
  ThermoSysPro.Properties.WaterSteam.Common.ThermoProperties_ph profs
    "Propriétés du fluide froid en sortie"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
public
  Connectors.FluidInlet Ec          annotation (Placement(transformation(extent=
           {{-110,-10},{-90,10}}, rotation=0)));
  Connectors.FluidInlet Ef          annotation (Placement(transformation(extent=
           {{-60,-70},{-40,-50}}, rotation=0)));
  Connectors.FluidOutlet Sf         annotation (Placement(transformation(extent=
           {{40,-70},{60,-50}}, rotation=0)));
  Connectors.FluidOutlet Sc         annotation (Placement(transformation(extent=
           {{90,-10},{110,10}}, rotation=0)));
initial equation
  if steady_state then
    for i in 1:N loop
      der(Hmc[i]) = 0;
      der(Hmf[i]) = 0;
    end for;
  else
    for i in 1:N loop
      Hmc[i] = if (Ec.Q >= 0) then Ec.h else Sc.h;
      Hmf[i] = if (Ef.Q >= 0) then Ef.h else Sf.h;
    end for;
  end if;

equation
  Ec.P = Pcc[1];
  Sc.P = Pcc[N + 1];
  Ec.Q = Qcc[1];
  Sc.Q = Qcc[N + 1];
  Ec.h = Hcc[1];
  Sc.h = Hcc[N + 1];

  Ef.P = Pcf[N + 1];
  Sf.P = Pcf[1];
  Ef.Q = Qcf[N + 1];
  Sf.Q = Qcf[1];
  Ef.h = Hcf[N + 1];
  Sf.h = Hcf[1];

  /* Flow reversal */
  0 = if (Ec.Q > 0) then Ec.h - Ec.h_vol else Sc.h - Sc.h_vol;
  0 = if (Ef.Q > 0) then Ef.h - Ef.h_vol else Sf.h - Sf.h_vol;

  /* Exchange area for the plate exchanger */
  dS = (nbp - 2)*Sp/N;
  M = (nbp - 1)/2;

  for i in 1:N loop
    /* Mass flow rates */
    Qcc[i] = Qcc[i + 1];
    Qcf[i] = Qcf[i + 1];

    Qc[i] = Qcc[i];
    Qf[i] = Qcf[i];

    /* Pressure losses */
    Pcc[i + 1] = if (Qc[i] > 0) then Pcc[i] - DPc[i]/N else Pcc[i] + DPc[i]/N;
    Pcf[i + 1] = if (Qf[i] > 0) then Pcf[i] + DPf[i]/N else Pcf[i] - DPf[i]/N;

    /* Heat transfer */
    /* K = 1/(1/hc + 1/hf + emetal/lambdam) */
    K[i] = hc[i]*hf[i]/(hc[i] + hf[i] + hc[i]*hf[i]*emetal/lambdam);
    dW[i] = K[i]*dS*(Tmc[i] - Tmf[i]);

    Vc/N*rhoc[i]*der(Hmc[i]) = Qcc[i]*Hcc[i] - Qcc[i + 1]*Hcc[i + 1] - dW[i];

    Vf/N*rhof[i]*der(Hmf[i]) = -Qcf[i]*Hcf[i] + Qcf[i + 1]*Hcf[i + 1] + dW[i];

    /* Heat trasnfer correlations */
    qmc[i] = noEvent(abs(Qc[i])/(max(ThermoSysPro.Properties.WaterSteam.InitLimits.ETAMIN, muc[i])*M));
    qmf[i] = noEvent(abs(Qf[i])/(max(ThermoSysPro.Properties.WaterSteam.InitLimits.ETAMIN, muf[i])*M));

    if (heat_exchange_correlation == 0) then
      hc[i] = p_hc;
      hf[i] = p_hf;
    elseif (heat_exchange_correlation == 1) then
      hc[i] = noEvent(if (qmc[i] < 1.e-3) then 0 else 11.245*abs(qmc[i])^0.8*
        abs(muc[i]*proc[i].cp/lambdac[i])^0.4*lambdac[i]);
      hf[i] = noEvent(if (qmf[i] < 1.e-3) then 0 else 11.245*abs(qmf[i])^0.8*
        abs(muf[i]*prof[i].cp/lambdaf[i])^0.4*lambdaf[i]);
    else
      hc[i] = 0;
      hf[i] = 0;
      assert(false,
        "DynamicWaterWaterExchanger: incorrect heat exchange correlation number");
    end if;

    /* Pressure losses correlations */
    quc[i] = noEvent(abs(Qc[i])/M);
    quf[i] = noEvent(abs(Qf[i])/M);

    if (pressure_loss_correlation == 0) then
      DPc[i] = p_Kc*Qc[i]^2/rhoc[i];
      DPf[i] = p_Kf*Qf[i]^2/rhof[i];
    elseif (pressure_loss_correlation == 1) then
      DPc[i] = noEvent(if (qmc[i] < 1.e-3) then 0 else c1*14423.2/rhoc[i]*abs(
        qmc[i])^(-0.097)*quc[i]^2*(1472.47 + 1.54*(M - 1)/2 + 104.97*abs(qmc[i])
        ^(-0.25)));
      DPf[i] = noEvent(if (qmf[i] < 1.e-3) then 0 else 14423.2/rhof[i]*abs(qmf[
        i])^(-0.097)*quf[i]^2*(1472.47 + 1.54*(M - 1)/2 + 104.97*abs(qmf[i])^(-0.25)));
    else
      DPc[i] = 0;
      DPf[i] = 0;
      assert(false,
        "DynamicWaterWaterExchanger: incorrect pressure loss correlation number");
    end if;

    /* Fluid thermodynamic properties */
    Pmc[i] = (Pcc[i] + Pcc[i + 1])/2;
    Pmf[i] = (Pcf[i] + Pcf[i + 1])/2;
    Hmc[i] = (Hcc[i] + Hcc[i + 1])/2;
    Hmf[i] = (Hcf[i] + Hcf[i + 1])/2;

    proc[i] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Pmc[i], Hmc[i], modec);
    prof[i] = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Pmf[i], Hmf[i], modef);

    Tmc[i] = proc[i].T;
    Tmf[i] = prof[i].T;

    if (p_rhoc > 0) then
      rhoc[i] = p_rhoc;
    else
      rhoc[i] = proc[i].d;
    end if;

    if (p_rhof > 0) then
      rhof[i] = p_rhof;
    else
      rhof[i] = prof[i].d;
    end if;

    muc[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhoc[i], Tmc[i]);
    muf[i] = ThermoSysPro.Properties.WaterSteam.IF97.DynamicViscosity_rhoT(rhof[i], Tmf[i]);

    lambdac[i] = ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhoc[i], Tmc[i], Pmc[i]);
    lambdaf[i] = ThermoSysPro.Properties.WaterSteam.IF97.ThermalConductivity_rhoT(rhof[i], Tmf[i], Pmf[i]);
  end for;

  /* Fluid temperatures at the inlet and the outlet of the exchanger */
  proce = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Ec.P, Ec.h, modec);
  procs = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Sc.P, Sc.h, modec);

  profe = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Ef.P, Ef.h, modef);
  profs = ThermoSysPro.Properties.WaterSteam.IF97.Water_Ph(Sf.P, Sf.h, modef);

  Tec = proce.T;
  Tsc = procs.T;
  Tef = profe.T;
  Tsf = profs.T;

  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillColor={127,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,60},{-80,-60}}),
        Line(points={{80,60},{80,-60}}),
        Line(points={{-80,0},{-60,0},{-40,20},{40,-20},{60,0},{80,0}}, color={0,
              0,255}),
        Line(
          points={{-40,60},{-40,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot),
        Line(
          points={{0,60},{0,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot),
        Line(
          points={{40,60},{40,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,255},
          fillColor={127,255,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,60},{-80,-60}}),
        Line(points={{80,60},{80,-60}}),
        Line(points={{-80,0},{-60,0},{-40,20},{40,-20},{60,0},{80,0}}, color={0,
              0,255}),
        Line(
          points={{-40,60},{-40,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot),
        Line(
          points={{0,60},{0,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot),
        Line(
          points={{40,60},{40,-60}},
          color={0,0,255},
          pattern=LinePattern.Dot)}),
    Window(
      x=0.04,
      y=0.05,
      width=0.93,
      height=0.91),
    Documentation(info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</h4>
<p><b>ThermoSysPro Version 4.0</h4>
<p>This component model is documented in Sect. 9.6.1 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </h4>
</html>",
   revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Daniel Bouskela </li>
</ul>
</html>"));
end DynamicWaterWaterExchanger;
