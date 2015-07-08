modifier_champion = class({})

function modifier_champion:IsHidden()
	return true
end

function modifier_champion:GetAttributes()
	local attr = {
		MODIFIER_ATTRIBUTE_PERMANENT,
	}
	return attr
end

function modifier_champion:DeclareFunctions()
	local func = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return func
end

function modifier_champion:GetModifierHealthBonus()
	return self:GetParent():GetHealthGain() * (self:GetParent():GetLevel() - 1)
end

function modifier_champion:GetModifierConstantHealthRegen()
	return self:GetParent():GetHealthRegenGain() * (self:GetParent():GetLevel() - 1)
end

function modifier_champion:GetModifierManaBonus()
	return self:GetParent():GetManaGain() * (self:GetParent():GetLevel() - 1)
end
function modifier_champion:GetModifierConstantManaRegen()
	return self:GetParent():GetManaRegenGain() * (self:GetParent():GetLevel() - 1)
end