within Modelica.Electrical.QuasiStatic.Machines.BasicMachines.Transformers.Dz;
model Dz02 "Transformer Dz2"

  extends QuasiStatic.Machines.Interfaces.PartialBasicTransformer(final
      VectorGroup="Dz02");
  QuasiStatic.Polyphase.Basic.Star star2(final m=m) annotation (Placement(
        transformation(
        origin={10,-80},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  QuasiStatic.SinglePhase.Interfaces.NegativePin starpoint2
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  QuasiStatic.Polyphase.Basic.Delta Rot21(final m=m) annotation (Placement(
        transformation(
        origin={30,0},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  QuasiStatic.Polyphase.Basic.Delta Rot22(final m=m) annotation (Placement(
        transformation(
        origin={40,20},
        extent={{-10,10},{10,-10}},
        rotation=180)));
  QuasiStatic.Polyphase.Basic.Delta Delta1(final m=m)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
equation
  connect(star2.pin_n, starpoint2) annotation (Line(points={{10,-90},{
          10,-100},{50,-100}}, color={85,170,255}));
  connect(r1.plug_p, Delta1.plug_p) annotation (Line(points={{-90,0},{-90,
          -20},{-50,-20}}, color={85,170,255}));
  connect(l1sigma.plug_n, core.plug_p1) annotation (Line(points={{-50,0},
          {-50,20},{-10,20},{-10,5}}, color={85,170,255}));
  connect(Delta1.plug_n, core.plug_n1) annotation (Line(points={{-30,-20},
          {-10,-20},{-10,-5}}, color={85,170,255}));
  connect(core.plug_p2, Rot21.plug_p)
    annotation (Line(points={{10,10},{30,10}}, color={85,170,255}));
  connect(core.plug_p3, Rot21.plug_n) annotation (Line(points={{10,-4},
          {20,-4},{20,-10},{30,-10}}, color={85,170,255}));
  connect(l2sigma.plug_p, Rot22.plug_p)
    annotation (Line(points={{50,0},{50,20}}, color={85,170,255}));
  connect(Rot22.plug_n, core.plug_n2) annotation (Line(points={{30,20},
          {20,20},{20,4},{10,4}}, color={85,170,255}));
  connect(core.plug_n3, star2.plug_p) annotation (Line(points={{10,-10},
          {10,-40},{10,-70},{10,-70}}, color={85,170,255}));
  annotation (defaultComponentName="transformer", Documentation(info="<html>
Transformer Dz2
<br>Typical parameters see:
<a href=\"modelica://Modelica.Electrical.Machines.Interfaces.PartialBasicTransformer\">PartialBasicTransformer</a>
</html>"));
end Dz02;
