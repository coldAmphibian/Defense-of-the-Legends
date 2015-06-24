function LeonaSunlight( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local casterLevel = caster:GetLevel()

	--As far as I could find there is no documentaion on what the damage amount per level is on leonas passive. All I could find was the damage.
	--Here I assume it starts at 20 and goes up every 2 levels finishing at 17
	print(caster)


	if casterLevel == 1 or casterLevel == 2 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 20,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 3 or casterLevel == 4 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 35,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 5 or casterLevel == 6 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 50,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 7 or casterLevel == 8 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 65,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 9 or casterLevel == 10 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 80,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 11 or casterLevel == 12 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 95,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 13 or casterLevel == 14 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 110,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 15 or casterLevel == 16 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 125,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel == 17 or casterLevel == 18 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 140,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)
	elseif casterLevel > 18 then
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = 200,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		ApplyDamage(damageTable)

	end
end


