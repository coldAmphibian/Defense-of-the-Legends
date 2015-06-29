function ManaBarrierCheck( event )
	local caster = event.caster
	local ability = event.ability
	local casterHP = caster:GetHealth()
	local casterMaxHP= caster:GetMaxHealth()
	local casterMana = caster:GetMana()
	local casterHPdivMax = casterHP / casterMaxHP

	local barrierAmount = 0.5 * casterMana

	if casterHPdivMax <= 0.20 and ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_mana_barrier", nil)
		ability:StartCooldown(90.0) --Because I couldnt figure out how to let it go on cooldown on its own.
	end
end

function ManaBarrier( event )
	local caster = event.caster
	local ability = event.ability
	local casterHP = caster:GetHealth()
	local casterMaxHP= caster:GetMaxHealth()
	local casterMana = caster:GetMana()
	local casterHPdivMax = casterHP / casterMaxHP

	local barrierAmount = 0.5 * casterMana

	caster:Heal(barrierAmount, caster)

end


