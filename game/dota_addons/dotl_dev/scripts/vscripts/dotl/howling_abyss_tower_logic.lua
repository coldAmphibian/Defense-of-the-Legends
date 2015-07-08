--[[require("util")

inhibitor_respawn = {["blue"] = 20, ["red"] = 20}
base_towers = {["blue"] = 2, ["red"] = 2}

function InhibitorTimer(team)
	local ent = Entities:CreateByClassname("info_target")
	ent:SetContextThink("timer", function()

			if inhibitor_respawn[team] == 0 then
				inhibitor_respawn[team] = 20
				Say(nil, team .. " inhibitor has respawned", false)
				if team == "red" then
					CreateUnitByName("npc_lol_red_inhibitor", Vector(2400,2352,76), false, nil, nil, 3)
				else
					CreateUnitByName("npc_lol_blue_inhibitor", Vector(-2336,-2240,76), false, nil, nil, 2)
				end
				return 0
			
			elseif inhibitor_respawn[team] == 15 then
				Say(nil, team .. " inhibitor is respawning in 15 seconds", false)
			end

			Say(nil, inhibitor_respawn[team] .. "s on " .. team .. " inhib", false)
			inhibitor_respawn[team] = inhibitor_respawn[team] - 1
			return 1
		end, 0)
end

function EntityKilled (eventInfo)
	local killed_unit = EntIndexToHScript(eventInfo.entindex_killed)

	--manages tower invuln
	if killed_unit:IsTower() then
		local name = killed_unit:GetName()
		local team = name:Split("_")[1]
		local tier = name:Split("_")[2]
		local nxt = ""

		print(killed_unit:UnitCanRespawn())

		--tier 2's killed
		if tier == "1" then
			nxt = team .. "_2"

		elseif tier == "2" then
			nxt = team .. "_" .. "inhibitor"

		--inhibs killed
		elseif tier == "inhibitor" then
			nxt = team .. "_" .. "base"

		--base towers killed
		elseif tier == "base" then
			base_towers[team] = base_towers[team] - 1
			if base_towers[team] == 0 then
				nxt = team .. "_" .. "nexus"
			end

		--tier 1's or 2's killed
		else
			nxt = team .. "_" .. lane .. "_" .. tonumber(tier) + 1
		end

		for _, building in pairs (Entities:FindAllByName(nxt)) do
			building:RemoveModifierByName("modifier_lol_building_invuln")
		end

    	--Say(nil, killed_unit:GetName() .. " is kill, " .. nxt .. " is now open", false)
    end
end

function Init()
	SendToConsole("fog_enable 0")

	for _, nexus in pairs (Entities:FindAllByClassname("npc_dota_fort")) do
		nexus:SetHullRadius(200)
	end

	for _, tower in pairs (Entities:FindAllByClassname("npc_dota_tower")) do
		local name = tower:GetName()

		--local team = name:Split("_")[1]
		local tier = name:Split("_")[2]

		if (tier == "inhibitor") then
			tower:SetHullRadius(150)
		end

		if (tier ~= "1" or tier == "base") then
			if lane ~= "obelisk" then
				giveUnitDataDrivenModifier(tower, tower, "modifier_lol_building_invuln", -1)
			end
		end
	end

	for _, nexus in pairs (Entities:FindAllByClassname("npc_dota_fort")) do
		giveUnitDataDrivenModifier(nexus, nexus, "modifier_lol_building_invuln", -1)
	end
end

ListenToGameEvent("entity_killed", EntityKilled, nil)

Init()
--InitTable()
]]

print("Howling Abyss Tower Logic Loaded")