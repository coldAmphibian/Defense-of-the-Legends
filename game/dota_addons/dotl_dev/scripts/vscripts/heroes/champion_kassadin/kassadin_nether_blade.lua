function PassiveOnAttackLanded( keys )
	local passive_ap_scaling = keys.ability:GetSpecialValueFor("passive_ap_scaling")
	local passive_base_damamge = keys.ability:GetSpecialValueFor("passive_base_damamge")

	local final_damage = passive_base_damamge + (keys.caster:GetAbilityPower() * passive_ap_scaling)

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = keys.ability:GetAbilityDamageType(),
		ability = keys.ability,
	}

	ApplyDamage( damage )
end


function ActiveOnAttackLanded( keys )
	local active_ap_scaling = keys.ability:GetSpecialValueFor("passive_ap_scaling")
	local active_base_damamge = keys.ability:GetAbilityDamage()
	local mana_restore_pct = keys.ability:GetSpecialValueFor("mana_restore_pct")
	local champion_multiplier = keys.ability:GetSpecialValueFor("champion_multiplier")

	local final_damage = active_base_damamge + (keys.caster:GetAbilityPower() * active_ap_scaling)

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = keys.ability:GetAbilityDamageType(),
		ability = keys.ability,
	}

	ApplyDamage( damage )

	local missing_mana = keys.caster:GetMaxMana() - keys.caster:GetMana()
	local multiplier = 1
	if keys.target:IsHero() then
		multiplier = champion_multiplier
	end
	local mana_to_restore = missing_mana * (0.01 * mana_restore_pct * multiplier)

	keys.caster:SetMana(keys.caster:GetMana() + mana_to_restore)
end