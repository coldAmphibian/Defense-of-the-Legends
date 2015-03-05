-- load required LUA files
require('spell_shop_UI')
require('util')

-- Generated from template
if CAddonLeagueOfLegends == nil then
	CAddonLeagueOfLegends = class({})
end

function Precache(context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource("model", "*.vmdl", context)
			PrecacheResource("soundfile", "*.vsndevts", context)
			PrecacheResource("particle", "*.vpcf", context)
			PrecacheResource("particle_folder", "particles/folder", context)
	]]
end

-- Runs on startup
function Activate()
	GameRules.AddonTemplate = CAddonLeagueOfLegends()
	GameRules.AddonTemplate:InitGameMode()
	SelectTowerLogic()
end

--Selects tower logic to use
function SelectTowerLogic()
	MapName = GetMapName()
	if MapName == "brush_test" or MapName == "summoners_rift" then
		file = "summoners_rift_tower_logic"
	end

	if MapName == "howling_abyss" or MapName == "howling_abyss_45" then
		file = "howling_abyss_tower_logic"
	end

	if file == nil then
		print("no tower logic loaded")
	else
		require(file)
	end
end

--Game Rules
function CAddonLeagueOfLegends:InitGameMode()
	SpellShopUI:InitGameMode();
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1134)
	GameRules:SetPreGameTime(0)
	GameRules:SetGoldPerTick(100000)

	print("GameMode Initialised")
end

-- Evaluate the state of the game
function CAddonLeagueOfLegends:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("Template addon script is running.")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end