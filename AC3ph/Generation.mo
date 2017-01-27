within PowerSystems.AC3ph;
package Generation "Turbo generator groups dq0"
  extends Modelica.Icons.VariantsPackage;

  model TurboGenerator "Turbo generator single mass"
    extends Partials.GenBase_el;

    replaceable model Rotor = PowerSystems.Mechanics.TurboGroups.SingleMassTG (
      final w_start=w_start,
      final H=H,
      final P_nom=generator.par.S_nom,
      final w_nom=w_nom) "single-mass rotor (turbine-rotor + generator-rotor)"
      annotation(choicesAllMatching=true);
    Rotor rotor "single-mass rotor (turbine-rotor + generator-rotor)"
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  equation
    connect(rotor.airgap, generator.airgap)
    annotation (Line(points={{-40,6},{50,6}}, color={0,0,0}));
    connect(rotor.speed, governor.speed)
      annotation (Line(points={{-56,10},{-56,50}}, color={0,0,127}));
    connect(governor.power, rotor.power)
      annotation (Line(points={{-44,50},{-44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGen1",
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
One-mass model, turbine- and generator-rotor represent one single rigid mass.<br>
The machine inertia is determined by the inertia time constant H.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid)}));
  end TurboGenerator;

  model TurboGrpGenerator "Example turbogroup generator"
    extends Partials.GenBase_el(final H=h);

    replaceable model Torque =
      PowerSystems.Mechanics.TurboGroups.PcontrolTorque (
        final w_nom=turboGroup.par.w_nom, final P_nom=turboGroup.par.P_nom)
      "torque-model" annotation (choicesAllMatching=true);
    Torque turbTorq "torque-model"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    replaceable model TurboGroup =
      PowerSystems.Mechanics.TurboGroups.SteamTurboGroup (
        final w_start=w_start) "steam turbo-goup with generator-rotor"
      annotation(choicesAllMatching = true);
    TurboGroup turboGroup "steam turbo-goup with generator-rotor"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  protected
    final parameter SI.Time h=(sum(turboGroup.par.J_turb) +
        turboGroup.par.J_gen + sum(turboGroup.par.J_aux))*w_nom^2/(2
        *generator.par.S_nom) "inertia cst turb + gen";

  equation
    connect(turbTorq.blades, turboGroup.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(turboGroup.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGrpGen1",
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
Turbo-group, with turbines and generator-rotor elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid), Polygon(
            points={{-61,48},{-61,-48},{-57,-50},{-57,50},{-61,48}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid)}));
  end TurboGrpGenerator;

  model GTGenerator "Example gas turbine generator"
    extends Partials.GenBase_el(final H=h);

    replaceable model Torque =
      PowerSystems.Mechanics.TurboGroups.PcontrolTorque (
        final w_nom=GT.par.w_nom, final P_nom=GT.par.P_nom) "torque-model"
      annotation(choicesAllMatching=true);
    Torque turbTorq "torque-model"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    replaceable model Gear =
      PowerSystems.Mechanics.TurboGroups.GasTurbineGear(final w_start=w_start)
      "gas turbine with gear and generator-rotor"
      annotation(choicesAllMatching=true);
    Gear GT "gas turbine with gear and generator-rotor"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  protected
    final parameter Real[3] gr2=diagonal(GT.par.ratio)*GT.par.ratio/GT.par.ratio[end]^2;
    final parameter SI.Inertia J_red=(GT.par.J_turb + GT.par.J_comp)
        *gr2[1] + GT.par.J_gear1*gr2[1:2] + GT.par.J_gear2*gr2[2:3] + (GT.par.J_acc
         + GT.par.J_cpl + GT.par.J_gen) "gear reduced inertia";
    final parameter SI.Time h=J_red*w_nom^2/(2*generator.par.S_nom);

  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*GT.par.w_nom) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, GT.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(GT.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "turboGen1",
    Documentation(
            info="<html>
<p>Turbo generator model with governor and exciter.<br>
Gas turbine with gear and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
<p>Note: for turbines with gear <tt>w_start</tt> denotes the initial angular velocity at the generator-side!</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Polygon(
            points={{-20,70},{-94,30},{-94,-30},{-20,-70},{-20,70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-61,48},{-61,-48},{-57,-50},{-57,50},{-61,48}},
            lineColor={135,135,135},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(
            points={{-86,-10},{-26,-10}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-86,10},{-68,10}},
            color={0,0,0},
            thickness=0.5),
          Line(
            points={{-48,10},{-26,10}},
            color={0,0,0},
            thickness=0.5)}));
  end GTGenerator;

  model HydroGenerator "Hydro generator"
    extends Partials.GenBase_el(final H=h);

    replaceable model Torque =
      PowerSystems.Mechanics.TurboGroups.PcontrolTorque (
        final w_nom=hydro.par.w_nom, final P_nom={hydro.par.P_nom})
      "torque-model"
      annotation(choicesAllMatching=true);
    Torque turbTorq "torque-model"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    replaceable model HydroTurbine =
      PowerSystems.Mechanics.TurboGroups.HydroTurbine(final w_start=w_start)
      "hydro turbine with generator-rotor"
      annotation(choicesAllMatching=true);
    HydroTurbine hydro "hydro turbine with generator-rotor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  protected
    final parameter SI.Time h=(hydro.par.J_turb + hydro.par.J_gen)
        *w_nom^2/(2*generator.par.S_nom);

  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*hydro.par.w_nom) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, hydro.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(hydro.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "hydroGen1",
    Documentation(
            info="<html>
<p>Hydro generator model with governor and exciter.<br>
Hydro turbine and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-70,50},{-30,-52}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-70,70},{-30,30}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-70,-30},{-30,-70}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}));
  end HydroGenerator;

  model DieselGenerator "Diesel generator"
    extends Partials.GenBase_el(final H=h);

    replaceable model Torque =
      PowerSystems.Mechanics.TurboGroups.PcontrolTorque (
        final w_nom=diesel.par.w_nom, final P_nom={diesel.par.P_nom})
      "torque-model" annotation(choicesAllMatching=true);
    Torque turbTorq "torque-model"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    replaceable model Diesel = PowerSystems.Mechanics.TurboGroups.Diesel (
      final w_start=w_start) "Diesel engine with generator-rotor"
      annotation(choicesAllMatching=true);
    Diesel diesel "Diesel engine with generator-rotor"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  protected
    final parameter SI.Time h=(diesel.par.J_turb + diesel.par.J_gen)
        *w_nom^2/(2*generator.par.S_nom);

  equation
    assert(abs(2*pi*generator.par.f_nom/(generator.par.pp*diesel.par.w_nom) - 1) < 1e-3,
      "nominal rpm, frequency and pole-pair number seems to be incompatible");
    connect(turbTorq.blades, diesel.blades)
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(diesel.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(turbTorq.speed, governor.speed)
                                          annotation (Line(points={{-56,10},{
            -56,50}}, color={0,0,127}));
    connect(governor.power, turbTorq.power)
                                          annotation (Line(points={{-44,50},{
            -44,10}}, color={0,0,127}));
  annotation (defaultComponentName = "dieselGen1",
    Documentation(
            info="<html>
<p>Diesel generator model with Diesel-controller and exciter.<br>
Diesel-engine and generator-rotor, elastically coupled.</p>
<p>Steady-state initialisation:<br>
If combined with 'Control.Setpoints.Set_w_p_v' or similar, the setpoint values <tt>p_set</tt> and <tt>v_set</tt> are determined at initialisation from initial active power and voltage. The corresponding value for the speed <tt>w_set</tt> is determined by the system frequency <tt>system.f0</tt>.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={
          Rectangle(
            extent={{-90,50},{-20,-70}},
            lineColor={95,95,95},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-85,-6},{-25,-66}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-80,70},{-30,50}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}));
  end DieselGenerator;

  model TurboPMgenerator "Turbo generator single mass, permanent magnet"
    extends Partials.GenBase;

    parameter SI.AngularVelocity w_start=2*pi*generator.par.f_nom/generator.par.pp
      "initial angular velocity (start-value if ini='st')";
    AC3ph.Ports.ACdq0_n term "negative terminal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    Modelica.Blocks.Interfaces.RealInput[2] setpts
      "setpoints {speed, power} pu"
    annotation (Placement(transformation(extent={{-110,10},{-90,-10}})));
    Modelica.Blocks.Interfaces.RealOutput phiRotor "rotor angle el"
      annotation (Placement(transformation(
          origin={100,100},
          extent={{10,-10},{-10,10}},
          rotation=180)));
    replaceable model Generator = PowerSystems.AC3ph.Machines.Synchron3rd_pm
      "synchron pm generator" annotation (choices(
      choice(redeclare model Generator =
              PowerSystems.AC3ph.Machines.Synchron3rd_pm "3rd order"),
      choice(redeclare model Generator =
              PowerSystems.AC3ph.Machines.Synchron_pm "nth order")));
    Generator generator "synchron pm generator"
      annotation (Placement(transformation(extent={{60,-10},{40,10}})));
    replaceable model Governor = PowerSystems.Control.Governors.GovernorConst
      "governor (control)" annotation (choices(
        choice(redeclare model Governor =
          PowerSystems.Control.Governors.GovernorConst "constant"),
        choice(redeclare model Governor =
          PowerSystems.Control.Governors.Governor1st "1st order")));
    Governor governor "governor (control)"
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
    parameter SI.Time H=10 "inertia cst turb + gen";
    replaceable model Rotor = PowerSystems.Mechanics.TurboGroups.SingleMassTG (
      final w_start=w_start,
      final H=H,
      final P_nom=generator.par.S_nom,
      final w_nom=w_nom) "single-mass rotor (turbine-rotor + generator-rotor)"
      annotation(choicesAllMatching=true);
    Rotor rotor "single-mass rotor (turbine-rotor + generator-rotor)"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  protected
    final parameter SI.AngularVelocity w_nom=2*pi*generator.par.f_nom/generator.par.pp
      "nominal angular velocity";

  equation
    connect(setpts[1], governor.setptSpeed)
                                          annotation (Line(points={{-100,5},{
            -90,5},{-90,44},{-60,44}}, color={0,0,127}));
    connect(setpts[2], governor.setptPower)
                                          annotation (Line(points={{-100,-5},{
            -80,-5},{-80,36},{-60,36}}, color={0,0,127}));
    connect(rotor.speed, governor.speed)
                                       annotation (Line(points={{-56,10},{-56,
            30}}, color={0,0,127}));
    connect(governor.power, rotor.power)
                                       annotation (Line(points={{-44,30},{-44,
            10}}, color={0,0,127}));
    connect(rotor.airgap, generator.airgap)
    annotation (Line(points={{-40,6},{50,6}}, color={0,0,0}));
    connect(generator.heat, heat) annotation (Line(points={{50,10},{50,40},{0,
            40},{0,100}}, color={176,0,0}));
    connect(generator.term, term)
      annotation (Line(points={{60,0},{100,0}}, color={0,120,120}));
    connect(generator.phiRotor, phiRotor)     annotation (Line(points={{40,10},
            {30,10},{30,100},{100,100}}, color={0,0,127}));
  annotation (defaultComponentName = "turboPMgen",
    Documentation(
            info="<html>
<p>Turbo generator model with governor and pm machine.<br>
One-mass model, turbine- and generator-rotor represent one single rigid mass.<br>
The machine inertia is determined by the inertia time constant H.</p>
</html>
"), Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-90,10},{-20,30},{-20,-32},{-90,-10},{-90,10}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}));
  end TurboPMgenerator;

  model PMgenerator "Generator inverter time-average"
    extends Partials.GenBase_ctrl(heat_adapt(final m={2,inverter.heat.m}));

    replaceable model Generator =
      PowerSystems.AC3ph.Machines.Synchron3rd_pm_ctrl
        "synchron pm generator" annotation (choices(
        choice(redeclare model Generator =
          PowerSystems.AC3ph.Machines.Synchron3rd_pm_ctrl "3rd order"),
        choice(redeclare model Generator =
          PowerSystems.AC3ph.Machines.Synchron_pm_ctrl "nth order")));
    Generator generator "synchron pm generator"
      annotation (Placement(transformation(extent={{40,-10},{20,10}})));
    replaceable model Inverter = PowerSystems.AC3ph.Inverters.InverterAverage
      constrainedby PowerSystems.AC3ph.Inverters.Partials.AC_DC_base
      "inverter (average or modulated)" annotation (choices(
      choice(redeclare model Invertoer =
        PowerSystems.AC3ph.Inverters.InverterAverage "inverter time-average"),
      choice(redeclare model Invertoer = PowerSystems.AC3ph.Inverters.Inverter
            "inverter with modulator")));
    Inverter inverter "inverter (average or modulated)"
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));

  equation
    connect(rotor.flange_b, generator.airgap) annotation (Line(points={{0,0},{
            10,0},{10,6},{30,6}}, color={0,0,0}));
    connect(generator.term, inverter.AC)
      annotation (Line(points={{40,0},{60,0}}, color={0,120,120}));
    connect(inverter.DC, term)
      annotation (Line(points={{80,0},{100,0}}, color={0,0,255}));
    connect(generator.heat, heat_adapt.port_a) annotation (Line(points={{30,10},
            {30,54},{-4,54},{-4,64}}, color={176,0,0}));
    connect(inverter.heat, heat_adapt.port_b) annotation (Line(points={{70,10},
            {70,64},{4,64}}, color={176,0,0}));
    connect(generator.phiRotor, inverter.theta)   annotation (Line(points={{20,
            10},{14,10},{14,20},{86,20},{86,10},{76,10}}, color={0,0,127}));
    connect(generator.vPhasor,inverter.vPhasor)
      annotation (Line(points={{40,10},{64,10}}, color={0,0,127}));
    connect(generator.i_meas, i_meas)       annotation (Line(points={{36,10},{
            36,40},{60,40},{60,100}}, color={0,0,127}));
    connect(i_act, generator.i_act)       annotation (Line(points={{-60,100},{
            -60,40},{24,40},{24,10}}, color={0,0,127}));
    annotation (
      defaultComponentName="pmGen_ctrl",
      Documentation(info="<html>
<p>Generator with pm excitation and inverter for current-control. To be coupled to a mechanical engine. May contain a gear.</p>
<p>Note: for machines with gear <tt>w_start</tt> denotes the initial angular velocity at the generator-side!</p>
</html>
"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{-50,14},{-40,-14}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-50,46},{-40,14}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-40,3},{-20,-3}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215}),
          Rectangle(
            extent={{-70,33},{-50,27}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215}),
          Rectangle(
            extent={{-80,40},{-70,20}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-80,20},{-70,-20}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={175,175,175}),
          Rectangle(
            extent={{-100,10},{-80,-10}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={215,215,215})}));
  end PMgenerator;

  model WindGenerator "Wind generator"
    extends Partials.GenBase;

    parameter SI.AngularVelocity w_start=2*pi*generator.par.f_nom/generator.par.pp
      "initial angular velocity (start-value if ini='st')";
    AC3ph.Ports.ACdq0_n term "negative terminal"
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    replaceable model Generator = PowerSystems.AC3ph.Machines.Asynchron
      "asynchron generator" annotation (choicesAllMatching=true);
    Generator generator "asynchron generator"
      annotation (Placement(transformation(extent={{60,-10},{40,10}})));
    replaceable model Torque = PowerSystems.Mechanics.TurboGroups.WindTabTorque
        (
      final w_nom=WT.par.w_nom, final P_nom=WT.par.P_nom)
      "table: wind speed, torque" annotation(choicesAllMatching=true);
    Torque turbTorq "table: wind speed, torque"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    replaceable model Gear =
      PowerSystems.Mechanics.TurboGroups.WindTurbineGear(final w_start= w_start)
      "wind turbine with generator-rotor" annotation(choicesAllMatching=true);
    Gear WT "wind turbine with generator-rotor"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.RealInput windSpeed "wind speed m/s"
    annotation (Placement(transformation(extent={{-110,10},{-90,-10}})));
  equation
    connect(windSpeed, turbTorq.windSpeed)
    annotation (Line(points={{-100,0},{-60,0}}, color={0,0,127}));
    connect(turbTorq.blades, WT.blades[1])
    annotation (Line(points={{-40,6},{-10,6}}, color={0,0,0}));
    connect(WT.airgap, generator.airgap)
    annotation (Line(points={{10,6},{50,6}}, color={0,0,0}));
    connect(generator.term, term)
    annotation (Line(points={{60,0},{100,0}}, color={0,120,120}));
    connect(generator.heat, heat) annotation (Line(points={{50,10},{50,40},{0,
            40},{0,100}}, color={176,0,0}));
  annotation (defaultComponentName = "windGen1",
    Documentation(
            info="<html>
<p>Wind generator.<br>
Turbine with gear and generator-rotor, elastically coupled, asynchronous generator.</p>
<p>Note: for turbines with gear <tt>w_start</tt> denotes the initial angular velocity at the generator-side!</p>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Polygon(
            points={{-55,-120},{-55,120},{-47,80},{-39,40},{-39,20},{-43,6},{-55,
                0},{-67,-6},{-71,-20},{-71,-40},{-65,-80},{-55,-120}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end WindGenerator;

  package Partials "Partial models"
    partial model GenBase0 "Generation base"

      Interfaces.ThermalV_n heat(m=2) "heat source port {stator, rotor}"
        annotation (Placement(transformation(
            origin={0,100},
            extent={{-10,-10},{10,10}},
            rotation=90)));
    protected
      outer System system;

    annotation (
        Documentation(
        info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Rectangle(
              extent={{-100,80},{90,-80}},
              lineColor={95,95,95},
              fillColor={184,189,116},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{88,54},{-20,-54}},
              lineColor={95,95,95},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-20,0},{88,0}},
              color={176,0,0},
              thickness=0.5),
            Text(
              extent={{-16,30},{84,-70}},
              lineColor={176,0,0},
              lineThickness=0.5,
              fillColor={127,0,255},
              fillPattern=FillPattern.Solid,
              textString="~"),
            Text(
              extent={{-100,-90},{100,-130}},
              lineColor={0,0,0},
              textString="%name")}));
    end GenBase0;
    extends Modelica.Icons.BasesPackage;

    partial model GenBase "Generation base"
      extends GenBase0;

      AC3ph.Ports.ACdq0_n term "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));
      annotation(Documentation(
        info="<html>
</html>"));
    end GenBase;

    partial model GenBase_el "Generation base el, synchron machines"
      extends GenBase;

      parameter SI.AngularVelocity w_start=2*pi*generator.par.f_nom/generator.par.pp
        "initial angular velocity (start-value if steady-state)"
        annotation (Dialog(tab="Initialization"));
      parameter Types.Init initType=PowerSystems.Types.Init.v_alpha
        "initialisation type (if steady-state)"
        annotation (Dialog(tab="Initialization"));
      parameter SIpu.Voltage v_start(unit="1")=1 "initial terminal voltage"
        annotation(Dialog(enable=initType == PowerSystems.Types.Init.v_alpha
               or initType == PowerSystems.Types.Init.v_p or initType ==
              PowerSystems.Types.Init.v_q, tab="Initialization"));
      parameter SI.Angle alpha_start=system.alpha0 "initial voltage phase angle"
        annotation(Dialog(enable=initType == PowerSystems.Types.Init.v_alpha,
          tab="Initialization"));
      parameter SIpu.Power p_start(unit="1")=1 "initial terminal active power"
        annotation(Dialog(enable=initType == PowerSystems.Types.Init.v_p
               or initType == PowerSystems.Types.Init.p_q, tab="Initialization"));
      parameter SIpu.Power q_start(unit="1")=1 "initial terminal reactive power"
        annotation(Dialog(enable=initType == PowerSystems.Types.Init.v_q
               or initType == PowerSystems.Types.Init.p_q, tab="Initialization"));
      parameter Boolean dispPA=false "display power angle"
        annotation(Evaluate=true);
      AC3ph.Ports.ACdq0_n term "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));
      Modelica.Blocks.Interfaces.RealInput[3] setpts
        "setpoints {speed, power, voltage} pu"
        annotation (Placement(transformation(extent={{-110,10},{-90,-10}})));
      replaceable model Generator = PowerSystems.AC3ph.Machines.Synchron3rd_ee
        "synchron generator" annotation (choices(
        choice(redeclare model Generator =
                PowerSystems.AC3ph.Machines.Synchron3rd_ee "3rd order"),
        choice(redeclare model Generator =
                PowerSystems.AC3ph.Machines.Synchron_ee "nth order")));
      Generator generator "synchron generator"
        annotation (Placement(transformation(extent={{60,-10},{40,10}})));

      replaceable model Exciter = Control.Exciters.ExciterConst
        "exciter (control)"
        annotation (choices(
        choice(redeclare model Exciter = Control.Exciters.ExciterConst
              "constant"),
        choice(redeclare model Exciter = Control.Exciters.Exciter1st
              "1st order")));
      Exciter exciter "exciter (control)"
        annotation (Placement(transformation(extent={{60,50},{40,70}})));

      replaceable model Excitation =
          PowerSystems.AC3ph.Machines.Control.Excitation (
        V_nom = generator.par.V_nom, Vf_nom = generator.Vf_nom)
        "exciter (electric)" annotation(choicesAllMatching=true);
      Excitation excitation "exciter (electric)"
        annotation (Placement(transformation(extent={{60,20},{40,40}})));

      replaceable model Governor = PowerSystems.Control.Governors.GovernorConst
        "governor (control)" annotation (choices(
        choice(redeclare model Governor =
                PowerSystems.Control.Governors.GovernorConst "constant"),
        choice(redeclare model Governor =
                PowerSystems.Control.Governors.Governor1st "1st order")));
      Governor governor "governor (control)"
        annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

      parameter SI.Time H=10 "inertia cst turb + gen";
    protected
      final parameter SI.AngularVelocity w_nom=2*pi*generator.par.f_nom/generator.par.pp
        "nominal angular velocity";
      Interfaces.Sender sender(w=generator.w_el, H=H)
        "sends weighted frequency"
        annotation (Placement(transformation(extent={{80,80},{100,100}})));
      function atan2 = Modelica.Math.atan2;

    initial equation
      if initType == PowerSystems.Types.Init.v_alpha then
        sqrt(term.v[1:2]*term.v[1:2]) = v_start*generator.par.V_nom;
        atan2(term.v[2], term.v[1]) = alpha_start;
      elseif initType == PowerSystems.Types.Init.v_p then
        sqrt(term.v[1:2]*term.v[1:2]) = v_start*generator.par.V_nom;
        -term.v[1:2]*term.i[1:2] = p_start*generator.par.S_nom;
      elseif initType == PowerSystems.Types.Init.v_q then
        sqrt(term.v[1:2]*term.v[1:2]) = v_start*generator.par.V_nom;
        -{term.v[2],-term.v[1]}*term.i[1:2] = q_start*generator.par.S_nom;
      elseif initType == PowerSystems.Types.Init.p_q then
        -term.v[1:2]*term.i[1:2] = p_start*generator.par.S_nom;
        -{term.v[2],-term.v[1]}*term.i[1:2] = q_start*generator.par.S_nom;
      end if;

    equation
      if initType == PowerSystems.Types.Init.v_alpha then
        Connections.potentialRoot(term.theta);
      end if;
      if Connections.isRoot(term.theta) then
        term.theta = if system.synRef then {0, system.theta} else {system.theta, 0};
      end if;
      connect(sender.sendFreq, system.receiveFreq);
      connect(term, generator.term)
        annotation (Line(points={{100,0},{80,0},{80,0},{60,0}}, color={0,130,
              175}));
      connect(exciter.fieldVoltage,excitation.fieldVoltage) annotation (Line(
            points={{44,50},{44,40}}, color={0,0,127}));
      connect(excitation.termVoltage, exciter.termVoltage)
                                                          annotation (Line(
            points={{56,40},{56,50}}, color={0,0,127}));
      connect(setpts[1], governor.setptSpeed) annotation (Line(points={{-100,
              6.66667},{-88,6.66667},{-88,64},{-60,64}}, color={0,0,127}));
      connect(setpts[2], governor.setptPower) annotation (Line(points={{-100,
              -4.44089e-016},{-80,-4.44089e-016},{-80,56},{-60,56}}, color={0,0,
              127}));
      connect(setpts[3], exciter.setptVoltage) annotation (Line(points={{-100,
              -6.66667},{-70,-6.66667},{-70,80},{70,80},{70,60},{60,60}}, color=
             {0,0,127}));
      connect(generator.term, excitation.term) annotation (Line(points={{60,0},
              {80,0},{80,30},{60,30}}, color={0,120,120}));
      connect(excitation.field, generator.field)
        annotation (Line(points={{60,26},{76,26},{76,-4},{60,-4}}, color={0,0,
              255}));
      connect(generator.heat, heat) annotation (Line(points={{50,10},{50,16},{0,
              16},{0,100}}, color={176,0,0}));
      annotation (
        Documentation(
              info="<html>
<p>
Setpoint values for turbine-speed, -power and terminal-voltage are determined through the input-connector 'setpts' (see also 'governor' and 'exciter').
<pre>
  setpts[1]:     turbine speed pu
  setpts[2]:     turbine power pu
  setpts[3]:     terminal voltage-norm pu
</pre>
<p>
Constant setpoint values can be obtained at (steady-state) initialisation when using Control.CstSetpointsGen.</p>
</html>"));
    end GenBase_el;

    partial model GenBase_ctrl "Generation base pm, synchronous machines"
      extends GenBase0(heat(final m=sum(heat_adapt.m)));

      parameter SI.AngularVelocity w_start=0
        "initial rpm (start-value if steady init)"
        annotation(Dialog(tab="Initialization"));
      Interfaces.Rotation_p flange    annotation (Placement(transformation(
              extent={{-110,-10},{-90,10}})));
      AC1ph_DC.Ports.TwoPin_n term "negative terminal"
        annotation (Placement(transformation(extent={{90,-10},{110,10}})));
      Common.Thermal.HeatV_a_b_ab heat_adapt annotation (Placement(
            transformation(extent={{-10,60},{10,80}})));
      replaceable model Gear = PowerSystems.Mechanics.Rotational.NoGear
        "type of gear"
        annotation (choices(
          choice(redeclare model Gear = PowerSystems.Mechanics.Rotational.Joint
              "no gear"),
          choice(redeclare model Gear =
                PowerSystems.Mechanics.Rotational.GearNoMass
                                                           "massless gear"),
          choice(redeclare model Gear = PowerSystems.Mechanics.Rotational.Gear
              "massive gear")));
      Gear gear "type of gear"
        annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

      replaceable model Rotor = PowerSystems.Mechanics.Rotational.Rotor (
        w(start=w_start)) "rotor generator" annotation(choicesAllMatching=true);
      Rotor rotor "rotor generator"
        annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

      Modelica.Blocks.Interfaces.RealOutput[2] i_meas(each final unit="1")
        "measured current {i_d, i_q} pu"
        annotation (Placement(transformation(
            origin={60,100},
            extent={{-10,-10},{10,10}},
            rotation=90)));
      Modelica.Blocks.Interfaces.RealInput[2] i_act(each final unit="1")
        "actuated current {i_d, i_q} pu"
        annotation (Placement(transformation(
            origin={-60,100},
            extent={{10,-10},{-10,10}},
            rotation=90)));

    equation
      connect(heat_adapt.port_ab, heat)
        annotation (Line(points={{0,76},{0,100}}, color={176,0,0}));
      connect(flange,gear.flange_a)
        annotation (Line(points={{-100,0},{-60,0}}, color={0,0,0}));
      connect(gear.flange_b,rotor.flange_a)
        annotation (Line(points={{-40,0},{-20,0}}, color={0,0,0}));
      annotation (
        Documentation(
              info="<html>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
              extent={{-90,112},{90,88}},
              lineColor={0,0,127},
              fillColor={170,213,255},
              fillPattern=FillPattern.Solid)}));
    end GenBase_ctrl;

  end Partials;

  annotation (preferredView="info",
Documentation(info="<html>
<p>Combined turbine-generator systems with governor and exciter, both electrical and mechanical model.</p>
<p>Heat ports must be connected. In cases where they are not needed, use 'Common.Thermal.BdCond(V)'.</p><p><a <p><a href=\"modelica://PowerSystems.UsersGuide.Overview\">up users guide</a></p>
</html>
"));
end Generation;
