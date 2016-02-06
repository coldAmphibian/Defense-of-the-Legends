--[[
Name: Udyr Bear's Stance
Author: Zarthbenn
Date: 07/2015
--]]
function BearHit( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	if target:HasModifier("modifier_bear_stun_debuff") ~= true then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_bear_stun", nil)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_bear_stun_debuff", nil)
	end
end