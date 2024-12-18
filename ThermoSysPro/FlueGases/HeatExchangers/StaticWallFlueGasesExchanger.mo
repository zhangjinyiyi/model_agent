within ThermoSysPro.FlueGases.HeatExchangers;
model StaticWallFlueGasesExchanger "Static wall/flue gases exchanger"
  parameter Integer Ns=1 "Number of segments";
  parameter Integer NbTub=100 "Number of pipes";
  parameter Real DPc=0 "Pressure loss coefficient";
  parameter Units.SI.Length L=2 "Exchanger length";
  parameter Units.SI.Diameter Dext=0.022 "External pipe diameter";
  parameter Units.SI.PathLength step_L=0.033 "Longitudinal length step";
  parameter Units.SI.PathLength step_T=0.066 "Transverse length step";
  parameter Units.SI.Area St=100 "Cross-sectional area";
  parameter Units.SI.Area Surf_ext=pi*Dext*Ls*NbTub*CSailettes
    "Heat exchange surface for one section";
  parameter Real Encras=1.00 "Corrective term for the heat exchange coefficient";
  parameter Real Fa=0.7 "Fouling factor (0.3 - 1.1)";
  parameter Units.SI.MassFlowRate Qmin=1e-3 "Minimum flue gases mass flow rate";
  parameter Integer exchanger_type=1
    "Exchanger type - 1:crossed flux - 2:longitudinal flux";
  parameter Units.SI.Temperature Tp0=500
    "Wall temperature (active if the thermal connector is not connected)";
  parameter Real CSailettes=1
    "Increase factor of the heat exchange surface to to the fins";
  parameter Real Coeff=1 "Corrective coeffeicient";
  parameter Units.SI.Density p_rho=0 "If > 0, fixed fluid density";

protected
  parameter Real eps=1.e-1
    "Small number for the computation of the pressure losses";
  constant Real Mco2=44.009 "CO2 molar mass";
  constant Real Mh2o=18.0148 "H2O molar mass";
  constant Real Mo2=31.998 "O2 molar mass";
  constant Real Mn2=28.014 "N2 molar mass";
  constant Real Mso2=64.063 "SO2 molar mass";
  constant Real pi=Modelica.Constants.pi;
  constant Units.SI.Acceleration g=Modelica.Constants.g_n "Gravity constant";
  parameter Units.SI.PathLength Ls=L/Ns "Section length";
  parameter Units.SI.Area Surf_tot=Ns*Surf_ext "Total heat exchange surface";
  parameter Units.SI.Area Sgaz=St*(1 - Dext/step_T) "Geometrical parameter";
  parameter Real PasLD=step_L/Dext "Geometrical parameter";
  parameter Real PasTD=step_T/Dext "Geometrical parameter";
  parameter Real Optl=ThermoSysPro.Correlations.Misc.WBCorrectiveDiameterCoefficient(PasTD,PasLD,Dext)
    "Geometrical parameter";
  parameter Units.SI.Length Deq=4*Sgaz/Perb
    "Equivalent diameter for longitudinal flux";
  parameter Units.SI.Length Perb=Surf_ext/Ls "Geometrical parameter";
  parameter Units.SI.CoefficientOfHeatTransfer Kdef=50
    "Heat exchange coefficient in case of zero flow";

