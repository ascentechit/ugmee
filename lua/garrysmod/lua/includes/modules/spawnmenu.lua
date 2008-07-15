
local table 	= table
local ipairs 	= ipairs
local debug 	= debug
local pairs		= pairs
local ipairs	= ipairs
local file		= file
local KeyValuesToTable = KeyValuesToTable


local PrintTable = PrintTable
local MsgN = MsgN

local spawnmenu_engine = spawnmenu

/*---------------------------------------------------------

---------------------------------------------------------*/

module("spawnmenu")


local g_ToolMenu = {}
local CreationMenus = {}
local PropTable = {}

/*---------------------------------------------------------
	GetTools
---------------------------------------------------------*/
function GetTools()
	return g_ToolMenu
end

/*---------------------------------------------------------
	GetToolMenu - This is WRONG. Probably.
---------------------------------------------------------*/
function GetToolMenu( name, label, icon )

	label = label or name
	icon = icon or "gui/silkicons/wrench"

	for k, v in ipairs( g_ToolMenu ) do
	
		if ( v.Name == name ) then return v.Items end
	
	end
	
	local NewMenu = { Name = name, Items = {}, Label = label, Icon = icon }
	table.insert( g_ToolMenu, NewMenu )
	
	return NewMenu.Items
	
end


/*---------------------------------------------------------
  
---------------------------------------------------------*/
function ClearToolMenus()
	g_ToolMenu = {}	
end


/*---------------------------------------------------------
  
---------------------------------------------------------*/
function AddToolTab( strName, strLabel, Icon )

	GetToolMenu( strName, strLabel, Icon )

	// Add the tab via the engine (todo: move to Lua)
	spawnmenu_engine.AddTab( strName, strLabel )

end


/*---------------------------------------------------------
  
---------------------------------------------------------*/
function AddToolCategory( tab, RealName, PrintName )
	
	local tab = GetToolMenu( tab )
	
	// Does this category already exist?
	for k, v in ipairs( tab ) do
	
		if ( v.Text == PrintName ) then return end
		if ( v.ItemName == RealName ) then return end
	
	end
	
	table.insert( tab, { Text = PrintName, ItemName = RealName } )

end

/*---------------------------------------------------------
  
---------------------------------------------------------*/
function AddToolMenuOption( tab, category, itemname, text, command, controls, cpanelfunction, TheTable )

	local Menu = GetToolMenu( tab )
	local CategoryTable = nil
	
	for k, v in ipairs( Menu ) do
		if ( v.ItemName && v.ItemName == category ) then CategoryTable = v break end
	end
	
	// No table found.. lets create one
	if ( !CategoryTable ) then
		CategoryTable = { Text = "#"..category, ItemName = category }
		table.insert( Menu, CategoryTable )
	end
	
	TheTable = TheTable or {}
	
	TheTable.ItemName = itemname
	TheTable.Text = text
	TheTable.Command = command
	TheTable.Controls = controls
	TheTable.CPanelFunction = cpanelfunction
	
	table.insert( CategoryTable, TheTable )
	
	// Keep the table sorted
	table.SortByMember( CategoryTable, "Text", true )

end

/*---------------------------------------------------------
	AddCreationTab
---------------------------------------------------------*/
function AddCreationTab( strName, pFunction, pMaterial, iOrder, strTooltip )

	iOrder = iOrder or 1000

	pMaterial = pMaterial or "gui/silkicons/exclamation"
	
	CreationMenus[ strName ] = { Function = pFunction, Icon = pMaterial, Order = iOrder, Tooltip = strTooltip }

end

/*---------------------------------------------------------
	GetCreationTabs
---------------------------------------------------------*/
function GetCreationTabs()

	return CreationMenus	

end


/*---------------------------------------------------------
	GetPropTable
---------------------------------------------------------*/
function GetPropTable()

	return PropTable	

end

/*---------------------------------------------------------
	GetPropCategoryTable
---------------------------------------------------------*/
function GetPropCategoryTable( strCategory )

	return PropTable[ strCategory ] or {}

end

/*---------------------------------------------------------
	AddProp
---------------------------------------------------------*/
function AddProp( strName, prop )

	PropTable[ strName ] = PropTable[ strName ] or {}

	table.insert( PropTable[ strName ], prop )

end

/*---------------------------------------------------------
	GetPropTable
---------------------------------------------------------*/
function AddPropCategory( strName, tabContents )

	PropTable[ strName ] = tabContents

end

/*---------------------------------------------------------
	RenamePropCategory
---------------------------------------------------------*/
function RenamePropCategory( strName, strNewName )

	PropTable[ strNewName ] = PropTable[ strName ]
	PropTable[ strName ] = nil

end


/*---------------------------------------------------------
	EmptyPropCategory
---------------------------------------------------------*/
function EmptyPropCategory( strName )

	PropTable[ strName ] = {}

end

/*---------------------------------------------------------
	DeletePropCategory
---------------------------------------------------------*/
function DeletePropCategory( strName )

	PropTable[ strName ] = nil

end

/*---------------------------------------------------------
	GetPropTable
---------------------------------------------------------*/
function RemoveProp( strCategory, strModel )

	local cat = PropTable[ strCategory ]
	if (!cat) then return end
	
	for id, modelname in pairs( cat ) do
	
		if ( modelname == strModel ) then 
			cat[ id ] = nil
		end
	
	end
	

end

/*---------------------------------------------------------
	SaveProps
---------------------------------------------------------*/
function SaveProps()

	spawnmenu_engine.SaveToTextFiles( PropTable )

end

/*---------------------------------------------------------
	Populate the spawnmenu from the text files (engine)
---------------------------------------------------------*/
function PopulateFromEngineTextFiles()

	spawnmenu_engine.PopulateFromTextFiles( AddPropCategory )

end
