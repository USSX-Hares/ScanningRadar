--- @class RadarState
--- A class representing radar current state, including all settings.
--- 
--- @field cx double
--- @field cy double
--- @field radius int
--- @field inner int
--- @field direction int
--- @field constrained boolean
--- @field oscillate boolean
--- @field start float      Start angle, in radians
--- @field stop function    End angle, in radians
--- @field step float       Angle step, in radians
--- @field previous float   Previous angle value, in radians
--- @field angle float      Current angle value, in radians
--- @field speed int
--- @field counter int
--- @field uncharted MapPosition[]
--- @field enabled int

--- @class RadarInputSignal
--- A class representing radar configuration read from the circuit network, before any defaults apply.
---
--- @field r int Radius, Scanning radius (may also be F -- Far range)
--- @field d int Direction, 1 for Clockwise, -1 for Counterclockwise
--- @field b int Begin angle, 0-360, sweep constraint
--- @field e int End angle, 0-360, sweep constraint
--- @field n int Near range, near limit scanning radius
--- @field s int Speed, 1 (slow) - 10 (fast)

--- @class RadarData
--- A class containing radar entities and state
--- 
--- @field connector LuaEntity
--- @field radar LuaEntity
--- @field power_units LuaEntity[]
--- @field state RadarState