public
  Units.SI.Density rho(start=1) "Flue gases density";
  Units.SI.Temperature T[Ns + 1](start=fill(900, Ns + 1))
    "Flue gases temperature at the inlet of section i";
  Units.SI.Temperature Tm[Ns](start=fill(900, Ns))
    "Average flue gases temperature in section i";
  Units.SI.SpecificEnthalpy h[Ns + 1](start=fill(1e6, Ns + 1))
    "Flue gases specific enthalpy at the inlet of section i";
  Units.SI.Temperature Tp[Ns](start=fill(500, Ns)) "Wall temperature";
  Units.SI.AbsolutePressure Pe(start=1e5)
    "Flue gases partial pressure at the inlet";
  Units.SI.AbsolutePressure Pco2 "CO2 partial pressure";
  Units.SI.AbsolutePressure Ph2o "H2O partial pressure";
  Real Xh2o "H2O mass fraction";
  Real Xco2 "CO2 mass fraction";
  Real Xn2 "N2 mass fraction";
  Real Xvh2o "H2O volume fraction";
  Real Xvco2 "CO2 volume fraction";
  Real Xvo2 "O2 volume fraction";
  Real Xvn2 "N2 volume fraction";
  Real Xvso2 "SO2 volume fraction";
  Units.SI.MassFlowRate Q(start=1) "Flue gases mass flow rate";
  Units.SI.CoefficientOfHeatTransfer K(start=0)
    "Total heat exchange coefficient";
  Units.SI.CoefficientOfHeatTransfer Kc(start=0)
    "Convective heat exchange coefficient";
  Units.SI.CoefficientOfHeatTransfer Kr(start=0)
    "Radiative heat exchange coefficient";
  Units.SI.CoefficientOfHeatTransfer Kcc[Ns](start=fill(0, Ns))
    "Intermedaite variable for the computation of the convective heat exchange coefficient";
  Units.SI.CoefficientOfHeatTransfer Krr[Ns](start=fill(0, Ns))
    "Intermedaite variable for the computation of the radiative heat exchange coefficient";
  Units.SI.Power dW[Ns](start=fill(0, Ns))
    "Power exchange between the wall and the fluid in each section";
  Units.SI.Power W(start=0) "Total power exchanged";
  ThermoSysPro.Units.SI.TemperatureDifference DeltaT[Ns](start=fill(50, Ns))
    "Temperature difference between the fluid and the wall";
  Units.SI.Temperature TFilm[Ns] "Film temperature";
  Real Mmt "Total flue gases molar mass";

