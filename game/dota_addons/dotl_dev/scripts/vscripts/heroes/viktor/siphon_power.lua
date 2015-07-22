function ViktorBubble( event )
	local damage = event.DamageTaken
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local unit = event.unit
	
	local bubbleAmount = ability:GetSpecialValueFor("shield_size")
	target.AphoticShieldRemaining = bubbleAmount
end	
function ViktorBubbleAbsorb( event )
	-- Variables
	local damage = event.DamageTaken
	local unit = event.unit
	local ability = event.ability

	-- Track how much damage was already absorbed by the shield
	local shield_remaining = unit.AphoticShieldRemaining

	-- Check if the unit has the borrowed time modifier
	if not unit:HasModifier("aura_perseverance_effect") then
		-- If the damage is bigger than what the shield can absorb, heal a portion
		if damage > shield_remaining then
			local newHealth = unit.OldHealth - damage + shield_remaining
			--print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..shield_remaining)
			unit:SetHealth(newHealth)
		else
			local newHealth = unit.OldHealth			
			unit:SetHealth(newHealth)
			--print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..damage)
		end

		-- Reduce the shield remaining and remove
		unit.AphoticShieldRemaining = unit.AphoticShieldRemaining-damage
		if unit.AphoticShieldRemaining <= 0 then
			unit.AphoticShieldRemaining = nil
			unit:RemoveModifierByName("modifier_perseverance_bubble")
			--print("--Shield removed--")
		end

		if unit.AphoticShieldRemaining then
			--print("Shield Remaining after Absorb: "..unit.AphoticShieldRemaining)
			--print("---------------")
		end
	end


end

-- Keeps track of the targets health
function ViktorBubbleHealth( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end