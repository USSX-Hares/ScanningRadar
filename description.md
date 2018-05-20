##Scanning Radar
A radar that actually scans in a sweeping arc. Massive power requirements that scale with area scanned and speed.

Default settings to scan about the same area as the vanilla radar.
Connect signals to modify the behavior.
The initial scan can be quite slow as the game generates map data.
Scanning too much map area can bloat your game. See [DeleteEmptyChunks](https://mods.factorio.com/mod/DeleteEmptyChunks) if you need to slim it back down.
375,000 chunks takes about 9GB of memory which is 3/4 of a full scan with a radius of 400

##Known issue: not blueprint compatible... yet

##Version History:

###v0.2.9 (2018-05-??)
  * Invalid entity was referenced when hidden entity destroyed

###v0.2.8 (2018-05-13)
  * Only call force.chart() once per chunk per scan
  * Corrected for floating point error near zero degrees
  * Inner radius specified by signal was not limited
  * Added option to disable additional power usage
  * Pause sweep while game generates new map data
  * Step size increased to full chunk on outside diameter per step
  * Polished prototype entries

###v0.2.5 (2018-05-02)
* Quick fix for mining, seems to fix bot mining as well

###v0.2.4 (2018-03-18)
* Some mods requires all items to have a 32 pixel icon

###v0.2.3 (2018-03-18)
* Signal input support added, can control
    * [R]adius, Scanning radius in chunks
    * [D]irection, 1 for Clockwise, -1 for Counterclockwise
    * [S]peed, 1 (slow) - 10 (fast)
    * [B]egin angle, 0-360, sweep constraint
    * [E]nd angle, 0-360, sweep constraint
    * [N]ear range, near limit scanning radius
    * [F]ar range, outer limit scanning radius (equivalent to [R])
* Can enable/disable radar with condition
* Power usage scales with speed and radius
* Able to configure default scanning speed
* Switched from Bresenham's circle algorithm to trig based calculation

###v0.1.0 (2018-03-13)
* Able to configure direction of rotation.

###v0.1.0 (2018-03-11)
* Initial Release.
