--[[
Name: Udyr Monkeys Agility
Author: Zarthbenn
Date: 07/2015
--]]
function GlobalCooldown( event )
	target = event.target
	caster = event.caster
	ability = event.ability

	for i = 0,5 do 
		spell = caster:GetAbilityByIndex(i)
		if spell == nil then
			i = i + 1
		elseif spell:GetAbilityIndex() == ability:GetAbilityIndex() then
			i = i + 1
		else
			cooldown = spell:GetCooldownTimeRemaining()
			if cooldown >= 2 then
				
			else
				spell:StartCooldown(2)
			end
			i = i + 1
		end
	end

	
end

function MonkeysAgility( event )
	target = event.target
	caster = event.caster
	ability = caster:GetAbilityByIndex(3)

	if caster:HasModifier("modifier_monkeys_agility") == false then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkeys_agility", nil)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkey_1", nil)
	elseif caster:GetModifierStackCount("modifier_monkeys_agility", caster) == 0 then
		caster:RemoveModifierByName("modifier_monkeys_agility")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkeys_agility", nil)
		caster:SetModifierStackCount("modifier_monkeys_agility", caster, 2)
		caster:RemoveModifierByName("modifier_monkey_1")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkey_2", nil)
	elseif caster:GetModifierStackCount("modifier_monkeys_agility", caster) == 2 then
		caster:RemoveModifierByName("modifier_monkeys_agility")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkeys_agility", nil)
		caster:SetModifierStackCount("modifier_monkeys_agility", caster, 3)
		caster:RemoveModifierByName("modifier_monkey_2")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkey_3", nil)
	elseif caster:GetModifierStackCount("modifier_monkeys_agility", caster) == 3 then
		caster:RemoveModifierByName("modifier_monkeys_agility")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkeys_agility", nil)
		caster:SetModifierStackCount("modifier_monkeys_agility", caster, 3)
		caster:RemoveModifierByName("modifier_monkey_3")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_monkey_3", nil)
	end
end