--[[========================
	LoL's Ezreal Dota port
	Author: wFX
	Date: 03/2015
==========================]]
function OnSpellStart(event)
	local caster = event.caster
	local ability = event.ability

 	ProjectileManager:ProjectileDodge(caster)
	--ParticleManager:CreateParticle("particles/heroes/ezrael/blink_start.vpcf", PATTACH_ABSORIGIN, caster)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	local origin_point = caster:GetAbsOrigin()
	local target_point = event.target_points[1]
	local difference_vector = target_point - origin_point
			
	if difference_vector:Length2D() > event.blink_range then
		target_point = origin_point + (target_point - origin_point):Normalized() * event.blink_range
	end

	caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(caster, target_point, false)

 	local pBlink = ParticleManager:CreateParticle("particles/heroes/ezreal/arcane_shift.vpcf", PATTACH_ABSORIGIN, caster)
 	ParticleManager:SetParticleControl(pBlink, 1, target_point)
 	--ParticleManager:SetParticleControl(pBlink, 0, caster:GetAbsOrigin())
 	Timers:CreateTimer(0.1, function()
		local nearby_enemy_units =
			FindUnitsInRadius(
				caster:GetTeam(),
				caster:GetAbsOrigin(),
				nil,
				event.search_range,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

		local target = nearby_enemy_units[1]
		if target ~= nil then
			local info = 
			{
				Target = target,
				Source = caster,
				Ability = ability,	
				EffectName = event.effect_name,
				vSourceLoc = caster:GetAbsOrigin(),
				iMoveSpeed = event.projectile_speed,
				bProvidesVision = false,
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false
			}
			projectile = ProjectileManager:CreateTrackingProjectile(info)
		end	
	end)
end

function OnProjectileHitUnit(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
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