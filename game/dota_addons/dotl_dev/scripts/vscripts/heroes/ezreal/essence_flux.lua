--[[========================
	LoL's Ezreal Dota port
	Author: wFX
	Date: 03/2015
==========================]]
function OnSpellStart(event)
	local caster = event.caster
	local info = 
	{
		Ability = event.ability,
    	EffectName = event.effect_name,
    	vSpawnOrigin = caster:GetAbsOrigin() + (event.target_points[1] - caster:GetAbsOrigin()):Normalized() * 64,
    	fDistance = event.range,
    	fStartRadius = event.radius,
    	fEndRadius = event.radius,
    	Source = caster,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO,
		vVelocity = (event.target_points[1] - caster:GetAbsOrigin()):Normalized() * event.projectile_speed,
		bProvidesVision = false,
		iVisionRadius = event.vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	event.caster.currentProjectileIndex = projectile
	event.caster.currentProjectileFireTime = GameRules:GetGameTime()
end

function OnProjectileHitUnit(event)
	
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	if target:GetTeamNumber() == caster:GetTeamNumber() then
		if (caster ~= target) or (GameRules:GetGameTime() > caster.currentProjectileFireTime + 0.05) then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_essence_flux", {duration = 5})
		end
	else
		local damage = ability:GetAbilityDamage()
		if IsChampion(caster) then
			damage = damage + (caster:GetAbilityPower() * ability:GetLevelSpecialValueFor('ap_ratio', 0))
		end	
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}
		ApplyDamage(damageTable)
	end
end