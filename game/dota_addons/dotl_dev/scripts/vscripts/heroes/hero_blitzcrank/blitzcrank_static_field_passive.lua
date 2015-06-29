--function for picking a random value from a table (not sure if there is a better way to do this)
function table.randFrom( t )
    local choice = "none"
    local n = 0
    for i, o in pairs(t) do
        n = n + 1
        if math.random() < (1/n) then
            choice = o      
        end
    end
    return choice 
end

function BlitzcrankStaticFieldPassive(event)

	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetAbilityDamage() 

	--Look for units in given range (range is set here since its always the same)
	local unitsNearCaster = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 328.5, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	--Pick a random unit/hero in from the table
	local randUnit = table.randFrom(unitsNearCaster)

	--If a random unit exists then create particle and damage that unit.
	if randUnit ~= "none" then
		local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, caster)
	    local loc = randUnit:GetAbsOrigin()
	    ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
	    ParticleManager:SetParticleControl(lightning, 1, loc)
	    ParticleManager:SetParticleControl(lightning, 2, loc)
	    EmitSoundOn("Hero_Leshrac.Lightning_Storm", randUnit)

		local damageTable = {
		victim = randUnit,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}

		ApplyDamage(damageTable)
	end
end

--Check if Static field is on cooldown, if its not then apply the passive modifier. As of writing this code there is no CheckAbilityCooldown function.
function BlitzcrankStaticFieldPassiveApply(event)

	local caster = event.caster
	local ability = caster:FindAbilityByName("blitzcrank_static_field")
	local abilityPassive = caster:FindAbilityByName("blitzcrank_static_field_passive") 

	if ability:IsCooldownReady() == true and caster:HasModifier("modifier_blitzcrank_static_field_passive") == false then
		abilityPassive:ApplyDataDrivenModifier(caster, caster, "modifier_blitzcrank_static_field_passive", nil)
	end
end