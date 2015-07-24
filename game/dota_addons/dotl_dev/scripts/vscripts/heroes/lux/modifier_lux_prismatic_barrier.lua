modifier_lux_prismatic_barrier = class({})

--------------------------------------------------------------------------------

function modifier_lux_prismatic_barrier:OnCreated( keys )
	self.shield_strength = keys.shield_strength
	self.damage_taken = 0

	if IsServer() then
		--The current way is a horrible mess and waiting on valve to add proper way to do this
		-- checkFunction = function(selfV, keys)
		-- 					local victim = EntIndexToHScript(keys.entindex_victim_const)
		-- 					if victim == self:GetParent() then
		-- 						local total = self.damage_taken + keys.damage

		-- 						if total >= self.shield_strength then
		-- 							keys.damage = total - self.shield_strength
		-- 							self:Destroy()
		-- 							return true
		-- 						else
		-- 							self.damage_taken = self.damage_taken + keys.damage
		-- 							return false
		-- 						end
		-- 					end

		-- 					return true
		-- 		 		end

		-- GameRules:GetGameModeEntity():SetDamageFilter(checkFunction, {})
	end
end

--------------------------------------------------------------------------------

function modifier_lux_prismatic_barrier:OnRefresh( keys )
	self.shield_strength = keys.shield_strength
	self.damage_taken = 0
end

--------------------------------------------------------------------------------

function modifier_lux_prismatic_barrier:OnDestroy()
	if IsServer() then
		--GameRules:GetGameModeEntity():ClearDamageFilter()
	end
end


function modifier_lux_prismatic_barrier:DeclareFunctions()
	func = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return func
end

--To make it easier the shield currently works on damage AFTER reductions, will be changed in future
function modifier_lux_prismatic_barrier:OnTakeDamage( keys )
	if IsServer() then
		self.damage_taken = self.damage_taken + keys.damage
		
		if self.damage_taken > self.shield_strength then
			amountToHeal = keys.damage - (self.damage_taken - self.shield_strength)

			self:GetParent():Heal(amountToHeal, nil)

			self:Destroy()
		elseif self.damage_taken == self.shield_strength then
			self:Destroy()
		else
			self:GetParent():Heal(keys.damage, nil)
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------