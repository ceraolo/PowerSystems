within PowerSystems.Examples.AC1ph_DC;
package Elementary "AC 1-phase and DC components"
  extends Modelica.Icons.ExamplesPackage;

  model BreakerOpening "Breaker"
    import PowerSystems;

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-10,40},{10,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.Control.Relays.SwitchRelay relay(
      n=1,
      ini_state=true,
      t_switch={0.1}) annotation (Placement(transformation(
          origin={36,30},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage(V_nom=10e3, use_vPhasor_in=
          true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind(
      r={0.1,0.1},
      V_nom=10e3,
      S_nom=1e6)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    replaceable PowerSystems.AC1ph_DC.Breakers.Breaker breaker(V_nom=10e3,
        I_nom=100)
      annotation (Placement(transformation(extent={{26,-10},{46,10}})));
    PowerSystems.AC1ph_DC.Nodes.Ground grd
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, ind.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,0,255}));
    connect(ind.term_n, meter.term_p)
      annotation (Line(points={{-20,0},{-10,0}}, color={0,0,255}));
    connect(meter.term_n, breaker.term_p)
      annotation (Line(points={{10,0},{26,0}}, color={0,0,255}));
    connect(relay.y[1], breaker.control)
      annotation (Line(points={{36,20},{36,20},{36,10}}, color={255,0,255}));
    connect(grd1.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    connect(grd.term, breaker.term_n)
      annotation (Line(points={{80,0},{64,0},{46,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>The breaker, initially closed, opens at 0.1s.  Current goes to zero at the next zero-crossig.</p>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end BreakerOpening;

  model CompareMSL
    "Comparison of a simple AC1ph_DC system with MSL counterpart"
    import PowerSystems;
    import Modelica.Constants.pi;

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(ph_start=-2.0943951023932,
        ph_end=-2.0943951023932)
      annotation (Placement(transformation(extent={{-52,16},{-32,36}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage uAC(use_vPhasor_in=true, V_nom=
          10000)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind(
      S_nom=1e6,
      V_nom=10000,
      r={0.6,0.1})
      annotation (Placement(transformation(extent={{44,-10},{64,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter(
      S_nom=1e6,
      puUnits=false,
      V_nom=10000)
      annotation (Placement(transformation(extent={{10,-10},{30,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-76,-10},{-96,10}})));

    PowerSystems.AC1ph_DC.Nodes.Ground grd
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage uDC(V=1000)
      annotation (Placement(transformation(extent={{-42,-10},{-62,10}})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage uDCsl(V=1000)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={-76,74})));
    Modelica.Electrical.Analog.Basic.Ground ground
      annotation (Placement(transformation(extent={{38,34},{58,54}})));
    Modelica.Electrical.Analog.Sources.SineVoltage uACsl(
      V=sqrt(2)*10e3,
      freqHz=50,
      phase=-0.5235987755983)
      annotation (Placement(transformation(extent={{-36,74},{-56,94}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor(R=60)
      annotation (Placement(transformation(extent={{-24,76},{-4,96}})));
    Modelica.Electrical.Analog.Basic.Inductor inductor(L=100/(2*pi*50))
      annotation (Placement(transformation(extent={{10,76},{30,96}})));
    Modelica.Electrical.Analog.Basic.Resistor resistor1(R=10)
      annotation (Placement(transformation(extent={{-24,52},{-4,72}})));
    Modelica.Electrical.Analog.Basic.Inductor inductor1(L=100/(2*pi*50))
      annotation (Placement(transformation(extent={{10,52},{30,72}})));
    Modelica.Electrical.Analog.Basic.Ground ground1
      annotation (Placement(transformation(extent={{-86,40},{-66,60}})));
  equation
    connect(transPh.y, uAC.vPhasor_in)
      annotation (Line(points={{-32,26},{-4,26},{-4,10}}, color={0,0,127}));
    connect(uDC.p, uAC.neutral)
      annotation (Line(points={{-42,0},{-31,0},{-20,0}}, color={0,0,255}));
    connect(uDC.n, grd1.term)
      annotation (Line(points={{-62,0},{-69,0},{-76,0}}, color={0,0,255}));
    connect(ind.term_p, meter.term_n)
      annotation (Line(points={{44,0},{37,0},{30,0}}, color={0,0,255}));
    connect(meter.term_p, uAC.term)
      annotation (Line(points={{10,0},{5,0},{0,0}}, color={0,0,255}));
    connect(ind.term_n, grd.term)
      annotation (Line(points={{64,0},{72,0},{80,0}}, color={0,0,255}));
    connect(uACsl.n, uDCsl.p)
      annotation (Line(points={{-56,84},{-66,84},{-76,84}}, color={0,0,255}));
    connect(resistor.p, uACsl.p) annotation (Line(points={{-24,86},{-30,86},{-30,
            84},{-36,84}}, color={0,0,255}));
    connect(resistor.n, inductor.p)
      annotation (Line(points={{-4,86},{10,86}}, color={0,0,255}));
    connect(ground.p, inductor.n) annotation (Line(points={{48,54},{48,54},{48,
            86},{30,86}}, color={0,0,255}));
    connect(resistor1.n, inductor1.p)
      annotation (Line(points={{-4,62},{10,62}}, color={0,0,255}));
    connect(inductor1.n, inductor.n) annotation (Line(points={{30,62},{48,62},{
            48,86},{30,86}}, color={0,0,255}));
    connect(ground1.p, uDCsl.n)
      annotation (Line(points={{-76,60},{-76,64}}, color={0,0,255}));
    connect(resistor1.p, uACsl.n) annotation (Line(points={{-24,62},{-40,62},{-40,
            62},{-56,62},{-56,84}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p>This example shows what happens when a mixed DC-AC signal is applied to an &QUOT;inductor&QUOT; component (actually a two conductor line with ground return).</p>
<p>Current i[1] and i[2] in AC terminals are the currents flowing in conductors 1 and 2, as can be verified also in the MSL version of the system.</p>
<p>The sum ind.i[1]+ind.i[2] can be seen also flowing in terminals of the DC part of Power Systems the model.</p>
<p><br><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=0.0001),
      Diagram(coordinateSystem(extent={{-100,-20},{100,100}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,100}})));
  end CompareMSL;

  model Fault "Fault"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(n=2, t_switch={3.5,29.5}/50)
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(n=2, t_switch={3.6,29.4}/50)
      annotation (Placement(transformation(extent={{80,0},{60,20}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage1(V_nom=10e3, alpha0=
          0.17453292519943)
      annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage2(V_nom=10e3)
      annotation (Placement(transformation(extent={{90,-40},{70,-20}})));
    PowerSystems.AC1ph_DC.Breakers.DoubleSwitch switch1(V_nom=10e3,I_nom=100)
      annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
    PowerSystems.AC1ph_DC.Breakers.DoubleSwitch switch2(V_nom=10e3, I_nom=100)
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    PowerSystems.AC1ph_DC.Lines.FaultRXline line(redeclare record Data =
          PowerSystems.AC1ph_DC.Lines.Parameters.RXline (V_nom=10e3, S_nom=1e6))
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation
            =90)));
    replaceable PowerSystems.AC1ph_DC.Faults.Fault_Ab fault_Ab
      annotation (Placement(transformation(extent={{-10,30},{10,50}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-90,-40},{-110,-20}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-40},{110,-20}})));

  equation
    connect(voltage1.term, switch1.term_p)
      annotation (Line(points={{-70,-30},{-60,-30}}, color={0,0,255}));
    connect(switch1.term_n, line.term_p)
      annotation (Line(points={{-40,-30},{-10,-30}}, color={0,0,255}));
    connect(line.term_n, switch2.term_p)
      annotation (Line(points={{10,-30},{40,-30}}, color={0,0,255}));
    connect(switch2.term_n, voltage2.term)
      annotation (Line(points={{60,-30},{70,-30}}, color={0,0,255}));
    connect(line.term_f, meter.term_p) annotation (Line(points={{0,-20},{0,-10},
            {-6.12303e-016,-10}}, color={0,0,255}));
    connect(meter.term_n, fault_Ab.term) annotation (Line(points={{6.12303e-016,
            10},{0,10},{0,30}}, color={0,0,255}));
    connect(relay1.y, switch1.control) annotation (Line(points={{-60,10},{-50,
            10},{-50,-20}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{60,10},{50,10},{50,-20}}, color={255,0,255}));
    connect(grd1.term, voltage1.neutral)
      annotation (Line(points={{-90,-30},{-90,-30}}, color={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (Line(points={{90,-30},{90,-30}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.2, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end Fault;

  model Impedance "Impedance"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC1ph_DC.Impedances.Inductor ind(r={0.1,0.1})
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));
    PowerSystems.AC1ph_DC.Nodes.Ground grd2
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,0,255}));
    connect(meter.term_n, ind.term_p)
      annotation (Line(points={{-20,0},{20,0}}, color={0,0,255}));
    connect(ind.term_n, grd2.term)
      annotation (Line(points={{40,0},{80,0}}, color={0,0,255}));
    connect(grd1.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=2.7e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end Impedance;

  model ImpedanceOneTerm "Impedance One-terminal"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-10,20},{10,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
    replaceable PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor ind(r=0.1)
      annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-50,-30},{-70,-10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-60,0},{-34,0},{-34,-10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-30,-20},{-20,-20}}, color={0,0,255}));
    connect(meter.term_n, ind.term)
      annotation (Line(points={{0,-20},{50,-20}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-50,-20},{-50,-20}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=2.7e-4),
      Diagram(coordinateSystem(extent={{-100,-40},{80,40}})),
      Icon(coordinateSystem(extent={{-100,-40},{80,40}})));
  end ImpedanceOneTerm;

  model Line "Line"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-10,40},{10,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(ph_end=
          0.087266462599716)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage1(
      V_nom=132e3,
      use_vPhasor_in=true,
      alpha0=0.087266462599716)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage2(V_nom=132e3)
      annotation (Placement(transformation(extent={{78,-10},{58,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter(V_nom=132e3, S_nom=100e6)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC1ph_DC.Lines.Tline line(redeclare record Data =
          PowerSystems.AC1ph_DC.Lines.Parameters.Line (V_nom=132e3))
      annotation (Placement(transformation(extent={{16,-10},{36,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{84,-10},{104,10}})));

  equation
    connect(transPh.y, voltage1.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage1.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,0,255}));
    connect(meter.term_n, line.term_p)
      annotation (Line(points={{-20,0},{16,0}}, color={0,0,255}));
    connect(line.term_n, voltage2.term)
      annotation (Line(points={{36,0},{58,0}}, color={0,0,255}));
    connect(grd1.term, voltage1.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (Line(points={{78,0},{84,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end Line;

  model DoublelLine "Parallel lines, one faulted"
    import PowerSystems;

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage1(V_nom=20e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
    PowerSystems.AC1ph_DC.Transformers.TrafoStray trafo(redeclare record Data
        = PowerSystems.Examples.Data.Transformers.TrafoStray1ph (
          V_nom={20e3,132e3},
          S_nom=100e6,
          f_nom=50))
      annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    PowerSystems.AC1ph_DC.Lines.Tline line(len=480000, redeclare record Data =
          PowerSystems.AC1ph_DC.Lines.Parameters.Line (V_nom=132e3))
      annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
    PowerSystems.AC1ph_DC.Breakers.Switch switch1(V_nom=132e3, I_nom=2500)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    PowerSystems.AC1ph_DC.Lines.FaultTline lineF(redeclare record Data =
          PowerSystems.AC1ph_DC.Lines.Parameters.Line (V_nom=132e3), len=430000)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    PowerSystems.AC1ph_DC.Breakers.Switch switch2(V_nom=132e3, I_nom=2500)
      annotation (Placement(transformation(extent={{50,0},{70,20}})));
    PowerSystems.AC1ph_DC.Faults.Fault_ab ab
      annotation (Placement(transformation(extent={{20,40},{40,60}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage2(V_nom=132e3, alpha0=
          0.5235987755983)
      annotation (Placement(transformation(extent={{90,-20},{70,0}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15,0.2}, n=1)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153,0.21}, n=1)
      annotation (Placement(transformation(extent={{90,40},{70,60}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterL(S_nom=1000e6, V_nom=132e3)
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterF(S_nom=1000e6, V_nom=132e3)
      annotation (Placement(transformation(extent={{-10,0},{10,20}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-90,-20},{-110,0}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-20},{110,0}})));

  equation
    connect(trafo.term_n, meterL.term_p) annotation (Line(points={{-40,-10},{-40,
            -30},{-10,-30}}, color={0,110,110}));
    connect(meterL.term_n, line.term_p)
      annotation (Line(points={{10,-30},{20,-30}}, color={0,110,110}));
    connect(line.term_n, voltage2.term) annotation (Line(points={{40,-30},{70,-30},
            {70,-10}}, color={0,110,110}));
    connect(trafo.term_n, switch1.term_p)
      annotation (Line(points={{-40,-10},{-40,10}}, color={0,110,110}));
    connect(switch1.term_n, meterF.term_p)
      annotation (Line(points={{-20,10},{-10,10}}, color={0,110,110}));
    connect(meterF.term_n, lineF.term_p)
      annotation (Line(points={{10,10},{20,10}}, color={0,110,110}));
    connect(lineF.term_n, switch2.term_p)
      annotation (Line(points={{40,10},{50,10}}, color={0,110,110}));
    connect(switch2.term_n, voltage2.term)
      annotation (Line(points={{70,10},{70,-10}}, color={0,110,110}));
    connect(lineF.term_f, ab.term)
      annotation (Line(points={{30,20},{30,40}}, color={0,110,110}));
    connect(voltage1.term, trafo.term_p)
      annotation (Line(points={{-70,-10},{-60,-10}}, color={0,120,120}));
    connect(grd1.term, voltage1.neutral)
      annotation (Line(points={{-90,-10},{-90,-10}}, color={0,0,255}));
    connect(grd2.term, voltage2.neutral)
      annotation (Line(points={{90,-10},{90,-10}}, color={0,0,255}));
    connect(relay1.y[1], switch1.control) annotation (Line(points={{-40,50},{-30,
            50},{-30,20}}, color={255,0,255}));
    connect(relay2.y[1], switch2.control) annotation (Line(points={{70,50},{66,
            50},{60,50},{60,20}}, color={255,0,255}));
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
<p><a href=\"modelica://PowerSystems.Examples.Spot.TransmissionAC3ph\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.5, Interval=2.5e-5),
      Diagram(coordinateSystem(extent={{-100,-60},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,60}})));
  end DoublelLine;

  model LoadAC "AC load"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    PowerSystems.Blocks.Signals.Transient[2] trsSignal(s_start={1,2}, s_end={2,
          3}) annotation (Placement(transformation(
          origin={40,40},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(a_end=0.9)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC1ph_DC.Loads.ZloadAC zLoadAC(use_pq_in=true)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,0,255}));
    connect(meter.term_n, zLoadAC.term)
      annotation (Line(points={{-20,0},{30,0}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    connect(trsSignal.y, zLoadAC.pq_in)
      annotation (Line(points={{40,30},{40,24},{40,10}}, color={0,0,127}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{80,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,60}})));
  end LoadAC;

  model LoadDC "AC load"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.Transient trsSignalL(s_start=0.5, s_end=1)
      annotation (Placement(transformation(
          origin={40,36},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC1ph_DC.Sources.DCvoltage voltage(use_vDC_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC1ph_DC.Loads.PindLoadDC pLoadDC(use_p_in=true)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    PowerSystems.Blocks.Signals.Transient transV(s_end=0.9)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,0,255}));
    connect(meter.term_n, pLoadDC.term)
      annotation (Line(points={{-20,0},{30,0}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    connect(transV.y, voltage.vDC_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(trsSignalL.y, pLoadDC.p_in)
      annotation (Line(points={{40,26},{40,10}}, color={0,0,127}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1, Interval=2.7e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{80,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,60}})));
  end LoadDC;

  model Machines "Machines"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Mechanics.Rotational.Rotor rotor
      annotation (Placement(transformation(extent={{28,-10},{48,10}})));
    PowerSystems.Mechanics.Rotational.Torque torq(tau0=-1)
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
    PowerSystems.Blocks.Signals.Transient transTau(s_start=0, s_end=-1)
      annotation (Placement(transformation(extent={{100,-10},{80,10}})));

    PowerSystems.AC1ph_DC.Sources.DCvoltage voltage1(use_vDC_in=true, V_nom=100)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.Blocks.Signals.Transient transV(s_start=0, s_end=1)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sensors.Psensor power
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    replaceable PowerSystems.AC1ph_DC.Machines.DCser motor(redeclare
        replaceable record Data =
          PowerSystems.AC1ph_DC.Machines.Parameters.DCser (V_nom=100, S_nom=1e3))
      "DC machine series"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  equation
    connect(voltage1.term, power.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,0,255}));
    connect(power.term_n, motor.term)
      annotation (Line(points={{-30,0},{-10,0}}, color={0,0,255}));
    connect(motor.airgap, rotor.flange_a)
      annotation (Line(points={{0,6},{14,6},{14,0},{28,0}}, color={0,0,0}));
    connect(rotor.flange_b, torq.flange)
      annotation (Line(points={{48,0},{60,0}}, color={0,0,0}));
    connect(grd.term, voltage1.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(transV.y, voltage1.vDC_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(motor.heat, boundary.heat)
      annotation (Line(points={{0,10},{0,10}}, color={176,0,0}));
    connect(transTau.y, torq.tau_in)
      annotation (Line(points={{80,0},{80,0}}, color={0,0,127}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Machines;

  model Sensor "Sensor and meter"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Resistor res
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    replaceable PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    PowerSystems.AC1ph_DC.Sources.Vspectrum voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-8,0}},color={0,0,255}));
    connect(meter.term_n, res.term)
      annotation (Line(points={{12,0},{40,0}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.2, Interval=2.7e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{80,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,60}})));
  end Sensor;

  model Source "Source"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    replaceable PowerSystems.AC1ph_DC.Sources.ACvoltage voltage
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Inductor ind
      annotation (Placement(transformation(extent={{52,-10},{72,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-40,-10},{-60,10}})));

  equation
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-20,0},{20,0}}, color={0,0,255}));
    connect(meter.term_n, ind.term)
      annotation (Line(points={{40,0},{52,0}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-40,0},{-40,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.2, Interval=2.7e-4),
      Diagram(coordinateSystem(extent={{-60,-20},{80,60}})),
      Icon(coordinateSystem(extent={{-60,-20},{80,60}})));
  end Source;

  model Transformer "Transformer"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.Control.Relays.TapChangerRelay tapChanger(
      preset_1={1,1,2},
      preset_2={1,1,2},
      t_switch_1={0.9,1.9},
      t_switch_2={1.1,2.1}) annotation (Placement(transformation(
          origin={10,30},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC1ph_DC.Sources.ACvoltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter1
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meter2(V_nom=10)
      annotation (Placement(transformation(extent={{50,-10},{70,10}})));
    replaceable PowerSystems.AC1ph_DC.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.AC1ph_DC.Transformers.Parameters.TrafoStray1ph (
          tap_neutral={1,1},
          dv_tap={0.1,0.2},
          V_nom={1,10}),
      use_tap_1_in=true,
      use_tap_2_in=true)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    PowerSystems.AC1ph_DC.ImpedancesOneTerm.Resistor res(V_nom=10, r=100)
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
    PowerSystems.AC1ph_DC.Nodes.PolarityGround polGrd1(pol=0)
      annotation (Placement(transformation(extent={{80,-36},{100,-16}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(voltage.term, meter1.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,0,255}));
    connect(meter1.term_n, trafo.term_p)
      annotation (Line(points={{-30,0},{0,0}}, color={0,0,255}));
    connect(trafo.term_n, meter2.term_p)
      annotation (Line(points={{20,0},{50,0}}, color={0,0,255}));
    connect(meter2.term_n, res.term)
      annotation (Line(points={{70,0},{80,0}}, color={0,0,255}));
    connect(res.term, polGrd1.term)
      annotation (Line(points={{80,0},{80,-26}}, color={0,0,255}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(tapChanger.tap_1, trafo.tap_1_in)
      annotation (Line(points={{6,20},{6,10}}, color={255,127,0}));
    connect(tapChanger.tap_2, trafo.tap_2_in)
      annotation (Line(points={{14,20},{14,10}}, color={255,127,0}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=3, Interval=4e-4),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Transformer;

  model Rectifier "Rectifier"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage vAC(V_nom=2, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    replaceable PowerSystems.AC1ph_DC.Inverters.Rectifier rectifier
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{10,10},{30,30}})));

  equation
    connect(transPh.y, vAC.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,0,255}));
    connect(ind.term_n, meterAC.term_p)
      annotation (Line(points={{-30,0},{-20,0}}, color={0,0,255}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (Line(points={{0,0},{10,0}}, color={0,0,255}));
    connect(rectifier.DC, meterDC.term_p)
      annotation (Line(points={{30,0},{40,0}}, color={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (Line(points={{60,0},{70,0}}, color={0,0,255}));
    connect(grd1.term, vAC.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (Line(points={{90,0},{90,0}}, color={0,0,255}));
    connect(rectifier.heat, boundary.heat)
      annotation (Line(points={{20,10},{20,10}}, color={176,0,0}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.2, Interval=0.2e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Rectifier;

  model Inverter "Inverter, controlled rectifier"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial,
        dynType=PowerSystems.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC1ph_DC.Sources.ACvoltage vAC(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC1ph_DC.Impedances.Inductor ind
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
    replaceable PowerSystems.AC1ph_DC.Inverters.Inverter dc_ac
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{60,-10},{40,10}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0, V_nom=2)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    PowerSystems.AC1ph_DC.Inverters.Select select(alpha0=0.5235987755983)
      annotation (Placement(transformation(extent={{30,34},{10,54}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    PowerSystems.AC1ph_DC.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{10,10},{30,30}})));

  equation
    connect(transPh.y, vAC.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(select.theta_out, dc_ac.theta)
      annotation (Line(points={{26,34},{26,10}}, color={0,0,127}));
    connect(select.vPhasor_out, dc_ac.vPhasor)
      annotation (Line(points={{14,34},{14,10}}, color={0,0,127}));
    connect(vDC.term, meterDC.term_p)
      annotation (Line(points={{70,0},{60,0}}, color={0,0,255}));
    connect(meterDC.term_n, dc_ac.DC)
      annotation (Line(points={{40,0},{30,0}}, color={0,0,255}));
    connect(dc_ac.AC, meterAC.term_p)
      annotation (Line(points={{10,0},{0,0}}, color={0,0,255}));
    connect(meterAC.term_n, ind.term_n)
      annotation (Line(points={{-20,0},{-30,0}}, color={0,0,255}));
    connect(ind.term_p, vAC.term)
      annotation (Line(points={{-50,0},{-60,0}}, color={0,0,255}));
    connect(grd1.term, vDC.neutral)
      annotation (Line(points={{90,0},{90,0}}, color={0,0,255}));
    connect(grd2.term, vAC.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(dc_ac.heat, boundary.heat)
      annotation (Line(points={{20,10},{20,10}}, color={176,0,0}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC1ph_DC.Elementary\">up users guide</a></p>
</html>
"),
      experiment(StopTime=0.2, Interval=0.2e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Inverter;

  annotation (preferredView="info", Documentation(info="<html>
<p>This package contains small models for testing single components from AC1ph_DC.
The replaceable component can be replaced by a user defined component of similar type.</p>
<p><a href=\"modelica://PowerSystems.Examples\">up users guide</a></p>
</html>"));
end Elementary;
