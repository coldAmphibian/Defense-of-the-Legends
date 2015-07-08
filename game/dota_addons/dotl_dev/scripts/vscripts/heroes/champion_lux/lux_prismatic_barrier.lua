lux_prismatic_barrier = class({})
LinkLuaModifier("modifier_lux_prismatic_barrier", "heroes/champion_lux/modifier_lux_prismatic_barrier", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function lux_prismatic_barrier:OnSpellStart()
    self.ap_scaling = self:GetSpecialValueFor("ap_scaling")
    self.projectile_radius = self:GetSpecialValueFor("projectile_radius")
    self.projectile_distance = self:GetSpecialValueFor("projectile_distance")
    self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
    self.base_shield_strength = self:GetSpecialValueFor("base_shield_strength")
    self.shield_duration = self:GetSpecialValueFor("shield_duration")

    local caster_ap = self:GetCaster():GetAbilityPower()
    self.shield_strength = (caster_ap * self.ap_scaling) + self.base_shield_strength

    self.returning = false

    -- --I want to make this unique, so that more than one projectile can be out on the field at the same time
    local vDirection = self:GetCursorPosition() - self:GetOrigin()
    vDirection = vDirection:Normalized()

    local info = {
        --EffectName = "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
        Source = self:GetCaster(),
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetOrigin(), 
        fStartRadius = self.projectile_radius,
        fEndRadius = self.projectile_radius,
        vVelocity = vDirection * self.projectile_speed,
        fDistance =  self.projectile_distance,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO,
    }
    self.nProjID = ProjectileManager:CreateLinearProjectile( info )
end

--------------------------------------------------------------------------------

function lux_prismatic_barrier:OnProjectileThink(vLocation)
    if IsServer() then
        DebugDrawCircle(vLocation, Vector(0, 255, 0), 1.0, self.projectile_radius, true, 0.03)

        if self.returning then
            local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), vLocation, nil, self.projectile_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

            for _,hero in pairs(allies) do
                if self.hitList[hero] == nil and hero ~= self:GetCaster() then
                    self:OnProjectileHit(hero, vLocation)
                    self.hitList[hero] = true
                end
            end
        end
    end
end

--------------------------------------------------------------------------------

function lux_prismatic_barrier:OnProjectileHit(hTarget, vLocation)
    if IsServer() then
         if hTarget ~= nil then
            local kv = {
                duration = 10,
                shield_strength = self.shield_strength,
            }
            hTarget:AddNewModifier(self:GetCaster(), self, "modifier_lux_prismatic_barrier", kv)

            if self.returning then
                UTIL_Remove(self.returnCaster)
            end
        elseif self:GetCaster():IsAlive() then
            self.returning = true
            self.returnCaster = CreateModifierThinker(self:GetCaster(), self, "modifier_root", {}, vLocation, self:GetCaster():GetTeamNumber(), false)
            self.hitList = {}

            local projTable = {
                Target = self:GetCaster(),
                Source = returnCaster,
                Ability = self,  
                --EffectName = "particles/econ/generic/generic_projectile_tracking_1/generic_projectile_tracking_1.vpcf",
                --EffectName = "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_base_attack.vpcf",
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                vSourceLoc = vLocation,
                iMoveSpeed = self.projectile_speed,
                bProvidesVision = false,
                bDrawsOnMinimap = false,
                bDodgeable = false,
                bVisibleToEnemies = true,
                bReplaceExisting = false
            }
            ProjectileManager:CreateTrackingProjectile( projTable )
        end
    end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
