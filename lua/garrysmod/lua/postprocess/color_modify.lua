


local mat_ColorMod		= Material( "pp/colour" )

mat_ColorMod:SetMaterialTexture( "$fbtexture", render.GetScreenEffectTexture() )

/*---------------------------------------------------------
   Register the convars that will control this effect
---------------------------------------------------------*/   
local pp_colormod 				= CreateClientConVar( "pp_colormod", "0", false, false )
local pp_colormod_addr 			= CreateClientConVar( "pp_colormod_addr", "0", false, false )
local pp_colormod_addg			= CreateClientConVar( "pp_colormod_addg", "0", false, false )
local pp_colormod_addb			= CreateClientConVar( "pp_colormod_addb", "0", false, false )
local pp_colormod_brightness	= CreateClientConVar( "pp_colormod_brightness", "0", false, false )
local pp_colormod_contrast		= CreateClientConVar( "pp_colormod_contrast", "1", false, false )
local pp_colormod_color			= CreateClientConVar( "pp_colormod_color", "1", false, false )
local pp_colormod_mulr			= CreateClientConVar( "pp_colormod_mulr", "0", false, false )
local pp_colormod_mulg			= CreateClientConVar( "pp_colormod_mulg", "0", false, false )
local pp_colormod_mulb			= CreateClientConVar( "pp_colormod_mulb", "0", false, false )

function DrawColorModify( tab )

	render.UpdateScreenEffectTexture()

	for k, v in pairs(tab) do
	
		mat_ColorMod:SetMaterialFloat( k, v )
		
	end

	render.SetMaterial( mat_ColorMod )
	render.DrawScreenQuad()
	
end

local function DrawInternal()

	if ( !pp_colormod:GetBool() ) then return end
	if ( !GAMEMODE:PostProcessPermitted( "color mod" ) ) then return end

	local tab = {}
	
	tab[ "$pp_colour_addr" ] 		= pp_colormod_addr:GetFloat() * 0.02
	tab[ "$pp_colour_addg" ] 		= pp_colormod_addg:GetFloat() * 0.02
	tab[ "$pp_colour_addb" ] 		= pp_colormod_addb:GetFloat() * 0.02
	tab[ "$pp_colour_brightness" ] 	= pp_colormod_brightness:GetFloat()
	tab[ "$pp_colour_contrast" ] 	= pp_colormod_contrast:GetFloat()
	tab[ "$pp_colour_colour" ] 		= pp_colormod_color:GetFloat()
	tab[ "$pp_colour_mulr" ] 		= pp_colormod_mulr:GetFloat() * 0.1
	tab[ "$pp_colour_mulg" ] 		= pp_colormod_mulg:GetFloat() * 0.1
	tab[ "$pp_colour_mulb" ] 		= pp_colormod_mulb:GetFloat() * 0.1
	
	DrawColorModify( tab );

end

hook.Add( "RenderScreenspaceEffects", "RenderColorModify", DrawInternal )


/*
// Control Panel
*/
local function BuildControlPanel( CPanel )

	CPanel:AddControl( "Header", { Text = "#Color_Mod", Description = "#Color_Mod_Information" }  )
	CPanel:AddControl( "CheckBox", { Label = "#Color_Mod_Toggle", Command = "pp_colormod" }  )
	
	local params = { Options = {}, CVars = {}, Label = "#Presets", MenuButton = "1", Folder = "colormod" }
	params.Options[ "#Default" ] = { pp_colormod = "1", pp_colormod_addr = "0", pp_colormod_addg = "0", pp_colormod_addb = "0", pp_colormod_brightness = "0", pp_colormod_contrast = "1", pp_colormod_color = "1", pp_colormod_mulr = "0", pp_colormod_mulg = "0", pp_colormod_mulb = "0" }
	params.CVars = { "pp_colormod", "pp_colormod_addr", "pp_colormod_addg", "pp_colormod_addb", "pp_colormod_brightness", "pp_colormod_contrast", "pp_colormod_color", "pp_colormod_mulr", "pp_colormod_mulg", "pp_colormod_mulb" }
	CPanel:AddControl( "ComboBox", 	params )
	
	CPanel:AddControl( "Slider", { Label = "#Colormod_Brightness", Command = "pp_colormod_brightness", Type = "Float", Min = "-2", Max = "2" }  )
	CPanel:AddControl( "Slider", { Label = "#Colormod_Contrast", Command = "pp_colormod_contrast", Type = "Float", Min = "0", Max = "10" }  )
	CPanel:AddControl( "Slider", { Label = "#Colormod_Color", Command = "pp_colormod_color", Type = "Float", Min = "0", Max = "5" }  )	
	
	CPanel:AddControl( "Color", { Label = "#Colormod_Color_Add", Red = "pp_colormod_addr", Green = "pp_colormod_addg", Blue = "pp_colormod_addb", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )	
	CPanel:AddControl( "Color", { Label = "#Colormod_Color_Multiply",  Red = "pp_colormod_mulr", Green = "pp_colormod_mulg", Blue = "pp_colormod_mulb", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )	
	
end

/*
// Tool Menu
*/
local function AddPostProcessMenu()

	spawnmenu.AddToolMenuOption( "PostProcessing", "PPShader", "ColorMod", "#Color Mod", "", "", BuildControlPanel, { SwitchConVar = "pp_colormod" } )

end

hook.Add( "PopulateToolMenu", "AddPostProcessMenu_ColorMod", AddPostProcessMenu )
