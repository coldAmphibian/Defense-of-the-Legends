self = {}

function OnSpellStart( keys )
	local target_team = keys.ability:GetAbilityTargetTeam()
	local target_type = keys.ability:GetAbilityTargetType()
	self.enemy_heroes = FindUnitsInRadius(target_team, keys.caster:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, target_team, target_type, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(self.enemy_heroes) do
		keys.ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_karthus_requiem", {})
	end
end

function OnChannelFinish( keys )
	for _,unit in pairs(self.enemy_heroes) do
		unit:RemoveModifierByNameAndCaster("modifier_karthus_requiem", keys.caster)
	end
end

function OnChannelSucceeded( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor("ap_scaling")
	local base_damage = keys.ability:GetAbilityDamage()
	local damage_type = keys.ability:GetAbilityDamageType()
	local caster_ap = keys.caster:GetAbilityPower()

	local final_damage = base_damage + (caster_ap * ap_scaling)

	for _,unit in pairs(self.enemy_heroes) do
		if not unit:IsMagicImmune() then
			damage = {
				victim = unit,
				attacker = keys.caster,
				damage = final_damage,
				damage_type = damage_type,
				ability = keys.ability,
			}
			ApplyDamage(damage)
		end
	end
end