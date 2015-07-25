RESOURCE_TYPE_MANA = 0
RESOURCE_TYPE_RAGE = 1
RESOURCE_TYPE_HEALTH = 2

if Champion == nil then
  print ( '[Champion] creating Champion parser' )
  Champion = {}
  Champion.__index = Champion

  Champion.kv_file = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")

  print("[Champion] Linking modifier_champion")
  LinkLuaModifier("modifier_champion", "modifiers/modifier_champion.lua", LUA_MODIFIER_MOTION_NONE)
end

function IsChampion( unit )
	return unit.ap ~= nil
end

function IsChampionInnate( ability )
	return ability:GetLevelSpecialValueFor('champion_passive', 0) == 1
end

function IsScaledByLevel( ability )
	return ability:GetLevelSpecialValueFor('level_scale', 0) ~= 0
end

function Champion:Create( unit )
	if not unit:IsHero() or IsChampion( unit ) then
		return
	end

	local kv_file = nil
	--Load the relavent section of the kv
	for k,v in pairs(Champion.kv_file) do
		if v.override_hero == unit:GetName() then
			unit.name = k
			kv_file = v
			break
		end
	end

	if kv_file == nil then
		print("[Champion] There was no champion file for " .. unit:GetName())
		return
	end

	--Add LoL based stats
	unit.ap = 0

	unit.health_gain = kv_file.HealthGain
	unit.health_regen_gain = kv_file.HealthRegenGain

	unit.mana_gain = kv_file.ManaGain
	unit.mana_regen_gain = kv_file.ManaRegenGain

	function unit:GetHealthGain()
		return unit.health_gain
	end

	function unit:GetHealthRegenGain()
		return unit.health_regen_gain
	end

	function unit:GetManaGain()
		return unit.mana_gain
	end

	function unit:GetManaRegenGain()
		return unit.mana_regen_gain
	end

	function unit:GetAbilityPower()
		return unit.ap
	end

	function unit:SetAbilityPower( ap )
		unit.ap = ap
	end

	function unit:ModifyAbilityPower( ap )
		unit.ap = unit.ap + ap
	end

	function unit:UpgradeSpellsByLevel(level)
		for i=0,15 do
		    local ability = unit:GetAbilityByIndex(i)
		    if ability ~= nil then
		    	if IsScaledByLevel(ability) then
		      		local nLevel = ability:GetLevelSpecialValueFor("level_scale", level-1)
					ability:SetLevel(nLevel)
		      	end
		    else
		      break
		    end
		end
	end

	function unit:LearnInnateSpells()
		for i=0,15 do
			local ability = unit:GetAbilityByIndex(i)
			if ability ~= nil then
				if IsChampionInnate(ability) then
					ability:SetLevel(1)
		        end
		    else
		    	break
		    end
		end
	end

	unit:AddNewModifier(unit, nil, "modifier_champion", {})

	unit:LearnInnateSpells()
	unit:UpgradeSpellsByLevel(1)

	print(unit:GetName() .. " has become " .. tostring(unit.name))
end