local self = {}

--------------------------------------------------------------------------------

function OnSpellStart( keys )
	self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	self.projectile_radius = keys.ability:GetSpecialValueFor( "projectile_radius" )
	self.projectile_distance = keys.ability:GetSpecialValueFor( "projectile_distance" )
	self.projectile_speed = keys.ability:GetSpecialValueFor( "projectile_speed" )
	self.max_targets = keys.ability:GetSpecialValueFor( "max_targets" )
	self.base_damage = keys.ability:GetAbilityDamage()
	self.ap_per_unit_kill = keys.ability:GetSpecialValueFor( "ap_per_unit_kill" )

	-- --I want to make this unique, so that more than one projectile can be out on the field at the same time
	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetAbsOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/champions/veigar/veigar_baleful_strike.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetAbsOrigin(), 
		fStartRadius = self.projectile_radius,
		fEndRadius = self.projectile_radius,
		vVelocity = vDirection * self.projectile_speed,
		fDistance = self.projectile_distance,
		Source = keys.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	self.targetsHit = 0
	self.nProjID = ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function OnProjectileHit( keys )
	--Incase the hero casting doesn't have ap defined for it
	local caster_ap = keys.caster:GetAbilityPower()
	local final_damage = self.base_damage + (caster_ap * self.ap_scaling)

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
			keys.caster:AddAbilityPower(self.ap_per_unit_kill * 2)
		else
			keys.caster:AddAbilityPower(self.ap_per_unit_kill)
		end
	end

	self.targetsHit = self.targetsHit + 1

	if self.targetsHit == self.max_targets then
		ProjectileManager:DestroyLinearProjectile(self.nProjID)
	end
end

function OnHeroKilled( keys )
	local ap_increase = keys.ability:GetSpecialValueFor("ap_per_champion_kill")
	keys.caster:AddAbilityPower(ap_increase)
end