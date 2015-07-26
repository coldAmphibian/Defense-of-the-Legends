modifier_lux_prismatic_barrier = class({})

--------------------------------------------------------------------------------

function modifier_lux_prismatic_barrier:OnCreated( keys )
	self.shield_strength = keys.shield_strength
end

--------------------------------------------------------------------------------

function modifier_lux_prismatic_barrier:OnRefresh( keys )
	self.shield_strength = keys.shield_strength
end


function modifier_lux_prismatic_barrier:DeclareFunctions()
	func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return func
end

--To make it easier the shield currently works on damage AFTER reductions, will be changed in future
function modifier_lux_prismatic_barrier:OnTakeDamage( keys )
	if IsServer() and keys.unit == self:GetParent() then
		self.shield_strength = self.shield_strength - keys.damage
		local amount_to_heal = keys.damage

		if self.shield_strength <= 0 then
			self:Destroy()
			amount_to_heal = amount_to_heal + self.shield_strength
		end

		self:GetParent():Heal(amount_to_heal, nil)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------