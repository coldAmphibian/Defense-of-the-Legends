self = {}

function OnSpellStart( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor("ap_scaling")
	local base_damage = keys.ability:GetAbilityDamage()
	self.damage_type = keys.ability:GetAbilityDamageType()

	local caster_ap = keys.caster:GetAbilityPower()
	self.final_damage = base_damage + (caster_ap * ap_scaling)

	keys.caster:SetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster, 0)
	keys.ability:SetActivated(false)
end

function OnProjectileHit( keys )
	damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = self.final_damage,
		damage_type = self.damage_type,
		ability = keys.ability,
	}

	ApplyDamage(damage)
end

function CasterOnCreated( keys )
	keys.ability:SetActivated(false)
end

function TargetOnAbilityExecuted( keys )
	local required_stacks = keys.ability:GetSpecialValueFor("required_stacks")
	local current_stacks = keys.caster:GetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster)

	if current_stacks < required_stacks then
		keys.caster:SetModifierStackCount("modifier_kassadin_force_pulse_caster", keys.caster, current_stacks + 1)

		if current_stacks + 1 == required_stacks then
			keys.ability:SetActivated(true)
		end
	end
end