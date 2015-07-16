--[[
Name: Taric Shatter Lua
Author: Zarthbenn
Date: 07/2015
--]]

function Shatter( event )
	target = event.target
	caster = event.caster
	ability = event.ability

	armor = caster:GetPhysicalArmorValue()
	abilityDamage = ability:GetAbilityDamage()

	damage = abilityDamage + (0.2 * armor)

	local damageTable = {}
	damageTable.attacker = caster
	damageTable.victim = target
	damageTable.damage_type = ability:GetAbilityDamageType()
	damageTable.ability = ability
	damageTable.damage = damage

	ApplyDamage(damageTable)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_taric_shatter_debuff", nil)
end

function ShatterCheck( event )
	caster = event.caster
	ability = event.ability

	if ability:IsCooldownReady() == true and caster:HasModifier("modifier_taric_shatter_passive") ~= true then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_taric_shatter_passive", nil)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_taric_shatter_bonus_armor", nil)

		caster:RemoveModifierByName("modifier_taric_shatter_check")
	else
	
	end
end
