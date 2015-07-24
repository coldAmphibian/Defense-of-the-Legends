lux_light_binding = class({})

local self = {}

--------------------------------------------------------------------------------

function OnSpellStart( keys )
	self.light_binding_ap_scaling = keys.ability:GetSpecialValueFor( "light_binding_ap_scaling" )
	self.light_binding_width = keys.ability:GetSpecialValueFor( "light_binding_width" )
	self.light_binding_distance = keys.ability:GetSpecialValueFor( "light_binding_distance" )
	self.light_binding_speed = keys.ability:GetSpecialValueFor( "light_binding_speed" )
	self.light_binding_damage = keys.ability:GetSpecialValueFor( "light_binding_damage" )
	self.light_binding_root_duration = keys.ability:GetSpecialValueFor( "light_binding_root_duration" )
	self.light_binding_decrease_factor = keys.ability:GetSpecialValueFor( "light_binding_decrease_factor" )
	self.light_binding_max_targets = keys.ability:GetSpecialValueFor( "light_binding_max_targets" )

	-- --I want to make this unique, so that more than one projectile can be out on the field at the same time
	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetOrigin()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetOrigin(), 
		fStartRadius = self.light_binding_width,
		fEndRadius = self.light_binding_width,
		vVelocity = vDirection * self.light_binding_speed,
		fDistance = self.light_binding_distance,
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

	local factor = math.pow(self.light_binding_decrease_factor, self.targetsHit)

	local final_damage = (caster_ap * self.light_binding_ap_scaling) + (self.light_binding_damage / factor)

	local final_duration = self.light_binding_root_duration / factor

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability,
	}

	ApplyDamage( damage )
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_light_binding", { duration = final_duration })
	keys.caster:FindAbilityByName( "lux_illumination" ):ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_illumination", {})

	self.targetsHit = self.targetsHit + 1

	if self.targetsHit == self.light_binding_max_targets then
		ProjectileManager:DestroyLinearProjectile(self.nProjID)
	end
end