--[[
Name: Udyr Tiger's Stance
Author: Zarthbenn
Date: 07/2015
--]]
function StrikeHit( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	local attackDamage = caster:GetAttackDamage()
	local abilityDamage = ability:GetAbilityDamage()
	local adRatio = ability:GetSpecialValueFor("attack_damage_ratio")

	local totalDamage = abilityDamage + (attackDamage * adRatio)
	target.tigerDamageTick = totalDamage / 4

	ability:ApplyDataDrivenModifier(caster, target, "modifier_tiger_strike_dot", nil)
end

function StrikeDot( event )
	local target = event.target
	local caster = event.caster
	
	local damage = target.tigerDamageTick

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}

	ApplyDamage(damageTable)
end