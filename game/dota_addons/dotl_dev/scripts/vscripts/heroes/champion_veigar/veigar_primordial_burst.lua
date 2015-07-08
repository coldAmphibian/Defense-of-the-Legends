self = {}

function OnSpellStart( keys )
	self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	self.target_ap_scaling = keys.ability:GetSpecialValueFor( "target_ap_scaling" )
	self.base_damage = keys.ability:GetAbilityDamage()
	self.damage_type = keys.ability:GetAbilityDamageType()

	local caster_ap = keys.caster:GetAbilityPower()
	local target_ap = keys.target:GetAbilityPower()
	self.final_damage = self.base_damage + (caster_ap * self.ap_scaling) + (target_ap * self.target_ap_scaling)
end

function OnProjectileHit( keys )
	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = self.final_damage,
		damage_type = self.damage_type,
		ability = keys.ability,
	}

	ApplyDamage( damage )
end