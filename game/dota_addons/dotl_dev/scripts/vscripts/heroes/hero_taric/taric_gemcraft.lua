--[[
Name: Taric Gemcraft Lua
Author: Zarthbenn
Date: 07/2015
--]]

function Gemcraft( event )
	target = event.target
	caster = event.caster
	ability = event.ability

	
	if caster:HasModifier("modifier_taric_gemcraft") == false then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_taric_gemcraft", nil)
	end

	-- This loop goes through each of tarics abilities. If the ability is on cooldown then reduce it by 2 seconds. If the cooldown is at less than 2 seconds then it ends it.
	for i = 0,5 do 
		spell = caster:GetAbilityByIndex(i)
		if spell == nil then
			i = i + 1
		elseif spell:GetAbilityIndex() == ability:GetAbilityIndex() then
			i = i + 1
		else
			cooldown = spell:GetCooldownTimeRemaining()
			if cooldown <= 2 then
				spell:EndCooldown()
			else
				newCooldown = cooldown - 2
				spell:EndCooldown()
				spell:StartCooldown(newCooldown)
			end
			i = i + 1
		end
	end
end

function GemcraftHit( event )
	target = event.target
	caster = event.caster

	armor = caster:GetPhysicalArmorValue()
	damage = 0.2 * armor
end