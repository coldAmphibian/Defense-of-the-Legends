self = {}

function OnSpellStart( keys )
	local wall_length = keys.ability:GetSpecialValueFor("wall_length")
	local wall_thickness = keys.ability:GetSpecialValueFor("wall_thickness")
	local obelisk_vision_radius = keys.ability:GetSpecialValueFor("obelisk_vision_radius")
	local wall_duration = keys.ability:GetSpecialValueFor("wall_duration")

	local point = keys.ability:GetCursorPosition()
	local direction_to_point = point - keys.caster:GetAbsOrigin()
	local normal_direction = Vector(-direction_to_point.y, direction_to_point.x, direction_to_point.z):Normalized()

	local obelisk_position_1 = point + (normal_direction * wall_length / 2)
	local obelisk_position_2 = point - (normal_direction * wall_length / 2)

	AddFOWViewer(keys.caster:GetTeamNumber(), obelisk_position_1, obelisk_vision_radius, wall_duration, false)
	AddFOWViewer(keys.caster:GetTeamNumber(), obelisk_position_2, obelisk_vision_radius, wall_duration, false)

	local thinkers_needed =  math.floor(wall_length / wall_thickness)
	local thinker_separation = wall_length / thinkers_needed

	local thinker_position = obelisk_position_1 - normal_direction * thinker_separation
	
	for i=1,thinkers_needed - 1 do
		DebugDrawCircle(thinker_position, Vector(0, 255, 0), 1, wall_thickness, true, wall_duration)
		keys.ability:ApplyDataDrivenThinker(keys.caster, thinker_position, "modifier_karthus_wall_of_pain_thinker", {})
		thinker_position = thinker_position - normal_direction * thinker_separation
	end

	DebugDrawCircle(obelisk_position_1, Vector(255, 0, 0), 1, 20, true, wall_duration)
	DebugDrawCircle(obelisk_position_2, Vector(255, 0, 0), 1, 20, true, wall_duration)
	DebugDrawLine(obelisk_position_1, obelisk_position_2, 0, 255, 0, true, wall_duration)

	keys.caster.wall_of_pain_hitlist = {}
end

function OnIntervalThink( keys )
	local ability_team_filter = keys.ability:GetAbilityTargetTeam()
	local ability_type_filter = keys.ability:GetAbilityTargetType()
	local ability_flag_filter = keys.ability:GetAbilityTargetFlags()
	local wall_thickness = keys.ability:GetSpecialValueFor("wall_thickness")

	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), nil, wall_thickness, ability_team_filter, ability_type_filter, ability_flag_filter, FIND_ANY_ORDER, false)
	
	if #units > 0 then
		for _,unit in pairs(units) do
			if keys.caster.wall_of_pain_hitlist[unit] ~= true then
				keys.caster.wall_of_pain_hitlist[unit] = true
				keys.ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_karthus_wall_of_pain", {})
			end
		end
	end
end

function OnDestroy( keys )
	UTIL_Remove(keys.target)
end