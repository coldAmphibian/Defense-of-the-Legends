self = {}

--------------------------------------------------------------------------------

function OnCreated( keys )
	self.target = keys.target:GetAbsOrigin()
	self.ring_radius = keys.ability:GetSpecialValueFor( "ring_radius" )
	self.ring_duration = keys.ability:GetSpecialValueFor( "ring_duration" )
	self.stun_duration = keys.ability:GetSpecialValueFor( "stun_duration" )
	self.thickness = keys.ability:GetSpecialValueFor( "edge_thickness" )
	self.thickness = 50
	self.hitList = {}

	AddFOWViewer(keys.caster:GetTeamNumber(), self.target, self.ring_duration, self.ring_radius, false)

	DebugDrawCircle(self.target, Vector(0, 255, 0), 1.0, self.ring_radius, true, self.ring_duration)
	DebugDrawCircle(self.target, Vector(0, 255, 0), 1.0, self.ring_radius - self.thickness, true, self.ring_duration)

	OnIntervalThink( keys )
end

--------------------------------------------------------------------------------

function OnIntervalThink( keys )
	local units = FindUnitsInRadius(keys.caster:GetTeamNumber(), self.target, nil, self.ring_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(units) do
		local pos = unit:GetAbsOrigin()
		local displacement = pos - self.target
		local distance = displacement:Length2D()

		if distance >= self.ring_radius - self.thickness and self.hitList[unit] == nil then
			keys.ability:ApplyDataDrivenModifier(keys.caster, unit, "modifier_veigar_event_horizon", {})
			self.hitList[unit] = true
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------