public
  ThermoSysPro.FlueGases.Connectors.FlueGasesInlet C1
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  ThermoSysPro.Thermal.Connectors.ThermalPort CTh[Ns]
    annotation (Placement(transformation(extent={{-10,20},{10,40}}, rotation=0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutlet C2
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation

  /* Wall boundary */
  CTh.W = -dW;
  CTh.T = Tp;

  /* Pipe boundaries */
  C2.Q = C1.Q;

  Xh2o = C1.Xh2o;
  Xco2 = C1.Xco2;

  T[1] = C1.T;
  T[Ns+1] = C2.T;

  Pe = C1.P;
  Q = C1.Q;

  /* Flue gases composition */
  C2.Xco2 = C1.Xco2;
  C2.Xh2o = C1.Xh2o;
  C2.Xo2 = C1.Xo2;
  C2.Xso2 = C1.Xso2;
  Xn2 = 1 - C1.Xco2 - C1.Xh2o - C1.Xo2 - C1.Xso2;

  /* Volume fractions */
  Xvco2 = (C1.Xco2/Mco2)/(C1.Xco2/Mco2 + C1.Xh2o/Mh2o + C1.Xo2/Mo2 + Xn2/Mn2 + C1.Xso2/Mso2);
  Xvh2o = (C1.Xh2o/Mh2o)/(C1.Xco2/Mco2 + C1.Xh2o/Mh2o + C1.Xo2/Mo2 + Xn2/Mn2 + C1.Xso2/Mso2);
  Xvo2 = (C1.Xo2/Mo2)/(C1.Xco2/Mco2 + C1.Xh2o/Mh2o + C1.Xo2/Mo2 + Xn2/Mn2 + C1.Xso2/Mso2);
  Xvn2 = (Xn2/Mn2)/(C1.Xco2/Mco2 + C1.Xh2o/Mh2o + C1.Xo2/Mo2 + Xn2/Mn2 + C1.Xso2/Mso2);
  Xvso2 = (C1.Xso2/Mso2)/(C1.Xco2/Mco2 + C1.Xh2o/Mh2o + C1.Xo2/Mo2 + Xn2/Mn2 + C1.Xso2/Mso2);

  /* Total molar mass */
  Mmt = Xvco2*Mco2 + Xvh2o*Mh2o + Xvo2*Mo2 + Xvn2*Mn2 + Xvso2*Mso2;

  /* Partial gas pressures */
  Ph2o = Pe*Xh2o*Mmt/Mh2o;
  Pco2 = Pe*Xco2*Mmt/Mco2;

  /* Pressure losses */
  Pe - C2.P = DPc*ThermoSysPro.Functions.ThermoSquare(Q,eps)/rho;

  /* Specific enthalpy at the inlet */
  h[1] = ThermoSysPro.Properties.FlueGases.FlueGases_h(Pe, T[1], C1.Xco2, C1.Xh2o, C1.Xo2, C1.Xso2);

  for i in 1:Ns loop
    /* Specific enthalpy at the inlet of section i */
    h[i+1] = ThermoSysPro.Properties.FlueGases.FlueGases_h(Pe, T[i + 1], C1.Xco2, C1.Xh2o, C1.Xo2, C1.Xso2);

    /* Average temperature in section i */
    Tm[i] = 0.5*(T[i] + T[i+1]);
    0 = noEvent(if (abs(Q) < Qmin) then Tm[i] - Tp[i] else Q*(h[i] - h[i + 1]) - Coeff*K*(Tm[i] - Tp[i])*Surf_ext);

    /* Temperature difference between the fluid and the wall */
    DeltaT[i] = Tm[i] - Tp[i];

    if (abs(Q) >= Qmin) then
      /* Convective heat exchange coefficient */
      if (exchanger_type == 1) then
        /* Crossed flux */
        Kcc[i] = ThermoSysPro.Correlations.Thermal.WBCrossedCurrentConvectiveHeatTransferCoefficient(TFilm[i], abs(Q), Xh2o*100, Sgaz, Dext, Fa);
      else
        /* Longitudinal flux */
        Kcc[i] = ThermoSysPro.Correlations.Thermal.WBLongitudinalCurrentConvectiveHeatTransferCoefficient(TFilm[i], Tm[i], abs(Q), Xh2o*100, Sgaz, Deq);
      end if;

      /* Radiative heat exchange coefficient */
      Krr[i] = ThermoSysPro.Correlations.Thermal.WBRadiativeHeatTransferCoefficient(DeltaT[i], Tp[i], Ph2o/Pe, Pco2/Pe, Optl);
    else
      Krr[i] = 0;
      Kcc[i] = 0;
    end if;

    /* Film temperature */
    TFilm[i] = 0.5*(Tm[i] + Tp[i]);

    /* Power exchanged for each section */
    dW[i] = Coeff*K*(Tm[i] - Tp[i])*Surf_ext;
  end for;

  /* Thermal exchange */
  0 = noEvent(if (abs(Q) >= Qmin) then K - (Kc + Kr)*Encras else K - Kdef);

  /* Convective and radiative heat exchange coefficients */
  Kc = sum(Kcc)*Surf_ext/Surf_tot;
  Kr = sum(Krr)*Surf_ext/Surf_tot;

  /* Total power exchanged */
  W = sum(dW);

  if (p_rho > 0) then
    rho = p_rho;
  else
    rho = ThermoSysPro.Properties.FlueGases.FlueGases_rho(Pe,0.5*(T[1]+T[Ns+1]), C1.Xco2, C1.Xh2o, C1.Xo2, C1.Xso2);
  end if;

  annotation (Diagram(graphics={
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Line(points={{-60,20},{-60,-20}}),
        Line(points={{-20,20},{-20,-20}}),
        Line(points={{20,20},{20,-20}}),
        Line(points={{60,20},{60,-20}})}),
                           Icon(graphics={
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={255,255,0},
          fillPattern=FillPattern.Backward),
        Line(points={{-60,20},{-60,-20}}),
        Line(points={{-20,20},{-20,-20}}),
        Line(points={{20,20},{20,-20}}),
        Line(points={{60,20},{60,-20}})}),
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2019</b> </p>
<p><b>ThermoSysPro Version 3.2</h4>
</html>"));
end StaticWallFlueGasesExchanger;
