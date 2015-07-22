--[[
Name: Sona Aria of Perseverance Lua 
Author: Zarthbenn
Date: 07/2015
--]]
function SonaHeal( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local targetHealth = target:GetHealth()
	local targetMaxHealth = target:GetMaxHealth()
	local healMax = ability:GetSpecialValueFor("healMax")
	local healMin = ability:GetSpecialValueFor("heal")

	local healIncrease = (100 * (targetHealth / targetMaxHealth)) * 0.5
	local heal = healMin + (healMin * healIncrease)

	if heal > healMax then
		target:Heal(healMax, target)
	else
		target:Heal(heal, target)
	end
end

function SonaHealBubble( event )
	local damage = event.DamageTaken
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local unit = event.unit
	
	local bubbleAmount = ability:GetSpecialValueFor("bubble_amount")
	target.AphoticShieldRemaining = bubbleAmount
end	
function SonaHealBubbleAbsorb( event )
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
function SonaHealBubbleHealth( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end