
//
// Don't try to edit this file if you're trying to add new NPCs.
// Just make a new file and copy the format below.
//

local Category = "Humans + Resistance"

local NPC = { 	Name = "Alyx Vance", 
				Class = "npc_alyx",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Barney", 
				Class = "npc_barney",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Wallace Breen", 
				Class = "npc_breen",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Dog", 
				Class = "npc_dog",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Eli Vance", 
				Class = "npc_eli",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "G-Man", 
				Class = "npc_gman",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Dr. Kleiner", 
				Class = "npc_kleiner",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Metro Police", 
				Class = "npc_metropolice",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Mossman", 
				Class = "npc_mossman",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

// I don't trust these Vorts, but I'll let em stay in this category until they mess up
local NPC = { 	Name = "Vortigaunt", 
				Class = "npc_vortigaunt",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Rebel", 
				Class = "npc_citizen",
				SpawnFlags = SF_CITIZEN_RANDOM_HEAD,
				KeyValues = { citizentype = CT_REBEL },
				Category = Category	}

list.Set( "NPC", "Rebel", NPC )

local NPC = { 	Name = "Medic", 
				Class = "npc_citizen",
				SpawnFlags = SF_CITIZEN_MEDIC,
				KeyValues = { citizentype = CT_REBEL },
				Category = Category	}

list.Set( "NPC", "Medic", NPC )

local NPC = { 	Name = "Refugee", 
				Class = "npc_citizen",
				KeyValues = { citizentype = CT_REFUGEE },
				Category = Category	}

list.Set( "NPC", "Refugee", NPC )

local NPC = { 	Name = "Citizen", 
				Class = "npc_citizen",
				KeyValues = { citizentype = CT_DOWNTRODDEN },
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )






Category = "Zombies + Enemy Aliens"


local NPC = { 	Name = "Zombie", 
				Class = "npc_zombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Zombie Torso", 
				Class = "npc_zombie_torso",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Poison Zombie", 
				Class = "npc_poisonzombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Antlion", 
				Class = "npc_antlion",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Antlion Guard", 
				Class = "npc_antlionguard",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Barnacle", 
				Class = "npc_barnacle",
				OnCeiling = true,
				Offset = 2,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Fast Zombie", 
				Class = "npc_fastzombie",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Fast Zomb Torso", 
				Class = "npc_fastzombie_torso",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab", 
				Class = "npc_headcrab",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab Black", 
				Class = "npc_headcrab_black",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Headcrab Fast", 
				Class = "npc_headcrab_fast",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )





Category = "Animals"

local NPC = { 	Name = "Crow", 
				Class = "npc_crow",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Pigeon", 
				Class = "npc_pigeon",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


local NPC = { 	Name = "Seagull", 
				Class = "npc_seagull",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )


// Countdown to "This is in the wrong category" emails, prompted by this hilarious joke

local NPC = { 	Name = "Father Grigori", 
				Class = "npc_monk",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )



Category = "Combine"

local NPC = { 	Name = "Rollermine", 
				Class = "npc_rollermine",
				Offset = 16,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Turret", 
				Class = "npc_turret_floor",
				OnFloor = true,
				TotalSpawnFlags = 0,
				Rotate = Angle( 0, 180, 0 ),
				Offset = 2,
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )

local NPC = { 	Name = "Combine Soldier", 
				Class = "npc_combine_s",
				Model = "models/combine_soldier.mdl",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )



local NPC = { 	Name = "Prison Guard", 
				Class = "npc_combine_s",
				Model = "models/combine_soldier_prisonguard.mdl",
				Category = Category	}

list.Set( "NPC", "CombinePrison", NPC )



local NPC = { 	Name = "Combine Elite", 
				Class = "npc_combine_s",
				Model = "models/combine_super_soldier.mdl",
				Category = Category	}

list.Set( "NPC", "CombineElite", NPC )



local NPC = { 	Name = "City Scanner", 
				Class = "npc_cscanner",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )



local NPC = { 	Name = "Manhack", 
				Class = "npc_manhack",
				Category = Category	}

list.Set( "NPC", NPC.Class, NPC )