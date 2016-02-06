--[[
Name: Taric Radiance Lua
Author: Zarthbenn
Date: 07/2015
--]]

function RadianceDamage( event )
	caster = event.caster
	target = event.target
	ability = event.ability

	abilityPower = caster:GetAbilityPower
	abilityDamage = ability:GetAbilityDamage()

	damage = abilityDamage + (abilityDamage * abilityPower)

	damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}
	ApplyDamage(damageTable)
end