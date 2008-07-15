
local vgui = vgui
local table = table
local pairs = pairs
local pcall = pcall
local ScrW = ScrW
local ScrH = ScrH
local Msg = Msg
local unpack = unpack

require("timer")

local timer = timer

module("vguix")
/*

// Was anyone using these functions?

local active_frames = {}

local function FrameFinished( box, returnValue )
	if (active_frames[box].timername) then
		timer.Destroy( active_frames[box].timername )
	end
	active_frames[box].frame:PostMessage("Close", "", "")
	if (active_frames[box].callback) then
		local result, error
		
		if (#active_frames[box].cbargs > 0) then
			result,error = pcall( active_frames[box].callback, unpack(active_frames[box].cbargs), returnValue )
		else
			result,error = pcall( active_frames[box].callback, returnValue )
		end
		
		if (result == false and error) then
			Msg("LUA Error: " .. error .. "\n")
		end

	end
	active_frames[box] = nil
end

local function FrameTimerExpire( panel )

	for index,qbox in pairs(active_frames) do
		if (qbox.frame == panel) then
			qbox.timername = nil
			FrameFinished( index, qbox.default )
			return
		end
	end
	
end

local function AlertBoxClosed( panel, message )

	if (message ~= "Command") then return end
	
	for index,qbox in pairs(active_frames) do
		if (qbox.frame == panel) then
			FrameFinished( index )
			return
		end
	end	
	
end

function AlertBox(text, title, btntext, callback, timeout, ... )

	if (title == nil) then title = "Alert" end
	if (btntext == nil) then btntext = "Ok" end
	
	local alert_box = {}
	alert_box.cbargs = arg
	alert_box.callback = callback
	alert_box.frame = vgui.Create( "MessageBox" )
	alert_box.frame:PostMessage( "SetTitle", "text", title )
	alert_box.frame:PostMessage( "SetText", "text", text )
	alert_box.frame:PostMessage( "SetButtonText", "text", btntext )
	alert_box.frame:SetActionFunction( AlertBoxClosed )
	
	if (timeout and timeout > 0) then
		alert_box.timername = "alert_box" .. (#active_frames)+1
		timer.Create(alert_box.timername, timeout, 1, FrameTimerExpire, alert_box.frame)
	end
	
	table.insert(active_frames, alert_box)

	alert_box.frame:DoModal()
	
end

*/