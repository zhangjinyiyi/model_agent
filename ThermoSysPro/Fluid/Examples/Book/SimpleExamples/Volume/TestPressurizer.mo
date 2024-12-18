within ThermoSysPro.Fluid.Examples.Book.SimpleExamples.Volume;
model TestPressurizer

  parameter Units.SI.Power Wch(fixed=false) = 0.29e6
    "Power released by the electrical heaters";
  parameter Real OUVfeedwaterValve( fixed=false)=0.01
    "Position of the feedwater valve";

  ThermoSysPro.Fluid.PressureLosses.ControlValve FeedwaterValve_Spray(
    Cv(start=100),
    C1(
      P(start=160e5),
      h_vol_2(start=1270e3),
      Q(start=0.3),
      h(start=1270e3)),
    Q(fixed=false, start=0.32),
    Cvmax=5000) annotation (Placement(transformation(extent={{-110,130},{-90,
            150}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.ControlValve SteamValve(
    Cv(start=25000),
    Cvmax(fixed=true) = 5000,
    Pm(start=15500000))
    annotation (Placement(transformation(extent={{58,130},{78,150}}, rotation=0)));
  ThermoSysPro.Fluid.PressureLosses.LumpedStraightPipe lumpedStraightPipe(
    L=1,
    D=1,
    z1=1,
    z2=0,
    C1(P(start=160e5)),
    C2(P(start=160e5)),
    Q(fixed=false, start=0))
             annotation (Placement(transformation(
        origin={-30,-42},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante SteamrValve_O(k(fixed=
          true) = 0.5) annotation (Placement(transformation(extent={{0,156},{20,
            176}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SourceP sourceP(
    option_temperature=false,
    h0=1270e3,
    P0=16000000)
           annotation (Placement(transformation(extent={{-168,124},{-148,144}},
          rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ(Q0=0, h0=3e6)
    annotation (Placement(transformation(extent={{106,124},{126,144}}, rotation=
           0)));
  ThermoSysPro.Fluid.Volumes.Pressurizer     pressurizer(
    Zm=10.15,
    Klv=0.5e6,
    cpp=600,
    hl(start=1629887.98290107),
    hv(start=2596216.59571565),
    Zl(start=5.5900717167325),
    Yw0=60,
    steady_state=true,
    V=61.12,
    Rp=1.27,
    Ae=96.23,
    Klp=1780,
    Kvp=7500,
    Mp=107e3,
    Kpa=5.63,
    Ccond=0.02,
    Cevap=0.05,
    Yw(start=32.92),
    y(start=0.3292, fixed=true),
    P0=15500000,
    P(start=15500000, fixed=true),
    Tp(start=617.94155291055)) annotation (Placement(transformation(extent={{-92,
            -12},{32,118}}, rotation=0)));
  ThermoSysPro.Fluid.BoundaryConditions.SinkQ sinkQ1(            Q0=0, h0=1600000)
           annotation (Placement(transformation(extent={{-30,-76},{-10,-56}},
          rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource SourceC1(
    option_temperature=2,
    T0={310},
    W0={1e5})
    annotation (Placement(transformation(
        origin={-133,32},
        extent={{-17,17},{17,-17}},
        rotation=270)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource SourceC2(
    T0={310},
    W0={0.286e6},
    option_temperature=1)
    annotation (Placement(transformation(
        origin={-133,55},
        extent={{-17,17},{17,-17}},
        rotation=270)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps ElectricalHeaters(Table=[0,
        Wch; 100,Wch; 110,Wch; 120,Wch; 300,Wch; 1200,Wch; 1400,Wch*7.75; 1600,
        Wch*7.75; 1900,Wch; 3000,Wch]) annotation (Placement(transformation(
          extent={{-175,19},{-149,45}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Tables.Table1DTemps FeedwaterValveSpray(Table=[0,
        OUVfeedwaterValve; 200,OUVfeedwaterValve; 250,OUVfeedwaterValve + 0.005;
        300,OUVfeedwaterValve + 0.005; 400,0; 1000,0]) annotation (Placement(
        transformation(extent={{-134,154},{-108,180}}, rotation=0)));
  ThermoSysPro.Examples.Control.Drum_LevelControl regulation_Niveau(
    Ti=50,
    add(k1=+1, k2=-1),
    minval=-100,
    pIsat(
      Limiteur1(u(signal(start=0.001))),
      ureset0=0.0,
      maxval=100,
      Ti=2000)) annotation (Placement(transformation(extent={{52,-52},{24,-26}},
          rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante Level_y100(k=32.92)
    annotation (Placement(transformation(extent={{87,-56},{68,-37}}, rotation=0)));
equation
  connect(sourceP.C, FeedwaterValve_Spray.C1)
    annotation (Line(points={{-148,134},{-110,134}}, color={0,0,255}));
  connect(SteamValve.C2, sinkQ.C) annotation (Line(points={{78,134},{106,134}},
        color={0,0,255}));
  connect(SteamrValve_O.y, SteamValve.Ouv)
    annotation (Line(points={{21,166},{68,166},{68,151}}));
  connect(FeedwaterValve_Spray.C2, pressurizer.Cas)
    annotation (Line(points={{-90,134},{-30,134},{-30,118}}, color={0,0,255}));
  connect(pressurizer.Cs, SteamValve.C1) annotation (Line(points={{32,116.7},{
          32,134},{58,134}}, color={0,0,255}));
  connect(sinkQ1.C, lumpedStraightPipe.C2)
    annotation (Line(points={{-30,-66},{-30,-52}}));
  connect(lumpedStraightPipe.C1, pressurizer.Cex)
    annotation (Line(points={{-30,-32},{-30,-12}}));
  connect(SourceC2.C[1], pressurizer.Ca) annotation (Line(points={{-116.34,55},
          {-103.17,55},{-103.17,54.3},{-85.8,54.3}}, color={191,95,0}));
  connect(SourceC1.C[1], pressurizer.Cc) annotation (Line(points={{-116.34,32},
          {-73.17,32},{-73.17,32.2},{-30,32.2}}, color={191,95,0}));
  connect(FeedwaterValveSpray.y, FeedwaterValve_Spray.Ouv) annotation (Line(
        points={{-106.7,167},{-100,167},{-100,151}}, color={0,0,255}));
  connect(ElectricalHeaters.y, SourceC1.ISignal)
    annotation (Line(points={{-147.7,32},{-141.5,32}}, color={0,0,255}));
  connect(Level_y100.y, regulation_Niveau.ConsigneNiveauEau) annotation (Line(
      points={{67.05,-46.5},{64,-46.5},{64,-46},{64,-48},{64,-46.8},{58,-46.8},
          {52.7,-46.8}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(pressurizer.yLevel, regulation_Niveau.MesureNiveauEau) annotation (
      Line(points={{25.8,53},{78,53},{78,-27.3},{52.7,-27.3}}, color={0,0,255}));
  connect(regulation_Niveau.SortieReelle1, sinkQ1.IMassFlow) annotation (Line(
        points={{23.3,-50.7},{-20,-50.7},{-20,-61}}, color={0,0,255}));
  annotation (
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
    experiment(StopTime=3000),
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
<p>This model is documented in Sect. 14.3.5 of the <a href=\"https://www.springer.com/us/book/9783030051044\">ThermoSysPro book</a>. </p>
<p>The results reported in the ThermoSysPro book were computed using Dymola. </p>
</html>"));
end TestPressurizer;
