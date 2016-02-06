function OnSpellStart( keys )
	local projectile_radius = keys.ability:GetSpecialValueFor( "projectile_radius" )
	local projectile_distance = keys.ability:GetSpecialValueFor( "projectile_distance" )
	local projectile_speed = keys.ability:GetSpecialValueFor( "projectile_speed" )

	-- --I want to make this unique, so that more than one projectile can be out on the field at the same time
	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetAbsOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/heroes/veigar/baleful_strike.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetAbsOrigin(), 
		fStartRadius = projectile_radius,
		fEndRadius = projectile_radius,
		vVelocity = vDirection * projectile_speed,
		fDistance = projectile_distance,
		Source = keys.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	keys.caster.baleful_strike_targets_hit = 0
	keys.caster.baleful_strike_projectile = ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function OnProjectileHit( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	local base_damage = keys.ability:GetAbilityDamage()
	local ap_per_unit_kill = keys.ability:GetSpecialValueFor( "ap_per_unit_kill" )
	local max_targets = keys.ability:GetSpecialValueFor( "max_targets" )

	--Incase the hero casting doesn't have ap defined for it
	local caster_ap = keys.caster:GetAbilityPower()
	local final_damage = base_damage + (caster_ap * ap_scaling)

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = keys.ability:GetAbilityDamageType(),
		ability = keys.ability,
	}

	ApplyDamage( damage )

	--Check if target killed. If so, increase AP
	if not keys.target:IsAlive() then
		if keys.target:IsHero() then
			keys.caster:ModifyAbilityPower(ap_per_unit_kill * 2)
		else
			keys.caster:ModifyAbilityPower(ap_per_unit_kill)
		end
	end

	keys.caster.baleful_strike_targets_hit = keys.caster.baleful_strike_targets_hit + 1

	if keys.caster.baleful_strike_targets_hit == max_targets then
		ProjectileManager:DestroyLinearProjectile(keys.caster.baleful_strike_projectile)
	end
end

function OnHeroKilled( keys )
	local ap_per_champion_kill = keys.ability:GetSpecialValueFor("ap_per_champion_kill")
	keys.caster:ModifyAbilityPower(ap_per_champion_kill)
end