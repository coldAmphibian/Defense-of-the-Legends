require("util")
require(GetMapName() .. "_brush_locations") --this file contains one variable named brush_locations
											--the variable contains arrays of coordinates keyed with the name of the brush they're associated with

--=================================================================================
--Brush Scripts
--=================================================================================

BrushTable = {}
 
function BrushEnd(trigger)
	trigger.activator:RemoveModifierByName("modifier_lol_in_brush")
	BrushTable[trigger.caller:GetEntityIndex()][trigger.activator:GetTeam()]["entities"][trigger.activator] = nil
	--Say(brush, "You have entered: " .. "brush" .. trigger.caller:GetEntityIndex(), false)
end

vision_spawned = 0

function CheckBrushTable(trigger, name)
	--creates table if table doesn't exist
	if BrushTable[name] == nil then
		--print("making new brush table for brush")
		BrushTable[name] = {}
	end

	if BrushTable[name][trigger.activator:GetTeam()] == nil then
		--print("making new team for brush")
		BrushTable[name][trigger.activator:GetTeam()] = {["entities"] = {}, ["revealers"] = {}, ["activated"] = 0} 					
	end
end


--spawning of brushes relies on the naming of your brush triggers, name them "brush_<<name>>_trigger", this searches for "brush_<<name>>"
function ActivateBrush(trigger, name)
	--spawns revealers
	local team = trigger.activator:GetTeam()
	local blocker_name = (trigger.caller:GetName()):Split("_")[1] .. "_" .. (trigger.caller:GetName()):Split("_")[2]
	local found = 0
	if trigger.activator:GetUnitName() ~= "npc_lol_brush_vision" then
		--print("adding unit to table")
		BrushTable[name][trigger.activator:GetTeam()]["entities"][trigger.activator] = true
	end

	if BrushTable[name][trigger.activator:GetTeam()]["activated"] == 0 and trigger.activator:GetUnitName() ~= "npc_lol_brush_vision" then
		BrushTable[name][trigger.activator:GetTeam()]["activated"] = 1
		--print("spawning vision due to " .. trigger.activator:GetUnitName())
		if brush_locations[blocker_name] ~= nil then
			for _, coord in pairs(brush_locations[blocker_name]) do
				--print("creating unit at: " .. coord[1] .. " " .. coord[2] .. " " .. coord[3])
				BrushTable[name][team]["revealers"][CreateUnitByName("npc_lol_brush_vision", coord, false, nil, nil, trigger.activator:GetTeam())] = true
			end
		else
			print("Failed to load coordinates")
		end
	end
end

function AddUnitsToTable(trigger, name)
	if trigger.activator:GetUnitName() == "npc_lol_brush_vision" then
		--print("adding revealer to to table for team: " .. trigger.activator:GetTeam())
		BrushTable[name][trigger.activator:GetTeam()]["revealers"][trigger.activator] = true
	
	else
		if trigger.activator:GetUnitName() ~= "npc_dota_courier" then
			giveUnitDataDrivenModifier(trigger.activator, trigger.activator, "modifier_lol_in_brush", -1)
		end
		if BrushTable[name][trigger.activator:GetTeam()]["entities"][trigger.activator] == nil then
			--print("adding ent to table")
			BrushTable[name][trigger.activator:GetTeam()]["entities"][trigger.activator] = true
		end
	end
end

function ChangeBrushVisionRange(trigger, name)
	for team, v in pairs(BrushTable[name]) do
		for revealer, v in pairs(BrushTable[name][team]["revealers"]) do 
			local largest_vr = 0
			-- This gets the largest vision the revealer should set its vision to								
			for entity, v in pairs(BrushTable[name][team]["entities"]) do
				-- Checks if the entity is touching the brush
				if trigger:IsTouching(entity) then
					-- Only gets vision for things on correct team
					if entity:GetTeam() == revealer:GetTeam() then
						local entity_vr = entity:GetCurrentVisionRange()
						local d = CalcDistanceBetweenEntityOBB(entity, revealer)
						largest_vr = math.max(entity_vr - d, largest_vr)
					end
				-- Else: remove it from the table, this prevents the script from crashing when something dies in the brush
				else
					--print("entity removed")
					BrushTable[name][team]["entities"][entity] = nil
				end
			end
			-- this changes vision
			revealer:SetDayTimeVisionRange(largest_vr)
			revealer:SetNightTimeVisionRange(largest_vr)
		end
	end
end

function CountRemainingUnits(brush, team)
	local count = 0
	for entity, _ in pairs(BrushTable[brush][team]["entities"]) do
		count = count + 1
	end
	--print("counted " .. count .. " units for " .. team)
	return count
end

function CleanVision(brush, team)
	local count = 0
	--print(cleaning)
	for revealer, _ in pairs(BrushTable[brush][team]["revealers"]) do
		revealer:RemoveSelf()
		BrushTable[brush][team]["revealers"][revealer] = nil
		count = count + 1
	end
	--print("removed: " .. count)
end

function CountActivated(brush)
	local count = 0
	for team, _ in pairs(BrushTable[brush]) do
		if BrushTable[brush][team]["activated"] == 1 then
			count = count + 1
		end
	end
	return count
end

function BrushThinker(trigger, name)
	thisEntity:SetContextThink("brush-thinker-for-" .. name, function(trigger)
			-- This will check if there are any entities remaining from your team inside the brush, if not. It stops the checking loop

			--print("thinking")

			ChangeBrushVisionRange(trigger, name)

			for team, _ in pairs(BrushTable[name]) do
				local continue = 0
				if CountRemainingUnits(name, team) > 0 then
					continue = 1
				end

				--deactivate the brush for this team
				if continue == 0 then
					--print("ending")
					CleanVision(name, team)
					BrushTable[name][team]["activated"] = 0
				end
			end
				--stop thinking
			if CountActivated(name) == 0 then
				return nil
			end

			return 0.01
		end, 0)
end	

function BrushStart(trigger)
	local name = trigger.caller:GetEntityIndex()
	CheckBrushTable(trigger, name)
	ActivateBrush(trigger, name)
	AddUnitsToTable(trigger, name)
	BrushThinker(trigger, name)
end


--Stops units from getting stuck
function AntiBlockStart(trigger)
	if trigger.activator then
		trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_phased", nil)
	end
end
 
function AntiBlockEnd(trigger)
	if trigger.activator then
		trigger.activator:RemoveModifierByName("modifier_phased")
	end
end
 
function giveUnitDataDrivenModifier(source, target, modifier, dur)
    --source and target should be hscript-units. The same unit can be in both source and target
    local item = CreateItem( "lol_modifiers", source, source)
    item:ApplyDataDrivenModifier(source, target, modifier, {duration=dur})
end