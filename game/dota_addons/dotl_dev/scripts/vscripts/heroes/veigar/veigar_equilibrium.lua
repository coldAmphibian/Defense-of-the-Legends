function OnUpgrade( keys )
	LinkLuaModifier("modifier_veigar_equilibrium", "heroes/veigar/modifier_veigar_equilibrium.lua", LUA_MODIFIER_MOTION_NONE)

	local kv = {
		missing_mana_pct = keys.ability:GetSpecialValueFor("missing_mana_pct"),
		mana_regen_pct = keys.ability:GetSpecialValueFor("mana_regen_pct"),
	}
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_veigar_equilibrium", kv)
end