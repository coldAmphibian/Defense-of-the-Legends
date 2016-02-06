function GravityFieldThink( event )
	caster = event.caster
	ability = event.ability
	target = event.target

	if target:HasModifier("modifier_viktor_gravity_field_stunned") == false then
		if target:HasModifier("modifier_viktor_gravity_field_stack") == false then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_viktor_gravity_field_stack", nil)
		else
			if target:GetModifierStackCount("modifier_viktor_gravity_field_stack", caster) == 0 then
				target:SetModifierStackCount("modifier_viktor_gravity_field_stack", caster, 2)
			elseif target:GetModifierStackCount("modifier_viktor_gravity_field_stack", caster) == 2 then
				ability:ApplyDataDrivenModifier(caster, target, "modifier_viktor_gravity_field_stun", nil)
				ability:ApplyDataDrivenModifier(caster, target, "modifier_viktor_gravity_field_stunned", nil)
				target:RemoveModifierByName("modifier_viktor_gravity_field_stack")
			end
		end
	end
end