function CreateSingularity( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target_point = keys.target_points[1]
	local lucent_singularity_aura = keys.lucent_singularity_aura
	local duration = keys.duration
	local vision_aoe = ability:GetSpecialValueFor("vision_aoe")

	caster.lucent_singularity_unit = CreateUnitByName("npc_dummy_blank", target_point, false, caster, caster, caster:GetTeam())
	caster.lucent_singularity_unit:SetDayTimeVisionRange(vision_aoe)
	caster.lucent_singularity_unit:SetNightTimeVisionRange(vision_aoe)
	ability:ApplyDataDrivenModifier(caster, caster.lucent_singularity_unit, lucent_singularity_aura, {})
	
	caster.lucent_singularity_remain = true
	local start_time = GameRules:GetGameTime()

	Timers:CreateTimer(function()
		local current_time = GameRules:GetGameTime()
		if caster.lucent_singularity_remain and current_time - start_time < duration then
			return 1/50
		else
			SwapAbilities(keys)

			caster.lucent_singularity_unit:RemoveModifierByName(lucent_singularity_aura)

			--Give a frame before removing the unit to ensure animations and sounds complete
			Timers:CreateTimer(0.01, function()
				caster.lucent_singularity_unit:RemoveSelf()
			end)
		end
	end)
end

function DetonateSingularity( keys )
	local caster = keys.caster
	caster.lucent_singularity_remain = false
end

--[[
	Author: Noya, Pizzalol
	Date: 20.02.2015.
	Swaps the abilities
]]
function SwapAbilities( keys )
	local caster = keys.caster
	local current_ability = keys.current_ability
	local new_ability = keys.new_ability

	-- Swap sub_ability
	caster:SwapAbilities(current_ability, new_ability, false, true)
	--print("Swapped "..main_ability_name.." with " ..sub_ability_name)
end