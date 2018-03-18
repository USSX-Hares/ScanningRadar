##Scanning Radar
A radar that actually scans in a sweeping arc. Massive power requirements that scale with area scanned and speed.

Default settings to scan about the same area as the vanilla radar.
Connect signals to modify the behavior.
The initial scan can be slow quite slow as the game generates map data.
Scanning too much map area can bloat your game. 
375,000 chunks takes about 9GB of memory which is 3/4 of a full scan with a radius of 400

##Version History:

###v0.2.3 (2018-03-18)
* Signal input support added, can control
  * [R]adius, Scanning radius in chunks
  * [D]irection, 1 for Clockwise, -1 for Counterclockwise
  * [S]peed, 1 (slow) - 10 (fast)
  * [B]egin angle, 0-360, sweep constraint
  * [E]nd angle, 0-360, sweep constraint
  * [N]ear range, near limit scanning radius
  * [F]ar range, near limit scanning radius (equivalent to [R])
* Can enable/disable radar with condition
* Power usage scales with speed and radius
* Able to configure default scanning speed
* Switched from Bresenham's circle algorithm to trig based calculation. CPUs made in the last 20 years can do math somewhat quicker

###v0.1.0 (2018-03-13)
* Able to configure direction of rotation.

###v0.1.0 (2018-03-11)
* Initial Release.
