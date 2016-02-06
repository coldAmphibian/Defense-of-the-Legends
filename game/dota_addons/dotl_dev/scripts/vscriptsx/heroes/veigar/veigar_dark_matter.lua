function OnSpellStart( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" ) 
	local explosion_radius = keys.ability:GetSpecialValueFor( "explosion_radius" ) 
	local explosion_delay = keys.ability:GetSpecialValueFor( "explosion_delay" ) 
	local base_damage = keys.ability:GetAbilityDamage()

	AddFOWViewer(keys.caster:GetTeamNumber(), keys.target_points[1], explosion_radius, explosion_delay, false)

	local caster_ap = keys.caster:GetAbilityPower()
	keys.caster.dark_matter_final_damage = base_damage + (caster_ap * ap_scaling)
end

function OnHit( keys )
	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = keys.caster.dark_matter_final_damage,
		damage_type = keys.ability:GetAbilityDamageType(),
		ability = keys.ability,
	}

	ApplyDamage( damage )
end