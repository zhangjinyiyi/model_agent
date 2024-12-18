within ThermoSysPro.Examples.SimpleExamples;
model TestPressurizer

  parameter Units.SI.Power Wch(fixed=false) = 0.29e6
    "Power released by the electrical heaters";
  parameter Real OUVfeedwaterValve( fixed=false)=0.01
    "OUV feed water valve";

  ThermoSysPro.WaterSteam.PressureLosses.ControlValve FeedwaterValve(
    Cv(start=100),
    C1(
      P(start=160e5),
      h_vol(start=1270e3),
      Q(start=0.3),
      h(start=1270e3)),
    Q(fixed=false, start=0.32),
    Cvmax=5000)      annotation (Placement(transformation(extent={{-110,130},{
            -90,150}}, rotation=0)));
  ThermoSysPro.WaterSteam.PressureLosses.ControlValve SteamValve(
    Cv(start=25000),
    Cvmax(fixed=true) = 5000,
    Pm(start=15500000))
    annotation (Placement(transformation(extent={{58,130},{78,150}}, rotation=0)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante OuvFeedwaterValve1(k=
        OUVfeedwaterValve)
    annotation (Placement(transformation(extent={{-140,176},{-120,196}},
          rotation=0)));
  ThermoSysPro.WaterSteam.PressureLosses.LumpedStraightPipe lumpedStraightPipe(
    L=1,
    D=1,
    z1=1,
    z2=0,
    mode=0,
    C1(P(start=160e5)),
    C2(P(start=160e5)),
    Q(fixed=false, start=0))
             annotation (Placement(transformation(
        origin={-30,-42},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  ThermoSysPro.InstrumentationAndControl.Blocks.Sources.Constante OuvSteamrValve(k(fixed=
          true) = 0.5) annotation (Placement(transformation(extent={{0,176},{20,
            196}}, rotation=0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.SourceP sourceP(
    option_temperature=2,
    h0=1270e3,
    mode=0,
    P0=160e5)
           annotation (Placement(transformation(extent={{-168,124},{-148,144}},
          rotation=0)));
  ThermoSysPro.WaterSteam.BoundaryConditions.SinkQ sinkQ(Q0=0, h0=3e6)
    annotation (Placement(transformation(extent={{106,124},{126,144}}, rotation=
           0)));
  WaterSteam.Volumes.Pressurizer pressurizer(
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
  WaterSteam.BoundaryConditions.SinkQ sinkQ1(            Q0=0, h0=1600000)
           annotation (Placement(transformation(extent={{-30,-76},{-10,-56}},
          rotation=0)));
  ThermoSysPro.Thermal.BoundaryConditions.HeatSource SourceC1(
    option_temperature=2,
    T0={310},
    W0={Wch})
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
equation
  connect(sourceP.C, FeedwaterValve.C1)  annotation (Line(points={{-148,134},{
          -110,134}}, color={0,0,255}));
  connect(SteamValve.C2, sinkQ.C) annotation (Line(points={{78,134},{106,134}},
        color={0,0,255}));
  connect(OuvSteamrValve.y, SteamValve.Ouv)
    annotation (Line(points={{21,186},{68,186},{68,151}}));
  connect(FeedwaterValve.C2, pressurizer.Cas) annotation (Line(points={{-90,134},
          {-30,134},{-30,118}}, color={0,0,255}));
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
  connect(OuvFeedwaterValve1.y, FeedwaterValve.Ouv) annotation (Line(points={{
          -119,186},{-100,186},{-100,151}}, color={0,0,255}));
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
<p><b>Copyright &copy; EDF 2002 - 2019 </p>
<p><b>ThermoSysPro Version 3.2 </h4>
</html>"));
end TestPressurizer;
