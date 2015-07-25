--[[
Name: Taric Imbue Lua
Author: Zarthbenn
Date: 07/2015
--]]

function Imbue( event )
	target = event.target
	caster = event.caster
	ability = event.ability
	abilityPower = caster:GetAbilityPower()

	healTarget = ability:GetSpecialValueFor("heal")
	healSelf = ability:GetSpecialValueFor("heal_self")

	if target == caster then
		heal = healSelf + (abilityPower * ability:GetSpecialValueFor("heal_self_apscale"))
		heal = heal + (heal * 0.4)
		--Add 7% 'bonus health' here
		caster:Heal(heal, caster)
	elseif target ~= caster then
		targetHeal = healTarget + (abilityPower * ability:GetSpecialValueFor("heal_apscale"))
		--Add 5% 'bonus health' here
		target:Heal(targetHeal, caster)
		selfHeal = healSelf + (abilityPower * ability:GetSpecialValueFor("heal_self_apscale"))
		--Add 7% 'bonus health' here
		caster:Heal(healSelf, caster)
	else
		print("ERROR")
	end
end
