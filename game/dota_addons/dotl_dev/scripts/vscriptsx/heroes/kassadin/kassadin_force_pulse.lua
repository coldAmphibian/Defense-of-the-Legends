function OnSpellStart( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor("ap_scaling")
	local base_damage = keys.ability:GetAbilityDamage()

	keys.caster:SetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster, 0)
	keys.ability:SetActivated(false)

	local caster_ap = keys.caster:GetAbilityPower()
	keys.caster.force_pulse_final_damage = base_damage + (caster_ap * ap_scaling)
end

function OnProjectileHit( keys )
	local damage_type = keys.ability:GetAbilityDamageType()

	damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = keys.caster.force_pulse_final_damage,
		damage_type = damage_type,
		ability = keys.ability,
	}

	ApplyDamage(damage)
end

function Caster_OnCreated( keys )
	keys.ability:SetActivated(false)
end

function Target_OnAbilityExecuted( keys )
	local required_stacks = keys.ability:GetSpecialValueFor("required_stacks")
	local current_stacks = keys.caster:GetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster)

	if current_stacks < required_stacks then
		keys.caster:SetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster, current_stacks + 1)

		if current_stacks + 1 == required_stacks then
			keys.ability:SetActivated(true)
		end
	end
end