function OnSpellStart( keys )
	local ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )
	local base_damage = keys.ability:GetAbilityDamage()

	local ability_team_filter = keys.ability:GetAbilityTargetTeam()
	local ability_type_filter = keys.ability:GetAbilityTargetType()
	local ability_flag_filter = keys.ability:GetAbilityTargetFlags()

	local beam_range = keys.ability:GetSpecialValueFor( "beam_range" )
	local beam_width = keys.ability:GetSpecialValueFor( "beam_width" )
	local vision_duration = keys.ability:GetSpecialValueFor( "vision_duration" )

	local thinkers_needed =  math.floor(beam_range / (beam_width / 2))
	local thinker_separation = beam_range / thinkers_needed

	local thinker_position = keys.caster:GetAbsOrigin()

	local illumination_ability = keys.caster:FindAbilityByName( "lux_illumination" )

	local hit_list = {}

	local caster_ap = keys.caster:GetAbilityPower()
	local final_damage = base_damage + (caster_ap * ap_scaling)
	
	for i=1,thinkers_needed do
		local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), thinker_position, nil, beam_width / 2, ability_team_filter, ability_type_filter, ability_flag_filter, FIND_ANY_ORDER, false)
		if #units > 0 then
			for _,unit in pairs(units) do
				if hit_list[unit] ~= true then
					print("Hit")
					hit_list[unit] = true
					local damage = {
						victim = unit,
						attacker = keys.caster,
						damage = final_damage,
						damage_type = keys.ability:GetAbilityDamageType(),
						ability = keys.ability,
					}
					ApplyDamage(damage)

					if illumination_ability ~= nil then
						local illumination_ap_scaling = illumination_ability:GetSpecialValueFor( "ap_scaling" )
						local illumination_base_damage = illumination_ability:GetSpecialValueFor( "base_damage" )
						local illumination_level_multiplier = illumination_ability:GetSpecialValueFor( "level_multiplier" )
						
						if unit:HasModifier( "modifier_lux_illumination" ) then
							--Incase the hero casting doesn't have ap defined for it
							local caster_level = keys.caster:GetLevel()
							local final_damage = illumination_base_damage + (illumination_level_multiplier * caster_level) + (caster_ap * illumination_ap_scaling)

							local damage = {
								victim = unit,
								attacker = keys.caster,
								damage = final_damage,
								damage_type = DAMAGE_TYPE_MAGICAL,
								ability = keys.ability,
							}
							ApplyDamage( damage )

							unit:RemoveModifierByNameAndCaster( "modifier_lux_illumination", keys.caster )
						end

						illumination_ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_lux_illumination", {})
					end
				end
			end
		end

		DebugDrawCircle(thinker_position, Vector(0, 255, 0), 1, beam_width / 2, true, 5)
		AddFOWViewer(keys.caster:GetTeamNumber(), thinker_position, beam_width / 2, vision_duration, false)
		thinker_position = thinker_position + keys.caster:GetForwardVector() * thinker_separation
	end
end

--------------------------------------------------------------------------------

function OnBeamHit( keys )
	

	--Check if the caster has illumination passive
	
	if illumination_ability ~= nil then
		local illumination_ap_scaling = illumination_ability:GetSpecialValueFor( "ap_scaling" )
		local illumination_base_damage = illumination_ability:GetSpecialValueFor( "base_damage" )
		local illumination_level_multiplier = illumination_ability:GetSpecialValueFor( "level_multiplier" )
		
		if keys.target:HasModifier( "modifier_lux_illumination" ) then
			--Incase the hero casting doesn't have ap defined for it
			local caster_level = keys.caster:GetLevel()
			local final_damage = illumination_base_damage + (illumination_level_multiplier * caster_level) + (caster_ap * illumination_ap_scaling)

			local damage = {
				victim = keys.target,
				attacker = keys.caster,
				damage = final_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = keys.ability,
			}
			ApplyDamage( damage )

			keys.target:RemoveModifierByNameAndCaster( "modifier_lux_illumination", keys.caster )
		end

		illumination_ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_lux_illumination", {})
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------