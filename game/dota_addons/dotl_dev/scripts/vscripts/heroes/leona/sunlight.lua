--[[
Name: Leona Sunlight Lua
Author: Zarthbenn with modifications by wFX
Date: 07/2015
--]]
function OnAttacked(event)

	local ability = event.ability
	local caster = ability:GetCaster()
	local attacker = event.attacker
	local target = event.target
	if attacker ~= caster then
		local damageTable = {
			victim = target,
			attacker = attacker,
			damage = ability:GetAbilityDamage(),
			damage_type = ability:GetAbilityDamageType()
		}
		ApplyDamage(damageTable)
		target:RemoveModifierByName("modifier_leona_sunlight")
	end
end

function ApplyModifier(event)
	local target = event.target
	local caster = event.caster
	local ability = caster:GetAbilityByIndex(3)
	ability:ApplyDataDrivenModifier(caster, target ,'modifier_leona_sunlight', nil)
end


