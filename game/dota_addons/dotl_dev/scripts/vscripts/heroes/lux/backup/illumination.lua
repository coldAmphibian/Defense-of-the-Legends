--[[
	Author: Capruce
	Date: 11.05.2015.
	Checks whether the caster has the illumination passive. Then applies it to the target
]]
function ApplyDebuff ( keys )
	local caster = keys.caster
	local target = keys.target
	local illumination_modifier_name = keys.illumination_modifier_name
	local illumination_ability_name = keys.illumination_ability_name
	local illumination_ability = CheckForIllumination(caster, illumination_ability_name)

	if illumination_ability ~= nil then
		illumination_ability:ApplyDataDrivenModifier(caster, target, illumination_modifier_name, {})
		illumination_ability.modifier_name = illumination_modifier_name
	else
		return
	end
end

function CheckForIllumination ( caster, illumination_ability_name )
	return caster:FindAbilityByName( illumination_ability_name )
end

function ApplyDamage( keys )
	local attacker = keys.attacker
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if attacker == caster then
		local caster_level = caster:GetLevel()
		local base_damage = ability:GetSpecialValueFor("base_damage")
		local damage_multiplier = ability:GetSpecialValueFor("damage_multiplier")
		local damage_total = base_damage + damage_multiplier * caster_level

		print(caster:GetName())
		print(target:GetName())
		print(damage_total)

		local damage_table = {
			victim = caster,
			attacker = caster,
			damage = damage_total,
			damage_type = ability:GetAbilityDamageType()
		}
		print("test: " .. ApplyDamage(damage_table))

		target:RemoveModifierByNameAndCaster(ability.modifier_name, caster)
	end
end