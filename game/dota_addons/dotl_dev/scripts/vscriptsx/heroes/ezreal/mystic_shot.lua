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
			damage = damage + (caster:GetAbilityPower() * ability:GetLevelSpecialValueFor('ap_ratio', 0)) + (caster:GetAttackDamage() * ability:GetLevelSpecialValueFor('ad_ratio', 0))
		end
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}
		ApplyDamage(damageTable)

		for i=0,caster:GetAbilityCount() - 1 do
		    local cAbility = caster:GetAbilityByIndex(i)
		    if cAbility ~= nil then
		    	if not IsSummonerSpell(cAbility) then
		    		local cd = cAbility:GetCooldownTimeRemaining() - 1
		    		if cd < 0 then
		    			cd = 0
		    		end
		    		cAbility:EndCooldown()
		    		cAbility:StartCooldown(cd)
		      	end
		    else
		      break
		    end
		end
	end
end