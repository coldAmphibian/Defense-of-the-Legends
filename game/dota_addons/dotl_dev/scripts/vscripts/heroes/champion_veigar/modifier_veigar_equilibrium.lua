modifier_veigar_equilibrium = class({})

function modifier_veigar_equilibrium:OnCreated(keys)
	self.missing_mana_pct = keys.missing_mana_pct
	self.mana_regen_pct = keys.mana_regen_pct
end

function modifier_veigar_equilibrium:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
	}
	return func
end

function modifier_veigar_equilibrium:GetModifierPercentageManaRegen()
	local current_missing_pct = 100 - self:GetParent():GetManaPercent()
	local regen = current_missing_pct * self.missing_mana_pct * self.mana_regen_pct
	return regen
end