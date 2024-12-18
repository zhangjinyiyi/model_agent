within ThermoSysPro.MultiFluids.HeatExchangers;
model DynamicExchangerWaterSteamFlueGases
  "Dynamic exchanger water/steam - flue gases "

  parameter Units.SI.Length L=1 "Exchanger length";
  parameter Units.SI.Position z1=0 "Exchanger inlet altitude";
  parameter Units.SI.Position z2=0 "Exchanger outlet altitude";
  parameter Integer Ns=1 "Numver of segments";
  parameter Units.SI.Diameter Dint=0.1 "Pipe internal diameter";
  parameter Integer Ntubes=1 "Number of pipes in parallel";

  ThermoSysPro.FlueGases.HeatExchangers.StaticWallFlueGasesExchanger
    ExchangerFlueGasesMetal(
    Dext=0.022,
    Ns=Ns,
    NbTub=Ntubes,
    L=L)
    annotation (Placement(transformation(extent={{-10,30},{10,10}}, rotation=0)));
  ThermoSysPro.Thermal.HeatTransfer.HeatExchangerWall ExchangerWall(
    L=L,
    D=Dint,
    Ns=Ns,
    ntubes=Ntubes)                       annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=0)));
  ThermoSysPro.WaterSteam.HeatExchangers.DynamicTwoPhaseFlowPipe
    TwoPhaseFlowPipe(
    L=L,
    D=Dint,
    ntubes=Ntubes,
    Ns=Ns,
    z1=z1,
    z2=z2)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}}, rotation=
            0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesInletI Cfg1
    annotation (Placement(transformation(extent={{-10,40},{10,60}}, rotation=0)));
  ThermoSysPro.FlueGases.Connectors.FlueGasesOutletI Cfg2
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}}, rotation=
            0)));
  ThermoSysPro.WaterSteam.Connectors.FluidInletI Cws1
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}, rotation=
           0)));
  ThermoSysPro.WaterSteam.Connectors.FluidOutletI Cws2
    annotation (Placement(transformation(extent={{90,-10},{110,10}}, rotation=0)));
equation
  connect(Cws2, TwoPhaseFlowPipe.C2)
                                   annotation (Line(points={{100,0},{40,0},{40,
          -20},{10,-20}}, color={255,0,0}));
  connect(Cws1, TwoPhaseFlowPipe.C1)
    annotation (Line(points={{-100,0},{-20,0},{-20,-20},{-10,-20}}));
  connect(Cfg1, ExchangerFlueGasesMetal.C1) annotation (Line(
      points={{0,50},{-20,50},{-20,20},{-10,20}},
      color={0,0,0},
      thickness=1));
  connect(ExchangerFlueGasesMetal.C2, Cfg2) annotation (Line(
      points={{10,20},{20,20},{20,-50},{0,-50}},
      color={0,0,0},
      thickness=1));
  connect(ExchangerWall.WT1, TwoPhaseFlowPipe.CTh)
    annotation (Line(points={{0,-2},{0,-17}}, color={191,95,0}));
  connect(ExchangerFlueGasesMetal.CTh, ExchangerWall.WT2)
    annotation (Line(points={{0,17},{0,2}}, color={191,95,0}));
  annotation (Diagram(graphics),
                       Icon(graphics={
        Rectangle(
          extent={{-100,50},{100,-50}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,127,0}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={0,0,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-60,50},{-60,-50}}),
        Line(points={{-20,50},{-20,-50}}),
        Line(points={{20,50},{20,-50}}),
        Line(points={{60,50},{60,-50}})}),
    Documentation(revisions="<html>
<p><u><b>Authors</b></u></p>
<ul>
<li>Guillaume Larrignon</li>
<li>Baligh El Hefni </li>
</ul>
</html>",
   info="<html>
<p><b>Copyright &copy; EDF 2002 - 2010</b></p>
</HTML>
<html>
<p><b>ThermoSysPro Version 2.0</b></p>
</HTML>
"));
end DynamicExchangerWaterSteamFlueGases;
