--[[
Name: Sona Power Chord Lua
Author: Zarthbenn
Date: 07/2015
--]]
function PowerChord( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability

	--Check to see if sona has power chord

	if caster:HasModifier("modifier_sona_power_chord") == true then

		if caster:GetModifierStackCount("modifier_sona_power_chord", caster) == 0 then

			caster:SetModifierStackCount("modifier_sona_power_chord", caster, 2)

		elseif caster:GetModifierStackCount("modifier_sona_power_chord", caster) == 2 then

			caster:SetModifierStackCount("modifier_sona_power_chord", caster, 3)

			--When at 3 stacks apply appropriate buff.
			--Remove previous power chord modifiers.
			if ability:GetAbilityName() == "sona_hymn_of_valor" then

				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_valor_power_chord", nil)

			elseif ability:GetAbilityName() == "sona_aria_of_perseverance" then

				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_perseverance_power_chord", nil)

			elseif ability:GetAbilityName() == "sona_song_of_celerity" then
				
				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_celerity_power_chord", nil)

			else
				print("Error")
			end
		
		elseif caster:GetModifierStackCount("modifier_sona_power_chord", caster) == 3 then

			if ability:GetAbilityName() == "sona_hymn_of_valor" then

				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_valor_power_chord", nil)

			elseif ability:GetAbilityName() == "sona_aria_of_perseverance" then

				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_perseverance_power_chord", nil)

			elseif ability:GetAbilityName() == "sona_song_of_celerity" then
				
				caster:RemoveModifierByName("modifier_sona_valor_power_chord")
				caster:RemoveModifierByName("modifier_sona_perseverance_power_chord")
				caster:RemoveModifierByName("modifier_sona_celerity_power_chord")

				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_celerity_power_chord", nil)
			else
				print("Error")
			end
		end
	else
		--If not then apply it
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_sona_power_chord", nil)
	end
end