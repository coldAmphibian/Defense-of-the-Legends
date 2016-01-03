--[[========================
	Author: wFX
	Date: 10/2015
==========================]]
function OnSpellStart(event)
	local caster = event.caster
	local info = 
	{
		Ability = event.ability,
    	EffectName = event.effect_name,
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	fDistance = event.range,
    	fStartRadius = event.radius,
    	fEndRadius = event.radius,
    	Source = caster,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = (event.target_points[1] - caster:GetAbsOrigin()):Normalized() * event.projectile_speed,
		bProvidesVision = false,
		iVisionRadius = event.vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
end

function OnProjectileHitUnit(event)
	local ability = event.ability
	if ability ~= nil then
		local caster = event.caster
		local target = event.target
		local damage = ability:GetAbilityDamage()
		if IsChampion(caster) then
			damage = damage + (caster:GetAbilityPower() * ability:GetSpecialValueFor('ap_ratio'))
		end
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}
		ApplyDamage(damageTable)

		local mod = target:FindModifierByName('modifier_blaze')
		if mod ~= nil then
			local duration = ability:GetSpecialValueFor('stun_duration')
			ability:ApplyDataDrivenModifier(caster, target,'modifier_sear_stun', {duration = duration})
		end

		local innate = caster:FindAbilityByName("brand_blaze")
		if innate ~= nil then
			local duration = innate:GetSpecialValueFor('buff_duration')
			innate:ApplyDataDrivenModifier(caster, target, 'modifier_blaze', {duration = duration})
		end
	end
end