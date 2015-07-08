self = {}

function OnOwnerSpawned( keys )
	print("OnOwnerSpawned")
end

function OnOwnerDied( keys )
	print("OnOwnerDied")

	-- if self.ghost_form == true then
	-- 	--Forced death, left ghost form
	-- 	print("exiting ghost form")

	-- 	self.ghost_form = false
	-- else
	-- 	--Natural death, enter ghost form
	-- 	print("entering ghost form")
		
	-- 	self.ghost_form = true

	-- 	local ghost_duration = keys.ability:GetSpecialValueFor("ghost_duration")
	-- 	local respawn_time = keys.caster:GetRespawnTime()
	-- 	local position = keys.caster:GetAbsOrigin()

	-- 	keys.caster:SetTimeUntilRespawn(respawn_time + ghost_duration)
	-- 	keys.caster:RespawnHero(false, true, true)
	-- 	keys.caster:SetAbsOrigin(position)
	-- 	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_karthus_death_defied", {})
	-- end
end

function OnCreated( keys )
	print("OnCreated")
end

function OnDestroy( keys )
	print("OnDestroy")

	--keys.caster:ForceKill(true)
end

function OnAbilityExecuted( keys )
	print("OnAbilityExecuted")
end