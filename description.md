##Scanning Radar
A radar that actually scans in a sweeping arc. Massive power requirements. 
Initial version, may still need a bit of polish.

Default settings to scan about the same area as the vanilla radar though much faster, can be increased or decreased to experiment.
A change to the radius takes effect after the radar is picked and replaced
If a large radius is used, the initial scan can be slow. Afterwards the speed picks back up

##Version History:

###v0.2.0 (2018-03-18)
* Signal input support added, can control
  * [R]adius, Scanning radius in chunks
  * [D]irection, 1 for Clockwise, -1 for Counterclockwise
  * [S]peed, 1 (slow) - 10 (fast)
  * [B]egin angle, 0-360, sweep constraint
  * [E]nd angle, 0-360, sweep constraint
  * [N]ear range, near limit scanning radius
  * [F]ar range, near limit scanning radius (equivilent to [R])
* Can enable/disable radar with condition
* Switched from Bresenham's circle algorithm to trig based calculation. CPUs made in the last 20 years can do math somewhat quicker

###v0.1.0 (2018-03-13)
* Able to configure direction of rotation.

###v0.1.0 (2018-03-11)
* Initial Release.
