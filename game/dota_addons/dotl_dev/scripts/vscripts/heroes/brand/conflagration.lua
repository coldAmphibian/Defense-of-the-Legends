function OnSpellStart( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target:FindModifierByName('modifier_blaze') then
		local nearby_enemy_units =
			FindUnitsInRadius(
				caster:GetTeam(),
				target:GetAbsOrigin(),
				nil,
				ability:GetSpecialValueFor('spread_radius'),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NONE,
				FIND_ANY_ORDER,
				false
			)
		for _,unit in pairs(nearby_enemy_units) do
			ActOnTarget(event, unit)
		end
	else
		ActOnTarget(event, target)
	end
end

function ActOnTarget(event, target)
	local caster = event.caster
	local ability = event.ability

	local damageTable = {
		attacker = caster,
		victim = target,
		ability = ability,
		damage = ability:GetAbilityDamage(),
		damage_type = ability:GetAbilityDamageType()
	}

	ApplyDamage(damageTable)

	local innate = caster:FindAbilityByName("brand_blaze")
	if innate ~= nil then
		local duration = innate:GetSpecialValueFor('buff_duration')
		innate:ApplyDataDrivenModifier(caster, target, 'modifier_blaze', {duration = duration})
	end
end