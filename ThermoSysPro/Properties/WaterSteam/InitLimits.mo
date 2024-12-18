within ThermoSysPro.Properties.WaterSteam;
package InitLimits
  constant Real MINPOS=1.0e-9
    "minimal value for physical variables which are always > 0.0";

  constant Units.SI.Area AMIN=MINPOS "Minimum surface";
  constant Units.SI.Area AMAX=1.0e5 "Maximum surface";
  constant Units.SI.Area ANOM=1.0 "Nominal surface";
  constant Units.SI.Density DMIN=MINPOS "Minimum density";
  constant Units.SI.Density DMAX=1.0e5 "Maximum densitye";
  constant Units.SI.Density DNOM=998.0 "Nominal density";
  constant Units.SI.ThermalConductivity LAMMIN=MINPOS
    "Minimum thermal conductivity";
  constant Units.SI.ThermalConductivity LAMNOM=1.0
    "Nominal thermal conductivity";
  constant Units.SI.ThermalConductivity LAMMAX=1000.0
    "Maximum thermal conductivity";
  constant Units.SI.DynamicViscosity ETAMIN=MINPOS "Minimum dynamic viscosity";
  constant Units.SI.DynamicViscosity ETAMAX=1.0e8 "Maximum dynamic viscosity";
  constant Units.SI.DynamicViscosity ETANOM=100.0 "Nominal dynamic viscosity";
  constant Units.SI.Energy EMIN=-1.0e10 "Minimum energy";
  constant Units.SI.Energy EMAX=1.0e10 "Maximum energy";
  constant Units.SI.Energy ENOM=1.0e3 "Nominal energy";
  constant Units.SI.Entropy SMIN=-1.0e6 "Minimum entropy";
  constant Units.SI.Entropy SMAX=1.0e6 "Maximum entropy";
  constant Units.SI.Entropy SNOM=1.0e3 "Nominal entropy";
  constant Units.SI.MassFlowRate MDOTMIN=-1.0e5 "Minimum mass flow rate";
  constant Units.SI.MassFlowRate MDOTMAX=1.0e5 "Maximum mass flow rate";
  constant Units.SI.MassFlowRate MDOTNOM=1.0 "Nominal mass flow rate";
  constant ThermoSysPro.Units.SI.MassFraction MASSXMIN=-1.0*MINPOS
    "Minimum mass fraction";
  constant ThermoSysPro.Units.SI.MassFraction MASSXMAX=1.0
    "Maximum mass fraction";
  constant ThermoSysPro.Units.SI.MassFraction MASSXNOM=0.1
    "Nominal mass fraction";
  constant Units.SI.Mass MMIN=1.0*MINPOS "Minimum mass";
  constant Units.SI.Mass MMAX=1.0e8 "Maximum mass";
  constant Units.SI.Mass MNOM=1.0 "Nominal mass";
  constant Units.SI.Power POWMIN=-1.0e8 "Minimum power";
  constant Units.SI.Power POWMAX=1.0e8 "Maximum power";
  constant Units.SI.Power POWNOM=1.0e3 "Nominal power";
  constant Units.SI.AbsolutePressure PMIN=100.0 "Minimum pressure";
  constant Units.SI.AbsolutePressure PMAX=1.0e9 "Maximum pressure";
  constant Units.SI.AbsolutePressure PNOM=1.0e5 "Nominal pressure";
  constant Units.SI.AbsolutePressure COMPPMIN=-1.0*MINPOS "Minimum pressure";
  constant Units.SI.AbsolutePressure COMPPMAX=1.0e8 "Maximum pressure";
  constant Units.SI.AbsolutePressure COMPPNOM=1.0e5 "Nominal pressure";
  constant Units.SI.RatioOfSpecificHeatCapacities KAPPAMIN=1.0
    "Minimum isentropic exponent";
  constant Units.SI.RatioOfSpecificHeatCapacities KAPPAMAX=Modelica.Constants.inf
    "Maximum isentropic exponent";
  constant Units.SI.RatioOfSpecificHeatCapacities KAPPANOM=1.2
    "Nominal isentropic exponent";
  constant Units.SI.SpecificEnergy SEMIN=-1.0e8 "Minimum specific energy";
  constant Units.SI.SpecificEnergy SEMAX=1.0e8 "Maximum specific energy";
  constant Units.SI.SpecificEnergy SENOM=1.0e6 "Nominal specific energy";
  constant Units.SI.SpecificEnthalpy SHMIN=-1.0e6 "Minimum specific enthalpy";
  constant Units.SI.SpecificEnthalpy SHMAX=1.0e8 "Maximum specific enthalpy";
  constant Units.SI.SpecificEnthalpy SHNOM=1.0e6 "Nominal specific enthalpy";
  constant Units.SI.SpecificEntropy SSMIN=-1.0e6 "Minimum specific entropy";
  constant Units.SI.SpecificEntropy SSMAX=1.0e6 "Maximum specific entropy";
  constant Units.SI.SpecificEntropy SSNOM=1.0e3 "Nominal specific entropy";
  constant Units.SI.SpecificHeatCapacity CPMIN=MINPOS
    "Minimum specific heat capacity";
  constant Units.SI.SpecificHeatCapacity CPMAX=Modelica.Constants.inf
    "Maximum specific heat capacity";
  constant Units.SI.SpecificHeatCapacity CPNOM=1.0e3
    "Nominal specific heat capacity";
  constant Units.SI.Temperature TMIN=200 "Minimum temperature";
  constant Units.SI.Temperature TMAX=6000 "Maximum temperature";
  constant Units.SI.Temperature TNOM=320.0 "Nominal temperature";
  constant Units.SI.ThermalConductivity LMIN=MINPOS
    "Minimum thermal conductivity";
  constant Units.SI.ThermalConductivity LMAX=500.0
    "Maximum thermal conductivity";
  constant Units.SI.ThermalConductivity LNOM=1.0 "Nominal thermal conductivity";
  constant Units.SI.Velocity VELMIN=-1.0e5 "Minimum velocity";
  constant Units.SI.Velocity VELMAX=Modelica.Constants.inf "Maximum velocity";
  constant Units.SI.Velocity VELNOM=1.0 "Nominal velocity";
  constant Units.SI.Volume VMIN=0.0 "Minimum volume";
  constant Units.SI.Volume VMAX=1.0e5 "Maximum volume";
  constant Units.SI.Volume VNOM=1.0e-3 "Nominal volume";

  annotation (
    Icon(graphics={
        Text(
          extent={{-102,0},{24,-26}},
          lineColor={242,148,0},
          textString=
               "Thermo"),
        Text(
          extent={{-4,8},{68,-34}},
          lineColor={46,170,220},
          textString=
               "SysPro"),
        Polygon(
          points={{-62,2},{-58,4},{-48,8},{-32,12},{-16,14},{6,14},{26,12},{42,
              8},{52,2},{42,6},{28,10},{6,12},{-12,12},{-16,12},{-34,10},{-50,6},
              {-62,2}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,38},{-24,38},{-26,30},{-26,22},{-24,14},{-24,12},{-46,8},
              {-42,22},{-42,30},{-44,38}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-26,20},{-20,20},{-20,22},{-14,22},{-14,20},{-12,20},{-12,12},
              {-26,12},{-28,12},{-26,20}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,14},{-8,24},{-6,24},{-6,14},{-8,14}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,30},{-6,26}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,36},{-6,32}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,42},{-6,38}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,48},{-6,44}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-4,14},{-4,26},{-2,26},{-2,14},{-4,14}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,32},{-2,28}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{-2,34}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,44},{-2,40}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,50},{-2,46}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-2,20},{8,20},{8,22},{10,22},{18,22},{18,12},{-4,14},{-2,20}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,2},{-58,4},{-48,8},{-36,10},{-18,12},{6,12},{26,10},{42,
              6},{52,0},{42,4},{28,8},{6,10},{-12,10},{-18,10},{-38,8},{-50,6},
              {-62,2}},
          lineColor={242,148,0},
          fillColor={242,148,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{22,12},{22,14},{22,16},{24,14},{20,18}},
          color={46,170,220},
          thickness=0.5),
        Line(
          points={{26,12},{26,14},{26,16},{28,14},{24,18}},
          color={46,170,220},
          thickness=0.5),
        Line(
          points={{30,10},{30,12},{30,14},{32,12},{28,16}},
          color={46,170,220},
          thickness=0.5),
        Polygon(
          points={{36,8},{36,30},{34,34},{36,38},{40,38},{40,8},{36,8}},
          lineColor={46,170,220},
          fillColor={46,170,220},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-100,80},{80,-100}}, lineColor={0,0,255}),
        Line(
          points={{-100,80},{-80,100},{100,100},{100,-80},{80,-100}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{80,80},{100,100}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Window(
      x=0.45,
      y=0.01,
      width=0.51,
      height=0.74,
      library=1,
      autolayout=1),
    Documentation(info="<html>
<p><b>Adapted from the ThermoFlow library  (H. Tummescheit)</b></p>
</HTML>
<html>
<p><b>Version 1.0</b></p>
</HTML>
"));

end InitLimits;
