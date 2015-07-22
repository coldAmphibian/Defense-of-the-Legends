--[[========================
	LoL's Ezreal Dota port
	Author: wFX
	Date: 03/2015
==========================]]
function OnSpellStart(event)
	local caster = event.caster
	local origin = Vector(GetWorldMinX(), GetWorldMinY())
	local far = Vector(GetWorldMaxX(), GetWorldMaxY())
	local distance = math.sqrt(math.pow((far[1] - origin[1]),2) + math.pow((far[2] - origin[2]),2))
	local info = 
	{
		Ability = event.ability,
    	EffectName = event.effect_name,
    	vSpawnOrigin = caster:GetAbsOrigin(),
    	fDistance = distance,
    	fStartRadius = event.radius,
    	fEndRadius = event.radius,
    	Source = caster,
    	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = (event.target_points[1] - caster:GetAbsOrigin()):Normalized() * event.projectile_speed,
		bProvidesVision = true,
		iVisionRadius = event.vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	event.caster.currentProjectileIndex = projectile
	event.caster.currentProjectileUnits = 0	
end

function OnProjectileHitUnit(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ability:GetAbilityDamage() * (1 - (caster.currentProjectileUnits * 0.10)),
		damage_type = ability:GetAbilityDamageType()
	}
	ApplyDamage(damageTable)
	if caster.currentProjectileUnits < 7 then 
		caster.currentProjectileUnits = caster.currentProjectileUnits + 1
	end
end