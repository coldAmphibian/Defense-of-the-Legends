--LinkLuaModifier("modifier_kassadin_null_sphere_sheild", "heroes/champion_kassadin/modifier_kassadin"_null_sphere_shield", LUA_MODIFIER_MOTION_NONE)
self = {}

function OnSpellStart( keys )
	self.damage_ap_scaling = keys.ability:GetSpecialValueFor("damage_ap_scaling")
	self.base_damage = keys.ability:GetAbilityDamage()
	self.damage_type = keys.ability:GetAbilityDamageType()
	self.shield_ap_scaling = keys.ability:GetSpecialValueFor("shield_ap_scaling")
	self.base_shield_strength = keys.ability:GetSpecialValueFor("base_shield_strength")
	self.shield_duration = keys.ability:GetSpecialValueFor("shield_duration")

	local caster_ap = keys.caster:GetAbilityPower()
	self.final_damage = self.base_damage + (caster_ap * self.damage_ap_scaling)
end


function OnProjectileHit( keys )
	keys.target:InterruptChannel()

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = self.final_damage,
		damage_type = self.damage_type,
		ability = keys.ability,
	}

	ApplyDamage( damage )
end