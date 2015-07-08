function OnKill( keys )
	local mana_per_kill = keys.ability:GetSpecialValueFor("mana_per_kill")
	local current_mana = keys.caster:GetMana()

	keys.caster:SetMana(current_mana + mana_per_kill)
end

function OnIntervalThink( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor("ap_scaling")
	local mana_per_second = keys.ability:GetSpecialValueFor("mana_per_second")
	local damage_radius = keys.ability:GetSpecialValueFor("damage_radius")

	local damage_type = keys.ability:GetAbilityDamageType()
	local ability_team_filter = keys.ability:GetAbilityTargetTeam()
	local ability_type_filter = keys.ability:GetAbilityTargetType()
	local ability_flag_filter = keys.ability:GetAbilityTargetFlags()

	local current_mana = keys.caster:GetMana()

	if current_mana < mana_per_second then
		keys.ability:ToggleAbility()
	else
		keys.caster:SetMana(current_mana - mana_per_second)

		local final_damage = keys.ability:GetAbilityDamage() + (keys.caster:GetAbilityPower() * ap_scaling)

		local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster:GetAbsOrigin(), nil, damage_radius, ability_team_filter, ability_type_filter, ability_flag_filter, FIND_ANY_ORDER, false)
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
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------