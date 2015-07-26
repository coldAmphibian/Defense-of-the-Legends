--[[
Name: Udyr Pheonix Stance
Author: Zarthbenn
Date: 07/2015
--]]
function WaveDamageTick( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local abilityPower = caster:GetAbilityPower()
	local abilityDamage = ability:GetSpecialValueFor("damage_wave")
	local abilityRatio = ability:GetSpecialValueFor("damage_wave_ratio")

	local damage = abilityDamage + (abilityPower * abilityRatio)

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}

	ApplyDamage(damageTable)
end

function PheonixHit( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local abilityPower = caster:GetAbilityPower()
	local abilityDamage = ability:GetSpecialValueFor("on_hit_damage")
	local abilityRatio = ability:GetSpecialValueFor("hit_damage_ratio")

	local damage = abilityDamage + (abilityPower * abilityRatio)

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}

	ApplyDamage(damageTable)

end

function PheonixStack( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if caster:GetModifierStackCount("modifier_pheonix_stack", caster) == 0 then
		caster:SetModifierStackCount("modifier_pheonix_stack", caster, 1)
	elseif caster:GetModifierStackCount("modifier_pheonix_stack", caster) == 1 then
		caster:SetModifierStackCount("modifier_pheonix_stack", caster, 2)
	elseif caster:GetModifierStackCount("modifier_pheonix_stack", caster) == 2 then
		caster:SetModifierStackCount("modifier_pheonix_stack", caster, 0)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_pheonix_attack", nil)
	end

end