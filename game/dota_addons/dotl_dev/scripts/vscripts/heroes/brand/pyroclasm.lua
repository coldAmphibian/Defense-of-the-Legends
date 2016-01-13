function OnSpellStart(event)

	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = event.particle_name,
	    iMoveSpeed = 700,
		vSourceLoc = caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
	    bDodgeable = false,                                -- Optional
	    bIsAttack = false,                                -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 150,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}

	ProjectileManager:CreateTrackingProjectile(info)
	caster.bounces = 0

end

function OnProjectileHitUnit(event)

	local caster = event.caster
	local ability = event.ability
	local target = event.target

	caster.bounces = caster.bounces + 1

	local damage = ability:GetAbilityDamage()
	if IsChampion(caster) then
		damage = damage + (caster:GetAbilityPower() * ability:GetSpecialValueFor('ap_ratio'))
	end

	local damageTable = {
		attacker = caster,
		victim = target,
		ability = ability,
		damage = damage,
		damage_type = ability:GetAbilityDamageType()
	}

	ApplyDamage(damageTable)


	if caster.bounces < 4 then

		if target:FindModifierByName('modifier_blaze') then
			local bFound = false

			units = FindUnitsInRadius(
				caster:GetTeam(),
				target:GetAbsOrigin(),
				nil,
				ability:GetSpecialValueFor('search_radius'),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			if units ~= nil then
				for _,unit in pairs(units) do
					if unit ~= target then

						local info = 
						{
							Target = unit,
							Source = target,
							Ability = ability,	
							EffectName = event.particle_name,
						    iMoveSpeed = 700,
							vSourceLoc = target:GetAbsOrigin(),               -- Optional (HOW)
							bDrawsOnMinimap = false,                          -- Optional
						    bDodgeable = false,                               -- Optional
						    bIsAttack = false,                                -- Optional
						    bVisibleToEnemies = true,                         -- Optional
						    bReplaceExisting = false,                         -- Optional
							bProvidesVision = true,                           -- Optional
							iVisionRadius = 150,                              -- Optional
							iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
						}

						ProjectileManager:CreateTrackingProjectile(info)
						bFound = true
						break
					end
				end
			end

			if not bFound then
				units = FindUnitsInRadius(
					caster:GetTeam(),
					target:GetAbsOrigin(),
					nil,
					ability:GetSpecialValueFor('search_radius'),
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false
				)
				if units ~= nil then
					for _,unit in pairs(units) do
						if unit ~= target then
							local info = 
							{
								Target = unit,
								Source = target,
								Ability = ability,	
								EffectName = event.particle_name,
							    iMoveSpeed = 700,
								vSourceLoc = target:GetAbsOrigin(),               -- Optional (HOW)
								bDrawsOnMinimap = false,                          -- Optional
							    bDodgeable = false,                               -- Optional
							    bIsAttack = false,                                -- Optional
							    bVisibleToEnemies = true,                         -- Optional
							    bReplaceExisting = false,                         -- Optional
								bProvidesVision = true,                           -- Optional
								iVisionRadius = 150,                              -- Optional
								iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
							}

							ProjectileManager:CreateTrackingProjectile(info)
							bFound = true
							break
						end
					end
				end
			end
		else
			units = FindUnitsInRadius(
				caster:GetTeam(),
				target:GetAbsOrigin(),
				nil,
				ability:GetSpecialValueFor('search_radius'),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)

			for _,unit in pairs(units) do

				if unit ~= target then

					local info = 
					{
						Target = unit,
						Source = target,
						Ability = ability,	
						EffectName = event.particle_name,
					    iMoveSpeed = 700,
						vSourceLoc = target:GetAbsOrigin(),               -- Optional (HOW)
						bDrawsOnMinimap = false,                          -- Optional
					    bDodgeable = false,                               -- Optional
					    bIsAttack = false,                                -- Optional
					    bVisibleToEnemies = true,                         -- Optional
					    bReplaceExisting = false,                         -- Optional
						bProvidesVision = true,                           -- Optional
						iVisionRadius = 150,                              -- Optional
						iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
					}

					ProjectileManager:CreateTrackingProjectile(info)
					break
				end
			end
		end
	end
end