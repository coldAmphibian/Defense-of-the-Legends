modifier_kassadin_riftwalk = class({})

--------------------------------------------------------------------------------

function modifier_kassadin_riftwalk:IsHidden()
	return ( self:GetStackCount() == 0 )
end

--------------------------------------------------------------------------------

function modifier_kassadin_riftwalk:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_kassadin_riftwalk:OnCreated( kv )
	self:GetAbility().modifier = self
end

--------------------------------------------------------------------------------

function modifier_kassadin_riftwalk:OnIntervalThink()
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:SetStackCount( 0 )
		self:GetAbility():MarkAbilityButtonDirty()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------