modifier_kassadin_null_sphere_shield = class({})

--------------------------------------------------------------------------------

function modifier_kassadin_null_sphere_shield:OnCreated( keys )
	self.shield_strength = keys.shield_strength
end

function modifier_kassadin_null_sphere_shield:DeclareFunctions()
	func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return func
end

function modifier_kassadin_null_sphere_shield:OnTakeDamage( keys )
	if IsServer() and keys.unit == self:GetParent() then
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			self.shield_strength = self.shield_strength - keys.damage
			local amount_to_heal = keys.damage

			if self.shield_strength <= 0 then
				self:Destroy()
				amount_to_heal = amount_to_heal + self.shield_strength
			end

			self:GetParent():Heal(amount_to_heal, nil)
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------