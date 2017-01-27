within PowerSystems.Examples.AC3ph;
package Elementary "AC 3-phase components dq0"
  extends Modelica.Icons.ExamplesPackage;

  model Breaker "Breaker"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.AC3ph.Nodes.Ground grd2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(V_nom=10e3, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Impedances.Inductor ind(
      r=0.1,
      V_nom=10e3,
      S_nom=1e6)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    replaceable PowerSystems.AC3ph.Breakers.Breaker breaker(V_nom=10e3, I_nom=
          100) annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    PowerSystems.Control.Relays.SwitchRelay relay(t_switch={0.1}) annotation (
        Placement(transformation(
          origin={50,32},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(relay.y, breaker.control)
      annotation (Line(points={{50,22},{50,26},{50,10}}, color={255,0,255}));
    connect(voltage.term, ind.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,110,110}));
    connect(ind.term_n, meter.term_p)
      annotation (Line(points={{-20,0},{-10,0}}, color={0,110,110}));
    connect(meter.term_n, breaker.term_p)
      annotation (Line(points={{10,0},{40,0}}, color={0,110,110}));
    connect(breaker.term_n, grd2.term)
      annotation (Line(points={{60,0},{90,0}}, color={0,110,110}));
    connect(grd1.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-20},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,40}})));
  end Breaker;

  model Fault "Fault"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.Sources.Voltage voltage1(V_nom=10e3, alpha0=
          0.17453292519943)
      annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
    PowerSystems.AC3ph.Breakers.Switch switch1(V_nom=10e3, I_nom=100)
      annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
    PowerSystems.AC3ph.Lines.FaultRXline line(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.RXline (V_nom=10e3, S_nom=1e6))
      annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
    PowerSystems.AC3ph.Breakers.Switch switch2(V_nom=10e3, I_nom=100)
      annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage2(V_nom=10e3)
      annotation (Placement(transformation(extent={{90,-50},{70,-30}})));
    PowerSystems.Control.Relays.SwitchRelay relay1(t_switch={0.15})
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.Control.Relays.SwitchRelay relay2(t_switch={0.153})
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=10e3, S_nom=1e6)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,-10})));
    replaceable PowerSystems.AC3ph.Faults.Fault_ab fault_ab
      annotation (Placement(transformation(extent={{-10,16},{10,36}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-90,-50},{-110,-30}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-50},{110,-30}})));

  equation
    connect(relay1.y, switch1.control)
      annotation (Line(points={{-60,0},{-50,0},{-50,-30}}, color={255,0,255}));
    connect(relay2.y, switch2.control)
      annotation (Line(points={{60,0},{50,0},{50,-30}}, color={255,0,255}));
    connect(voltage1.term, switch1.term_p)
      annotation (Line(points={{-70,-40},{-60,-40}}, color={0,110,110}));
    connect(switch1.term_n, line.term_p)
      annotation (Line(points={{-40,-40},{-10,-40}}, color={0,110,110}));
    connect(line.term_n, switch2.term_p)
      annotation (Line(points={{10,-40},{40,-40}}, color={0,110,110}));
    connect(switch2.term_n, voltage2.term)
      annotation (Line(points={{60,-40},{70,-40}}, color={0,110,110}));
    connect(line.term_f, meter.term_p) annotation (Line(points={{0,-30},{0,-20},
            {-6.12303e-016,-20}}, color={0,110,110}));
    connect(meter.term_n, fault_ab.term) annotation (Line(points={{6.12303e-016,
            0},{0,0},{0,16}}, color={0,110,110}));
    connect(grd1.term, voltage1.neutral)
      annotation (Line(points={{-90,-40},{-90,-40}}, color={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (Line(points={{90,-40},{90,-40}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2, Interval=1e-4),
      Diagram(coordinateSystem(extent={{-100,-60},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-60},{100,40}})));
  end Fault;

  model Impedance "Impedance"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC3ph.Impedances.Inductor ind(r=0.1)
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    PowerSystems.AC3ph.Nodes.Ground grd2
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,110,110}));
    connect(meter.term_n, ind.term_p)
      annotation (Line(points={{-20,0},{20,0}}, color={0,110,110}));
    connect(ind.term_n, grd2.term)
      annotation (Line(points={{40,0},{80,0}}, color={0,110,110}));
    connect(grd1.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2),
      Diagram(coordinateSystem(extent={{-100,-20},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,40}})));
  end Impedance;

  model ImpedanceYD "Impedance Y-Delta"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC3ph.ImpedancesYD.Inductor indYD(r=0.1)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,110,110}));
    connect(meter.term_n, indYD.term)
      annotation (Line(points={{-20,0},{30,0}}, color={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=0.2),
      Diagram(coordinateSystem(extent={{-100,-20},{80,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,40}})));
  end ImpedanceYD;

  model Line "Line"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh(ph_end=
          0.087266462599716)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage1(
      V_nom=132e3,
      use_vPhasor_in=true,
      alpha0=0.087266462599716)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(V_nom=132e3, S_nom=100e6)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    PowerSystems.AC3ph.Sources.Voltage voltage2(V_nom=132e3)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    replaceable PowerSystems.AC3ph.Lines.Tline line(redeclare record Data =
          PowerSystems.AC3ph.Lines.Parameters.Line (V_nom=132e3))
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  equation
    connect(transPh.y, voltage1.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage1.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,110,110}));
    connect(meter.term_n, line.term_p)
      annotation (Line(points={{-20,0},{20,0}}, color={0,110,110}));
    connect(line.term_n, voltage2.term)
      annotation (Line(points={{40,0},{70,0}}, color={0,110,110}));
    connect(grd1.term, voltage1.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    connect(voltage2.neutral, grd2.term)
      annotation (Line(points={{90,0},{90,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-20},{100,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,40}})));
  end Line;

  model Load "Load"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    replaceable PowerSystems.AC3ph.Loads.PQindLoad load(tcst=0.01, use_pq_in=
          true)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    PowerSystems.Blocks.Signals.Transient[2] trsSignal(s_start={sqrt(3)/2,1/2},
        s_end={1,0.2}) annotation (Placement(transformation(
          origin={40,30},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(trsSignal.y, load.pq_in) annotation (Line(points={{40,20},{40,20},{
            40,30},{40,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-40,0}}, color={0,110,110}));
    connect(meter.term_n, load.term)
      annotation (Line(points={{-20,0},{30,0}}, color={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-20},{60,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{60,40}})));
  end Load;

  model Machines "Machines"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Synchron)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(
      v0=1,
      use_vPhasor_in=true,
      V_nom=400)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC3ph.Sensors.Psensor power
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    replaceable PowerSystems.AC3ph.Machines.Asynchron asynchron(redeclare
        record Data = PowerSystems.AC3ph.Machines.Parameters.Asynchron_cage (
            V_nom=400, S_nom=1e3))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    PowerSystems.Mechanics.Rotational.Rotor rotor
      annotation (Placement(transformation(extent={{28,-10},{48,10}})));
    PowerSystems.Mechanics.Rotational.Torque torq
      annotation (Placement(transformation(extent={{80,-10},{60,10}})));
    PowerSystems.Blocks.Signals.Transient trsSignal
      annotation (Placement(transformation(extent={{100,-10},{80,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=2)
      annotation (Placement(transformation(extent={{-10,10},{10,30}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(voltage.term, power.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,110,110}));
    connect(power.term_n, asynchron.term)
      annotation (Line(points={{-30,0},{-10,0}}, color={0,110,110}));
    connect(asynchron.airgap, rotor.flange_a)
      annotation (Line(points={{0,6},{14,6},{14,0},{28,0}}, color={0,0,0}));
    connect(rotor.flange_b, torq.flange)
      annotation (Line(points={{48,0},{60,0}}, color={0,0,0}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(asynchron.heat, boundary.heat)
      annotation (Line(points={{0,10},{0,10}}, color={176,0,0}));
    connect(trsSignal.y, torq.tau_in)
      annotation (Line(points={{80,0},{80,0}}, color={0,0,127}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end Machines;

  model Sensor "Sensor and meter"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.AC3ph.Sources.Vspectrum voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
    PowerSystems.AC3ph.ImpedancesYD.Resistor res
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    replaceable PowerSystems.AC3ph.Sensors.PVImeter meter(abc=true)
      annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-70,-10},{-90,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-54,20},{-54,10}}, color={0,0,127}));
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-50,0},{-12,0}}, color={0,110,110}));
    connect(meter.term_n, res.term)
      annotation (Line(points={{8,0},{8,0},{60,0}}, color={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-70,0},{-70,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-20},{80,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,60}})));
  end Sensor;

  model Source "Source"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    PowerSystems.AC3ph.ImpedancesYD.Inductor ind(r=0.1)
      annotation (Placement(transformation(extent={{30,-10},{50,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter(abc=true)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    replaceable PowerSystems.AC3ph.Sources.Voltage voltage
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

  equation
    connect(voltage.term, meter.term_p)
      annotation (Line(points={{-40,0},{-26,0},{0,0}}, color={0,110,110}));
    connect(meter.term_n, ind.term)
      annotation (Line(points={{20,0},{30,0}}, color={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-60,0},{-60,0}}, color={0,0,255}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1),
      Diagram(coordinateSystem(extent={{-100,-20},{80,40}})),
      Icon(coordinateSystem(extent={{-100,-20},{80,40}})));
  end Source;

  model Transformer "Transformer"

    inner PowerSystems.System system
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage voltage(use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter1
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    replaceable PowerSystems.AC3ph.Transformers.TrafoStray trafo(
      redeclare record Data =
          PowerSystems.AC3ph.Transformers.Parameters.TrafoStray (
          tap_neutral={1,1},
          dv_tap={0.1,0.2},
          V_nom={1,10}),
      redeclare model Topology_p = PowerSystems.AC3ph.Ports.Topology.Y,
      redeclare model Topology_n = PowerSystems.AC3ph.Ports.Topology.Delta,
      use_tap_1_in=true,
      use_tap_2_in=true)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meter2(V_nom=10)
      annotation (Placement(transformation(extent={{50,-10},{70,10}})));
    PowerSystems.AC3ph.ImpedancesYD.Resistor res(V_nom=10, r=100)
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
    PowerSystems.Control.Relays.TapChangerRelay tapChanger(
      preset_1={1,1,2},
      preset_2={1,1,2},
      t_switch_1={0.9,1.9},
      t_switch_2={1.1,2.1}) annotation (Placement(transformation(
          origin={10,40},
          extent={{-10,-10},{10,10}},
          rotation=270)));
    PowerSystems.AC3ph.Nodes.GroundOne grd
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));

  equation
    connect(transPh.y, voltage.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(voltage.term, meter1.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,110,110}));
    connect(meter1.term_n, trafo.term_p)
      annotation (Line(points={{-30,0},{0,0}}, color={0,110,110}));
    connect(trafo.term_n, meter2.term_p)
      annotation (Line(points={{20,0},{50,0}}, color={0,110,110}));
    connect(meter2.term_n, res.term)
      annotation (Line(points={{70,0},{80,0}}, color={0,110,110}));
    connect(grd.term, voltage.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(tapChanger.tap_1, trafo.tap_1_in)
      annotation (Line(points={{6,30},{6,10}}, color={255,127,0}));
    connect(tapChanger.tap_2, trafo.tap_2_in)
      annotation (Line(points={{14,30},{14,10}}, color={255,127,0}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=3),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end Transformer;

  model Rectifier "Rectifier"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage vAC(V_nom=2, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC3ph.Impedances.Inductor ind(r=0.05)
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    replaceable PowerSystems.AC3ph.Inverters.Rectifier rectifier
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=3)
      annotation (Placement(transformation(extent={{10,10},{30,30}})));

  equation
    connect(transPh.y, vAC.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,110,110}));
    connect(ind.term_n, meterAC.term_p)
      annotation (Line(points={{-30,0},{-20,0}}, color={0,110,110}));
    connect(meterAC.term_n, rectifier.AC)
      annotation (Line(points={{0,0},{10,0}}, color={0,110,110}));
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
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1, Interval=0.2e-3),
      Diagram(coordinateSystem(extent={{-100,-20},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-20},{100,60}})));
  end Rectifier;

  model Inverter "Inverter, controlled rectifier"

    inner PowerSystems.System system(refType=PowerSystems.Types.ReferenceFrame.Inertial)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    PowerSystems.Blocks.Signals.TransientPhasor transPh
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    PowerSystems.AC3ph.Sources.Voltage vAC(V_nom=2, use_vPhasor_in=true)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    PowerSystems.AC3ph.Impedances.Inductor ind(r=0.05)
      annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
    PowerSystems.AC3ph.Sensors.PVImeter meterAC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
    replaceable PowerSystems.AC3ph.Inverters.Inverter ac_dc
      annotation (Placement(transformation(extent={{30,-10},{10,10}})));
    PowerSystems.AC1ph_DC.Sensors.PVImeter meterDC(av=true, tcst=0.1)
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
    PowerSystems.AC1ph_DC.Sources.DCvoltage vDC(pol=0)
      annotation (Placement(transformation(extent={{90,-10},{70,10}})));
    PowerSystems.AC3ph.Inverters.Select select
      annotation (Placement(transformation(extent={{30,30},{10,50}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd1
      annotation (Placement(transformation(extent={{-80,-10},{-100,10}})));
    PowerSystems.AC3ph.Nodes.GroundOne grd2
      annotation (Placement(transformation(extent={{90,-10},{110,10}})));
    PowerSystems.Common.Thermal.BoundaryV boundary(m=3)
      annotation (Placement(transformation(extent={{10,10},{30,30}})));

  equation
    connect(transPh.y, vAC.vPhasor_in)
      annotation (Line(points={{-80,20},{-64,20},{-64,10}}, color={0,0,127}));
    connect(vAC.term, ind.term_p)
      annotation (Line(points={{-60,0},{-50,0}}, color={0,110,110}));
    connect(ind.term_n, meterAC.term_p)
      annotation (Line(points={{-30,0},{-20,0}}, color={0,110,110}));
    connect(meterAC.term_n, ac_dc.AC)
      annotation (Line(points={{0,0},{10,0}}, color={0,110,110}));
    connect(ac_dc.DC, meterDC.term_p)
      annotation (Line(points={{30,0},{40,0}}, color={0,0,255}));
    connect(meterDC.term_n, vDC.term)
      annotation (Line(points={{60,0},{70,0}}, color={0,0,255}));
    connect(select.theta_out, ac_dc.theta)
      annotation (Line(points={{26,30},{26,10}}, color={0,0,127}));
    connect(select.vPhasor_out, ac_dc.vPhasor)
      annotation (Line(points={{14,30},{14,10}}, color={0,0,127}));
    connect(grd1.term, vAC.neutral)
      annotation (Line(points={{-80,0},{-80,0}}, color={0,0,255}));
    connect(vDC.neutral, grd2.term)
      annotation (Line(points={{90,0},{90,0}}, color={0,0,255}));
    connect(ac_dc.heat, boundary.heat)
      annotation (Line(points={{20,10},{20,10}}, color={176,0,0}));
    annotation (
      Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.AC3ph.Elementary\">up users guide</a></p>
</html>"),
      experiment(StopTime=1, Interval=0.2e-3),
      Diagram(coordinateSystem(extent={{-100,-40},{100,60}})),
      Icon(coordinateSystem(extent={{-100,-40},{100,60}})));
  end Inverter;

  annotation (preferredView="info", Documentation(info="<html>
<p>This package contains small models for testing single components from AC3ph.
The replaceable component can be replaced by a user defined component of similar type.</p>
<p><a href=\"modelica://PowerSystems.Examples\">up users guide</a></p>
</html>"));
end Elementary;
