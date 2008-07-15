
require( 'hook' )

// Globals that we need.
local os = os
local string = string
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local pcall = pcall
local hook = hook

/*---------------------------------------------------------
   Name: schedule
   Desc: A module implementing scheduled events.
---------------------------------------------------------*/
module("schedule")

// Declare our locals
local Schedules = {}

local function daytoint( str )
	weekday = string.lower(str)
	    if	( weekday == "sunday" ) then return 1
	elseif	( weekday == "monday" ) then return 2
	elseif	( weekday == "tuesday" ) then return 3
	elseif	( weekday == "wednesday" ) then return 4
	elseif	( weekday == "thursday" ) then return 5
	elseif	( weekday == "friday" ) then return 6
	elseif	( weekday == "saturday" ) then return 7
	end
	return tonumber(weekday)
end

/*---------------------------------------------------------
   Name: IsSchedule( name )
   Desc: Returns boolean whether or not name is a schedule.
---------------------------------------------------------*/
function IsSchedule( name )
	if ( Schedules[name] != nil ) then return true
	else return false end
end

/*---------------------------------------------------------
   Name: Add( name, func, sec, min, hour, wday, day, month, year )
   Desc: Setup and start a schedule by name.
---------------------------------------------------------*/
function Add( name, func, sec, min, hour, wday, day, month, year )
	if ( IsSchedule( name ) ) then Remove( name ) end

	local date = {}

	if ( sec != nil ) then date.sec = sec end
	if ( min != nil ) then date.min = min end
	if ( hour != nil ) then date.hour = hour end
	if ( wday != nil ) then date.wday = daytoint(wday) end
	if ( day != nil ) then date.day = day end
	if ( month != nil ) then date.month = month end
	if ( year != nil ) then date.year = year end

	Schedules[name] = {}
	Schedules[name].Func = func
	Schedules[name].Date = date
	Schedules[name].Last = os.time()
end

/*---------------------------------------------------------
   Name: Remove( name )
   Desc: Stop a schedule by name.
---------------------------------------------------------*/
function Remove( name )
	if ( IsSchedule( name ) ) then
		Schedules[name] = nil
		return true
	end
	return false
end

/*---------------------------------------------------------
   Name: Check()
   Desc: Check all schedules and complete any tasks needed.
		This should be run at least every second.
---------------------------------------------------------*/
local function Check()
	local date = os.date( "*t" )
	for Sched, SchedTable in pairs( Schedules ) do
		if (SchedTable.Last != os.time()) then
			for k,v in pairs( SchedTable.Date ) do
				local match = false
				for value in string.gmatch(v, "%d+") do
					if ( tonumber(date[k]) == tonumber(value) ) then match = true end
				end
				if ( !match ) then
					SchedTable.Last = os.time()
					//return false
				end
			end
			local b, e = pcall( SchedTable.Func )
			if ( !b ) then
				Msg("Schedule Error: "..tostring(e).."\n")
			end
			
			SchedTable.Last = os.time()
			//return true
		end
	end
	// return false
	// NOTE: Don't return anything or the hook will override the Think
	//  		function's return and the real think won't run
end

hook.Add( "Think", "CheckSchedules", Check )