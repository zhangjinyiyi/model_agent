within ThermoSysPro.Properties.WaterSteamSimple.SurfaceTension;
function SurfaceTension_T "Surface tension for given temperature"
  input Units.SI.Temperature T "Temperature";
  output Units.SI.SurfaceTension sigma "Surface tension";
protected
  SurfaceTension_T_coef coef
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
algorithm

  sigma :=
    ThermoSysPro.Properties.WaterSteamSimple.Utilities.polynomial_x_order5(coef,
    T);

end SurfaceTension_T;
