local self = {}

--------------------------------------------------------------------------------

function OnAttackLanded( keys )
	-- local modifier = keys.target:FindModifierByName( "modifier_lux_illumination" )
	-- if modifier ~= nil and modifier:GetCaster() == keys.caster then
	-- 	self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	-- end

	if keys.target:HasModifier( "modifier_lux_illumination" ) then
		self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
		self.base_damage = keys.ability:GetSpecialValueFor( "base_damage" )
		self.level_multiplier = keys.ability:GetSpecialValueFor( "level_multiplier" )
		
		--Incase the hero casting doesn't have ap defined for it
		local caster_ap = 0
		if keys.caster.ap ~= nil then
			caster_ap = keys.caster.ap
		end
		local caster_level = keys.caster:GetLevel()
		local final_damage = self.base_damage + (self.level_multiplier * caster_level) + (caster_ap * self.ap_scaling)

		keys.target:RemoveModifierByNameAndCaster( "modifier_lux_illumination", keys.caster )
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------