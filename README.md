# Modified-Power-Systems
A modified version of https://github.com/modelica/PowerSystems
It is realised starting from the version available there on Jan, 20 2017, at 15.00

All rights and copyrights belong to the library available from this link.

A few words about the rationale of this repository. As a professor of Electric power Systems and a heavy Modelica user, I consider Power System Library a very important achievement of the Modelica community. However, personally I've had several problems in understanding how to use this library, and I think that also other users may encounter similar problems.
My the difficulties in understanding this library were due to both the documentation (that I consider too short) and the library whose structure and organization, in my opinion, can be improved.
Therefore I consider this fork as a lab to test my ideas and what I think are improvements. I will continue to contribute to the "official" Power Systems Library with tickets and comments to tickets.

NOTES ABOUT COMMITS

1)  ELIMINATION OF GENERIC SUB-LIBRARY.
Power systems has two kinds of models: Generic and Other. The latter come from the original SPOT library. I think that for the purpose of my fork, having two kinds of models is too much. I see  that the Generic models are much simpler than the others, and are too simple, in my opinion, for the majority of needs a  Power System Engineer usually has. Therefore I chose to concentrate on the other models (i.e. those that come from the SPOT library)

2) ADAPTATION OF EXAMPLES' SHEET SIZE TO THE MODEL SIZE.
 Tools use the size of the model's sheet to choose the display default size of the models. Tools (e.g. Dymola and OpenModelica) as default arrange things so that everything in the shett is visible. So, If models have large blank parts, then important parts of the diagram are smaller than necessary, often tiny. This is particular important when in Dymola's simulation mode the model diagram is displayed.
  Blank parts will be thus progressively eliminated to enhance model's display in tools, at least those mentioned above.

3) THE PU SYSTEM
The p.u. System is largely used in Power System Analysis, and in power system components databases. Therefore, the Power Systems library supplies support for this.
Note that, due to the current Modelica standard, the units of measure of plotted quantities are unable to make this distinction. Therefore, for instance, a voltage will always be shown as having as unit “V/V”, whether it is actually p.u. or S.I.
This is especially tricky when input parameters must be introduced. Take for instance AC3ph.Lines.Parameters.RXline. resistances and reactances are shown to be introduced in Ohm/Ohm or Ohm/(V.V/VA) whether puUnits is true or false.
To alleviate this, this ticket modifies input dialog boxes to show that the user has two units of measure. For instance the unit of measure in AC4ph.Impedances.Inductor will ve "ohm or p.u." This is clearer for the user instead of having "Ohm/Ohm" (even if they are actually ohm's when input is in SI). As a drawback this imposes units of measure that are not good Modelica code, and may cause warning.


The writer of these notes, as well as all the changes that will be made in this repository is
Massimo Ceraolo - massimo.ceraolo@unipi.it


