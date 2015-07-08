self = {}

function OnSpellStart( keys )
	local explosion_delay = keys.ability:GetSpecialValueFor("explosion_delay")

	self.thinker = keys.ability:ApplyDataDrivenThinker(keys.caster, keys.ability:GetCursorPosition(), "modifier_karthus_lay_waste_thinker", {})
end

--------------------------------------------------------------------------------

function OnCreated( keys )
	local explosion_radius = keys.ability:GetSpecialValueFor("explosion_radius")
	local explosion_delay = keys.ability:GetSpecialValueFor("explosion_delay")

	AddFOWViewer(keys.caster:GetTeamNumber(), keys.ability:GetCursorPosition(), explosion_radius, explosion_delay, false)
end

--------------------------------------------------------------------------------

function OnDestroy( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor("ap_scaling")
	local explosion_radius = keys.ability:GetSpecialValueFor("explosion_radius")
	local single_target_multiplier = keys.ability:GetSpecialValueFor("single_target_multiplier")

	local damage_type = keys.ability:GetAbilityDamageType()
	local ability_team_filter = keys.ability:GetAbilityTargetTeam()
	local ability_type_filter = keys.ability:GetAbilityTargetType()
	local ability_flag_filter = keys.ability:GetAbilityTargetFlags()

	local final_damage = keys.ability:GetAbilityDamage() + (keys.caster:GetAbilityPower() * ap_scaling)

	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, explosion_radius, ability_team_filter, ability_type_filter, ability_flag_filter, FIND_ANY_ORDER, false)
	if #units == 1 then
		final_damage = final_damage * single_target_multiplier
	end

	for _,unit in pairs(units) do
		damage = {
			victim = unit,
			attacker = keys.caster,
			damage = final_damage,
			damage_type = damage_type,
			ability = keys.ability,
		}
		ApplyDamage(damage)
	end

	UTIL_Remove(self.thinker)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------