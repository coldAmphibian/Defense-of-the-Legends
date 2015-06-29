function ezreal_mystic_shot_on_spell_start(event)
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

function ezreal_mystic_shot_on_hit_unit(event)
	local ability = event.ability
	if ability ~= nil then
		local caster = event.caster
		local target = event.target
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = ability:GetAbilityDamage(),
			damage_type = ability:GetAbilityDamageType()
		}
		ApplyDamage(damageTable)

		local aux
		local newcd
		for i=1,4 do
			aux = caster:GetAbilityByIndex(i)
			if aux ~= nil then
				newcd = aux:GetCooldownTimeRemaining() - 1
				if newcd > 0 then
					aux:EndCooldown()
					aux:StartCooldown(newcd)
				end
			end
		end
	end
end