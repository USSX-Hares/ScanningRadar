- - -
# Signal References
### Range Control:
 - **R or F:** (Far) Range, maximum scanning distance, in tiles (32 tiles per chunk)
 - **N:** Near range, minimum scanning distance, in tiles.
   Chunks within the minimum range will not be scanned

### Arc Control:
 - **D:** Direction, 1 for Clockwise, -1 for Anticlockwise
 - **B:** Begin angle, -360..360, sweep constraint, in degrees
 - **E:** End angle, -360..360, sweep constraint, in degrees
 - **S:** Speed, 1..10, in inverse scare scale

In addition, the following signals from [Schall Virtual Signal](https://mods.factorio.com/mod/SchallVirtualSignal) mod are supported:

 - ↻ and ↺ (`clockwise-open-circle` and `anticlockwise-open-circle` respectively):
   If either is set (≠ 0), and Direction is unset, the respective direction (clockwise and anticlockwise) is considered.

#### Oscillation:
If the Direction is unset, and the scanning arc is set (and it's not a full circle),
then the radar would oscillate between Begin and End angles.

Note that by now oscillation can't be controlled if the direction is set.

### Default Settings:
If any (except for Begin and End angles) setting is missing in the input signal, the default values apply:

 * **Near Range:** 0
 * **Far Range:** 576 (18 tiles), can be changed in mod's settings
 * **Direction:** Anticlockwise-oscillating, can be changed in mod's settings
 * **Speed:** 5 (see below)

### Invalid States:
Having any of the following would result in the invalid input state and lead to undefined behaviour:

 * Both **R** and **F** values are set
 * Any two of the following are set: **D**, ↻, or ↺

- - -
# How does it work?
### Arc Values
The degrees are located as follows:

 * 0° or 360° is East
 * 90° is South
 * 180° is West
 * 270° is North

All angles are converted to the `[0; 360)` range,
and then up to a full rotation is performed in the chosen direction.

#### Maintainer's Note:
This was nested from the previous maintainer, and I personally (as a mathematician)
don't like the fact angles mirror the trigonometrical plane.
I'll probably make a setting for that.

### Speed Formula
The arc speed (in radians per tick) is calculated by the following formula:
!["Arc Speed = \frac {\frac {1} {3}} {\frac{Range}{32} \times {\left(11 - Speed\right)}^{2}}"](https://github.com/USSX-Hares/ScanningRadar/blob/main/docs/img/arc-speed.png?raw=true)

The full circle rotation time is calculated as follows:
!["Circle Period = \frac {2 \pi} {Arc Speed}"](https://github.com/USSX-Hares/ScanningRadar/blob/main/docs/img/circle-period.png?raw=true)

So, for the default settings (18 chunks radius and 5 scanning speed),
the full circle period would be approximately 203.58 seconds (3.4 minutes).
Here's calculated values for different speeds for the default range:

| Speed | Circle Period |
|:-----:|:-------------:|
|   1   |  9.4 minutes  |
|   2   |  7.6 minutes  |
|   3   |   6 minutes   |
|   4   |  4.6 minutes  |
|   5   |  3.4 minutes  |
|   6   |  141 seconds  |
|   7   | 90.5 seconds  |
|   8   | 50.9 seconds  |
|   9   | 22.6 seconds  |
|  10   | 5.65 seconds  |

Larger ranges would proportionally increase the circle period.
Smaller arcs won't affect the rotation speed, but will decrease the arc scan period.

- - -
# Lamp Color Output
As for v0.4.x, lamp can be only in two states:

 * Grey: Radar is disabled
 * White: Radar is enabled

In the future releases, this will be changed to include additional state reporting.
(Like red lighting if the radar control input signal is invalid.)
