self = {}

function OnOwnerDied( keys )
	print("OnOwnerDied")
	if self.in_ghost_form ~= true then
		self.in_ghost_form = true
		keys.caster:SetRespawnPosition(keys.caster:GetAbsOrigin())
		keys.caster:SetTimeUntilRespawn(0)
	end
end

function OnOwnerSpawned( keys )
	print("OnOwnerSpawned")
	if self.in_ghost_form == true then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_karthus_death_defied_ghost_form", {})
	end
end

function OnCreated( keys )
	print("OnCreated")
end

function OnDestroy( keys )
	print("OnDestroy")

	local caster_gold = keys.caster:GetGold()
	keys.caster:Kill(keys.caster, nil)
	keys.caster:SetGold(caster_gold, false)
	self.in_ghost_form = false
end

function OnAbilityExecuted( keys )
	print("OnAbilityExecuted")
end