within PowerSystems.Examples.AC3ph;
package Transmission "AC transmission, dq0"
  extends Modelica.Icons.ExamplesPackage;

  model PowerTransfer "Power transfer between two nodes"
    import PowerSystems;

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.SteadyState)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      t_change=30,
      t_duration=60,
      ph_end=2*pi,
      ph_start=0)
      annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(V_nom=130e3, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    PowerSystems.AC3ph.Lines.RXline line(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline, len=100000)
      annotation (Placement(transformation(extent={{18,-10},{38,10}})));
    PowerSystems.AC3ph.Sensors.Psensor powSens
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=130e3)
      annotation (Placement(transformation(extent={{78,-10},{58,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{78,-10},{98,10}})));

  equation
    connect(transPh.y, infBus1.vPhasor_in)
      annotation (Line(points={{-62,20},{-44,20},{-44,10}}, color={0,0,127}));
    connect(infBus1.term, powSens.term_p)
      annotation (Line(points={{-40,0},{-20,0}}, color={0,110,110}));
    connect(powSens.term_n, line.term_p)
      annotation (Line(points={{0,0},{18,0}}, color={0,110,110}));
    connect(line.term_n, infBus2.term)
      annotation (Line(points={{38,0},{58,0}}, color={0,110,110}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-70,0},{-60,0}}, color={0,0,255}));
    connect(grd2.term, infBus2.neutral)
      annotation (Line(points={{78,0},{78,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Shows the influence of phase-difference on power flow.</p>
<p>The theory of power transfer across a RX-line is well known. </p>
<p>For the particular simple case of resistance very low in comparison with reactance it is as follows: </p>
<p><img src=\"modelica://PowerSystems/Examples/AC3ph/PowerTransfer1.png\"/></p>
<p>The maximum active power transfer occurs when <i><span style=\"font-family: Symbol;\">b</span></i>=<i><span style=\"font-family: Symbol;\">p</span></i>/2, and is equal to: <i><span style=\"font-family: Times New Roman;\">P</span></i><sub>max</sub>=<i>UE</i>/<i>X.</i></p>
<p>In this model we have a RX transmission line with the two ends voltages having amplitude equal to the nominal values. </p>
<p>To see results comparable with the above formulas, first change the line resistance from the default value 1e-3 PU/km to 1e-4 PU/km. </p>
<p>Using these values the following results are obtained (p[1] is active power, p[2] is reactive power): </p>
<p><br><img src=\"modelica://PowerSystems/Examples/AC3ph/PowerTransfer2.png\"/></p>
<p><br><br><br><br>If the resistance is modified and set back to its default of 1e-3 PU/km, the curves change as follows: </p><p><br><br><br><br><img src=\"modelica://PowerSystems/Examples/AC3ph/PowerTransfer3.png\"/></p>
<p><br><br>While reactive power remains basically unchanged active power is larger, especially its peak, since the power lost inside the line resistance is added to the transferred power.</p>
<p><br><i>Documentation by Massimo Ceraolo - University of Pisa.</i></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a> </p>
</html>"),
      experiment(StopTime=60),
      Diagram(coordinateSystem(extent={{-100,-20},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,40}})));
  end PowerTransfer;

  model PowerTransferRXY "Power transfer between two nodes"
    import PowerSystems;

    inner PowerSystems.System system(dynType=PowerSystems.Types.Dynamics.SteadyState)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      t_change=30,
      t_duration=60,
      ph_end=2*pi,
      ph_start=0)
      annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(V_nom=130e3, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    PowerSystems.AC3ph.Lines.RXline line(redeclare record Data =
          PowerSystems.Examples.Data.Lines.ItOHline_132kV, len=200000)
      annotation (Placement(transformation(extent={{18,-10},{38,10}})));
    PowerSystems.AC3ph.Sensors.Psensor rxPsens
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=130e3)
      annotation (Placement(transformation(extent={{78,-10},{58,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{78,-10},{98,10}})));

    PowerSystems.AC3ph.Lines.Tline line1(
      ne=1,
      redeclare record Data = PowerSystems.Examples.Data.Lines.ItOHline_132kV,
      len=200000)
      annotation (Placement(transformation(extent={{18,-50},{38,-30}})));
    PowerSystems.AC3ph.Sensors.Psensor rxyPsens
      annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  equation
    connect(transPh.y, infBus1.vPhasor_in)
      annotation (Line(points={{-62,20},{-44,20},{-44,10}}, color={0,0,127}));
    connect(infBus1.term, rxPsens.term_p)
      annotation (Line(points={{-40,0},{-20,0}}, color={0,110,110}));
    connect(rxPsens.term_n, line.term_p)
      annotation (Line(points={{0,0},{18,0}}, color={0,110,110}));
    connect(line.term_n, infBus2.term)
      annotation (Line(points={{38,0},{58,0}}, color={0,110,110}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-70,0},{-60,0}}, color={0,0,255}));
    connect(grd2.term, infBus2.neutral)
      annotation (Line(points={{78,0},{78,0}}, color={0,0,255}));
    connect(rxyPsens.term_n, line1.term_p)
      annotation (Line(points={{0,-40},{0,-40},{18,-40}}, color={0,120,120}));
    connect(line1.term_n, infBus2.term) annotation (Line(points={{38,-40},{48,-40},
            {48,0},{58,0}}, color={0,120,120}));
    connect(rxyPsens.term_p, infBus1.term) annotation (Line(points={{-20,-40},{
            -40,-40},{-40,0}}, color={0,120,120}));
    annotation (
      Documentation(info="<html>
<p>The model AC3ph.Transmission.PowerTransfer refers to a 100 km generic RX line.</p>
<p>This one refers to a longer, 200 km, 132kV line, whose geometry is specified in the line&apos;s documentation.</p>
<p>From the Power System Analysis theory it is known that the RX model gives good results with short lines (say up to 100 km at 50 Hz), while PI line or a T line, with a single PI or T is reasonably good up to 200-250 km.</p>
<p>This model compares the results of the two models using the same line parameters. Differences are significant especially for the reactive power.</p>
<p>It is recommended to simulate PowerTransfer first, and compare the power plots (e.g. those shown in its documentation) with the ones that can be obtained with PowerTransferRXY, comparing RX and T line&apos;s results.</p>
<p>The T line model can be substituted by a PI line model. However this may cause an initialisation problem, since at t=0 we will have, at the two line ends, capacitances directly connected to voltage sources. This is a condition which can not be dealt successfully with by all Modelica tools.</p>
<p><i>Model supplied and commented by Massimo Ceraolo-University of Pisa.</i></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a> </p>
</html>"),
      experiment(StopTime=60),
      Diagram(coordinateSystem(extent={{-100,-60},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,40}})));
  end PowerTransferRXY;

  model VoltageStability "Voltage stability"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    PowerSystems.AC3ph.Sources.InfBus Vsource0(V_nom=400e3, alpha0=0)
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    PowerSystems.AC3ph.Sources.InfBus infBus(V_nom=400e3, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{60,0},{40,20}})));

    PowerSystems.AC3ph.Sensors.Vmeter Vmeter(V_nom=400e3)
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter0(S_nom=100e6)
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    PowerSystems.AC3ph.Lines.RXline line0(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=2e-3,
          x=0.25e-3), len=500e3)
      annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
    PowerSystems.AC3ph.Sources.InfBus Vsource1(V_nom=400e3, alpha0=
          0.087266462599716)
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter1(S_nom=100e6)
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    PowerSystems.AC3ph.Lines.RXline line1(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=2e-3,
          x=0.25e-3), len=500e3)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC3ph.Sources.InfBus Vsource2(V_nom=400e3, alpha0=-0.087266462599716)
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter2(S_nom=100e6)
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    PowerSystems.AC3ph.Lines.RXline line2(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          r=2e-3,
          x=0.25e-3), len=500e3)
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(
      t_change=90,
      t_duration=120,
      a_start=1,
      a_end=0) annotation (Placement(transformation(extent={{90,20},{70,40}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,40},{-100,60}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd4
      annotation (Placement(transformation(extent={{60,0},{80,20}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{-80,0},{-100,20}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd3
      annotation (Placement(transformation(extent={{-80,-40},{-100,-20}})));

  equation
    connect(transPh.y, infBus.vPhasor_in)
      annotation (Line(points={{70,30},{44,30},{44,20}}, color={0,0,127}));
    connect(Vsource0.term, line0.term_p)
      annotation (Line(points={{-60,50},{-40,50}}, color={0,110,110}));
    connect(line0.term_n, meter0.term_p)
      annotation (Line(points={{-20,50},{0,50}}, color={0,110,110}));
    connect(meter0.term_n, infBus.term) annotation (Line(points={{20,50},{30,50},
            {30,10},{40,10}}, color={0,110,110}));
    connect(Vsource1.term, line1.term_p)
      annotation (Line(points={{-60,10},{-40,10}}, color={0,110,110}));
    connect(line1.term_n, meter1.term_p)
      annotation (Line(points={{-20,10},{0,10}}, color={0,110,110}));
    connect(meter1.term_n, infBus.term)
      annotation (Line(points={{20,10},{40,10}}, color={0,110,110}));
    connect(Vsource2.term, line2.term_p)
      annotation (Line(points={{-60,-30},{-40,-30}}, color={0,110,110}));
    connect(line2.term_n, meter2.term_p)
      annotation (Line(points={{-20,-30},{0,-30}}, color={0,110,110}));
    connect(meter2.term_n, infBus.term) annotation (Line(points={{20,-30},{30,-30},
            {30,10},{40,10}}, color={0,110,110}));
    connect(infBus.term, Vmeter.term)
      annotation (Line(points={{40,10},{40,50}}, color={0,110,110}));
    connect(grd1.term, Vsource0.neutral)
      annotation (Line(points={{-80,50},{-80,50}}, color={0,0,255}));
    connect(grd2.term, Vsource1.neutral)
      annotation (Line(points={{-80,10},{-80,10}}, color={0,0,255}));
    connect(grd3.term, Vsource2.neutral)
      annotation (Line(points={{-80,-30},{-80,-30}}, color={0,0,255}));
    connect(infBus.neutral, grd4.term)
      annotation (Line(points={{60,10},{60,10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Power flow between source and infinite bus. The bus-voltage decreases from 1 to 0.
<pre>
  stable:     voltage above extremal point (maximum p[1])
  instable:   voltage below extremal point (maximum p[1])
</pre></p>
<p><i>See for example:</i>
<pre>
  meter1/2/3.v_norm and plot it against
  meter1/2/3.p[1] as independent variable.
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>"),
      experiment(StopTime=180, Interval=180e-3),
      Diagram(coordinateSystem(extent={{-100,-60},{100,100}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,100}})));
  end VoltageStability;

  model RXline "Single lumped line"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(
      V_nom=400e3,
      v0=1.04,
      alpha0=0.5235987755983)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC3ph.Lines.RXline line(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          x=0.25e-3,
          r=0.02e-3), len=400e3)
      annotation (Placement(transformation(extent={{10,-20},{30,0}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=400e3)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.2,0.65})
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.3,0.7})
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-20},{-100,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(relay1.y, switch1.control)
      annotation (Line(points={{-20,30},{-10,30},{-10,0}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{60,30},{50,30},{50,0}}, color={255,0,255}));
    connect(infBus1.term, meter.term_p)
      annotation (Line(points={{-60,-10},{-50,-10}}, color={0,110,110}));
    connect(meter.term_n, switch1.term_p)
      annotation (Line(points={{-30,-10},{-20,-10}}, color={0,110,110}));
    connect(switch1.term_n, line.term_p)
      annotation (Line(points={{0,-10},{10,-10}}, color={0,110,110}));
    connect(line.term_n, switch2.term_p)
      annotation (Line(points={{30,-10},{40,-10}}, color={0,110,110}));
    connect(switch2.term_n, infBus2.term)
      annotation (Line(points={{60,-10},{70,-10}}, color={0,110,110}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-80,-10},{-80,-10}}, color={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Short-time line switched off.<br>
Compare with PIline.</p>
<p><i>See for example:</i>
<pre>  meter.p[1:2]     active and reactive power</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end RXline;

  model Tline "Single PI-line"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(
      V_nom=400e3,
      v0=1.04,
      alpha0=0.5235987755983)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC3ph.Breakers.Breaker breaker1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC3ph.Lines.Tline line(len=400e3, redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.Line (
          V_nom=400e3,
          x=0.25e-3,
          r=0.02e-3))
      annotation (Placement(transformation(extent={{10,-20},{30,0}})));
    PowerSystems.AC3ph.Breakers.Breaker breaker2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=400e3)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.2,0.65})
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.3,0.7})
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-20},{-100,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(relay1.y, breaker1.control)
      annotation (Line(points={{-20,30},{-10,30},{-10,0}}, color={255,0,255}));
    connect(relay2.y, breaker2.control)
      annotation (Line(points={{60,30},{50,30},{50,0}}, color={255,0,255}));
    connect(infBus1.term, meter.term_p)
      annotation (Line(points={{-60,-10},{-50,-10}}, color={0,110,110}));
    connect(meter.term_n, breaker1.term_p)
      annotation (Line(points={{-30,-10},{-20,-10}}, color={0,110,110}));
    connect(breaker1.term_n, line.term_p)
      annotation (Line(points={{0,-10},{10,-10}}, color={0,110,110}));
    connect(line.term_n, breaker2.term_p)
      annotation (Line(points={{30,-10},{40,-10}}, color={0,110,110}));
    connect(breaker2.term_n, infBus2.term)
      annotation (Line(points={{60,-10},{70,-10}}, color={0,110,110}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-80,-10},{-80,-10}}, color={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Short-time line switched off.<br>
Compare with RXline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=1, Interval=2.5e-5),
      Diagram(coordinateSystem(extent={{-100,-40},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,40}})));
  end Tline;

  model FaultRXline "Faulted lumped line"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(
      V_nom=400e3,
      v0=1.04,
      alpha0=0.5235987755983)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC3ph.Lines.FaultRXline line(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (
          V_nom=400e3,
          x=0.25e-3,
          r=0.02e-3), len=400e3)
      annotation (Placement(transformation(extent={{10,-20},{30,0}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=400e3)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.2,0.65})
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.3,0.7})
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc
      annotation (Placement(transformation(extent={{10,14},{30,34}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-20},{-100,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(relay1.y, switch1.control)
      annotation (Line(points={{-20,30},{-10,30},{-10,0}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{60,30},{50,30},{50,0}}, color={255,0,255}));
    connect(infBus1.term, meter.term_p)
      annotation (Line(points={{-60,-10},{-50,-10}}, color={0,110,110}));
    connect(meter.term_n, switch1.term_p)
      annotation (Line(points={{-30,-10},{-20,-10}}, color={0,110,110}));
    connect(switch1.term_n, line.term_p)
      annotation (Line(points={{0,-10},{10,-10}}, color={0,110,110}));
    connect(line.term_n, switch2.term_p)
      annotation (Line(points={{30,-10},{40,-10}}, color={0,110,110}));
    connect(switch2.term_n, infBus2.term)
      annotation (Line(points={{60,-10},{70,-10}}, color={0,110,110}));
    connect(line.term_f, abc.term)
      annotation (Line(points={{20,0},{20,14}}, color={0,120,120}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-80,-10},{-80,-10}}, color={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with FaultPIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-40},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,40}})));
  end FaultRXline;

  model FaultTline "Faulted PI-line"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(
      V_nom=400e3,
      v0=1.04,
      alpha0=0.5235987755983)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    PowerSystems.AC3ph.Breakers.Breaker breaker1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    PowerSystems.AC3ph.Lines.FaultTline line(len=400e3, redeclare record Data
        = PowerSystems.AC3ph.Lines.Parameters.Line (
          V_nom=400e3,
          x=0.25e-3,
          r=0.02e-3))
      annotation (Placement(transformation(extent={{10,-20},{30,0}})));
    PowerSystems.AC3ph.Breakers.Breaker breaker2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    PowerSystems.AC3ph.Sources.InfBus infBus2(V_nom=400e3)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.2,0.65})
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.3,0.7})
      annotation (Placement(transformation(extent={{80,20},{60,40}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=400e3, S_nom=1000e6)
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc
      annotation (Placement(transformation(extent={{10,16},{30,36}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-20},{-100,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(relay1.y, breaker1.control)
      annotation (Line(points={{-20,30},{-10,30},{-10,0}}, color={255,0,255}));
    connect(relay2.y, breaker2.control)
      annotation (Line(points={{60,30},{50,30},{50,0}}, color={255,0,255}));
    connect(infBus1.term, meter.term_p)
      annotation (Line(points={{-60,-10},{-50,-10}}, color={0,110,110}));
    connect(meter.term_n, breaker1.term_p)
      annotation (Line(points={{-30,-10},{-20,-10}}, color={0,110,110}));
    connect(breaker1.term_n, line.term_p)
      annotation (Line(points={{0,-10},{10,-10}}, color={0,110,110}));
    connect(line.term_n, breaker2.term_p)
      annotation (Line(points={{30,-10},{40,-10}}, color={0,110,110}));
    connect(breaker2.term_n, infBus2.term)
      annotation (Line(points={{60,-10},{70,-10}}, color={0,110,110}));
    connect(line.term_f, abc.term)
      annotation (Line(points={{20,0},{20,16}}, color={0,120,120}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-80,-10},{-80,-10}}, color={0,0,255}));
    connect(infBus2.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with FaultRXline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=1, Interval=2.5e-5),
      Diagram(coordinateSystem(extent={{-100,-40},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,40}})));
  end FaultTline;

  model DoubleRXline "Parallel lumped lines, one faulted"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(V_nom=20e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC3ph.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.Examples.Data.Transformers.TrafoStray,
      redeclare model Topology_p = PowerSystems.AC3ph.Ports.Topology.Delta,
      redeclare model Topology_n = PowerSystems.AC3ph.Ports.Topology.Y)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC3ph.Lines.RXline line(len=480000, redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline400kV)
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC3ph.Lines.FaultRXline lineF(redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline400kV, len=430000)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{50,0},{70,20}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc
      annotation (Placement(transformation(extent={{20,36},{40,56}})));
    PowerSystems.AC3ph.Sources.InfBus InfBus2(V_nom=400e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
      annotation (Placement(transformation(extent={{90,40},{70,60}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,0},{10,20}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-90,-20},{-110,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));
  equation
    connect(relay1.y, switch1.control) annotation (Line(points={{-40,50},{-30,
            50},{-30,20}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{70,50},{60,50},{60,20}}, color={255,0,255}));
    connect(trafo.term_n, meterL.term_p) annotation (Line(points={{-40,-10},{-40,
            -30},{-10,-30}}, color={0,110,110}));
    connect(meterL.term_n, line.term_p)
      annotation (Line(points={{10,-30},{20,-30}}, color={0,110,110}));
    connect(line.term_n, InfBus2.term) annotation (Line(points={{40,-30},{70,-30},
            {70,-10}}, color={0,110,110}));
    connect(trafo.term_n, switch1.term_p)
      annotation (Line(points={{-40,-10},{-40,10}}, color={0,110,110}));
    connect(switch1.term_n, meterF.term_p)
      annotation (Line(points={{-20,10},{-10,10}}, color={0,110,110}));
    connect(meterF.term_n, lineF.term_p)
      annotation (Line(points={{10,10},{20,10}}, color={0,110,110}));
    connect(lineF.term_n, switch2.term_p)
      annotation (Line(points={{40,10},{50,10}}, color={0,110,110}));
    connect(switch2.term_n, InfBus2.term)
      annotation (Line(points={{70,10},{70,-10}}, color={0,110,110}));
    connect(lineF.term_f, abc.term)
      annotation (Line(points={{30,20},{30,36}}, color={0,120,120}));
    connect(infBus1.term, trafo.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,120,120}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-90,-10},{-90,-10}}, color={0,0,255}));
    connect(InfBus2.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.5, Interval=2.5e-5),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end DoubleRXline;

  model DoublelLine "Parallel lines, one faulted"
    import PowerSystems;

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.InfBus infBus1(V_nom=20e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC3ph.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.Examples.Data.Transformers.TrafoStray,
      redeclare model Topology_p = PowerSystems.AC3ph.Ports.Topology.Delta,
      redeclare model Topology_n = PowerSystems.AC3ph.Ports.Topology.Y)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC3ph.Lines.PIline line(redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline_400kV, len=480000)
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC3ph.Lines.FaultTline lineF(redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline_400kV, len=430000)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{50,0},{70,20}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc
      annotation (Placement(transformation(extent={{20,34},{40,54}})));
    PowerSystems.AC3ph.Sources.InfBus InfBus2(V_nom=400e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
      annotation (Placement(transformation(extent={{90,40},{70,60}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,0},{10,20}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-90,-20},{-110,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(relay1.y, switch1.control) annotation (Line(points={{-40,50},{-30,
            50},{-30,20}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{70,50},{60,50},{60,20}}, color={255,0,255}));
    connect(trafo.term_n, meterL.term_p) annotation (Line(points={{-40,-10},{-40,
            -30},{-10,-30}}, color={0,110,110}));
    connect(meterL.term_n, line.term_p)
      annotation (Line(points={{10,-30},{20,-30}}, color={0,110,110}));
    connect(line.term_n, InfBus2.term) annotation (Line(points={{40,-30},{70,-30},
            {70,-10}}, color={0,110,110}));
    connect(trafo.term_n, switch1.term_p)
      annotation (Line(points={{-40,-10},{-40,10}}, color={0,110,110}));
    connect(switch1.term_n, meterF.term_p)
      annotation (Line(points={{-20,10},{-10,10}}, color={0,110,110}));
    connect(meterF.term_n, lineF.term_p)
      annotation (Line(points={{10,10},{20,10}}, color={0,110,110}));
    connect(lineF.term_n, switch2.term_p)
      annotation (Line(points={{40,10},{50,10}}, color={0,110,110}));
    connect(switch2.term_n, InfBus2.term)
      annotation (Line(points={{70,10},{70,-10}}, color={0,110,110}));
    connect(lineF.term_f, abc.term)
      annotation (Line(points={{30,20},{30,34}}, color={0,110,110}));
    connect(infBus1.term, trafo.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,120,120}));
    connect(grd1.term, infBus1.neutral)
      annotation (Line(points={{-90,-10},{-90,-10}}, color={0,0,255}));
    connect(grd2.term, InfBus2.neutral)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  lineF.v          fault line voltage
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.5, Interval=2.5e-5),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end DoublelLine;

  model DoubleRXlineTG
    "Parallel lumped lines with turbo generator, one line faulted"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Generation.TurboGenerator turbGen(
      p_start=0.762922,
      redeclare model Generator = PowerSystems.AC3ph.Machines.Synchron_ee (
            redeclare replaceable record Data =
              PowerSystems.AC3ph.Machines.Parameters.Synchron_ee (
              V_nom=20e3,
              S_nom=1000e6,
              If_nom=2000), dynType=PowerSystems.Types.Dynamics.FreeInitial)
        "nth order",
      initType=PowerSystems.Types.Init.v_alpha,
      alpha_start=0.5235987755983)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC3ph.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.Examples.Data.Transformers.TrafoStray,
      redeclare model Topology_p = PowerSystems.AC3ph.Ports.Topology.Delta,
      redeclare model Topology_n = PowerSystems.AC3ph.Ports.Topology.Y)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC3ph.Lines.RXline line(len=480000, redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline400kV)
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC3ph.Lines.FaultRXline lineF(redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline400kV, len=430000)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{50,0},{70,20}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc(epsG=1e-5)
      annotation (Placement(transformation(extent={{20,34},{40,54}})));
    PowerSystems.AC3ph.Sources.InfBus InfBus(V_nom=400e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
      annotation (Placement(transformation(extent={{90,40},{70,60}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,0},{10,20}})));
    PowerSystems.Control.Setpoints.Set_w_p_v cst_set
      annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  equation
    connect(relay1.y, switch1.control) annotation (Line(points={{-40,50},{-30,
            50},{-30,20}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{70,50},{60,50},{60,20}}, color={255,0,255}));
    connect(cst_set.setpts, turbGen.setpts)
      annotation (Line(points={{-90,-10},{-90,-10}}, color={0,0,127}));
    connect(turbGen.term, trafo.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,110,110}));
    connect(trafo.term_n, meterL.term_p) annotation (Line(points={{-40,-10},{-40,
            -30},{-10,-30}}, color={0,110,110}));
    connect(meterL.term_n, line.term_p)
      annotation (Line(points={{10,-30},{20,-30}}, color={0,110,110}));
    connect(line.term_n, InfBus.term) annotation (Line(points={{40,-30},{70,-30},
            {70,-10}}, color={0,110,110}));
    connect(trafo.term_n, switch1.term_p)
      annotation (Line(points={{-40,-10},{-40,10}}, color={0,110,110}));
    connect(switch1.term_n, meterF.term_p)
      annotation (Line(points={{-20,10},{-10,10}}, color={0,110,110}));
    connect(meterF.term_n, lineF.term_p)
      annotation (Line(points={{10,10},{20,10}}, color={0,110,110}));
    connect(lineF.term_n, switch2.term_p)
      annotation (Line(points={{40,10},{50,10}}, color={0,110,110}));
    connect(switch2.term_n, InfBus.term)
      annotation (Line(points={{70,10},{70,-10}}, color={0,110,110}));
    connect(lineF.term_f, abc.term)
      annotation (Line(points={{30,20},{30,34}}, color={0,110,110}));
    connect(InfBus.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    connect(turbGen.heat, boundary.heat)
      annotation (Line(points={{-80,0},{-80,0}}, color={176,0,0}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.5),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end DoubleRXlineTG;

  model DoubleLineTG "Parallel lines with turbo generator, one line faulted"
    import PowerSystems;

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Generation.TurboGenerator turbGen(
      p_start=0.761825,
      redeclare model Generator = PowerSystems.AC3ph.Machines.Synchron_ee (
            redeclare replaceable record Data =
              PowerSystems.AC3ph.Machines.Parameters.Synchron_ee (
              V_nom=20e3,
              S_nom=1000e6,
              If_nom=2000), dynType=PowerSystems.Types.Dynamics.FreeInitial)
        "nth order",
      alpha_start=0.5235987755983)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC3ph.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.Examples.Data.Transformers.TrafoStray,
      redeclare model Topology_p = PowerSystems.AC3ph.Ports.Topology.Delta,
      redeclare model Topology_n = PowerSystems.AC3ph.Ports.Topology.Y)
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC3ph.Lines.PIline line(len=480e3,redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline_400kV)
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC3ph.Lines.FaultTline lineF(redeclare record Data =
          PowerSystems.Examples.Data.Lines.OHline_400kV, len=430000)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=400e3, I_nom=2500)
      annotation (Placement(transformation(extent={{50,0},{70,20}})));
    PowerSystems.AC3ph.Faults.Fault_abc abc(epsG=1e-5)
      annotation (Placement(transformation(extent={{20,32},{40,52}})));
    PowerSystems.AC3ph.Sources.InfBus InfBus(V_nom=400e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2})
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21})
      annotation (Placement(transformation(extent={{90,40},{70,60}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=400e3)
      annotation (Placement(transformation(extent={{-10,0},{10,20}})));
    PowerSystems.Control.Setpoints.Set_w_p_v cst_set
      annotation (Placement(transformation(extent={{-110,-20},{-90,0}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  equation
    connect(relay1.y, switch1.control) annotation (Line(points={{-40,50},{-30,
            50},{-30,20}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{70,50},{60,50},{60,20}}, color={255,0,255}));
    connect(cst_set.setpts, turbGen.setpts)
      annotation (Line(points={{-90,-10},{-90,-10}}, color={0,0,127}));
    connect(turbGen.term, trafo.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,110,110}));
    connect(trafo.term_n, meterL.term_p) annotation (Line(points={{-40,-10},{-40,
            -30},{-10,-30}}, color={0,110,110}));
    connect(meterL.term_n, line.term_p)
      annotation (Line(points={{10,-30},{20,-30}}, color={0,110,110}));
    connect(line.term_n, InfBus.term) annotation (Line(points={{40,-30},{70,-30},
            {70,-10}}, color={0,110,110}));
    connect(trafo.term_n, switch1.term_p)
      annotation (Line(points={{-40,-10},{-40,10}}, color={0,110,110}));
    connect(switch1.term_n, meterF.term_p)
      annotation (Line(points={{-20,10},{-10,10}}, color={0,110,110}));
    connect(meterF.term_n, lineF.term_p)
      annotation (Line(points={{10,10},{20,10}}, color={0,110,110}));
    connect(lineF.term_n, switch2.term_p)
      annotation (Line(points={{40,10},{50,10}}, color={0,110,110}));
    connect(switch2.term_n, InfBus.term)
      annotation (Line(points={{70,10},{70,-10}}, color={0,110,110}));
    connect(lineF.term_f, abc.term)
      annotation (Line(points={{30,20},{30,32}}, color={0,110,110}));
    connect(InfBus.neutral, grd2.term)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    connect(turbGen.heat, boundary.heat)
      annotation (Line(points={{-80,0},{-80,0}}, color={176,0,0}));
    annotation (
      Documentation(info="<html>
<p>Fault clearance by short-time line switched off.<br>
Compare with DoublePIline.</p>
<p><i>See for example:</i>
<pre>
  meter.p[1:2]     active and reactive power
  line.v           line voltage, oscillations due to switching
  lineF.v          fault line voltage
  abc.i_abc        fault currents
</pre></p>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Transmission\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.5, Interval=1.5e-4),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end DoubleLineTG;

  annotation (preferredView="info", Documentation(info="<html>
<p>Compares RX and RXY line models with a line having a 250 km length.</p>
<p>Particularly interensting is the comparison with analytic formulas for active and reactive powers, and between the RX version (transverse admittances neglected) and the RXY (Y considered).</p>
<p>Detailed documentation is under way.</p>
<p><a href=\"modelica://PowerSystems.Examples\">up users guide</a></p>
</html>"));
end Transmission;
