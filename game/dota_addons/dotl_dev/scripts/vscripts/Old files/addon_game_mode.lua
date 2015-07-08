local function loadModule(name)
    local status, err = pcall(function()
        -- Load the module
        require(name)
    end)

    if not status then
        -- Tell the user about it
        print('WARNING: '..name..' failed to load!')
        print(err)
    end
end

--[[
Dota PvP game mode
]]

require("GameData")
require("GameDataInfo")

print( "Dota PvP game mode loaded." )

if DotaPvP == nil then
	DotaPvP = class({})
end

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()
    GameRules.DotaPvP = DotaPvP()
    GameRules.DotaPvP:InitGameMode()
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function DotaPvP:InitGameMode()
	local GameMode = GameRules:GetGameModeEntity()

	-- Enable the standard Dota PvP game rules
	GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )

	-- Register Think
	GameMode:SetContextThink( "DotaPvP:GameThink", function() return self:GameThink() end, 0.25 )

	-- Register Game Events

	--Hooks
	ListenToGameEvent('npc_spawned', Dynamic_Wrap( DotaPvP, 'OnNPCSpawned' ), self )

end

--------------------------------------------------------------------------------
function DotaPvP:GameThink()
	return 0.25
end
--------------------------------------------------------------------------------
function DotaPvP:GameThink()
	return 0.25
end

function DotaPvP:OnNPCSpawned( keys )
  local spawnedUnit = EntIndexToHScript( keys.entindex )
  if spawnedUnit:GetUnitName() == "npc_dota_hero_drow_ranger" then
	local spell = spawnedUnit:FindAbilityByName("ashe_focus_passive")
	spell:SetLevel(1)
  end
end