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

--[[
An overly complicated solution to something that could have been done with a simple function. (ApplyBonusArmor or something like that)
This function creates a stack of modifier_taric_shatter_armor_percentage (one stack == 1 armor) for whatever 12 percent of taric's current armor is.
--]]
function ShatterApply( event )
	caster = event.caster
	ability = event.ability
	target = event.target

	armor = caster:GetPhysicalArmorValue() * 0.12
	--Reduce one to compensate for the stack added at applydatadrivenmodifier()
	armor = armor - 1

	if armor <= 0 then
		armor = 0
	end

	if target == nil then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_taric_shatter_armor_percentage", nil)
		caster:SetModifierStackCount("modifier_taric_shatter_armor_percentage", caster, armor)
	elseif target ~= nil then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_taric_shatter_armor_percentage", nil)
		target:SetModifierStackCount("modifier_taric_shatter_armor_percentage", caster, armor)
	else
		print("Error")
	end
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
