



/*---------------------------------------------------------
   Register the convars that will control this effect
---------------------------------------------------------*/   
local pp_mat_overlay 				= CreateClientConVar( "pp_mat_overlay", "0", false, false )
local pp_mat_overlay_texture		= CreateClientConVar( "pp_mat_overlay_texture", "models/shadertest/shader4", false, false )
local pp_mat_overlay_refractamount	= CreateClientConVar( "pp_mat_overlay_refractamount", "0.3", false, false )

local lastTexture = nil
local mat_Overlay = nil

function DrawMaterialOverlay( texture, refractamount )

	if (texture ~= lastTexture or mat_Overlay == nil) then
		mat_Overlay = Material( texture )
		lastTexture = texture
	end
	
	if (mat_Overlay == nil) then return end

	render.UpdateScreenEffectTexture()

	mat_Overlay:SetMaterialFloat("$envmap",			0)
	mat_Overlay:SetMaterialFloat("$envmaptint",		0)
	mat_Overlay:SetMaterialFloat("$refractamount",	refractamount)
	mat_Overlay:SetMaterialInt("$ignorez",		1)

	render.SetMaterial( mat_Overlay )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	if ( !pp_mat_overlay:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "material overlay" ) ) then return end

	DrawMaterialOverlay( 
			pp_mat_overlay_texture:GetString(), 
			pp_mat_overlay_refractamount:GetFloat()	);

end

hook.Add( "RenderScreenspaceEffects", "RenderMaterialOverlay", DrawInternal )


/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Material_Overlay", Description = "#Material_Overlay_Information" }  )
	CPanel:AddControl( "CheckBox", { Label = "#Material_Overlay_Toggle", Command = "pp_mat_overlay" }  )
	
	local params = { Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "materialoverlay" }
	params.Options[ "#Default" ] = { pp_mat_overlay_texture = "1", pp_mat_overlay_refractamount = "0" }
	params.CVars = { "pp_mat_overlay_texture", "pp_mat_overlay_refractamount" }
	CPanel:AddControl( "ComboBox", 	params )

	local Options = {}
		Options[ "#Waterfall" ] = "models/shadertest/shader3"
		Options[ "#Jelly" ] 	= "models/shadertest/shader4"
		Options[ "#Stained Glass" ] = "models/shadertest/shader5"
		Options[ "#Combine Stasis" ] = "models/props_combine/stasisshield_sheet"
		Options[ "#Combine Shield" ] = "models/props_combine/com_shield001a"
		Options[ "#Frosted Glass" ] = "models/props_c17/frostedglass_01a"
		Options[ "#Tank Glass" ] = "models/props_lab/Tank_Glass001"
		Options[ "#tprings_globe" ] = "models/props_combine/tprings_globe"
		Options[ "#Fisheye" ] = "models/props_c17/fisheyelens"
		Options[ "#RenderTarget" ] = "models/overlay_rendertarget"
	CPanel:AddControl( "MatSelect", { Height = "3", Label = "", ConVar = "pp_mat_overlay_texture", Options = Options } )
	
	CPanel:AddControl( "Slider", { Label = "#Material_Overlay_RefractAmount", Command = "pp_mat_overlay_refractamount", Type = "Float", Min = "-1", Max = "1" }  )	


end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPSimple", "Overlay", "#Overlay", "", "", BuildControlPanel, { SwitchConVar = "pp_mat_overlay" } )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_Overlay", AddPostProcessMenu )