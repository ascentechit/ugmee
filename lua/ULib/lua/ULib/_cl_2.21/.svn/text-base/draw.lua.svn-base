


function ULib.csayDraw( msg, color, duration, fade )
	color = color or Color( 255, 255, 255, 255 )
	duration = duration or 5
	fade = fade or 0.5
	local start = CurTime()
	
	local function drawToScreen()
		local alpha = 255
		local dtime = CurTime() - start
		
		if dtime > duration then 
			hook.Remove( "HUDPaint", "CSayHelperDraw" )		
			return
		end
		
		if fade - dtime > 0 then 
			alpha = (fade - dtime) / fade 
			alpha = 1 - alpha 
			alpha = alpha * 255
		end
		
		if duration - dtime < fade then 
			alpha = (duration - dtime) / fade 
			alpha = alpha * 255
		end		
		color.a  = alpha
		
		draw.DrawText( msg, "TargetID", ScrW() * 0.5, ScrH() * 0.25, color, TEXT_ALIGN_CENTER )
	end

	hook.Add( "HUDPaint", "CSayHelperDraw", drawToScreen )
end
