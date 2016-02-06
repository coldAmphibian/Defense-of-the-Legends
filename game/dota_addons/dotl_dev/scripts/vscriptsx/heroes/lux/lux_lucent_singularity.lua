function OnSpellStart( keys )
	keys.caster.lucent_singularity_target = keys.target_points[1]
	local projectile_speed = keys.ability:GetSpecialValueFor( "projectile_speed" )
	local singularity_vision_radius = keys.ability:GetSpecialValueFor( "singularity_vision_radius" )

	local vDirection = keys.ability:GetCursorPosition() - keys.caster:GetOrigin()
	local projectile_distance = vDirection:Length2D()
	vDirection = vDirection:Normalized()

	local info = {
		EffectName = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf",
		Ability = keys.ability,
		vSpawnOrigin = keys.caster:GetOrigin(), 
		fStartRadius = 0,
		fEndRadius = 0,
		vVelocity = vDirection * projectile_speed,
		fDistance = projectile_distance,
		Source = keys.caster,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
	}

	keys.caster:SwapAbilities("lux_lucent_singularity", "lux_lucent_singularity_detonate", false, true)

	ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function OnProjectileHit( keys )
	keys.caster.lucent_singularity_thinker = keys.ability:ApplyDataDrivenThinker(keys.caster, keys.caster.lucent_singularity_target, "modifier_lux_lucent_singularity_thinker", {})
end

--------------------------------------------------------------------------------

function Thinker_OnCreated( keys )
	local singularity_vision_radius = keys.ability:GetSpecialValueFor("singularity_vision_radius")
	keys.caster.lucent_singularity_start_time = GameRules:GetGameTime()
	keys.caster.lucent_singularity_previous_vision_time = keys.caster.lucent_singularity_start_time

	keys.caster.lucent_singularity_should_detonate = false

	--Duration is up for tweaking
	AddFOWViewer(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), singularity_vision_radius, 0.7, false)
end

--------------------------------------------------------------------------------

function Thinker_OnIntervalThink( keys )
	local singularity_radius = keys.ability:GetSpecialValueFor( "singularity_radius" )
	local singularity_vision_radius = keys.ability:GetSpecialValueFor("singularity_vision_radius")
	local singularity_max_duration = keys.ability:GetSpecialValueFor( "singularity_max_duration" )

	local current_time = GameRules:GetGameTime()

	if current_time - keys.caster.lucent_singularity_previous_vision_time >= 0.5 then
		AddFOWViewer(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), singularity_vision_radius, 0.7, false)

		keys.caster.lucent_singularity_previous_vision_time = current_time
	end

	if current_time - keys.caster.lucent_singularity_start_time >= singularity_max_duration or keys.caster.lucent_singularity_should_detonate == true then
		keys.target:RemoveModifierByName("modifier_lux_lucent_singularity_thinker")
		UTIL_Remove(keys.target)
	end
end

--------------------------------------------------------------------------------

function Thinker_OnDestroy( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	local base_damage = keys.ability:GetAbilityDamage()
	local singularity_radius = keys.ability:GetSpecialValueFor( "singularity_radius" )

	local enemies = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), keys.target, singularity_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if #enemies > 0 then

		--Incase the hero casting doesn't have ap defined for it
		local caster_ap = keys.caster:GetAbilityPower()
		local final_damage =  base_damage + (caster_ap * ap_scaling)

		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				local damage = {
					victim = enemy,
					attacker = keys.caster,
					damage = final_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = keys.ability,
				}

				ApplyDamage( damage )

				local illumination_ability = keys.caster:FindAbilityByName("lux_illumination")
				if illumination_ability ~= nil then
					illumination_ability:ApplyDataDrivenModifier(keys.caster, enemy, "modifier_lux_illumination", {})
				end
			end
		end
	end

	keys.caster:SwapAbilities("lux_lucent_singularity_detonate", "lux_lucent_singularity", false, true)
end

--------------------------------------------------------------------------------

function Thinker_Detonate( keys )
	keys.caster.lucent_singularity_should_detonate = true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------