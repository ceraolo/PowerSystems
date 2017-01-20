within PowerSystems.Types;
package Generic "Types for input: e.g. input voltage unit \"V or PU\""
  extends Modelica.Icons.Package;

  type AngularVelocity = Real (final quantity="AngularVelocity",unit=
          "rad.s or PU");
  type Voltage = Real (final quantity="ElectricPotential", unit="kV or PU");
  type Current = Real (final quantity="ElectricCurrent", unit="A or PU");
  type Power = Real (final quantity="Power", unit="W or PU");
  type ActivePower = Real (final quantity="Power", unit="MW or PU");
  type ApparentPower = Real (final quantity="ApparentPower", unit="MVA or PU");
  type ReactivePower = Real (final quantity="ReactivePower", unit="Mvar or PU");
  type Resistance = Real (final quantity="Resistance", unit="ohm or PU");
  type Reactance = Real (final quantity="Reactance", unit="ohm or PU");
  type Impedance = Real (final quantity="Impedance", unit="ohm or PU");
  type Inductance = Real (final quantity="Inductance", unit="H or PU");
  type Conductance = Real (
      final quantity="Conductance",
      unit="S/S",
      final min=0);
  type Susceptance = Real (final quantity="Susceptance", unit="S or PU");
  type Admittance = Real (
      final quantity="Admittance",
      unit="S or PU",
      min=0);
  type Resistance_km = Real (
      final quantity="Resistance",
      unit="ohm/km or PU/km",
      min=0);
  type Reactance_km = Real (
      final quantity="Reactance_per_km",
      unit="ohm/km or PU/km",
      min=0);
  type Conductance_km = Real (
      final quantity="Conductance",
      unit="S/km or PU/km",
      min=0);
  type Susceptance_km = Real (
      final quantity="Susceptance",
      unit="S/km or PU/km",
      min=0);
  type MagneticFlux = Real (final quantity="MagneticFlux", unit="Wb or PU");

  type Energy = Real (final quantity="Energy", unit="J or PU");
  type Torque = Real (final quantity="Torque", unit="N.m or PU");

  annotation (Documentation(info="<html>
</html>
"));
end Generic;
