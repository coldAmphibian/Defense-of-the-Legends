--[[========================
	LoL's Ezreal Dota port
	Author: wFX
	Date: 03/2015
==========================]]
function ezreal_rising_spell_force_on_spell_hit(event)
	local caster = event.caster
	local innate = caster:FindAbilityByName("ezreal_rising_spell_force")
	if innate ~= nil then
		local current_stack = caster:GetModifierStackCount("modifier_rising_spell_force", nil)	
		caster:RemoveModifierByName("modifier_rising_spell_force")
		innate:ApplyDataDrivenModifier(caster, caster, "modifier_rising_spell_force", {duration = 6})
		local max_stack = innate:GetSpecialValueFor("max_stacks")
		if current_stack >= max_stack then
			caster:SetModifierStackCount("modifier_rising_spell_force", innate, max_stack)
		else
			current_stack = current_stack + 1
			caster:SetModifierStackCount("modifier_rising_spell_force", innate, current_stack)
		end

	end
end