self = {}

function OnSpellStart( keys )self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" ) 
	self.explosion_radius = keys.ability:GetSpecialValueFor( "explosion_radius" ) 
	self.explosion_delay = keys.ability:GetSpecialValueFor( "explosion_delay" ) 
	self.base_damage = keys.ability:GetAbilityDamage() 
	self.damage_type = keys.ability:GetAbilityDamageType()

	AddFOWViewer(keys.caster:GetTeamNumber(), keys.target_points[1], self.explosion_radius, self.explosion_delay, false)

	local caster_ap = keys.caster:GetAbilityPower()
	self.final_damage = self.base_damage + (caster_ap * self.ap_scaling)
end

function OnHit( keys )
	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = self.final_damage,
		damage_type = self.damage_type,
		ability = keys.ability,
	}

	ApplyDamage( damage )
end