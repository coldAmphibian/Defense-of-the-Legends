function Flash( event )
	local caster = event.caster
	local ability = event.ability
	local range =  ability:GetSpecialValueFor('range')

 	ProjectileManager:ProjectileDodge(caster)
	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	local origin_point = caster:GetAbsOrigin()
	local target_point = event.target_points[1]
	local difference_vector = target_point - origin_point
			
	if difference_vector:Length2D() > range then
		target_point = origin_point + (target_point - origin_point):Normalized() * range
	end

	caster:SetAbsOrigin(target_point)
	FindClearSpaceForUnit(caster, target_point, false)

 	local pBlink = ParticleManager:CreateParticle("particles/heroes/ezreal/arcane_shift.vpcf", PATTACH_ABSORIGIN, caster)
 	ParticleManager:SetParticleControl(pBlink, 1, target_point)
 	caster:Stop()
end

function Recall( event )
	local caster = event.caster
	local fountain_pos = Vector(-2125, -2025, 75)
	caster:SetAbsOrigin(fountain_pos)
	FindClearSpaceForUnit(caster, fountain_pos, false)
	caster:Stop()
end

function Recall_Damage( event )
	event.caster:Stop()
end