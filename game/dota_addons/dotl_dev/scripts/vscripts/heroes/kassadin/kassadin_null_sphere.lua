LinkLuaModifier("modifier_kassadin_null_sphere_shield", "heroes/kassadin/modifier_kassadin_null_sphere_shield.lua", LUA_MODIFIER_MOTION_NONE)

function OnSpellStart( keys )
	local shield_ap_scaling = keys.ability:GetSpecialValueFor("shield_ap_scaling")
	local base_shield_strength = keys.ability:GetSpecialValueFor("base_shield_strength")

	local caster_ap = keys.caster:GetAbilityPower()
	local final_shield_strength = base_shield_strength + (caster_ap * shield_ap_scaling)

	local shield_duration = keys.ability:GetSpecialValueFor("shield_duration")

	local kv = {
		duration = 20,
		shield_strength = final_shield_strength,
	}

	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_kassadin_null_sphere_shield", kv)
end

function OnProjectileHit( keys )
	local damage_ap_scaling = keys.ability:GetSpecialValueFor("damage_ap_scaling")
	local base_damage = keys.ability:GetAbilityDamage()
	local damage_type = keys.ability:GetAbilityDamageType()
	
	local caster_ap = keys.caster:GetAbilityPower()
	local final_damage = base_damage + (caster_ap * damage_ap_scaling)

	keys.target:InterruptChannel()

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = damage_type,
		ability = keys.ability,
	}

	ApplyDamage( damage )
end