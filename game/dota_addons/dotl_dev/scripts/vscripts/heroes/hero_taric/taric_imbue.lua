--[[
Name: Taric Imbue Lua
Author: Zarthbenn
Date: 07/2015
--]]

function Imbue( event )
	target = event.target
	caster = event.caster
	ability = event.ability

	healTarget = ability:GetSpecialValueFor("heal")
	healSelf = ability:GetSpecialValueFor("heal_self")

	if target == caster then
		heal = healSelf + (healSelf * 0.4)
		caster:Heal(heal, caster)
	elseif target ~= caster then
		target:Heal(healTarget, caster)
		caster:Heal(healSelf, caster)
	else
		print("ERROR")
	end
end
