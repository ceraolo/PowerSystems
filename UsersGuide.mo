within PowerSystems;
package UsersGuide "User's Guide"
  package ShortGuide "Short Guide to PSL"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p align=\"center\"><h4>BASIC INFORMATION</h4></p>
<p><b>The Modelica PowerSystems library</b> is intended for the modeling of electrical power systems at different levels of detail both in transient and steady-state mode.</p>
<p>This library contains basically two sets of models. </p>
<p><b>1) Models that are available under the &QUOT;AC1ph_DC&QUOT; package</b>. These models allow time-domain simulations of single-phase systems, with shape of current and voltage that can be arbitrary: no need to have sines. Possibly containing DC components and non-sinusoidal voltages and currents. They are somewhat similar to the models included in Modelica.Electric.Analog, but they are written having electric power engineers in mind.</p>
<p><b>2) Models that are available under the &QUOT;AC3ph&QUOT; package</b>. These models take advantage of the DQ0 transform (Power-invariant Parks&apos;s transform). In this way, when currents and voltages are balanced (the three quantities are sines which are equal in amplitude have equally spaced phases) the correspoding DQ0 components are constant.</p>
<h4>THE UNITS OF MEASURE</h4>
<p>The so-called p.u. (or PU) System is largely used in Power System analysis, and in power system components databases. In short it consists in using units of measure of quantities (currents, voltages, powers, etc.) that are not those of the S.I, or any other general system, but are specific to the problem considered. If ron instance We have a problem in qhich the majority of voltages are around 230 V (230 times a volt), the unit of measure chosen might be 230 V. In such a way a voltage equal to 1.1 PU simply means 1.1 times the reference times, in turn 230 V.</p>
<p>The PU system is very largely used by power System Engineers, because of advantages that are discussed in any book of Power System Analysis.</p>
<p>In the Power System Library there is always a choice, for both input and output quantities, between PU or SI; tt is important to note, however, that that PU is only used for parameterization and for sensors. All internal variables are S.I. and phase systems define as the standard display unit kV. </p>
<p>A Boolean choice is available at the component based level to decide wheter to input quantities expressed in SI or in PU.</p>
<p><i>Note that, due to the current Modelica standard, the units of measure of plotted quantities are unable to make this distinction. Therefore, for instance, a voltage will always be shown as having as unit &ldquo;V/V&rdquo;, whether it is actually p.u. or S.I. The user has the burden to remember which is the current choice. </i></p>
<h4>THE PSL DQ0 TRANSFORM BASICS</h4>
<p>Different types of the DQ0 transform are proposed in books and papers. The power System Library uses the Power Invariant Transform, which is rapidly recalled here.</p>
<p>Consider three phase quantities: <i>A</i><sub>1</sub>, <i>A</i><sub>2</sub> <i>A</i><sub>3</sub> (they could for instance be the three phase voltages in a point of the system, <i>U</i><sub>1</sub>, <i>U</i><sub>2</sub>, <i>U</i><sub>3</sub>). They are transformed into their DQ0 transform counterpart as follows:</p>
<p><img src=\"modelica://PowerSystems/ParkIntro.png\"/> <img src=\"modelica://PowerSystems/PDefinition.png\"/></p>
<p>with <i><b><span style=\"font-family: Times New Roman; font-size: 10pt;\">P</span></b></i>=<i><b>RC</b></i> and</p>
<p><img src=\"modelica://PowerSystems/RDefinition.png\"/> <img src=\"modelica://PowerSystems/CDefinition.png\"/></p>
<p>I.e., Park&apos;s matrix <i><b>P</b></i> is obtained by composition of Clarke&apos;s transform matrix <i><b>C</b></i> and rotation&apos;s matrix <i><b>R</b></i>.</p>
<p>In Power System Library<img src=\"modelica://PowerSystems/ThetaDef.png\"/> and we have three options for the parameter <span style=\"font-family: Symbol;\">w</span> (called in System model <span style=\"font-family: Courier New;\">omega</span>) depending on the value of fType parameter in System model:</p>
<ol>
<li>For <span style=\"font-family: Courier New;\">fType Parameter</span> this is simply a parameter value.</li>
<li>For <span style=\"font-family: Courier New;\">fType Signal</span> it is a positive input signal.</li>
<li>For<span style=\"font-family: Courier New;\"> fType Average</span> it is a weighted average over the relevant generator frequencies.</li>
</ol>
<p><br>A special case is when we use <span style=\"font-family: Symbol;\">w</span> =0. In this case the rotational matrix becomes the identity matrix <i>I</i><sub>3</sub>, and the Park Transform reduces to Clarke&apos;s. In this case, if the system operates indeed at a given frequency, signals <i>A</i><sub>d</sub>, <i>A</i><sub>q</sub>, <i>A</i><sub>0</sub> as a function of time oscillate. In power Systems library whether to use park&apos;s or Clarke&apos;s transform is selected by means parameter refType System model(here the variable previously shown as <i><span style=\"font-family: Symbol;\">q</span></i> is called <span style=\"font-family: Courier New;\">theta_</span>): </p>
<ul>
<li><span style=\"font-family: Courier New;\">thetaRef = theta_ if refType == Synchron</span> (reference frame is synchronously rotating with theta).</li>
<li><span style=\"font-family: Courier New;\">thetaRef = 0 if refType == Inertial </span>(inertial reference frame, not rotating).</li>
</ul>
<p><br>In the System model terminology, we have:</p>
<p><span style=\"font-family: Courier New;\">der(theta_) = omega</span></p>
<p><span style=\"font-family: Courier New;\">thetaRel=theta_-thetaRef</span></p>
<p><br>In each connector of the AC3ph sub-package the array <span style=\"font-family: Courier New;\">theta = {thetaRel, thetaRef}</span> is always present.</p>
<p>Therefore:</p>
<ul>
<li>if <span style=\"font-family: Courier New;\">refType==Synchron</span> then <span style=\"font-family: Courier New;\">theta = {0, theta_}</span></li>
<li>if <span style=\"font-family: Courier New;\">refType==Inertia</span>l then <span style=\"font-family: Courier New;\">theta = {theta_, 0}</span> </li>
</ul>
<h4>POWER IN THE USED DQ0 TRANSFORM</h4>
<p>Power is computed as per the function ThreePhase_dq.phasePowers_vi in PackagePhaseSystem</p>
<p>This definition uses as function function &QUOT;j&QUOT; , which is in PhaseSystems.ThreePhase_dq.j</p>
<p>This definition results in the computation of the array p[3], whose elements have a special interpretation when voltage and current systems are both balanced:</p>
<p>p[1] is the three-phase active power</p>
<p>p[2] is the three-phase reactive power</p>
<p>p[0] is zero.</p>
<h4>DQ0 TRANSFORM OF LINES</h4>
<p>In papers and books DQ0 transform is often gdiscussed with reference to a single rotating machine. Since AC3ph models of PSL work using Park&apos;s transformation throughout the system, it is important to draw also the DQ0 transformatio of three-phase lines.</p>
<p>Consider a transmission line:</p>
<p><img src=\"modelica://PowerSystems/LineDQ0.png\"/></p>
<p>Its equation, if capacitances are neglected (short line) is: </p>
<p><img src=\"modelica://PowerSystems/LinePhase.png\"/> (1)</p>
<p>In PSL line models consider only symmetrical lines, in which <i><b>R</b></i><sub>f</sub> and <i><b>L</b></i><sub>f</sub> have a special structure, i.e.:</p>
<p><img src=\"modelica://PowerSystems/R_line.png\"/> <img src=\"modelica://PowerSystems/L_line.png\"/> (2)</p>
<p>Where <i>R</i> is the resistance of a single conductor wire, <i>L</i> and <i>M</i> are the self and mutual inductance coefficients, respectively. </p>
<p>It must be said that in Power System Analysis lines are often considered as being symmetrical, since high voltage lines are normally rendered such by transposition.</p>
<p>For such lines it can be easily shown that equation (1), transformed in DQ0 quantities, becomes:</p>
<p><img src=\"modelica://PowerSystems/LinePark.png\"/> (3)</p>
<p>Equation (3) is equivalent to (1) when equations (2) are met.</p>
<p>When the system operates with balanced voltages and currents, eq. (3) becomes:</p>
<p><img src=\"modelica://PowerSystems/LineParkSS.png\"/> (4)</p>
<p><br>PSL simulates lines using (3) or (4) depending on whether in the System model dynType==SteadyInitial or dynType==SteadyStarte, respectively.</p>
<p>See the specific examples showing the difference between these two dynTypes: Examples.Introductory.SimulationSteadyInitial and Examples.Introductory.SimulationSteadyState.</p>
<h4>INITIALISATION</h4>
<p>Due to the representation of the overall system in DQ0-coordinates, the initialization can be done with the same differential algebraic system that is later used for the dynamic simulation. </p>
<p>On the contrary when only time-domain approach is used, usually a separate equation system referring to the sinusoidal steady-state is generated (this is done with resolution of an algebraic system with complex numbers in ATP/EMTP simulation programs). </p>
<p>This a very important advantage of the DQ0 approach adopted. </p>
<p>When in the System menu the option &ldquo;FixedInitial&rdquo; is chosen, simulation starts with fixed initial conditions. Default values for line currents are zero. </p>
<p><span style=\"color: #ff0000;\">When I wrote these notes I was not able to change these defaults, and therefore I cannot explain how to do this (M. Ceraolo)</span> </p>
</html>"));
  end ShortGuide;
  extends Modelica.Icons.Information;

  package Examples "Examples"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p><a href=\"modelica://PowerSystems.Examples.Network\">Examples.Network</a>: The examples NetworkLoop and NetworkOpened are taken from the textbook Oeding, Oswald: Elektrische Kraftwerke und Netze, section 14.2.5: Leistungsfluss in Ringnetzen. The example NetworkControlled additionally investigates frequency/power control in conjunction with the Modelica.Rotational library and a basic EMF (Electro-Motoric Force). </p>
