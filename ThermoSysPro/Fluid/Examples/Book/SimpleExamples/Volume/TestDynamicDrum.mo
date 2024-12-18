within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.Volume;
model TestDynamicDrum
  parameter ThermoSysPro.Units.xSI.Cv CvmaxWater(fixed=false, start=670)
    "Maximum CV (active if mode_caract=0)";
  parameter Real LambdaPipe(fixed=false,start=0.085)
    "Friction pressure loss coefficient (active if lambda_fixed=true)";

  ThermoSysPro.Fluid.Volumes.DynamicDrum              Drum(
    Vv(start=39),
    Vertical=false,
    hl(start=1454400),
    hv(start=2.658e6),
    xv(start=0.01),
    rhol(start=670),
    rhov(start=78),
    zl(fixed=true, start=1.05),
    P0=13000000,
    P(start=13000000, fixed=false),
    Tp(start=592.6)) annotation (Placement(transformation(extent={{-61,16},{1,
            78}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve FeedwaterValve(
    Cv(start=335),
    Q(start=79.5),
    rho(start=888),
    h(start=1400000),
    C1(
      h_vol_2(start=1400e3),
      h(start=1400e3),
      Q(start=79.5),
      P(start=13300000)),
    Cvmax=CvmaxWater,
    Pm(start=13100000))
                     annotation (Placement(transformation(extent={{-120,74},{
            -100,94}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve SteamValve(
    Cv(start=25000),
    Q(start=79.5),
    rho(start=78.5),
    h(start=2657930),
    Cvmax=10000,
    Pm(start=12900000))
    annotation (Placement(transformation(extent={{40,74},{60,94}}, rotation=0)));
  ThermoSysPro.Fluid.HeatExchangers.DynamicTwoPhaseFlowPipe
    TubeEcranBoucleEvaporatoire(
    T0=fill(400, 10),
    heb(start={10409,10268,10127,9985,9842,9698,9552,9406,9258,9111}),
    advection=false,
    z2=10,
    simplified_dynamic_energy_balance=false,
    P(start={13007000,13006600,13006000,13005500,13005000,13004500,13004000,13003000,
          13002000,13001000,13000000,12999990}),
    D=0.03,
    ntubes=1400,
    h(start={1400e3,1450e3,1500e3,1550e3,1600e3,1650e3,1700e3,1750e3,1800e3,1850e3,
          1900e3,1950e3}),
    L=20,
    Q(start=fill(130, 11)))
                     annotation (Placement(transformation(
        origin={6,-28},
        extent={{-10,10},{10,-10}},
        rotation=90)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource SourceC3(
    option_temperature=2,
    W0={1e7,1e7,1e7,1e7,1e7,1e7,1e7,1e7,1e7,1e7},
    T0={290,290,290,290,290,290,290,290,290,290})
    annotation (Placement(transformation(
        origin={36,-28},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall heatExchangerWall(Ns=10, L=20,
    D=0.03,
    ntubes=1400)
    annotation (Placement(transformation(
        origin={18,-28},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe lumpedStraightPipe(
    L=20,
    z1=20,
    C1(P(start=130e5)),
    Q(fixed=true, start=130),
    lambda=LambdaPipe)
             annotation (Placement(transformation(
        origin={-66,-28},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP              sourceQ(h0=1400000,
    option_temperature=false,
    P0=13300000)
           annotation (Placement(transformation(extent={{-196,68},{-176,88}},
          rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkP              sinkP(
    option_temperature=false,
    h0=2.650e6,
    P0=12700000)
    annotation (Placement(transformation(extent={{115,68},{135,88}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante SteamValve_O(k=0.5)
    annotation (Placement(transformation(extent={{20,100},{40,119}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps Steam_Pressure(Table=[0,
        128e5; 100,128e5; 110,124e5; 200,124e5; 400,128e5; 2000,128e5; 2010,
        131e5; 2090,131e5; 2300,128e5; 3000,128e5])
    annotation (Placement(transformation(extent={{96,97},{120,121}},  rotation=
            0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau(
    add(k1=-1, k2=+1),
    Ti=50,
    pIsat(
      ureset0=0.5,
      Limiteur1(u(signal(start=0.5))),
      Ti=2000)) annotation (Placement(transformation(extent={{-56,104},{-84,130}},
          rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Level(k=1.05) annotation (
      Placement(transformation(extent={{-21,100},{-40,119}}, rotation=0)));
equation
  connect(Drum.Cv, SteamValve.C1)
    annotation (Line(points={{1,78},{40,78}}, color={0,0,255}));
  connect(FeedwaterValve.C2, Drum.Ce1)
    annotation (Line(points={{-100,78},{-61,78}}, color={0,0,255}));
  connect(Drum.Cd, lumpedStraightPipe.C1) annotation (Line(points={{-61,16},{
          -66,16},{-66,-18}}, color={0,0,255}));
  connect(heatExchangerWall.WT1, SourceC3.C) annotation (Line(points={{20,-28},
          {26.2,-28}}, color={191,95,0}));
  connect(Drum.Cm, TubeEcranBoucleEvaporatoire.C2)
    annotation (Line(points={{1,16},{6,16},{6,-18}}));
  connect(TubeEcranBoucleEvaporatoire.CTh, heatExchangerWall.WT2) annotation (Line(
        points={{9,-28},{16,-28}}, color={191,95,0}));
  connect(sourceQ.C, FeedwaterValve.C1)  annotation (Line(
      points={{-176,78},{-120,78}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(SteamValve.C2,sinkP. C) annotation (Line(
      points={{60,78},{115,78}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(TubeEcranBoucleEvaporatoire.C1, lumpedStraightPipe.C2)
    annotation (Line(points={{6,-38},{6,-70},{-66,-70},{-66,-38}}));
  connect(SteamValve_O.y, SteamValve.Ouv)
    annotation (Line(points={{41,109.5},{50,109.5},{50,95}}, color={0,0,255}));
  connect(Steam_Pressure.y, sinkP.IPressure) annotation (Line(points={{121.2,
          109},{130,109},{130,78}}, color={0,0,255}));
  connect(Level.y, regulation_Niveau.ConsigneNiveauEau) annotation (Line(
      points={{-40.95,109.5},{-44,109.5},{-44,110},{-44,108},{-44,109.2},{-50,
          109.2},{-55.3,109.2}},
      color={0,0,0},
      pattern=LinePattern.Dash));

  connect(Drum.yLevel, regulation_Niveau.MesureNiveauEau) annotation (Line(
      points={{4.1,47},{10,47},{10,128.7},{-55.3,128.7}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(regulation_Niveau.SortieReelle1, FeedwaterValve.Ouv) annotation (Line(
        points={{-84.7,105.3},{-110,105.3},{-110,95}}, color={0,0,255}));
  annotation (experiment(StopTime=3000),
    Window(
      x=0.43,
      y=0,
      width=0.57,
      height=0.63),
    Diagram(graphics,
            coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-100},{140,200}},
        grid={2,2})),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
    Documentation(info="<html>
<h4>Copyright &copy; EDF 2002 - 2021 </h4>
<h4>ThermoSysPro Version 4.0 </h4>
<p>This model is documented in Sect. 14.2.5 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </p>
<p>The results reported in the ThermoSysPro book were computed using Dymola. </p>
</html>"));
end TestDynamicDrum;
