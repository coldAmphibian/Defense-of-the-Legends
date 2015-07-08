kassadin_riftwalk = class({})
LinkLuaModifier( "modifier_kassadin_riftwalk", "heroes/champion_kassadin/modifier_kassadin_riftwalk.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function kassadin_riftwalk:GetIntrinsicModifierName()
	return "modifier_kassadin_riftwalk"
end

--------------------------------------------------------------------------------

function kassadin_riftwalk:GetAOERadius()
	return self:GetSpecialValueFor( "damage_radius" )
end

--------------------------------------------------------------------------------

function kassadin_riftwalk:GetManaCost( level )
	local base_mana_cost = self:GetSpecialValueFor("base_mana_cost")

	if self.modifier ~= nil then
		local current_stacks = self.modifier:GetStackCount()
		local stack_mana_multiplier = self:GetSpecialValueFor("stack_mana_multiplier")

		return base_mana_cost * math.pow(stack_mana_multiplier, current_stacks)
	else
		return base_mana_cost
	end
end

--------------------------------------------------------------------------------

function kassadin_riftwalk:OnSpellStart()
	if IsServer() then
		local base_mana_scaling = self:GetSpecialValueFor("base_mana_scaling")
		local stack_mana_scaling = self:GetSpecialValueFor("stack_mana_scaling")
		local base_damage = self:GetAbilityDamage()
		local stack_damage = self:GetSpecialValueFor("stack_damage")
		local damage_radius = self:GetSpecialValueFor("damage_radius")
		
		local damage_type = self:GetAbilityDamageType()
		local ability_team_filter = self:GetAbilityTargetTeam()
		local ability_type_filter = self:GetAbilityTargetType()
		local ability_flag_filter = self:GetAbilityTargetFlags()
		
		local max_mana = self:GetCaster():GetMaxMana()

		local point = self:GetCursorPosition()
		local casterPos = self:GetCaster():GetAbsOrigin()
		local difference = point - casterPos
		local max_blink_range = self:GetSpecialValueFor("max_blink_range")
		
		local current_stacks = self.modifier:GetStackCount()
		local max_stacks = self:GetSpecialValueFor("max_stacks")
		local stack_duration = self:GetSpecialValueFor("stack_duration")

		if difference:Length2D() > max_blink_range then
			point = casterPos + (point - casterPos):Normalized() * max_blink_range
		end

		FindClearSpaceForUnit(self:GetCaster(), point, false)

		DebugDrawCircle(point, Vector(0, 255, 0), 1.0, damage_radius, true, 3.0)

		--Calculate final damage
		local final_base_damage = base_damage + (max_mana * base_mana_scaling)
		local final_stack_damage = stack_damage + (max_mana * stack_mana_scaling) * current_stacks
		local final_damage = final_base_damage + final_stack_damage

		local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, damage_radius, ability_team_filter, ability_type_filter, ability_flag_filter, FIND_ANY_ORDER, false)

		for _,unit in pairs(units) do
			damage = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = final_damage,
				damage_type = damage_type,
				ability = self,
			}
			ApplyDamage(damage)
		end

		--check if the modifier stack count needs to be increased
		if current_stacks < max_stacks then
			self.modifier:IncrementStackCount()
		else
			self.modifier:SetStackCount( self.modifier:GetStackCount() )
			self.modifier:ForceRefresh()
		end

		self.modifier:SetDuration( stack_duration, true )
		self.modifier:StartIntervalThink( stack_duration )

		self:MarkAbilityButtonDirty()
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------