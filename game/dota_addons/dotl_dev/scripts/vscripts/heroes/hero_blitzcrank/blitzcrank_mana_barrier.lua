function ManaBarrierCheck( event )
	local caster = event.caster
	local ability = event.ability
	local casterHP = caster:GetHealth()
	local casterMaxHP= caster:GetMaxHealth()
	local casterMana = caster:GetMana()
	local casterHPdivMax = casterHP / casterMaxHP

	local barrierAmount = 0.5 * casterMana

	if casterHPdivMax <= 0.20 and ability:IsCooldownReady() then
		
		caster.AphoticShieldRemaining = barrierAmount
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mana_barrier", nil)
		ability:StartCooldown(90.0) --Because I couldnt figure out how to let it go on cooldown on its own.
	end
end

function ManaShieldAbsorb( event )
	-- Variables
	local damage = event.DamageTaken
	local unit = event.unit
	local ability = event.ability
	
	-- Track how much damage was already absorbed by the shield
	local shield_remaining = unit.AphoticShieldRemaining


	-- Check if the unit has the borrowed time modifier
	if not unit:HasModifier("modifier_borrowed_time") then
		-- If the damage is bigger than what the shield can absorb, heal a portion
		if damage > shield_remaining then
			local newHealth = unit.OldHealth - damage + shield_remaining
			print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..shield_remaining)
			unit:SetHealth(newHealth)
		else
			local newHealth = unit.OldHealth			
			unit:SetHealth(newHealth)
			print("Old Health: "..unit.OldHealth.." - New Health: "..newHealth.." - Absorbed: "..damage)
		end

		-- Reduce the shield remaining and remove
		unit.AphoticShieldRemaining = unit.AphoticShieldRemaining-damage
		if unit.AphoticShieldRemaining <= 0 then
			unit.AphoticShieldRemaining = nil
			unit:RemoveModifierByName("modifier_mana_barrier")
			print("--Shield removed--")
		end

		if unit.AphoticShieldRemaining then
			print("Shield Remaining after Absorb: "..unit.AphoticShieldRemaining)
			print("---------------")
		end
	end

end

-- Keeps track of the targets health
function ManaShieldHealth( event )
	local target = event.target

	target.OldHealth = target:GetHealth()
end