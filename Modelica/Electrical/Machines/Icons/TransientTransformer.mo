within Modelica.Electrical.Machines.Icons;
model TransientTransformer
  annotation (Icon(graphics={Polygon(
              points={{-70,60},{-50,40},{-50,-40},{-70,-60},{-70,60}},
              fillColor={135,135,135},
              fillPattern=FillPattern.VerticalCylinder),
            Polygon(
              points={{70,60},{50,40},{50,-40},{70,-60},{70,60}},
              fillColor={135,135,135},
              fillPattern=FillPattern.VerticalCylinder),
            Polygon(
              points={{0,50},{-10,40},{-10,-40},{0,-50},{10,-40},{10,40},{0,
            50}},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={135,135,135}),
            Polygon(
              points={{-70,60},{70,60},{50,40},{10,40},{0,50},{-10,40},{-50,
            40},{-70,60}},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={135,135,135}),
            Polygon(
              points={{-70,-60},{70,-60},{50,-40},{10,-40},{0,-50},{-10,-40},
            {-50,-40},{-70,-60}},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={135,135,135}),
            Rectangle(
              extent={{-78,36},{-42,-36}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={128,0,255},
              pattern=LinePattern.None),
            Rectangle(
              extent={{-84,28},{-36,-28}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={0,128,255},
              pattern=LinePattern.None),
            Rectangle(
              extent={{-18,36},{18,-36}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={128,0,255},
              pattern=LinePattern.None),
            Rectangle(
              extent={{-24,28},{24,-28}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={0,128,255},
              pattern=LinePattern.None),
            Rectangle(
              extent={{42,36},{78,-36}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={128,0,255},
              pattern=LinePattern.None),
            Rectangle(
              extent={{36,28},{84,-28}},
              lineColor={0,0,0},
              fillPattern=FillPattern.VerticalCylinder,
              fillColor={0,128,255},
              pattern=LinePattern.None)}),
            Documentation(info="<html>
<p>
This icon is designed for a <strong>transient transformer</strong> model.
</p>
</html>"));

end TransientTransformer;
