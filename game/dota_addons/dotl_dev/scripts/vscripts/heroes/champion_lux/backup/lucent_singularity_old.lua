--[[
	Author: Capruce
	Date: 10.05.2015.
	Launches a singularity
]]
function CreateSingularity( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]
	local singularity_aura = keys.singularity_aura
	local duration = keys.duration

	caster.singularity_unit = CreateUnitByName("npc_dummy_blank", target_point, false, caster, caster, caster:GetTeam())
	caster.singularity_unit:AddNewModifier(caster, ability, "modifier_kill", {Duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster.singularity_unit, singularity_aura, {})
end

--[[
	Author: Capruce
	Date: 10.05.2015.
	Swaps the abilities back then deletes the unit on the next frame (can be buggy if removed instantly)
]]
function RemoveSingularity( keys )
	local singularity_unit = keys.caster.singularity_unit

	SwitchAbilities(keys)
	
	Timers:CreateTimer(0.01, function()
		singularity_unit:RemoveSelf()
	end)
end

--[[
	Author: Capruce
	Date: 10.05.2015.
	Launches a singularity
]]
function DetonateSingularity(keys)
	local caster = keys.caster
	caster.singularity_unit:ForceKill(true)
end

--[[
	Author: Noya, Pizzalol
	Date: 20.02.2015.
	Swaps the abilities
]]
function SwitchAbilities( keys )
	local caster = keys.caster
	local current_ability = keys.current_ability
	local new_ability = keys.new_ability

	-- Swap sub_ability
	caster:SwapAbilities(current_ability, new_ability, false, true)
	--print("Swapped "..main_ability_name.." with " ..sub_ability_name)
end