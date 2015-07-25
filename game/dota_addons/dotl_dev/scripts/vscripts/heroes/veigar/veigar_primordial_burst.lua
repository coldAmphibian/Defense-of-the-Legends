function OnProjectileHit( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	local target_ap_scaling = keys.ability:GetSpecialValueFor( "target_ap_scaling" )
	local base_damage = keys.ability:GetAbilityDamage()
	local damage_type = keys.ability:GetAbilityDamageType()

	local caster_ap = keys.caster:GetAbilityPower()
	local target_ap = keys.target:GetAbilityPower()
	local final_damage = base_damage + (caster_ap * ap_scaling) + (target_ap * target_ap_scaling)

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = damage_type,
		ability = keys.ability,
	}

	ApplyDamage( damage )
end