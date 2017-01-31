within PowerSystems.Examples;
package Introductory "Introductory examples for overall concepts"
  extends Modelica.Icons.ExamplesPackage;

  model Units "SI and pu units"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.Voltage voltage_SI(v0=408)
      annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV1
      annotation (Placement(transformation(extent={{-70,10},{-90,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage_pu(V_nom=400, v0=1.02)
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV2
      annotation (Placement(transformation(extent={{-70,-30},{-90,-10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter_SI
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter_pu(V_nom=400, S_nom=10e3)
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
    PowerSystems.AC3ph.Impedances.Resistor load_SI(r=20)
      annotation (Placement(transformation(extent={{20,10},{40,30}})));
    PowerSystems.AC3ph.Impedances.Resistor load_pu(
      V_nom=400,
      S_nom=10e3,
      r=1.25) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
    PowerSystems.AC3ph.Nodes.Ground grd1
      annotation (Placement(transformation(extent={{50,10},{70,30}})));
    PowerSystems.AC3ph.Nodes.Ground grd2
      annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  equation
    connect(voltage_SI.term, meter_SI.term_p)
      annotation (Line(points={{-40,20},{-20,20}}, color={0,130,175}));
    connect(meter_SI.term_n, load_SI.term_p)
      annotation (Line(points={{0,20},{20,20}}, color={0,130,175}));
    connect(load_SI.term_n, grd1.term)
      annotation (Line(points={{40,20},{50,20}}, color={0,130,175}));
    connect(voltage_pu.term, meter_pu.term_p)
      annotation (Line(points={{-40,-20},{-20,-20}}, color={0,130,175}));
    connect(meter_pu.term_n, load_pu.term_p)
      annotation (Line(points={{0,-20},{20,-20}}, color={0,130,175}));
    connect(load_pu.term_n, grd2.term)
      annotation (Line(points={{40,-20},{50,-20}}, color={0,130,175}));
    connect(grdV1.term, voltage_SI.neutral)
      annotation (Line(points={{-70,20},{-60,20}}, color={0,0,255}));
    connect(grdV2.term, voltage_pu.neutral)
      annotation (Line(points={{-70,-20},{-60,-20}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>This example shows, how input-parameters can be defined in SI- or in pu-units (V, A or 'per unit').<br>
Values are scaled with the respective nominal values. Parameters are scaled if 'puUnits = true'.
<pre>
  SI:     base-values = 1
  pu:     base-values = nominal-values (by definition)
</pre></p>
<p>
Upper part:<br>
input for 'voltage_SI', 'meter_SI' and 'load_SI' in V, VA, and Ohm.
<pre>
  V_base = 1,     V_nom = 400 V
  S_base = 1,     S_nom = 10 kVA
  R_base = 1
</pre>
Lower part:<br>
input for 'voltage_pu', 'meter_pu' and 'load_pu' in pu.
<pre>
  V_base = V_nom = 400 V
  S_base = S_nom = 10 kVA
  R_base = V_base^2/S_base = 16 Ohm
</pre>
The corresponding values are
<pre>
  408 V   and  1.02 pu
  20 Ohm  and  1.25 pu
</pre>
Quantities in 'meter_SI' are displayed in SI.<br>
Quantities in 'meter_pu' are displayed in pu.</p>
<p>
<i>See for example:</i>
<pre>
  meter_SI.p[1] = 8323.2 W   (active power in SI)
  meter_pu.p[1] = 0.83232 pu (active power in pu)
</pre>
and other meter-signals.</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.1),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Units;

  model Frequency "System and autonomous frequency"

    inner PowerSystems.System system(f_nom=60, refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientFreq theta_dq0(f_end=50, f_start=10)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage1(v0eff=230)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grdV1
      annotation (Placement(transformation(extent={{-50,20},{-70,40}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage2(v0eff=230, fType=
          PowerSystems.Types.SourceFrequency.Signal)
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grdV2
      annotation (Placement(transformation(extent={{-50,-40},{-70,-20}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor ind1(
      x=0.2,
      r=0.5,
      f_nom=700)
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor ind2(x=0.2, r=0.5)
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter1
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter2
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  equation
    connect(voltage1.term, meter1.term_p)
      annotation (Line(points={{-20,30},{0,30}}, color={0,0,255}));
    connect(meter1.term_n, ind1.term)
      annotation (Line(points={{20,30},{40,30}}, color={0,0,255}));
    connect(voltage2.term, meter2.term_p)
      annotation (Line(points={{-20,-30},{0,-30}}, color={0,0,255}));
    connect(meter2.term_n, ind2.term)
      annotation (Line(points={{20,-30},{40,-30}}, color={0,0,255}));
    connect(grdV1.term, voltage1.neutral)
      annotation (Line(points={{-50,30},{-40,30}}, color={0,0,255}));
    connect(grdV2.term, voltage2.neutral)
      annotation (Line(points={{-50,-30},{-40,-30}}, color={0,0,255}));
    connect(theta_dq0.y, voltage2.omega_in) annotation (Line(points={{-60,-10},
            {-36,-10},{-36,-20}}, color={0,0,127}));
    annotation (
      Documentation(info="<html>
<p>Example of two frequency-independent parts, one with system- and one with autonomous frequency.</p>
<p>The input 'omega_in' of voltage2 is connected to a signal source and the parameter <tt>fType</tt> is set to <tt>\"Signal\"</tt>. The source delivers an angular frequency <tt>omega</tt> which is independent of the actual system frequency.</p>
<p>Note: the 'dynType'-parameter in 'system' only influences AC3ph components.</p>
<p>
<i>See for example:</i>
<pre>
  meter1     v and i-signal, system frequency (60 Hz)
  meter2     v and i-signal, variable frequency (10 to 50 Hz)
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=1, Interval=1e-3),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end Frequency;

  model ReferenceInertial "Inertial reference system (non rotating)"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial,
        refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.Sources.Voltage voltage_dq0(V_nom=400, v0=1.02)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV_dq0
      annotation (Placement(transformation(extent={{-70,-20},{-90,0}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter_dq0(V_nom=400, S_nom=10e3)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC3ph.Impedances.Imped_RXX load_dq0(
      V_nom=400,
      S_nom=10e3,
      r=0.1) annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    PowerSystems.AC3ph.Nodes.Ground grd_dq0
      annotation (Placement(transformation(extent={{50,-20},{70,0}})));

  equation
    connect(voltage_dq0.term, meter_dq0.term_p)
      annotation (Line(points={{-40,-10},{-20,-10}}, color={0,120,120}));
    connect(meter_dq0.term_n, load_dq0.term_p)
      annotation (Line(points={{0,-10},{20,-10}}, color={0,120,120}));
    connect(load_dq0.term_n, grd_dq0.term)
      annotation (Line(points={{40,-10},{50,-10}}, color={0,120,120}));
    connect(grdV_dq0.term, voltage_dq0.neutral)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>This example shows a system in the inertial, non rotating reference frame (<tt>refType=Inertial</tt>).
Signals oscillate with the source frequency.</p>
<p>
<i>See for example:</i>
<pre>
  meter_dq0.i     standard notation: 'alpha beta gamma'-system
</pre>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.1, Interval=0.1e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,40}})));
  end ReferenceInertial;

  model ReferenceSynchron "Synchronous reference system (rotating)"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
    PowerSystems.AC3ph.Sources.Voltage voltage_dq0(V_nom=400, v0=1.02)
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV_dq0
      annotation (Placement(transformation(extent={{-70,-30},{-90,-10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter_dq0(
      V_nom=400,
      S_nom=10e3,
      abc=true)
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
    PowerSystems.AC3ph.Impedances.Imped_RXX load_dq0(
      V_nom=400,
      S_nom=10e3,
      r=0.1) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
    PowerSystems.AC3ph.Nodes.Ground grd_dq0
      annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  equation
    connect(voltage_dq0.term, meter_dq0.term_p)
      annotation (Line(points={{-40,-20},{-20,-20}}, color={0,120,120}));
    connect(meter_dq0.term_n, load_dq0.term_p)
      annotation (Line(points={{0,-20},{20,-20}}, color={0,120,120}));
    connect(load_dq0.term_n, grd_dq0.term)
      annotation (Line(points={{40,-20},{50,-20}}, color={0,120,120}));
    connect(grdV_dq0.term, voltage_dq0.neutral)
      annotation (Line(points={{-70,-20},{-60,-20}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>This example shows a system in the synchronous, rotating reference frame (<tt>refType=Synchron</tt>).
Stationary signals are constant after an initial oscillation.</p>
<p>
<i>See for example:</i>
<pre>
  meter_dq0.i     standard notation: 'dq0'-system
</pre>
<p>Compare with <tt>meter_dq0.i_abc</tt>, showing oscillating stationary signals.</p><br>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.1, Interval=0.1e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,20}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,20}})));
  end ReferenceSynchron;

  model InitialSteadyState "Steady-state initialisation"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
    PowerSystems.AC3ph.Sources.Voltage voltage_dq0(V_nom=400, v0=1.02)
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV_dq0
      annotation (Placement(transformation(extent={{-70,-30},{-90,-10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter_dq0(
      V_nom=400,
      S_nom=10e3,
      abc=true)
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
    PowerSystems.AC3ph.Impedances.Imped_RXX load_dq0(
      V_nom=400,
      S_nom=10e3,
      r=0.1) annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
    PowerSystems.AC3ph.Nodes.Ground grd_dq0
      annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  equation
    connect(voltage_dq0.term, meter_dq0.term_p)
      annotation (Line(points={{-40,-20},{-20,-20}}, color={0,120,120}));
    connect(meter_dq0.term_n, load_dq0.term_p)
      annotation (Line(points={{0,-20},{20,-20}}, color={0,120,120}));
    connect(load_dq0.term_n, grd_dq0.term)
      annotation (Line(points={{40,-20},{50,-20}}, color={0,120,120}));
    connect(grdV_dq0.term, voltage_dq0.neutral)
      annotation (Line(points={{-70,-20},{-60,-20}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>With 'system.dynType = SteadyInitial' (using the steady-state initial conditions) no inrush is observed as in the previous two examples. The solution is steady-state from the beginning.</p>
<p>The example illustrates the choice <tt>refType=Inertial</tt>, but is valid for other choices too.</p>
<p>
<i>See for example:</i>
<pre>
  meter_dq0.i_abc
</pre>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.1, Interval=0.1e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,20}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,20}})));
  end InitialSteadyState;

  model SimulationFixedInitial
    "Transient simulation with fixed initial conditions"

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      a_start=1.14,
      a_end=1.0865,
      t_duration=0.8,
      ph_start=0.32114058236696,
      ph_end=0.16667894356546)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.Voltage voltageL(V_nom=400e3, use_vPhasor_in=
          true)
      annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdL
      annotation (Placement(transformation(extent={{-80,20},{-100,40}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.AC3ph.Lines.RXline lineR(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=0.02e-3,
          x=0.25e-3))
      annotation (Placement(transformation(extent={{30,20},{50,40}})));
    PowerSystems.AC3ph.Lines.RXline lineL(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=0.02e-3,
          x=0.25e-3))
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    PowerSystems.AC3ph.Sources.Voltage voltageR(V_nom=400e3)
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdR
      annotation (Placement(transformation(extent={{90,20},{110,40}})));
    PowerSystems.AC3ph.Breakers.ForcedSwitch switch(V_nom=400e3, I_nom=5e3)
      annotation (Placement(transformation(
          origin={20,-10},
          extent={{-10,10},{10,-10}},
          rotation=270)));
    PowerSystems.Control.Relays.SwitchRelay relayNet(
      n=1,
      ini_state=true,
      t_switch={0.4,0.6})
      annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
    PowerSystems.AC3ph.Lines.RXline lineB(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=0.02e-3,
          x=0.25e-3)) annotation (Placement(transformation(
          origin={20,-40},
          extent={{-10,10},{10,-10}},
          rotation=270)));
    PowerSystems.AC3ph.Sources.Voltage voltageB(V_nom=400e3) annotation (
        Placement(transformation(
          origin={20,-71},
          extent={{-10,-10},{10,10}},
          rotation=90)));
    PowerSystems.AC3ph.Nodes.GroundOne grdB annotation (Placement(
          transformation(
          origin={20,-100},
          extent={{-10,10},{10,-10}},
          rotation=270)));

  equation
    connect(relayNet.y, switch.control)
      annotation (Line(points={{-10,-10},{10,-10}}, color={255,0,255}));
    connect(voltageL.term, meter.term_p)
      annotation (Line(points={{-50,30},{-40,30}}, color={0,110,110}));
    connect(meter.term_n, lineL.term_p)
      annotation (Line(points={{-20,30},{-10,30}}, color={0,110,110}));
    connect(lineL.term_n, switch.term_p)
      annotation (Line(points={{10,30},{20,30},{20,0}}, color={0,110,110}));
    connect(switch.term_p, lineR.term_p)
      annotation (Line(points={{20,0},{20,30},{30,30}}, color={0,110,110}));
    connect(lineR.term_n, voltageR.term)
      annotation (Line(points={{50,30},{60,30}}, color={0,110,110}));
    connect(switch.term_n, lineB.term_p)
      annotation (Line(points={{20,-20},{20,-30}}, color={0,110,110}));
    connect(lineB.term_n, voltageB.term)
      annotation (Line(points={{20,-50},{20,-61}}, color={0,110,110}));
    connect(transPh.y, voltageL.vPhasor_in)
      annotation (Line(points={{-80,50},{-54,50},{-54,40}}, color={0,0,127}));
    connect(grdL.term, voltageL.neutral)
      annotation (Line(points={{-80,30},{-70,30}}, color={0,0,255}));
    connect(voltageR.neutral, grdR.term)
      annotation (Line(points={{80,30},{90,30}}, color={0,0,255}));
    connect(grdB.term, voltageB.neutral)
      annotation (Line(points={{20,-90},{20,-81}}, color={0,0,255}));
    annotation (Documentation(info="<html>
<p>With 'system.dynType = FixedInitial' an inrush is observed at initial time.
Fast dynamics are resolved after switching.</p>
<p>
<i>See for example:</i>
<pre>
  meter.p[1]  active power in pu, changing from 0.5 (1000 MW) to 0.25 (500 MW)
  meter.p[2]  reactive power in pu, from 0.25 (500 MW) to 0.125 (250 MW)
</pre>
and other meter-signals.</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>
"), experiment(StopTime=1, Interval=1e-3));
  end SimulationFixedInitial;

  model SimulationSteadyInitial
    extends SimulationFixedInitial(system(dynType=PowerSystems.Types.Dynamics.SteadyInitial));
    annotation (Documentation(info="<html>
<p>With 'system.dynType = SteadyInitial' fast dynamics are resolved after switching.</p>
<p>
<i>See for example:</i>
<pre>
  meter.p[1]  active power in pu, changing from 0.5 (1000 MW) to 0.25 (500 MW)
  meter.p[2]  reactive power in pu, from 0.25 (500 MW) to 0.125 (250 MW)
</pre>
and other meter-signals.</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>
"), experiment(StopTime=1, Interval=1e-3));
  end SimulationSteadyInitial;

  model SimulationSteadyState "Steady-state simulation"
    extends SimulationFixedInitial(system(dynType=PowerSystems.Types.Dynamics.SteadyState));
    annotation (Documentation(info="<html>
<p>With 'system.dynType = SteadyState' transients are suppressed and only slow dynamics, imposed by the source-voltage is resolved.<br>
This quasi-stationary approximation corresponds to an infinitely fast response of the system.</p>
<p>
<i>See for example:</i>
<pre>
  meter.p[1]  active power in pu, changing from 0.5 (1000 MW) to 0.25 (500 MW)
  meter.p[2]  reactive power in pu, from 0.25 (500 MW) to 0.125 (250 MW)
</pre>
and other meter-signals.</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>
"), experiment(StopTime=1, Interval=1e-3));
  end SimulationSteadyState;

  model Display "Display of phasors and power"

    inner PowerSystems.System system(f=50)
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      a_end=1.2,
      ph_start=-pi,
      ph_end=pi,
      a_start=0.7,
      t_change=15,
      t_duration=30)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltageL(
      V_nom=400,
      use_vPhasor_in=true,
      alpha0=0.10035643198967)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV1
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.AC3ph.Sensors.Phasor phasor_ind(V_nom=400, S_nom=10e3)
      annotation (Placement(transformation(extent={{-30,20},{10,60}})));
    PowerSystems.AC3ph.Impedances.Imped_RXX ind(
      V_nom=400,
      S_nom=10e3,
      x_m=0.5,
      x_s=2,
      r=1) annotation (Placement(transformation(extent={{20,30},{40,50}})));
    PowerSystems.AC3ph.Sources.Voltage voltageR(V_nom=400)
      annotation (Placement(transformation(extent={{80,30},{60,50}})));
    PowerSystems.AC3ph.Nodes.GroundOne grdV2
      annotation (Placement(transformation(extent={{90,30},{110,50}})));
    PowerSystems.AC3ph.Sensors.Phasor phasor_cap(V_nom=400, S_nom=10e3)
      annotation (Placement(transformation(extent={{-30,-60},{10,-20}})));
    PowerSystems.AC3ph.Impedances.Capacitor cap(
      V_nom=400,
      S_nom=10e3,
      g=0.1,
      b=1) annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
    PowerSystems.AC3ph.Nodes.Ground grd
      annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
    PowerSystems.AC3ph.Impedances.Resistor res(
      V_nom=400,
      S_nom=10e3,
      r=0.5) annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  equation
    connect(transPh.y, voltageL.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltageL.term, phasor_ind.term_p) annotation (Line(points={{-50,0},
            {-40,0},{-40,40},{-30,40}}, color={0,120,120}));
    connect(phasor_ind.term_n, ind.term_p)
      annotation (Line(points={{10,40},{20,40}}, color={0,120,120}));
    connect(ind.term_n, voltageR.term)
      annotation (Line(points={{40,40},{60,40}}, color={0,120,120}));
    connect(voltageL.term, phasor_cap.term_p) annotation (Line(points={{-50,0},
            {-40,0},{-40,-40},{-30,-40}}, color={0,120,120}));
    connect(phasor_cap.term_n, res.term_p)
      annotation (Line(points={{10,-40},{20,-40}}, color={0,120,120}));
    connect(res.term_n, cap.term_p)
      annotation (Line(points={{40,-40},{50,-40}}, color={0,120,120}));
    connect(cap.term_n, grd.term)
      annotation (Line(points={{70,-40},{80,-40}}, color={0,120,120}));
    connect(grdV1.term, voltageL.neutral)
      annotation (Line(points={{-80,0},{-70,0}}, color={0,0,255}));
    connect(voltageR.neutral, grdV2.term)
      annotation (Line(points={{80,40},{90,40}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>The example shows the use of a display element for voltage and current 'phasors' with additional power bars.</p>
<p>The phase of 'voltageL' moves in positive sense with increasing amplitude.<br>
Inductive current (blue) is behind, capacitive ahead of voltage (red).</p>
<p>
The left bar (green) displays the active power,<br>
the right bar (violet) displays the reactive power.<br>
An additional arrow indicates the direction of active power flow.</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"),
      experiment(StopTime=30, Interval=0.02),
      Diagram(coordinateSystem(extent={{-100,-80},{100,80}})),
      Icon(coordinateSystem(extent={{-100,-80},{100,80}})));
  end Display;

  model Tables "Using tables"

    parameter Integer icol[:]={2,3} "{2nd column, 3rd column}";
    Real u "1st column";
    Real y[size(icol, 1)] "values of chosen columns";
    Modelica.Blocks.Tables.CombiTable1Ds table(
      columns=icol,
      tableOnFile=true,
      tableName="values",
      fileName=TableDir + "TableExample.tab")
      annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

  equation
    u = 10*time "for plotting, time = {0, 1}";

    table.u = u;
    y = table.y;
    annotation (Documentation(info="<html>
<p>The example shows the use of a table.<br>
Interpolates table-values.</p>
<pre>
  u     argument
  y     values(argument)
</pre>
<p>
<i>plot:</i>
<pre>
  y[1] against u     linear curve
  y[2] against u     quadratic curve
</pre>
(choose  u as 'independent variable', right mouse)</p>
<p><a href=\"modelica://PowerSystems.Examples.Introductory\">up users guide</a></p>
</html>"), experiment(StopTime=1));
  end Tables;

  annotation (preferredView="info", Documentation(info="<html>
<p>Each of the introductory examples points out one specific aspect of specifying and simulating a model.
The examples are based on most elementary configurations. A meter is added for convenience, displaying signals both in abc- and dq0-representation. </p>
<p>The component <a href=\"modelica://PowerSystems.System\">PowerSystems.System</a> is needed in all models for system wide definitions.</p>
<p><a href=\"modelica://PowerSystems.Examples\">up users guide</a></p>
</html>
"));
end Introductory;
