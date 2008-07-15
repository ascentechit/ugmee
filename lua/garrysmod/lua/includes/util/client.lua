/*---------------------------------------------------------
    Get the real frame time, instead of the 
	 host_timescale linked frametime. This is for things
	 like GUI effects. NOT FOR REAL IN GAME STUFF(!!!)
---------------------------------------------------------*/
local FrameTime = 0
local LastQuery = 0

function RealFrameTime() return FrameTime end

local function RealFrameTimeThink()

	FrameTime = math.Clamp( SysTime() - LastQuery, 0, 0.1 )
	LastQuery = SysTime()

end

hook.Add( "Think", "RealFrameTime", RealFrameTimeThink ) // Think is called after ever frame on the client.


