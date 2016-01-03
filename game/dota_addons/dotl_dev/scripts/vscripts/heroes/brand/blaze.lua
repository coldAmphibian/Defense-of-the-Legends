function OnIntervalThink( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local tick_damage = (target:GetMaxHealth() * 0.08)/ability:GetSpecialValueFor('buff_duration')

	-- print('Max health: ' .. target:GetMaxHealth())
	-- print('Full damage: ' .. target:GetMaxHealth()*0.08)
	-- print('Tick damage: ' .. target:GetMaxHealth()*0.08/4)
	-- print('Current Unit Health:' .. target:GetHealth())
	
	if not target:IsHero() and tick_damage > 80 then
		tick_damage = 80
	end

	local damageTable = {
		attacker = caster,
		victim = target,
		damage = tick_damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability
	}

	ApplyDamage(damageTable)
end