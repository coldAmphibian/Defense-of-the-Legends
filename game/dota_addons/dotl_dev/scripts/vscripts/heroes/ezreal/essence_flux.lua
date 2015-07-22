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
	if caster ~= target then
		if target:GetTeamNumber() == 2 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_essence_flux", {duration = 5})
		else
			local damageTable = {
				victim = target,
				attacker = caster,
				damage = ability:GetAbilityDamage(),
				damage_type = ability:GetAbilityDamageType()
			}
			ApplyDamage(damageTable)
		end
	else
		if GameRules:GetGameTime() > caster.currentProjectileFireTime + 0.05 then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_essence_flux", {duration = 5})
		end
	end
end