

local function CreateToolMenuCategories()

	spawnmenu.AddToolCategory( "PostProcessing", 	"PPSimple", 	"#Simple" )
	spawnmenu.AddToolCategory( "PostProcessing", 	"PPShader", 	"#Pixel Shaders" )

end	

hook.Add( "AddToolMenuCategories", "CreatePostProcessingMenuCategories", CreateToolMenuCategories )