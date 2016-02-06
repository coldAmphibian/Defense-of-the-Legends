function PointOne ( keys )
	local caster = keys.caster
	local target_point = keys.target_points[1]
	
	local lucent_singularity_aura = keys.modifier
	caster.laserPoint1 = target_point
end

function LaserMove( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local target_point = keys.target_points[1]
	local target_location = target_point

	local speed = 3500 * 0.03

	local unit_location = caster.lucent_singularity_unit:GetAbsOrigin()
	local distance = (target_location - unit_location):Length2D()

	local direction = (unit_location - target_location):Normalized()

	Timers:CreateTimer(0, function()
			unit_location = target_location + (unit_location - target_location):Normalized() * (distance - speed)
			caster.lucent_singularity_unit:SetAbsOrigin(unit_location)

			distance = (unit_location - target_location):Length2D()

			if distance > 100 then
				return 0.03
			else
				-- Finished dragging the target
				FindClearSpaceForUnit(target, target_location, false)
				-- This is to fix a visual bug when the target is very close to the caster
				
			end

			end)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_viktor_death_ray_remove", nil)
	
end

function SwapAbilities( keys )
	local caster = keys.caster
	local current_ability = keys.current_ability
	local new_ability = keys.new_ability

	-- Swap sub_ability
	caster:SwapAbilities(current_ability, new_ability, false, true)
	--print("Swapped "..main_ability_name.." with " ..sub_ability_name)
end

function RemoveLaser( event )
	caster = event.caster
	caster.lucent_singularity_unit:RemoveSelf()
end	

function MakeLaser( event )
	local caster = event.caster
	local ability = event.ability

	local target_point = caster.laserPoint1

	caster.lucent_singularity_unit = CreateUnitByName("npc_dummy_blank", target_point, false, caster, caster, caster:GetTeam())
	ability:ApplyDataDrivenModifier(caster, caster.lucent_singularity_unit, "modifier_lucent_singularity_unit", {})
end

function Damage( event )
	caster = event.caster
	target = event.target
	ability = event.ability
	damage = ability:GetAbilityDamage()

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
end