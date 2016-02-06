function OnAttackLanded( keys )
	if keys.target:HasModifier( "modifier_lux_illumination" ) then
		local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
		local base_damage = keys.ability:GetSpecialValueFor( "base_damage" )
		local level_multiplier = keys.ability:GetSpecialValueFor( "level_multiplier" )
		
		--Incase the hero casting doesn't have ap defined for it
		local caster_ap = keys.caster:GetAbilityPower()
		local caster_level = keys.caster:GetLevel()
		local final_damage = base_damage + (level_multiplier * caster_level) + (caster_ap * ap_scaling)

		local damage = {
			victim = keys.target,
			attacker = keys.caster,
			damage = final_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = keys.ability,
		}
		ApplyDamage(damage)

		keys.target:RemoveModifierByNameAndCaster("modifier_lux_illumination", keys.caster)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------