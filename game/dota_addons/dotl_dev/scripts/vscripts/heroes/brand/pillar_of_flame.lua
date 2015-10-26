--[[========================
	Author: wFX
	Date: 10/2015
==========================]]
function OnSpellStart(event)

	local caster = event.caster
	local ability = event.ability
	local radius = ability:GetSpecialValueFor('radius')
	local vPoint = event.target_points[1]
	local pInstant = event.particle_instant
	local pDelayed = event.particle_delayed
	local particle_instant = ParticleManager:CreateParticle(pInstant, PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle_instant, 0, vPoint)
	ParticleManager:SetParticleControl(particle_instant, 1, Vector(radius, 0, 0))

	Timers:CreateTimer(ability:GetSpecialValueFor('delay'), function()
		local caught_units =
		FindUnitsInRadius(
			caster:GetTeamNumber(),
			vPoint,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false
		)

		local particle_delayed = ParticleManager:CreateParticle(pDelayed, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle_delayed, 0, vPoint)
		ParticleManager:SetParticleControl(particle_delayed, 1, Vector(radius, 0, 0))

		for _,unit in pairs(caught_units) do
			local damageTable = {
				attacker = caster,
				victim = unit,
				damage = ability:GetAbilityDamage(),
				damage_type = ability:GetAbilityDamageType(),
				ability = ability
				}
			ApplyDamage(damageTable)
		end
	end)
end