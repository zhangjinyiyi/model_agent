within ThermoSysPro.Fluid.HeatExchangers;
model DynamicWaterHeaterOnePipe "Dynamic water heater"
  extends
    ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.WaterSteamFluidTypeParameterInterface;
  extends ThermoSysPro.Fluid.Interfaces.IconColors;
  import ThermoSysPro.Fluid.Interfaces.PropertyInterfaces.FluidType;

  //parameter Modelica.SIunits.Volume Vc=4510 "Cavity total volume";
  //parameter Modelica.SIunits.Area Ac=200 "Cavity cross-sectional area";
  parameter Units.SI.Radius Rv=1.0 "Radius of the cavity cross-sectional area";
  parameter Units.SI.Length L1=12.5
    "Length of drowned pipes in liquid (pipes 1)";
  parameter Units.SI.Length L2=12.5 "Length of Pipe 2 (in steam)";
  parameter Units.SI.Length L3=25 "Length of Pipe 3 (in steam)";
  parameter Units.SI.Length Lc=2.5
    "Support plate spacing in cooling zone(chicanes)";
  parameter Units.SI.Diameter Dc=0.016 "Internal diameter of the cooling pipes";
  parameter Units.SI.Thickness ec=2.e-3 "Thickness of the cooling pipes";
  parameter Units.SI.Diameter DIc=1.390 "Internal calendre diameter";
  parameter Units.SI.Length PasL=0.03
    "Longitudianl step or Length bottom pipes triangular step";
  parameter Units.SI.Length PasT=0.03 "Transverse step or pipes step";
  //parameter Modelica.SIunits.Angle Angle = 60 "Average bend angle (deg)";
  parameter Integer Ns=10 "Number of segments for one tube pass (half U pipe)";
  parameter Integer ntubes1=500 "Numbers of drowned pipes in liquid for pipes 1";
  parameter Integer ntubes2=500 "Numbers of the pipes immersed in steam = NbTub2, for pipes 2";
  parameter Integer ntubes3=500 "Numbers of the pipes immersed in steam, for pipe 3";
  parameter Integer ntubesV=15 "Numbers of pipes in a vertical row (tube bank)";
  parameter Units.SI.SpecificHeatCapacity cp=460
    "Specific heat capacity of the metal of the cooling pipes";
  parameter Units.SI.Density rho=7900
    "Density of the metal of the cooling pipes";
  parameter Units.SI.ThermalConductivity lambda=26
    "Wall thermal conductivity of the cooling pipes";
  //parameter Modelica.SIunits.CoefficientOfHeatTransfer hcond=25000 "Heat transfer coefficient between the vapor and the cooling pipes";
  parameter Real DpfCorr=1.00 "Corrective terme for friction pressure loss (dpf) in node i";
  parameter Real COP0v=1.0 "Corrective terme for Heat exchange coefficient or Fouling coefficient steam side";
  parameter Real COP0l=1 "Corrective terme for Heat exchange coefficient or Fouling coefficient liquid side";
  parameter Boolean inertia=true "true: momentum balance equation with inertia - false: without inertia";
  parameter Boolean advection=true "true: momentum balance equation with advection terme - false: without advection terme";
  parameter Boolean dynamic_energy_balance=true "true: dynamic energy balance equation - false: static energy balance equation";
  parameter Boolean dynamic_mass_balance=true "true: dynamic mass balance equation - false: static mass balance equation (active if the fluid is compressible and if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=isCompressible and dynamic_energy_balance));
  parameter Boolean simplified_dynamic_energy_balance=true "true: simplified dynamic energy balance equation - false: full dynamic energy balance equation (active if dynamic_energy_balance=true and dynamic_mass_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and dynamic_mass_balance));
  parameter Boolean steady_state=true "true: start from steady state - false: start from (Vf0, P0c, T0 or h0) (active if dynamic_energy_balance=true)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance));
  parameter Real Vf0=0.66 "Fraction of initial water volume in the drum (active if dynamic_energy_balance=true and steady_state=false)" annotation(Evaluate=true, Dialog(enable=dynamic_energy_balance and not steady_state));
  parameter Units.SI.AbsolutePressure P0c=1.e5
    "Fluid initial pressure (active if dynamic_energy_balance=true and steady_state=false)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state));
  parameter Units.SI.Temperature T0[2*Ns]=fill(290, 2*Ns)
    "Initial fluid temperature (active if steady_state = false and option_temperature=true)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state and option_temperature));
  parameter Units.SI.SpecificEnthalpy h0[2*Ns]=fill(1e5, 2*Ns)
    "Initial fluid specific enthalpy (active if steady_state = false and option_temperature=false)"
    annotation (Evaluate=true, Dialog(enable=dynamic_energy_balance and not
          steady_state and not option_temperature));
  parameter Boolean option_temperature=true "true: initial temperature is fixed - false: initial specific enthalpy is fixed (active if steady_state=false)" annotation(Evaluate=true, Dialog(enable=not steady_state));
  parameter Boolean continuous_flow_reversal=false "true: continuous flow reversal - false: discontinuous flow reversal";
  parameter Boolean diffusion=false "true: energy balance equation with diffusion - false: energy balance equation without diffusion";

  Volumes.TwoPhaseCavity WaterHeating(
    Vf0=Vf0,
    P0=P0c,
    Ns=Ns,
    L2=L2,
    NbTub1=ntubes1,
    NbTubV=ntubesV,
    DIc=DIc,
    R=Rv,
    Dext=Dc + 2*ec,
    COPv=COP0v,
    COPl=COP0l,
    Lc=Lc,
    PasL=PasL,
    PasT=PasT,
    L1=L1,
    L3=L3,
    NbTub2=ntubes2,
    NbTub3=ntubes3,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    wsftype=wsftype)
    annotation (                        Placement(transformation(extent={{-100,
            -100},{100,100}}, rotation=0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicOnePhaseFlowPipe pipe_3(
    D=Dc,
    Ns=Ns*2,
    dpfCorr=DpfCorr,
    L=L3,
    ntubes=ntubes3,
    Q(start=fill(300, Ns*2 + 1)),
    inertia=inertia,
    advection=advection,
    dynamic_energy_balance=dynamic_energy_balance,
    dynamic_mass_balance=dynamic_mass_balance,
    simplified_dynamic_energy_balance=simplified_dynamic_energy_balance,
    steady_state=steady_state,
    continuous_flow_reversal=continuous_flow_reversal,
    diffusion=diffusion,
    h0=h0,
    T0=T0,
    option_temperature=option_temperature,
    P0=P0c)
    annotation (Placement(transformation(extent={{-35,-34},{60,0}}, rotation=0)));
  Interfaces.Connectors.FluidInlet C1vap "Vapor inlet" annotation (Placement(
        transformation(extent={{-10,90},{10,110}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet C2ex "Condensed water extraction outlet"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}, rotation=
           0)));
  Interfaces.Connectors.FluidInlet Ce1 "Cooling water inlet" annotation (
      Placement(transformation(extent={{-110,-55},{-90,-35}}, rotation=0)));
  Interfaces.Connectors.FluidOutlet Ce2 "Cooling water outlet" annotation (
      Placement(transformation(extent={{-110,34},{-90,54}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Connectors.OutputReal sortieReelle
    annotation (Placement(transformation(extent={{92,-86},{112,-66}}, rotation=
            0)));

  Interfaces.Connectors.FluidInlet C1 "Extra water inlet" annotation (
      Placement(transformation(extent={{-74,82},{-54,102}}, rotation=0)));
  Thermal.HeatTransfer.HeatExchangerWall Wall_3(
    D=Dc,
    e=ec,
    lambda=lambda,
    cpw=cp,
    rhow=rho,
    Ns=Ns*2,
    L=L3,
    ntubes=ntubes3,
    steady_state=steady_state,
    dynamic_energy_balance=dynamic_energy_balance)
    annotation (Placement(transformation(extent={{-34,-24},{60,24}}, rotation=0)));

  Volumes.VolumeD volumeD(
    h0=790e3,
    dynamic_energy_balance=dynamic_energy_balance,
    steady_state=steady_state,
    diffusion=diffusion,
    dynamic_mass_balance=dynamic_mass_balance,
    continuous_flow_reversal=continuous_flow_reversal,
    ftype=ftype)   annotation (Placement(transformation(extent={{-72,-54},{-54,-36}},
                   rotation=0)));
  Volumes.VolumeC volumeC(
    h0=890e3,
    dynamic_energy_balance=dynamic_energy_balance,
    dynamic_mass_balance=dynamic_mass_balance,
    steady_state=steady_state,
    diffusion=diffusion,
    continuous_flow_reversal=continuous_flow_reversal,
    ftype=ftype)                annotation (Placement(transformation(extent={{-52,35},
            {-70,53}},         rotation=0)));
equation
  if (cardinality(C1) == 1) then
    C1.Q = 0;
    C1.h = 1.e5;
    C1.h_vol_1 = 1.e5;
    C1.diff_res_1 = 0;
    C1.diff_on_1 = false;
    C1.ftype = ftype;
    C1.Xco2 = 0;
    C1.Xh2o = 0;
    C1.Xo2 = 0;
    C1.Xso2 = 0;
  end if;

  connect(C1vap, WaterHeating.Cv)
                                annotation (Line(points={{0,100},{0,73.3333},{
          1.11111,73.3333}}));
  connect(WaterHeating.Cl, C2ex)
                               annotation (Line(points={{1.11111,-73.3333},{
          1.11111,-94},{-2,-94},{-2,-98},{0,-98},{0,-100}},   color={0,0,255}));
  connect(C1, WaterHeating.Ce)
    annotation (Line(points={{-64,92},{-60,92},{-60,73.3333},{-38.8889,73.3333}}));
  connect(WaterHeating.yLevel, sortieReelle)
    annotation (Line(points={{98.8889,-32.6667},{94,-32.6667},{94,-76},{102,-76}}));
  connect(WaterHeating.Cth3, Wall_3.WT2)
                                      annotation (Line(points={{0.555556,2},{0.555556,
          8.33335},{13,8.33335},{13,4.8}},          color={191,95,0}));
  connect(Wall_3.WT1, pipe_3.CTh) annotation (Line(points={{13,-4.8},{13,-10.4},
          {12.5,-10.4},{12.5,-11.9}}, color={191,95,0}));
  connect(Ce1, volumeD.Ce)
    annotation (Line(points={{-100,-45},{-72,-45}}, color={0,0,0}));
  connect(volumeD.Cs1, pipe_3.C1) annotation (Line(points={{-63,-36},{-64,-36},{
          -64,-17},{-35,-17}}, color={0,0,0}));
  connect(pipe_3.C2, volumeC.Ce1) annotation (Line(points={{60,-17},{78,-17},{78,
          44},{-52,44}}, color={0,0,0}));
  connect(volumeC.Cs, Ce2)
    annotation (Line(points={{-70,44},{-100,44}}, color={0,0,0}));
  annotation (Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1), graphics={
        Text(
          extent={{-116,-56},{-90,-72}},
          lineColor={0,0,255},
          textString="Inlet"),
        Text(
          extent={{-110,67},{-86,53}},
          lineColor={0,0,255},
          textString="Outlet"),
        Text(
          extent={{16,102},{44,87}},
          lineColor={0,0,255},
          textString=
               "Steam")}),
                       Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-100,0},{-74,-90}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,-8},{0,-14}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,14},{-74,8}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{60,14},{16,8}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{60,-90},{-100,-90}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{60,90},{-100,90}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-100,0},{76,0}},
          color={0,0,255},
          thickness=0.5),
        Rectangle(
          extent={{-74,-52},{60,-90}},
          lineColor={0,0,255},
          lineThickness=0,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,90},{-74,0}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-8},{-74,-14}},
          lineColor={0,0,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-30},{-74,-36}},
          lineColor={0,0,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-54},{-74,-60}},
          lineColor={0,0,255},
          fillColor={170,170,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,36},{-74,30}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,60},{-74,54}},
          lineColor={0,0,255},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,90},{70,80},{84,60},{94,40},{100,20},{102,0},{100,-20},{
              94,-40},{84,-60},{70,-80},{60,-90},{60,90}},
          lineColor={0,0,255},
          lineThickness=0,
          fillColor= DynamicSelect({85,170,255},
          if dynamic_energy_balance then fill_color_dynamic
          else if diffusion then fill_color_singular
          else fill_color_static),
          fillPattern=DynamicSelect(FillPattern.Solid,
          if dynamic_mass_balance and dynamic_energy_balance then FillPattern.HorizontalCylinder
          else FillPattern.Solid)),
        Rectangle(
          extent={{66,14},{60,-14}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,36},{16,30}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,60},{16,54}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,-30},{16,-36}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,-52},{88,-52},{74,-74},{64,-86},{59,-90},{60,-52}},
          lineColor={255,170,170},
          lineThickness=0,
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,-76},{72,-76}},
          color={255,255,255},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Rectangle(
          extent={{74,36},{68,-36}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{82,60},{76,-60}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{76,-54},{16,-60}},
          lineColor={0,0,255},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,-68},{78,-68}},
          color={255,255,255},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Line(
          points={{-74,-58},{84,-58}},
          color={255,255,255},
          pattern=LinePattern.Dash,
          thickness=0.5),
        Text(
          extent={{-132,72},{-106,58}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Water outlet"),
        Text(
          extent={{-132,-18},{-104,-32}},
          lineColor={0,0,255},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Water inlet")}),
    Documentation(revisions="<html>
<p><u><b>Author</b></u></p>
<ul>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2021</b> </p>
<p><b>ThermoSysPro Version 4.0</b> </p>
</html>"));
end DynamicWaterHeaterOnePipe;
