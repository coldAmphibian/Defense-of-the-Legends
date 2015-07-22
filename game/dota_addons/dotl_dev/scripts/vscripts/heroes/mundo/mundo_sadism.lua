--[[========================
    LoL's Mundo Dota port
    Author: TheAlpacalypse
    Date: 06/2015
==========================]]
function mundo_sadism_health_cost(event)
    local caster = event.caster
    local newHealth = (caster:GetCurrentHealth() - (caster:GetCurrentHealth()*0.2)
    caster:SetHealth(newHealth)
    mundo_sadism_on_spell_start()
end
