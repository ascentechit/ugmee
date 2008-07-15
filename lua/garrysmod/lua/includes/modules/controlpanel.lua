
local ControlPanels = {}

/*---------------------------------------------------------
   Name: GetControlPanel
   Desc: Global, backwards compatibility
---------------------------------------------------------*/
function GetControlPanel( strName )
	return controlpanel.Get( strName )
end


module( "controlpanel", package.seeall )

//function Register( name, cpanel )
	//ControlPanels[ name ] = cpanel
//end

function Get( name )

	if ( !ControlPanels[ name ] || !ControlPanels[ name ]:IsValid() ) then
	
		local cp = vgui.Create( "ControlPanel" )
		if (!cp) then
		
			debug.Trace()
			Error( "controlpanel.Get() - Error creating a ControlPanel!\nYou're calling this function too early! Call it in a hook!\n" )
			return nil
		
		end
		
		cp:SetVisible( false )
		cp.Name = name
		ControlPanels[ name ] = cp
	
	end
	
	return ControlPanels[ name ]
	
end
