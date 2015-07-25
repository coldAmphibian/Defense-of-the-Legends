--[[
Name: Sona Power Chord Lua
Author: Zarthbenn with mods by wFX
Date: 07/2015
--]]
function PowerChord( event )
	local caster = event.caster
	local ability = event.ability
	local trigger = event.trigger
	local innate = caster:FindAbilityByName("modifier_power_chord")
	if innate ~= nil then
		local current_stack = caster:GetModifierStackCount("modifier_power_chord", nil)	
		caster:RemoveModifierByName("modifier_power_chord")
		innate:ApplyDataDrivenModifier(caster, caster, "modifier_power_chord", nil)
		local max_stack = innate:GetLevelSpecialValueFor("max_stacks", 0)
		if current_stack >= max_stack then
			caster:SetModifierStackCount("modifier_power_chord", innate, max_stack)
			caster.effect = trigger
		else
			current_stack = current_stack + 1
			caster:SetModifierStackCount("modifier_power_chord", innate, current_stack)
		end
	end
end

function OnAttackLanded(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local effect = caster.effect
	local damage = ability:GetAbilityDamage()
	if IsChampion(caster) then
		damage = damage + (caster:GetAbilityPower() * ability:GetLevelSpecialValueFor('ap_ratio', 0)) 
	end

	if effect == 'hymn' then
		damage = damage*ability:GetLevelSpecialValueFor('staccato_ratio', 0)

	elseif effect == 'aria' then
		local debuff_value = ability:GetLevelSpecialValueFor('diminuendo_base_ratio', 0)
		if IsChampion(caster) then
			local divisor = ability:GetLevelSpecialValueFor('diminuendo_ap_ratio_divisor', 0)
			local dimratio = ability:GetLevelSpecialValueFor('diminuendo_ap_ratio_per_quotient', 0)
			debuff_value = debuff_value + ( math.floor(caster:GetAbilityPower() / divisor) * dimratio)
		end
		ability:ApplyDataDrivenModifier(caster, target, 'modifier_power_chord_diminuendo', {filter = debuff_value}) 

	elseif effect == 'song' then
		local debuff_value = ability:GetLevelSpecialValueFor('tempo_base_slow', 0)
		if IsChampion(caster) then
			local divisor = ability:GetLevelSpecialValueFor('tempo_ap_ratio_divisor', 0)
			local dimratio = ability:GetLevelSpecialValueFor('tempo_ap_ratio_per_quotient', 0)
			debuff_value = debuff_value + ( math.floor(caster:GetAbilityPower() / divisor) * dimratio)
		end
		ability:ApplyDataDrivenModifier(caster, target, 'modifier_power_chord_tempo', {slow = debuff_value}) 
		
	end

	damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}
	ApplyDamage(damageTable)
	caster:RemoveModifierByName("modifier_power_chord")
end