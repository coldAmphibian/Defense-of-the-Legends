require("util")

base_towers = {["blue"] = 2, ["red"] = 2}

function EntityKilled (eventInfo)
	local killed_unit = EntIndexToHScript(eventInfo.entindex_killed)

	--manages tower invuln
	if killed_unit:IsTower() then
		local name = killed_unit:GetName()
		local team = name:Split("_")[1]
		local lane = name:Split("_")[2]
		local tier = name:Split("_")[3]
		local nxt = ""

		--tier 3's killed
		if tier == "3" then
			nxt = team .. "_" .. lane .. "_" .. "inhibitor"

		--inhibs killed
		elseif tier == "inhibitor" then
			nxt = team .. "_" .. "base"

		--base towers killed
		elseif lane == "base" then
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

function InitInvuln()
	for _, tower in pairs (Entities:FindAllByClassname("npc_dota_tower")) do
		local name = tower:GetName()
		--local team = name:Split("_")[1]
		local lane = name:Split("_")[2]
		local tier = name:Split("_")[3]

		if (tier ~= "1" or lane == "base") then
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

buildings = {}
InitInvuln()
--InitTable()

print("Summoner's Rift Tower Logic Loaded")