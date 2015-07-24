local self = {}

--------------------------------------------------------------------------------

function OnCreated( keys )
	self.start_time = GameRules:GetGameTime()
	self.singularity_radius = keys.ability:GetSpecialValueFor( "singularity_radius" )
	self.singularity_damage = keys.ability:GetSpecialValueFor( "singularity_damage" )
	self.singularity_duration = keys.ability:GetSpecialValueFor( "singularity_duration" )
	self.vision_radius = keys.ability:GetSpecialValueFor("vision_radius")
	self.last_vision_time = self.start_time

	AddFOWViewer(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), self.vision_radius, 0.7, false)
end

--------------------------------------------------------------------------------

function OnIntervalThink( keys )
	local current_time = GameRules:GetGameTime()
	if current_time - self.last_vision_time >= 0.5 then
		AddFOWViewer(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), self.vision_radius, 0.7, false)

		self.last_vision_time = current_time
	end

	if current_time - self.start_time >= self.singularity_duration or self.detonate_singularity == true then
		keys.target:RemoveModifierByName("modifier_lux_lucent_singularity_thinker")
		UTIL_Remove(keys.target)

		self.detonate_singularity = false
	end
end

--------------------------------------------------------------------------------

function OnDestroy( keys )
	self.ap_scaling = keys.ability:GetSpecialValueFor( "ap_scaling" )

	local enemies = FindUnitsInRadius(keys.caster:GetTeamNumber(), keys.target:GetAbsOrigin(), keys.target, self.singularity_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	if #enemies > 0 then

		--Incase the hero casting doesn't have ap defined for it
		local caster_ap = keys.caster:GetAbilityPower()
		local final_damage = (caster_ap * self.ap_scaling) + self.singularity_damage

		for _,enemy in pairs(enemies) do
			if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then
				local damage = {
					victim = enemy,
					attacker = keys.caster,
					damage = final_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = keys.ability,
				}

				ApplyDamage( damage )

				keys.caster:FindAbilityByName( "lux_illumination" ):ApplyDataDrivenModifier(keys.caster, enemy, "modifier_lux_illumination", {})
			end
		end
	end

	keys.caster:SwapAbilities("lux_lucent_singularity_detonate", "lux_lucent_singularity", false, true)
end

--------------------------------------------------------------------------------


function DetonateSingularity( keys )
	self.detonate_singularity = true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------