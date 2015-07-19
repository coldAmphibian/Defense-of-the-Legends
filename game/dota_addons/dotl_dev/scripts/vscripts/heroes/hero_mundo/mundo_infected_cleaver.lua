--[[========================
    LoL's Mundo Dota port
    Author: TheAlpacalypse
    Date: 06/2015
==========================]]
function mundo_infected_cleaver_check_health(event)
    local caster = event.caster
    if caster:GetCurrentHealth() >= GetManaCost() then
        caster:SetHealth(caster:GetCurrentHealth() - GetManaCost())
        mundo_infected_cleaver_on_spell_start()
    end
end

function mundo_infected_cleaver_on_spell_start()
    local caster = event.caster
    local info =
    {
        Ability = event.ability,
        EffectName = event.effect_name,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = event.range,
        fStartRadius = event.radius,
        fEndRadius = event.radius,
        Source = caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        vVelocity = (event.target_points[1] - caster:GetAbsOrigin()):Normalized() * event.projectile_speed,
        bProvidesVision = false,
        iVisionRadius = event.vision_radius,
        iVisionTeamNumber = caster:GetTeamNumber()
    }
    local projectile = ProjectileManageer:CreateLinearProjectile(info)
end

function mundo_infected_cleaver_on_hit(event)
    local ability = event.ability
    if ability ~= nil then
        local caster = event.caster
        local target = event.target
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = ability:GetAbilityDamage(),
            damage_type = ability:GetAbilityDamageType()
        }
        ApplyDamage(damageTable)
    if event.target:IsAlive() then
        caster:SetHealth(caster:GetCurrentHealth() + (GetManaCost() / 2))
    else
        caster:SetHealth(caster:GetCurrentHealth() + GetManaCost())
    end
end
