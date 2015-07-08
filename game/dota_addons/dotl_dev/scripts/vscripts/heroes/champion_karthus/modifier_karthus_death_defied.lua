modifier_karthus_death_defied = class({})

function modifier_karthus_death_defied:OnDestroy()
	print("OnDestroy")

	self:GetParent():Kill(nil, nil)
end