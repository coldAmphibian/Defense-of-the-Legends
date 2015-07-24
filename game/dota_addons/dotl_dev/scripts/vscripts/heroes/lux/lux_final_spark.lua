local self = {}

--------------------------------------------------------------------------------

function OnSpellStart( keys )
	self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	self.beam_range = keys.ability:GetSpecialValueFor( "beam_range" )
	self.beam_width = keys.ability:GetSpecialValueFor( "beam_width" )
	self.vision_duration = keys.ability:GetSpecialValueFor( "vision_duration" )
	self.beam_damage = keys.ability:GetSpecialValueFor( "beam_damage" )

	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetOrigin()
	vDirection = vDirection:Normalized()

	local number = math.floor(self.beam_range / self.beam_width)
	for i = 0, number do
		local location = keys.caster:GetAbsOrigin() + keys.caster:GetForwardVector() * i * self.beam_width
		AddFOWViewer(keys.caster:GetTeamNumber(), location, self.beam_width / 2, self.vision_duration, false)
	end
end

--------------------------------------------------------------------------------

function OnBeamHit( keys )
	--Incase the hero casting doesn't have ap defined for it
	local caster_ap = keys.caster:GetAbilityPower()
	local final_damage = (caster_ap * self.ap_scaling) + self.beam_damage

	local damage = {
		victim = keys.target,
		attacker = keys.caster,
		damage = final_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = keys.ability,
	}

	ApplyDamage( damage )

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

	keys.caster:FindAbilityByName( "lux_illumination" ):ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_illumination", {})
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------