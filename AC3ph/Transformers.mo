within PowerSystems.AC3ph;
package Transformers "Transformers 3-phase"
  extends Modelica.Icons.VariantsPackage;

  model TrafoIdeal "Ideal transformer, 3-phase dq0"
    parameter Boolean D_D=false "set true if Delta-Delta topology!";
    extends Partials.TrafoIdealBase(final dynType=Types.Dynamics.SteadyState);

  equation
    i1 + i2 = zeros(PS.n);
    if D_D then
      v1[1:2] = v2[1:2];
      i1[3] = 0;
    else
      v1 = v2;
    end if;
    annotation (defaultComponentName="trafo", Documentation(info="<html>
<p>Ideal magnetic coupling, no stray-impedance, zero magnetisation current.</p>
</html>
"));
  end TrafoIdeal;

  model TrafoStray "Ideal magnetic coupling transformer, 3-phase dq0"
    extends Partials.TrafoStrayBase;

  initial equation
    if dynType == Types.Dynamics.SteadyInitial then
      der(i1) = omega[1]*j(i1);
    end if;

  equation
    i1 + i2 = zeros(PS.n);
    if dynType <> Types.Dynamics.SteadyState then
      PS.map({sum(L),sum(L),sum(L0)}) .* der(i1) + omega[2]*sum(L)*j(i1) + sum(
        R)*i1 = v1 - v2;
    else
      omega[2]*sum(L)*j(i1) + sum(R)*i1 = v1 - v2;
    end if;
    annotation (defaultComponentName="trafo", Documentation(info="<html>
<p>Stray-impedance, but ideal magnetic coupling, i.e. zero magnetisation current.<br>
Delta topology: impedance is defined as winding-impedance (see info package Transformers).</p>
<p>SI-input: values for stray and coupling impedances are winding dependent.</p>
<pre>
  r[k]  = R[k]
  x[k]  = omega_nom*L[k]
  x0[k] = omega_nom*L0[k]
</pre>
<p>pu-input: values for stray and coupling impedances are <b>winding</b>-reduced to primary side.</p>
<pre>
  r[k]  = R[k]/R_nom[k]
  x[k]  = omega_nom*L[k]/R_nom[k]
  x0[k] = omega_nom*L0[k]/R_nom[k]
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>"));
  end TrafoStray;

  model TrafoMag "Magnetic coupling transformer, 3-phase dq0"
    extends Partials.TrafoMagBase;

    PS.Voltage[PS.n] v0;
    PS.Current[PS.n] imag;
    PS.Current[PS.n] iedc;

  initial equation
    if dynType == Types.Dynamics.SteadyInitial then
      der(i1) = omega[1]*j(i1);
      der(i2) = omega[1]*j(i2);
      der(imag) = omega[1]*j(imag);
    elseif dynType <> Types.Dynamics.SteadyState then
      der(imag) = omega[1]*j(imag);
    end if;

  equation
    i1 + i2 = imag + iedc;
    Redc*iedc = v0;
    if dynType <> Types.Dynamics.SteadyState then
      PS.map({L[1],L[1],L0[1]}) .* der(i1) + omega[2]*L[1]*j(i1) + R[1]*i1 = v1
         - v0;
      PS.map({L[2],L[2],L0[2]}) .* der(i2) + omega[2]*L[2]*j(i2) + R[2]*i2 = v2
         - v0;
      Lm*der(imag) + omega[2]*Lm*j(imag) = v0;
    else
      omega[2]*L[1]*j(i1) + R[1]*i1 = v1 - v0;
      omega[2]*L[2]*j(i2) + R[2]*i2 = v2 - v0;
      omega[2]*Lm*j(imag) = v0;
    end if;
    annotation (defaultComponentName="trafo", Documentation(info="<html>
<p>Stray-impedance and resistance, with non-ideal magnetic coupling, i.e. non-zero magnetisation current
and eddy current losses.<br>
Delta topology: impedance is defined as winding-impedance (see info package Transformers).</p>
<p>SI-input: values for stray and coupling impedances are winding dependent.</p>
<pre>
  r[k]  = R[k]
  x[k]  = omega_nom*L[k]
  x0[k] = omega_nom*L0[k]
  redc  = Redc
  xm    = omega_nom*Lm
  xm0   = omega_nom*Lm0
</pre>
<p>pu-input: values for stray and coupling impedances are <b>winding</b>-reduced to primary side.</p>
<pre>
  r[k]  = R[k]/R_nom[k]
  x[k]  = omega_nom*L[k]/R_nom[k]
  x0[k] = omega_nom*L0[k]/R_nom[k]
  redc  = Redc/sqrt(R_nom[1]*R_nom[2])
  xm    = omega_nom*Lm/sqrt(R_nom[1]*R_nom[2])
  xm0   = omega_nom*Lm0/sqrt(R_nom[1]*R_nom[2])
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
</html>"));
  end TrafoMag;

  model TrafoSatEff "Averaged saturation transformer, 3-phase dq0"
    extends Partials.TrafoSatBase;

    PS.Voltage[PS.n] v0;
    PS.Current[PS.n] imag;
    PS.Current[PS.n] iedc;
  protected
    Real[PS.n] psi0(each stateSelect=StateSelect.prefer) "unsaturated flux";
    Real gp;
    function der_sat = Common.IronSaturation.der_saturationAnalytic;

  initial equation
    if dynType == Types.Dynamics.SteadyInitial then
      der(i1) = omega[1]*j(i1);
      der(i2) = omega[1]*j(i2);
      der(psi0) = omega[1]*j(psi0);
    elseif dynType <> Types.Dynamics.SteadyState then
      der(psi0) = omega[1]*j(psi0);
    end if;

  equation
    i1 + i2 = imag + iedc;
    Redc*iedc = v0;
    psi0 = Lm*imag;
    gp = scalar(der_sat({0.66*sqrt(psi0*psi0)/psi_nom}, c_sat));

    if dynType <> Types.Dynamics.SteadyState then
      PS.map({L[1],L[1],L0[1]}) .* der(i1) + omega[2]*L[1]*j(i1) + R[1]*i1 = v1
         - v0;
      PS.map({L[2],L[2],L0[2]}) .* der(i2) + omega[2]*L[2]*j(i2) + R[2]*i2 = v2
         - v0;
      gp*(der(psi0) + omega[2]*j(psi0)) = v0;
    else
      omega[2]*L[1]*j(i1) + R[1]*i1 = v1 - v0;
      omega[2]*L[2]*j(i2) + R[2]*i2 = v2 - v0;
      gp*(omega[2]*j(psi0)) = v0;
    end if;
    annotation (defaultComponentName="trafo", Documentation(info="<html>
<p>Stray-impedance and resistance, with non-ideal magnetic coupling, i.e. non-zero magnetisation current, eddy current losses and effective saturation.<br>
Delta topology: impedance is defined as winding-impedance (see info package Transformers).</p>
<p>Note: the saturation is treated as a 'time-average-effect' with the intention to omit variable transforms.<br>
It has to be decided, under which conditions the approximation is acceptable. If this is not the case, use Transformers.TrafoSat (more computation intensive).<br>
The factor <tt>0.66</tt> in the expression of the effective pu flux is an estimation, between <tt>sqrt(1/3)</tt> (eff value of unsaturated flux) and <tt>sqrt(2/3)</tt> (amplitude of unsaturated flux). </p>
<p>SI-input: values for stray and coupling impedances are winding dependent.</p>
<pre>
  r[k]   = R[k]
  x[k]   = omega_nom*L[k]
  x0[k]  = omega_nom*L0[k]
  redc   = Redc
  xm     = omega_nom*Lm
  xm_sat = omega_nom*Lm_sat, saturation value of inductance
  psi_sat, pu saturation value of flux (no SI-value!)
</pre>
<p>pu-input: values for stray and coupling impedances are <b>winding</b>-reduced to primary side.</p>
<pre>
  r[k]   = R[k]/R_nom[k]
  x[k]   = omega_nom*L[k]/R_nom[k]
  x0[k]  = omega_nom*L0[k]/R_nom[k]
  redc   = Redc/sqrt(R_nom[1]*R_nom[2])
  xm     = omega_nom*Lm/sqrt(R_nom[1]*R_nom[2])
  xm_sat = omega_nom*Lm_sat/sqrt(R_nom[1]*R_nom[2]), saturation value of inductance
  psi_sat, pu saturation value of flux
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
<p>Saturation needs high-precision integration!</p>
</html>
"));
  end TrafoSatEff;

  model TrafoSat "Saturation transformer, 3-phase dq0"
    extends Partials.TrafoSatBase;

    PS.Voltage[3] v0;
    PS.Current[3] imag;
    PS.Current[3] iedc;
  protected
    Real[3] psi0(each stateSelect=StateSelect.prefer) "unsaturated flux";
    Real[3] gp;
    Real[3, 3] Park=Utilities.Transforms.park(term_p.theta[2]);
    function der_sat = Common.IronSaturation.der_saturationAnalytic;

  initial equation
    if dynType == Types.Dynamics.SteadyInitial then
      der(i1) = omega[1]*j_dq0(i1);
      der(i2) = omega[1]*j_dq0(i2);
      der(psi0) = omega[1]*j_dq0(psi0);
    elseif dynType <> Types.Dynamics.SteadyState then
      der(psi0) = omega[1]*j_dq0(psi0);
    end if;

  equation
    i1 + i2 = imag + iedc;
    Redc*iedc = v0;
    psi0 = Lm*imag;
    gp = der_sat(transpose(Park)*psi0/psi_nom, c_sat);

    diagonal({L[1],L[1],L0[1]})*der(i1) + omega[2]*L[1]*j_dq0(i1) + R[1]*i1 =
      v1 - v0;
    diagonal({L[2],L[2],L0[2]})*der(i2) + omega[2]*L[2]*j_dq0(i2) + R[2]*i2 =
      v2 - v0;
    Park*diagonal(gp)*transpose(Park)*(der(psi0) + omega[2]*j_dq0(psi0)) = v0;
    annotation (
      defaultComponentName="trafo",
      Documentation(info="<html>
<p>Stray-impedance and resistance, with non-ideal magnetic coupling, i.e. non-zero magnetisation current, eddy current losses and saturation.<br>
Delta topology: impedance is defined as winding-impedance (see info package Transformers).</p>
<p>SI-input: values for stray and coupling impedances are winding dependent.</p>
<pre>
  r[k]   = R[k]
  x[k]   = omega_nom*L[k]
  x0[k]  = omega_nom*L0[k]
  redc   = Redc
  xm     = omega_nom*Lm
  xm_sat = omega_nom*Lm_sat, saturation value of inductance
  psi_sat, pu saturation value of flux (no SI-value!)
</pre>
<p>pu-input: values for stray and coupling impedances are <b>winding</b>-reduced to primary side.</p>
<pre>
  r[k]   = R[k]/R_nom[k]
  x[k]   = omega_nom*L[k]/R_nom[k]
  x0[k]  = omega_nom*L0[k]/R_nom[k]
  redc   = Redc/sqrt(R_nom[1]*R_nom[2])
  xm     = omega_nom*Lm/sqrt(R_nom[1]*R_nom[2])
  xm_sat = omega_nom*Lm_sat/sqrt(R_nom[1]*R_nom[2]), saturation value of inductance
  psi_sat, pu saturation value of flux
</pre>
<p>with</p>
<pre>  R_nom[k] = V_nom[k]^2/S_nom,  k = 1(primary), 2(secondary)</pre>
<p>Saturation needs high-precision integration!</p>
</html>
"),
      Diagram(coordinateSystem(
          preserveAspectRatio=false,
          extent={{-100,-100},{100,100}},
          grid={2,2}), graphics={Line(
              points={{-15,-30},{-11,0},{-7,20},{-5,30},{-1,40},{5,46},{15,50}},
              color={0,0,0},
              thickness=0.5),Line(
              points={{-15,-50},{-11,-20},{-7,0},{-5,10},{-1,20},{5,26},{15,30}},
              color={0,0,0},
              thickness=0.5)}));
  end TrafoSat;

  model Trafo3Stray
    extends Partials.Trafo3StrayBase;

  initial equation
    if dynType == Types.Dynamics.SteadyInitial then
      der(i2a) = omega[1]*j(i2a);
      der(i2b) = omega[1]*j(i2b);
    end if;

  equation
    i1 + i2a + i2b = zeros(PS.n);
    if dynType <> Types.Dynamics.SteadyState then
      PS.map({L[1],L[1],L0[1]}) .* der(i1) + omega[2]*L[1]*j(i1) + R[1]*i1 = v1
         - v0;
      PS.map({L[2],L[2],L0[2]}) .* der(i2a) + omega[2]*L[2]*j(i2a) + R[2]*i2a =
        v2a - v0;
      PS.map({L[3],L[3],L0[3]}) .* der(i2b) + omega[2]*L[3]*j(i2b) + R[3]*i2b =
        v2b - v0;
    else
      omega[2]*L[1]*j(i1) + R[1]*i1 = v1 - v0;
      omega[2]*L[2]*j(i2a) + R[2]*i2a = v2a - v0;
      omega[2]*L[3]*j(i2b) + R[3]*i2b = v2b - v0;
    end if;
  end Trafo3Stray;

  package Partials "Partial models"
    extends Modelica.Icons.BasesPackage;

    partial model TrafoIdealBase "Base for ideal transformer, 3-phase dq0"

      extends Ports.YDportTrafo_p_n(
        final term_p(v(start=PS.map({cos(system.alpha0),sin(system.alpha0),0}*
                par.V_nom[1]))),
        final term_n(v(start=PS.map({cos(system.alpha0),sin(system.alpha0),0}*
                par.V_nom[2]))),
        i1(start=i1_start),
        i2(start=i2_start));

      parameter Types.Dynamics dynType=system.dynType
        "transient or steady-state model"
        annotation (Evaluate=true,Dialog(tab="Initialization"));
      parameter PS.Current[PS.n] i1_start=zeros(PS.n)
        "start value of primary current"
        annotation (Dialog(tab="Initialization"));
      parameter PS.Current[PS.n] i2_start=i1_start
        "start value of secondary current"
        annotation (Dialog(tab="Initialization"));

      parameter Boolean use_tap_1_in=false "= true to enable input tap_1_in"
        annotation (
        Evaluate=true,
        choices(checkBox=true),
        Dialog(group="Options"));
      parameter Integer tap_1=par.tap_neutral[1] "fixed tap_1 position"
        annotation (Dialog(enable=not use_tap_1_in,group="Options"));
      parameter Boolean use_tap_2_in=false "= true to enable input tap_2_in"
        annotation (
        Evaluate=true,
        choices(checkBox=true),
        Dialog(group="Options"));
      parameter Integer tap_2=par.tap_neutral[2] "fixed tap_2 position"
        annotation (Dialog(enable=not use_tap_2_in,group="Options"));
      parameter Boolean dynTC=false "enable dynamic tap-changing" annotation (
          Evaluate=true, Dialog(tab="Initialization", enable=dynType <>
              PowerSystems.Types.Dynamics.SteadyState));

      Modelica.Blocks.Interfaces.IntegerInput tap_1_in if use_tap_1_in
        "1: index of voltage level" annotation (Placement(transformation(
            origin={-40,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
      Modelica.Blocks.Interfaces.IntegerInput tap_2_in if use_tap_2_in
        "2: index of voltage level" annotation (Placement(transformation(
            origin={40,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));

      replaceable record Data =
          PowerSystems.AC3ph.Transformers.Parameters.TrafoIdeal constrainedby
        PowerSystems.AC3ph.Transformers.Parameters.TrafoIdeal
        "trafo parameters" annotation (choicesAllMatching=true);
      final parameter Data par
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    protected
      Modelica.Blocks.Interfaces.IntegerInput tap_1_internal
        "Needed to connect to conditional connector";
      Modelica.Blocks.Interfaces.IntegerInput tap_2_internal
        "Needed to connect to conditional connector";

      outer System system;
      constant Real tc=0.01 "time constant tap-chg switching";
      final parameter PS.Voltage[2] V_base=Utilities.Precalculation.baseTrafoV(
          par.puUnits, par.V_nom);
      final parameter SI.Resistance[2, 2] RL_base=
          Utilities.Precalculation.baseTrafoRL(
              par.puUnits,
              par.V_nom,
              par.S_nom,
              2*pi*par.f_nom);
      final parameter SI.Resistance R_n1=par.r_n[1]*RL_base[1, 1];
      final parameter SI.Resistance R_n2=par.r_n[2]*RL_base[2, 1];
      SI.AngularFrequency[2] omega;
      Real[2] dv_tap_pu=par.dv_tap .* V_base ./ par.V_nom;
      Real w1_set=(1 + (tap_1_internal - par.tap_neutral[1])*dv_tap_pu[1])*sqrt(
          scale[1]) "1: set voltage ratio to nominal primary";
      Real w2_set=(1 + (tap_2_internal - par.tap_neutral[2])*dv_tap_pu[2])*sqrt(
          scale[2]) "2: set voltage ratio to nominal secondary";

    initial equation
      if dynTC then
        w1 = w1_set;
        w2 = w2_set;
      end if;

    equation
      connect(tap_1_in, tap_1_internal);
      connect(tap_2_in, tap_2_internal);
      if not use_tap_1_in then
        tap_1_internal = tap_1;
      end if;
      if not use_tap_2_in then
        tap_2_internal = tap_2;
      end if;

      omega = der(term_p.theta);
      if dynType <> Types.Dynamics.SteadyState and dynTC then
        der(w1) + (w1 - w1_set)/tc = 0;
        der(w2) + (w2 - w2_set)/tc = 0;
      else
        w1 = w1_set;
        w2 = w2_set;
      end if;
      w2_nom = par.V_nom[2]/par.V_nom[1];

      v_n1 = R_n1*i_n1 "1: equation neutral to ground (relevant if Y-topology)";
      v_n2 = R_n2*i_n2 "2: equation neutral to ground (relevant if Y-topology)";
      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={
            Ellipse(
              extent={{-80,60},{40,-60}},
              lineColor={44,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-40,60},{80,-60}},
              lineColor={0,120,120},
              lineThickness=0.5,
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Ellipse(
              extent={{-80,60},{40,-60}},
              lineColor={0,120,120},
              lineThickness=0.5),
            Text(
              extent={{-120,80},{-80,40}},
              lineColor={0,0,0},
              textString="1"),
            Text(
              extent={{80,80},{120,40}},
              lineColor={0,0,0},
              textString="2"),
            Line(
              points={{-80,0},{-40,0}},
              color={176,0,0},
              thickness=0.5),
            Line(
              points={{40,0},{80,0}},
              color={176,0,0},
              thickness=0.5)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{-20,60},{-14,-60}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{14,60},{20,-60}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Line(points={{-40,0},{-40,-80}},
              color={0,0,255}),Line(points={{40,0},{40,-80}}, color={0,0,255}),
              Rectangle(
                  extent={{-50,-80},{-30,-84}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{30,-80},{50,-84}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>Terminology (formal, the models are symmetric).<br>
&nbsp; - index 1 (term_p)     \"primary\"<br>
&nbsp; - index 2 (term_n)     \"secondary\"</p>
<p>Contains choice of topology (Delta or Y connection primary and secondary).<br>
Note that transformers with topology 'Delta-Y' and 'Y-Delta' exhibit a phase-shift
of the voltage signals Delta-side versus the signals Y-side of -30 deg.<br>
&nbsp; Delta (prim) - Y (sec): Y is 30 deg shifted versus Delta<br>
&nbsp; Y (prim) - Delta (sec): Delta is -30 deg shifted versus Y<br>
&nbsp; Setting the parameter <tt>sh = +-1</tt> shifts the secondary side by <tt>+-120 deg</tt>.</p>
<p>Transformer ratio.<br>
The winding ratio is determined indirectly by the choice of nominal voltages and the topology of both primary and secondary side.<br>
It may be &gt; 1 or &lt; 1.</p>
<p>Tap changers.<br>
For constant transformer ratio no tap changer input needed.<br>
For variable transformer ratio tap changer input needed.</p>
<p>The sequence of the parameters</p>
<pre>  v_tc     tc voltage levels v_tc[1], v_tc[2], v_tc[3], ...</pre>
<p>must be defined in accordance with the input-signals of </p>
<pre>  tap     index of tap voltage levels, v_tc[tap]</pre>
<p>Set <tt>dynTC = true</tt> if tap-index changes during simulation.</p>
</html>"));
    end TrafoIdealBase;

    partial model TrafoStrayBase
      "Base for ideal magnetic coupling transformer, 3-phase dq0"
      extends TrafoIdealBase(redeclare replaceable record Data =
            PowerSystems.AC3ph.Transformers.Parameters.TrafoStray
          constrainedby PowerSystems.AC3ph.Transformers.Parameters.TrafoStray);
    protected
      SI.Resistance[2] R=par.r .* RL_base[:, 1];
      SI.Inductance[2] L=par.x .* RL_base[:, 2];
      SI.Inductance[2] L0=par.x0 .* RL_base[:, 2];
      annotation (
        Documentation(info="<html>
<p>Precalculation of coefficients for ideal magnetic coupling transformer</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{-10,62},{10,-62}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{-26,60},{-20,-60}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{20,60},{26,-60}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid)}));
    end TrafoStrayBase;

    partial model TrafoMagBase
      "Base for magnetic coupling transformer, 3-phase dq0"
      extends TrafoStrayBase(redeclare replaceable record Data =
            PowerSystems.AC3ph.Transformers.Parameters.TrafoMag constrainedby
          PowerSystems.AC3ph.Transformers.Parameters.TrafoMag);
    protected
      final parameter SI.Resistance[2] RL12_base=sqrt((RL_base[1, :] .* RL_base[
          2, :])/product(scale));
      SI.Resistance Redc=par.redc*RL12_base[1];
      SI.Inductance Lm=par.xm*RL12_base[2];
      SI.Inductance Lm0=par.xm0*RL12_base[2];
      annotation (
        Documentation(info="<html>
<p>Precalculation of coefficients for magnetic coupling trafo transformer</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(
                  points={{-20,62},{-20,-62}},
                  color={0,128,255},
                  pattern=LinePattern.Dot),Line(
                  points={{20,62},{20,-62}},
                  color={0,128,255},
                  pattern=LinePattern.Dot),Ellipse(
                  extent={{-22,62},{-18,58}},
                  lineColor={0,128,255},
                  fillColor={0,128,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{18,-58},{22,-62}},
                  lineColor={0,128,255},
                  fillColor={0,128,255},
                  fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(
                  points={{-30,60},{-30,-60}},
                  color={0,0,255},
                  pattern=LinePattern.Dot),Line(
                  points={{30,60},{30,-60}},
                  color={0,0,255},
                  pattern=LinePattern.Dot)}));
    end TrafoMagBase;

    partial model TrafoSatBase "Base for saturation transformer, 3-phase dq0"
      extends TrafoMagBase(redeclare replaceable record Data =
            PowerSystems.AC3ph.Transformers.Parameters.TrafoSat constrainedby
          PowerSystems.AC3ph.Transformers.Parameters.TrafoSat);
    protected
      Real xratio=par.xm_sat/par.xm;
      Real[3] c_sat={1 - xratio,(1 - xratio)/(par.psi_sat - xratio),xratio};
      final parameter SI.MagneticFlux psi_nom=sqrt(scale[1])*par.V_nom[1]/(2*pi
          *par.f_nom) "amplitude!";
      annotation (
        Documentation(info="<html>
<p>Precalculation of coefficients for saturation transformer</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(
                  points={{-15,-40},{-11,-10},{-7,10},{-5,20},{-1,30},{5,36},{
                15,40}},
                  color={0,0,0},
                  thickness=0.5)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Line(
                  points={{-15,-40},{-11,-10},{-7,10},{-5,20},{-1,30},{5,36},{
                15,40}},
                  color={0,0,0},
                  thickness=0.5)}));

    end TrafoSatBase;

    partial model Trafo3IdealBase
      "Base for ideal 3-winding transformer, 3-phase dq0"

      extends Ports.YDportTrafo_p_n_n(
        final term_p(v(start=PS.map({cos(system.alpha0),sin(system.alpha0),0}*
                par.V_nom[1]))),
        final term_na(v(start=PS.map({cos(system.alpha0),sin(system.alpha0),0}*
                par.V_nom[2]))),
        final term_nb(v(start=PS.map({cos(system.alpha0),sin(system.alpha0),0}*
                par.V_nom[3]))));

      parameter Types.Dynamics dynType=system.dynType
        "transient or steady-state model"
        annotation (Evaluate=true,Dialog(tab="Initialization"));

      parameter Boolean use_tap_1_in=false "= true to enable input tap_1_in"
        annotation (
        Evaluate=true,
        choices(checkBox=true),
        Dialog(group="Options"));
      parameter Integer tap_1=par.tap_neutral[1] "fixed tap_1 position"
        annotation (Dialog(enable=not use_tap_1_in,group="Options"));
      parameter Boolean use_tap_2_in=false "= true to enable input tap_2_in"
        annotation (
        Evaluate=true,
        choices(checkBox=true),
        Dialog(group="Options"));
      parameter Integer[2] tap_2=par.tap_neutral[2:3] "fixed tap_2 position"
        annotation (Dialog(enable=not use_tap_2_in,group="Options"));
      parameter Boolean dynTC=false "enable dynamic tap-changing"
        annotation (Evaluate=true,Dialog(group="Options"));

      Modelica.Blocks.Interfaces.IntegerInput tap_1_in if use_tap_1_in
        "1: index of voltage level" annotation (Placement(transformation(
            origin={-40,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));
      Modelica.Blocks.Interfaces.IntegerInput[2] tap_2_in if use_tap_2_in
        "2: indices of voltage levels" annotation (Placement(transformation(
            origin={40,100},
            extent={{-10,-10},{10,10}},
            rotation=270)));

      replaceable record Data =
          PowerSystems.AC3ph.Transformers.Parameters.Trafo3Ideal constrainedby
        PowerSystems.AC3ph.Transformers.Parameters.Trafo3Ideal
        "trafo parameters" annotation (choicesAllMatching=true);
      final parameter Data par "trafo parameter record"
        annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
    protected
      Modelica.Blocks.Interfaces.IntegerInput tap_1_internal
        "Needed to connect to conditional connector";
      Modelica.Blocks.Interfaces.IntegerInput[2] tap_2_internal
        "Needed to connect to conditional connector";

      outer System system;
      constant Real tc=0.01 "time constant tap-chg switching";
      final parameter PS.Voltage[3] V_base=Utilities.Precalculation.baseTrafoV(
          par.puUnits, par.V_nom);
      final parameter SI.Resistance[3, 2] RL_base=
          Utilities.Precalculation.baseTrafoRL(
              par.puUnits,
              par.V_nom,
              par.S_nom,
              2*pi*par.f_nom);
      final parameter SI.Resistance R_n1=par.r_n[1]*RL_base[1, 1];
      final parameter SI.Resistance R_n2a=par.r_n[2]*RL_base[2, 1];
      final parameter SI.Resistance R_n2b=par.r_n[3]*RL_base[3, 1];
      SI.AngularFrequency omega[2];
      Real[3] dv_tap_pu=par.dv_tap .* V_base ./ par.V_nom;
      Real w1_set=(1 + (tap_1_internal - par.tap_neutral[1])*dv_tap_pu[1])*sqrt(
          scale[1]) "1: set voltage ratio to nominal primary";
      Real w2a_set=(1 + (tap_2_internal[1] - par.tap_neutral[2])*dv_tap_pu[2])*
          sqrt(scale[2]) "2a: set voltage ratio to nominal secondary";
      Real w2b_set=(1 + (tap_2_internal[2] - par.tap_neutral[3])*dv_tap_pu[3])*
          sqrt(scale[3]) "2b: set voltage ratio to nominal secondary";

    initial equation
      if dynTC then
        w1 = w1_set;
        w2a = w2a_set;
        w2b = w2b_set;
      end if;

    equation
      connect(tap_1_in, tap_1_internal);
      connect(tap_2_in, tap_2_internal);
      if not use_tap_1_in then
        tap_1_internal = tap_1;
      end if;
      if not use_tap_2_in then
        tap_2_internal = tap_2;
      end if;

      omega = der(term_p.theta);
      if dynType <> Types.Dynamics.SteadyState and dynTC then
        der(w1) + (w1 - w1_set)/tc = 0;
        der(w2a) + (w2a - w2a_set)/tc = 0;
        der(w2b) + (w2b - w2b_set)/tc = 0;
      else
        w1 = w1_set;
        w2a = w2a_set;
        w2b = w2b_set;
      end if;
      w2a_nom = par.V_nom[2]/par.V_nom[1];
      w2b_nom = par.V_nom[3]/par.V_nom[1];

      v_n1 = R_n1*i_n1 "1: equation neutral to ground (relevant if Y-topology)";
      v_n2a = R_n2a*i_n2a
        "2a: equation neutral to ground (relevant if Y-topology)";
      v_n2b = R_n2b*i_n2b
        "2b: equation neutral to ground (relevant if Y-topology)";
      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Ellipse(
                  extent={{-80,60},{40,-60}},
                  lineColor={44,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-20,90},{80,-10}},
                  lineColor={0,0,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Text(
                  extent={{-120,80},{-80,40}},
                  lineColor={0,0,0},
                  textString="1"),Text(
                  extent={{80,20},{120,-20}},
                  lineColor={0,0,0},
                  textString="2"),Line(
                  points={{-80,0},{-20,0}},
                  color={176,0,0},
                  thickness=0.5),Ellipse(
                  extent={{-20,10},{80,-90}},
                  lineColor={0,120,120},
                  lineThickness=0.5,
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-80,60},{40,-60}},
                  lineColor={0,120,120},
                  lineThickness=0.5),Ellipse(
                  extent={{-20,90},{80,-10}},
                  lineColor={0,120,120},
                  lineThickness=0.5),Line(
                  points={{30,-40},{80,-40}},
                  color={176,0,0},
                  thickness=0.5),Line(
                  points={{30,40},{80,40}},
                  color={176,0,0},
                  thickness=0.5),Text(
                  extent={{80,100},{120,60}},
                  lineColor={0,0,0},
                  textString="a"),Text(
                  extent={{80,-60},{120,-100}},
                  lineColor={0,0,0},
                  textString="b")}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{-20,60},{-14,-60}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{14,60},{20,-60}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Line(points={{-40,0},{-40,-80}},
              color={0,0,255}),Line(points={{40,40},{40,-80}}, color={0,0,255}),
              Rectangle(
                  extent={{-50,-80},{-30,-84}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{30,-80},{50,-84}},
                  lineColor={128,128,128},
                  fillColor={128,128,128},
                  fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>Terminology (formal, the models are symmetric).<br>
&nbsp; - index 1 (term_p)     \"primary\"<br>
&nbsp; - index 2a (term_na)     \"secondary a\"<br>
&nbsp; - index 2b (term_nb)     \"secondary b\"</p>
<p>Contains choice of topology (Delta or Y connection primary and secondary).<br>
Note that transformers with topology 'Delta-Y' and 'Y-Delta' exhibit a phase-shift
of the voltage signals Delta-side versus the signals Y-side of -30 deg.<br>
&nbsp; Delta (prim) - Y (sec): Y is 30 deg shifted versus Delta<br>
&nbsp; Y (prim) - Delta (sec): Delta is -30 deg shifted versus Y<br>
&nbsp; Setting the parameter <tt>sh = +-1</tt> shifts the secondary side by <tt>+-120 deg</tt>.</p>
<p>Transformer ratio.<br>
The winding ratio is determined indirectly by the choice of nominal voltages and the topology of both primary and secondary side.<br>
It may be &gt; 1 or &lt; 1.</p>
<p>Tap changers.<br>
For constant transformer ratio no tap changer input needed.<br>
For variable transformer ratio tap changer input needed.</p>
<p>The sequence of the parameters</p>
<pre>  v_tc     tc voltage levels v_tc[1], v_tc[2], v_tc[3], ...</pre>
<p>must be defined in accordance with the input-signals of </p>
<pre>  tap     index of tap voltage levels, v_tc[tap]</pre>
<p>Set <tt>dynTC = true</tt> if tap-index changes during simulation.</p>
</html>"));
    end Trafo3IdealBase;

    partial model Trafo3StrayBase
      "Base for ideal magnetic coupling 3-winding transformer, 3-phase dq0"
      extends Trafo3IdealBase(redeclare replaceable record Data =
            PowerSystems.AC3ph.Transformers.Parameters.Trafo3Stray
          constrainedby PowerSystems.AC3ph.Transformers.Parameters.Trafo3Stray);
    protected
      SI.Resistance[3] R=par.r .* RL_base[:, 1];
      SI.Inductance[3] L=par.x .* RL_base[:, 2];
      SI.Inductance[3] L0=par.x0 .* RL_base[:, 2];
      annotation (
        Documentation(info="<html>
<p>Precalculation of coefficients for ideal magnetic coupling 3-winding transformer</p>
</html>"),
        Icon(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{0,62},{20,-62}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(
            preserveAspectRatio=false,
            extent={{-100,-100},{100,100}},
            grid={2,2}), graphics={Rectangle(
                  extent={{-26,60},{-20,-60}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{20,60},{26,-60}},
                  lineColor={215,215,215},
                  fillColor={215,215,215},
                  fillPattern=FillPattern.Solid)}));
    end Trafo3StrayBase;

  end Partials;

  package Parameters "Parameter data for interactive use"
    extends Modelica.Icons.MaterialPropertiesPackage;

    record TrafoIdeal "Parameters for ideal transformer, 3-phase"
      extends Common.Nominal.NominalDataTrafo;

      Integer[2] tap_neutral={0,0} "{1,2}: neutral tap position"
        annotation (Dialog(group="Options"));
      SIpu.Voltage[2] dv_tap={0,0} "{1,2}: delta-v per tap change"
        annotation (Dialog(group="Options"));
      SIpu.Resistance[2] r_n={1,1} "{1,2}: resistance neutral to grd (if Y)"
        annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
</html>"));
    end TrafoIdeal;

    record TrafoStray
      "Parameters for ideal magnetic coupling transformer, 3-phase"
      extends TrafoIdeal;

      SIpu.Resistance[2] r={0.05,0.05} "{1,2}: resistance" annotation (Dialog);
      SIpu.Reactance[2] x={0.05,0.05} "{1,2}: stray reactance"
        annotation (Dialog);
      SIpu.Reactance[2] x0={x[1],x[2]} "{1,2}: stray reactance zero-comp"
        annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
</html>"));
    end TrafoStray;

    record TrafoMag "Parameters for magnetic coupling transformer, 3-phase"
      extends TrafoStray;

      SIpu.Resistance redc=500 "resistance eddy current" annotation (Dialog);
      SIpu.Reactance xm=500 "mutual reactance" annotation (Dialog);
      SIpu.Reactance xm0=1 "mutual reactance zero" annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
</html>"));
    end TrafoMag;

    record TrafoSat "Parameters for saturation transformer, 3-phase"
      extends TrafoMag;

      Real psi_sat(unit="1") = 1.5 "saturation flux" annotation (Dialog);
      SIpu.Reactance xm_sat=1 "mutual reactance saturated" annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
</html>"));
    end TrafoSat;

    record Trafo3Ideal "Parameters for ideal 3-winding transformer, 3-phase"
      extends Common.Nominal.NominalDataTrafo(V_nom={1,1,1}
          "{prim,sec_a,sec_b} nom Voltage (= base if pu)");

      Integer[3] tap_neutral={0,0,0} "{1,2a,2b}: neutral tap position"
        annotation (Dialog(group="Options"));
      SIpu.Voltage[3] dv_tap={0,0,0} "{1,2a,2b}: delta-v per tap change"
        annotation (Dialog(group="Options"));
      SIpu.Resistance[3] r_n={1,1,1}
        "{1,2a,2b}: resistance neutral to grd (if Y)" annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
<p>Nominal voltage with 3 components: {prim, sec_a, sec_b}.</p>
</html>"));
    end Trafo3Ideal;

    record Trafo3Stray
      "Parameters for ideal magnetic coupling 3-winding transformer, 3-phase"
      extends Trafo3Ideal;

      SIpu.Resistance[3] r={0.05,0.05,0.05} "{1,2a,2b}: resistance"
        annotation (Dialog);
      SIpu.Reactance[3] x={0.05,0.05,0.05} "{1,2a,2b}: stray reactance"
        annotation (Dialog);
      SIpu.Reactance[3] x0={x[1],x[2],x[3]}
        "{1,2a,2b}: stray reactance zero-comp" annotation (Dialog);

      annotation (
        defaultComponentName="data",
        defaultComponentPrefixes="parameter",
        Documentation(info="<html>
</html>"));
    end Trafo3Stray;

    annotation (preferredView="info", Documentation(info="<html>
<p>Records containing parameters of the corresponding components.</p>
</html>"));
  end Parameters;

  annotation (preferredView="info", Documentation(info="<html>
<p>Transformer models in different abstraction levels.</p>
<p>All transformers allow the choice between Y- and Delta-topology both at primary and secondary side.<br>
For Delta an additional phase-shift may be chosen in order to adapt to a given phase-numbering scheme.<br>
The impedance parameters are defined 'as seen from the terminals', directly relating terminal voltage and terminal current. With this definition same parameters lead to same network properties, independent of topology. The necessary scaling is performed automatically.</p>
<p>In Delta-topology the conductor voltage is sqrt(3) higher, the current sqrt(3) lower,
compared to the terminal voltage and current. Therefore the impedance relating conductor current and voltage is a factor 3 larger, the admittance a factor 1/3 smaller than the impedance and admittance as seen from the terminal.</p>
<p>If impedance parameters are given for the Deta-connected WINDINGS, choose:</p>
<pre>  input values impedance parameters = 1/3 * (impedance parameters of windings)</pre>
<p>In the dq0-representation the following relations hold between terminal-voltage <tt>v_term</tt> and -current <tt>i_term</tt> on the one hand and conductor-voltage <tt>v_cond</tt> and -current <tt>i_cond</tt> on the other.</p>
<p>A) Y-topology.</p>
<pre>
  v_cond = v_term - {0, 0, sqrt(3)*v_n};
  i_term = i_cond;
  i_n = sqrt(3)*i_term[3];
</pre>
<p>where <tt>v_n</tt> denotes the voltage at the neutral point and <tt>i_n</tt> the current neutral to ground.</p>
<p>B) Delta-topology.</p>
<pre>
  v_cond[1:2] = sqrt(3)*R30*v_term[1:2];
  i_term[1:2] = sqrt(3)*transpose(R30)*i_cond[1:2];
  v_cond[3] = 0;
  i_term[3] = 0;
</pre>
<p>where <tt>R30</tt> denotes a rotation by 30deg in positive sense.<br>
(Alternative solutions corresponding to permuted phases are <tt>R-90</tt> and <tt>R150</tt> instead of <tt>R30</tt>).</p>
<p>The winding scaled voltage- and current-variables <tt>v</tt> and <tt>i</tt> are related to the corresponding conductor quantities through the relation:
<pre>
  v = v_cond/w
  i = i_cond*w
</pre>
The equations are written in winding-scaled form.</p>
</html>"));
end Transformers;
