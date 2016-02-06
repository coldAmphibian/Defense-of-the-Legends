function OnCreated( keys )
	local ring_radius = keys.ability:GetSpecialValueFor( "ring_radius" )
	local ring_duration = keys.ability:GetSpecialValueFor( "ring_duration" )
	local thickness = keys.ability:GetSpecialValueFor( "edge_thickness" )
	keys.caster.event_horizon_target = keys.target:GetAbsOrigin()
	keys.caster.event_horizon_hit_list = {}

	AddFOWViewer(keys.caster:GetTeamNumber(), keys.caster.event_horizon_target, ring_duration, ring_radius, false)

	DebugDrawCircle(keys.caster.event_horizon_target, Vector(0, 255, 0), 1.0, ring_radius, true, ring_duration)
	DebugDrawCircle(keys.caster.event_horizon_target, Vector(0, 255, 0), 1.0, ring_radius - thickness, true, ring_duration)

	OnIntervalThink( keys )
end

--------------------------------------------------------------------------------

function OnIntervalThink( keys )
	local ring_radius = keys.ability:GetSpecialValueFor( "ring_radius" )
	local thickness = keys.ability:GetSpecialValueFor( "edge_thickness" )

	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.caster.event_horizon_target, nil, ring_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(units) do
		local pos = unit:GetAbsOrigin()
		local displacement = pos - keys.caster.event_horizon_target
		local distance = displacement:Length2D()

		if distance >= ring_radius - thickness and keys.caster.event_horizon_hit_list[unit] == nil then
			keys.ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_veigar_event_horizon", {})
			keys.caster.event_horizon_hit_list[unit] = true
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------