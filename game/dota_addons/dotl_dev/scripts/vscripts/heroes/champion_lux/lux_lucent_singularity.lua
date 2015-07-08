--lux_lucent_singularity = class({})

local self = {}

--------------------------------------------------------------------------------

function OnSpellStart( keys )
	self.target = keys.target_points[1]
	self.projectile_speed = keys.ability:GetSpecialValueFor( "projectile_speed" )
	self.vision_radius = keys.ability:GetSpecialValueFor( "vision_radius" )
	self.singularity_duration = keys.ability:GetSpecialValueFor( "singularity_duration" )

	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetOrigin()
	self.projectile_distance = math.sqrt(vDirection.x * vDirection.x + vDirection.y * vDirection.y + vDirection.z + vDirection.z)
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetOrigin(), 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * self.projectile_speed,
		fDistance = self.projectile_distance,
		Source = keys.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	}

	keys.caster:SwapAbilities("lux_lucent_singularity", "lux_lucent_singularity_detonate", false, true)

	ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function OnProjectileHit( keys )
	self.singularity_thinker = keys.ability:ApplyDataDrivenThinker(keys.caster, self.target, "modifier_lux_lucent_singularity_thinker", {})
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------