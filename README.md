# Scanning Radar
A radar that actually scans in a sweeping arc. Massive power requirements that scale with area scanned and speed.

Default settings to scan about the same area as the vanilla radar.
Connect signals to modify the behavior.
The initial scan can be quite slow as the game generates map data.
Scanning too much map area can bloat your game.
See [DeleteEmptyChunks](https://mods.factorio.com/mod/DeleteEmptyChunks) if you need to slim it back down.
375,000 chunks takes about 9GB of memory which is 3/4 of a full scan with a radius of 400

### Features
 - Controlled by circuit network
 - Blueprint-compatible (unless you rotate it)

### Known Limitations
 - CPU-time and UPS consuming
 - No translations
 - Rotating a blueprint may break everything
 - When Scanning Radar entity ghost is removed, its connector ghost may remain and must be cleared manually
