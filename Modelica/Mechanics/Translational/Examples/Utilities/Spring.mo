within Modelica.Mechanics.Translational.Examples.Utilities;
model Spring "Input/output block of a spring model"
  extends Modelica.Blocks.Icons.Block;
  parameter SI.TranslationalSpringConstant c=1e4
    "Spring constant";
  parameter SI.Length s_rel0=0
    "Unstretched spring length";

  Modelica.Mechanics.Translational.Components.GeneralPositionToForceAdaptor positionToForce1(use_pder=false, use_pder2=
        false) annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Interfaces.RealInput s1(unit="m")
    "Position of left flange of force element"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput f1(unit="N")
    "Force generated by the force element"
    annotation (Placement(transformation(extent={{-100,-90},{-120,-70}})));
  Modelica.Mechanics.Translational.Components.Spring spring(c=c,
      s_rel0=s_rel0) annotation (Placement(transformation(extent={{-10,
            -10},{10,10}})));
  Modelica.Blocks.Interfaces.RealInput s2(unit="m")
    "Position of right flange of force element"
    annotation (Placement(transformation(extent={{140,60},{100,100}})));
  Modelica.Blocks.Interfaces.RealOutput f2(unit="N")
    "Force generated by the force element"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Mechanics.Translational.Components.GeneralPositionToForceAdaptor positionToForce2(use_pder=false, use_pder2=
        false) annotation (Placement(transformation(extent={{30,-10},{10,10}})));
equation

  connect(f1, positionToForce1.f) annotation (Line(points={{-110,-80},{-60,-80},
          {-60,-8},{-23,-8}}, color={0,0,127}));
  connect(positionToForce2.f, f2) annotation (Line(points={{23,-8},{60,-8},{60,-80},
          {110,-80}}, color={0,0,127}));
  connect(positionToForce1.flange, spring.flange_a)
    annotation (Line(points={{-18,0},{-10,0}}, color={0,127,0}));
  connect(spring.flange_b, positionToForce2.flange)
    annotation (Line(points={{10,0},{18,0}}, color={0,127,0}));
  connect(positionToForce1.p, s1) annotation (Line(points={{-23,8},{
          -60,8},{-60,80},{-120,80}}, color={0,0,127}));
  connect(positionToForce2.p, s2) annotation (Line(points={{23,8},{60,
          8},{60,80},{120,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={Text(
                extent={{-48,-36},{48,-68}},
                textColor={135,135,135},
                textString="to FMU"),Text(
                extent={{-94,96},{-10,66}},
                horizontalAlignment=TextAlignment.Left,
          textString="s1"),      Text(
                extent={{-150,-114},{150,-144}},
                textString="c=%c"),Bitmap(extent={{-88,-36},{92,56}},
            fileName="modelica://Modelica/Resources/Images/Mechanics/Translational/Spring.png"),
          Text( extent={{12,96},{96,66}},
                horizontalAlignment=TextAlignment.Right,
          textString="s2"),      Text(
                extent={{10,-60},{94,-90}},
                horizontalAlignment=TextAlignment.Right,
          textString="f2"),      Text(
                extent={{-90,-64},{-6,-94}},
                horizontalAlignment=TextAlignment.Left,
          textString="f1")}), Documentation(info="<html>
<p>
A linear 1D translational spring with pure signal
interface which can be applied for
a FMU (<a href=\"https://fmi-standard.org\">Functional Mock-up Unit</a>)
exchange.
</p>
</html>"));
end Spring;