<p><a href=\"modelica://PowerSystems.Examples.PowerWorld\">Examples.PowerWorld</a> models a control area for power distribution in island mode. It was used to demonstrate &quot;Stabilization of wind power&quot; in the Eurosyslib work package 5.3. See . </p>
<p><a href=\"modelica://PowerSystems.Examples.Spot\">Examples.Spot</a> serve as tutorial and interactive documentation for the detailed component models in AC1ph_DC and AC3ph. </p>
</html>"));
  end Examples;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;
    annotation (Documentation(info="<html>
<p><b>Contributors</b></p>
<ul>
<li>Hansj&uuml;rg Wiesmann (&dagger; 2015):<br>
   Wrote the original Spot library and supported the creation of the PowerSystems library.
</li>
<li><a href=\"mailto:Martin.Otter@dlr.de\">Martin Otter</a>:<br>
   Converted the original Spot library from Modelica 2 to Modelica 3.
</li>
<li><a href=\"mailto:Ruediger.Franke@de.abb.com\">R&uuml;diger Franke</a>:<br>
   Created the PowerSystems library out of the PowerFlow concept library and the Spot library.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li><i>18 Jan 2017</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
    Version 0.6.0
  <ul>
  <li>Enhance AC3ph with replaceable PhaseSystem.
      Many components work with ThreePhase_dq as well, besides the default ThreePhase_dq0.</li>
  <li>Introduce own SI sub-package to get appropriate display units.</li>
  <li>Treat PerCent as display unit, 0..1 internally.</li>
  <li>Implement inertial reference frame for Generic components (#18)</li>
  <li>Fix some HTML warnings (#20)</li>
  <li>Fix measurement units in PWM control models (#21)</li>
  <li>Make phasor of PVImeter unconditional (#26)</li>
  <li>Unify naming of start values for Loads</li>
  <li>Reorganize Examples to better outline the Introductory examples and
      to better reflect the three component sub-packages AC3ph, AC1ph_DC and Generic.</li>
  </ul>
</li>
<li><i>20 Sep 2016</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
    Version 0.5.0<br>
    This release introduces a couple of changes that improve the modeling experience
    and unify the library with other Modelica libraries.
  <ul>
  <li>Introduce replaceable model and record types, instead of replaceable
      model and record instances.</li>
  <li>Simplify initialization
  <ul><li>Introduce enumeration Types.Dynamics dynType, replacing Booleans stIni_en, steadyIni_t and transientSim</li>
      <li>Unify naming of start parameters from *_ini to *_start</li>
      <li>Simplify initialization of machine rotors and line models</li>
  </ul></li>
  <li>Rework AC3ph and AC1ph_DC line models: rename PIline to Tline and introduce new PIline.</li>
  <li>Rework tap changers of AC3ph and AC1ph_DC trafo models: treat effect of tap changers in replaceable Topology, enabling more arrangements such as phase angle regulating.</li>
  <li>Add examples for electrical drive trains of wind turbines</li>
  <li>Reorganize Basic package to Utilities.</li>
  <li>Add Inline=true annotations to functions that shall be inlined.</li>
  <li>Introduce PhaseSystem Voltage and Current types, including nominal values of 1000.</li>
  <li>Upgrade Phasor model to standard Modelica graphics.</li>
  <li>Base on Modelica 3.2.2 instead of 3.2.1 (without changing anything).</li>
  </ul>
</li>
<li><i>14 Mar 2015</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.4.0
  <ul>
  <li>fix Generic components to work with simple ThreePhase_d again (was broken in v0.3)</li>
  <li>rework parameter records (move parameter qualifiers from record members to whole records to permit their construction with functions)</li>
  <li>remove ambiguous start values</li>
  <li>lot of clean-up</li>
  </ul>
</li>
<li><i>20 Oct 2014</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.3
  <ul>
  <li>add initial equations to Generic models and related examples</li>
  <li>add start parameters to AC1phDC and extend transient initialization</li>
  <li>add start parameters to AC3ph to improve steady-state initialization</li>
  <li>fix use of condionally declared variables</li>
  <li>clean up annotations</li>
  <li>rename dqo to dq0</li>
  </ul>
</li>
<li><i>15 Aug 2014</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.2.1
  <ul>
  <li>use Modelica.Utilities.Files.loadResource() instead of deprecated classDirectory()</li>
  <li>fix references to Connections package</li>
  </ul>
</li>
<li><i>18 Apr 2013</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.2
  <ul>
  <li>Clean-up Examples and Resources</li>
  </ul>
</li>
<li><i>28 Feb 2013</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.1.3
  <ul>
  <li>Generic: change connector units from MW to W</li>
  </ul>
</li>
<li><i>22 Dec 2012</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.1.2
  <ul>
  <li>Rework Basic.Types to using SI units</li>
  <li>Adapt parameter records to SI units</li>
  </ul>
</li>
<li><i>15 Dec 2012</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.1.1
  <ul>
  <li>Rename Utilities package to Basic</li>
  <li>Remove BasePU and BaseSI sub-packages</li>
  </ul>
</li>
<li><i>6 Dec 2012</i>
    by <a href=\"mailto:Ruediger.Franke@de.abb.com\">Ruediger Franke</a>:<br>
     Version 0.1
  <ul>
  <li>Initial version</li>
  </ul>
</li>
</ul>
</html>"));
  end ReleaseNotes;

  annotation (
    DocumentationClass=true,
    preferredView="info",
    Documentation(info="<html>
<p>The User&apos;s guide is composed by a &QUOT;<b>ShortGuide</b>&QUOT; and &QUOT;<b>Examples</b>&QUOT;.</p>
<p>The <u>ShortGuide</u> package contains very basic information that is higly recommended to any new user of the library.</p>
<p>To get more detailed info the following scientific papers are recommended:</p>
<p>1) <a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">Bachmann, Wiesmann: Advanced Modeling of Electromagnetic Transients in Power Systems -- Modelica Workshop 2000 Proceedings, pp93-97</a>.</p>
<p>2) <a href=\"https://www.modelica.org/events/modelica2014/proceedings/html/submissions/ECP14096515_FrankeWiesmann.pdf\">Franke, Wiesmann: Flexible modeling of electrical power systems -- the Modelica PowerSystems library, Modelica conference 2014</a>.</p>
<p><br>The <u>Examples</u> package of the user&apos;s guide supplies very simple examples that are intended to operate as a &QUOT;hands-on&QUOT; tutorial to the user to understand the library basic concepts.</p>
</html>"));
end UsersGuide;
