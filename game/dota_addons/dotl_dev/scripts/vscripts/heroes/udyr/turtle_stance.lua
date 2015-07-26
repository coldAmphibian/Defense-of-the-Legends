--[[
Name: Udyr Turtle Stance
Author: Zarthbenn
Date: 07/2015
--]]
function TurtleShieldInit( event )
	local ability = event.ability
	local caster = event.caster
	
	local abilityPower = caster:GetAbilityPower()
	local shieldSize = ability:GetSpecialValueFor("shield_size")
	local abilityPowerRatio = ability:GetSpecialValueFor("shield_ap_ratio")
	local sheildAmount = shieldSize + (shieldSize * abilityPowerRatio)
	
	caster.TurtleShieldRemaining = sheildAmount
end	
function TurtleShieldAbsorb( event )
	-- Variables
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability

	-- Track how much damage was already absorbed by the shield
	local shield_remaining = caster.TurtleShieldRemaining

	-- Check if the caster has the borrowed time modifier
	if not caster:HasModifier("modifier_turtle_activate") then
		-- If the damage is bigger than what the shield can absorb, heal a portion
		if damage > shield_remaining then
			local newHealth = caster.OldHealth - damage + shield_remaining
			--print("Old Health: "..caster.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..shield_remaining)
			caster:SetHealth(newHealth)
		else
			local newHealth = caster.OldHealth			
			caster:SetHealth(newHealth)
			--print("Old Health: "..caster.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..damage)
		end

		-- Reduce the shield remaining and remove
		caster.TurtleShieldRemaining = caster.TurtleShieldRemaining-damage
		if caster.TurtleShieldRemaining <= 0 then
			caster.TurtleShieldRemaining = nil
			caster:RemoveModifierByName("modifier_turtle_activate")
			--print("--Shield removed--")
		end

		if caster.TurtleShieldRemaining then
			--print("Shield Remaining after Absorb: "..caster.TurtleShieldRemaining)
			--print("---------------")
		end
	end


end

-- Keeps track of the targets health
function TurtleSheildHealth( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end