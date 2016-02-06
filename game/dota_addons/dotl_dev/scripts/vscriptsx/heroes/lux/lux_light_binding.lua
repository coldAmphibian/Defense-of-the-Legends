function OnSpellStart( keys )
	local projectile_width = keys.ability:GetSpecialValueFor( "projectile_width" )
	local projectile_distance = keys.ability:GetSpecialValueFor( "projectile_distance" )
	local projectile_speed = keys.ability:GetSpecialValueFor( "projectile_speed" )

	-- --I want to make this unique, so that more than one projectile can be out on the field at the same time
	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetOrigin(), 
		fStartRadius = projectile_width,
		fEndRadius = projectile_width,
		vVelocity = vDirection * projectile_speed,
		fDistance = projectile_distance,
		Source = keys.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	keys.caster.light_binding_targets_hit = 0
	keys.caster.light_binding_projectile = ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function OnProjectileHit( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	local base_damage = keys.ability:GetAbilityDamage()

	local base_root_duration = keys.ability:GetSpecialValueFor( "base_root_duration" )
	local decrease_factor = keys.ability:GetSpecialValueFor( "decrease_factor" )
	local max_targets = keys.ability:GetSpecialValueFor( "max_targets" )

	local caster_ap = keys.caster:GetAbilityPower()
	local factor = math.pow(decrease_factor, keys.caster.light_binding_targets_hit)
	local final_damage =  (base_damage / factor) + (caster_ap * ap_scaling)
	local final_duration = base_root_duration / factor

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability,
	}

	ApplyDamage( damage )
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_light_binding", { duration = final_duration })

	local illumination_ability = keys.caster:FindAbilityByName( "lux_illumination" )
	if illumination_ability ~= nil then
		illumination_ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_illumination", {})
	end

	keys.caster.light_binding_targets_hit = keys.caster.light_binding_targets_hit + 1

	if keys.caster.light_binding_targets_hit == max_targets then
		ProjectileManager:DestroyLinearProjectile(keys.caster.light_binding_projectile)
	end
end