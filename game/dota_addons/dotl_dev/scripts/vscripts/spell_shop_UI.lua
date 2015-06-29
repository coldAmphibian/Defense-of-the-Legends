if SpellShopUI == nil then
	SpellShopUI = class({})
end

function SpellShopUI:InitGameMode()
	
	_res = 4;
	
	Convars:RegisterCommand( "buySpell", function(name, _ID, abilityName, _cost, _pnt)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerBuySpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Add the spell to the player", 0 )
	
	Convars:RegisterCommand( "sellSpell", function(name, _ID, abilityName, _cost, _pnt)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerSellSpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Remove the spell from the player", 0 )
	
	Convars:RegisterCommand( "upgradeSpell", function(name, _ID, abilityName, _cost, _pnt)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerUpgradeSpell( cmdPlayer, _ID, abilityName, _cost, _pnt)
		end
	end, "Upgrade the spell of the player", 0 )
	
	Convars:RegisterCommand( "buySkillpoint", function(name, _cost)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerBuySkillpoint( cmdPlayer, _cost)
		end
	end, "Upgrade the spell of the player", 0 )
	
	Convars:RegisterCommand( "sellSkillpoint", function(name, _cost)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:PlayerSellSkillpoint( cmdPlayer, _cost)
		end
	end, "Upgrade the spell of the player", 0 )
	
	--[[ test commands, feel free to remove
	Convars:RegisterCommand( "removeSpell", function(name)
		local cmdPlayer = Convars:GetCommandClient()
		if cmdPlayer then 
			return self:RemoveAbilities( cmdPlayer )
		end
	end, "Remove abaddons abilities", 0 )]]
	
end

-- function that takes care of buying the spell
function SpellShopUI:PlayerBuySpell( player, _ID, abilityName, _cost, _pnt )
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	local gold = hero:GetGold()
	
	-- add your code here: ifs, whens, butts..
	if( gold >= tonumber(_cost) ) then
	
		hero:RemoveAbility('invoker_empty1') -- im doing this because i started with 4 'invoker_empty1' abilites to test my module
		hero:AddAbility(abilityName)
		local ability = hero:FindAbilityByName(abilityName)
		ability:SetLevel(1)
		
		_res = _res - _pnt
		
		success = true
		hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)
		
	end
	
	
	-- [IMPORTANT] Send the event when you're finished so the Flash UI properly registers it
	FireGameEvent('spell_shop_ui_spell_buy', { player_ID = pID, _ID = _ID, _success = success } )
	FireGameEvent('spell_shop_ui_update_res', { player_ID = pID, _res = _res } )
end

function SpellShopUI:PlayerUpgradeSpell( player, _ID, abilityName, _cost, _pnt )
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	local gold = hero:GetGold()
	
	-- add your code here: ifs, whens, butts..
	if( gold >= tonumber(_cost) ) then
	
		local ability = hero:FindAbilityByName(abilityName)
		local level = ability:GetLevel()
		ability:SetLevel(level+1)
		
		_res = _res - _pnt
		
		success = true
		hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)	
		
	end

	-- [IMPORTANT] Send the event when you're finished so the Flash UI properly registers it
	FireGameEvent('spell_shop_ui_spell_upgrade', { player_ID = pID, _ID = _ID, _success = success } )
	FireGameEvent('spell_shop_ui_update_res', { player_ID = pID, _res = _res } )
end

-- function that takes care of selling(removing) the spell
function SpellShopUI:PlayerSellSpell( player, _ID, abilityName, _cost, _pnt)
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	
	-- add your code here, ifs, whens, butts..
	ability = hero:FindAbilityByName(abilityName)
	hero:RemoveAbility(abilityName)
	hero:AddAbility('invoker_empty1')
	
	_res = _res + _pnt
	
	-- set the success status
	success = true
	hero:ModifyGold(tonumber(_cost), false, DOTA_ModifyGold_Unspecified)
	
	-- [IMPORTANT] Send the event when you're finished so the Flash UI properly registers it
	FireGameEvent('spell_shop_ui_spell_sell', { player_ID = pID, _ID = _ID, _success = success } )
	FireGameEvent('spell_shop_ui_update_res', { player_ID = pID, _res = _res } )
	
end

function SpellShopUI:PlayerBuySkillpoint( player, _cost)
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	local gold = hero:GetGold()
	
	-- add your code here: ifs, whens, butts..
	if( gold >= tonumber(_cost) ) then	
		success = true
		_res = _res + 1
		hero:SpendGold(tonumber(_cost), DOTA_ModifyGold_Unspecified)	
	end
	
	
	-- [IMPORTANT] Send the event when you're finished so the Flash UI properly registers it
	FireGameEvent('spell_shop_ui_update_res', { player_ID = pID, _res = _res } )
end

function SpellShopUI:PlayerSellSkillpoint( player, _cost)
	local pID = player:GetPlayerID()
	local hero = player:GetAssignedHero()
	local success = false
	
	-- add your code here, ifs, whens, butts..
	success = true
	hero:ModifyGold(tonumber(_cost), false, DOTA_ModifyGold_Unspecified)
	_res = _res - 1
	
	-- [IMPORTANT] Send the event when you're finished so the Flash UI properly registers it
	FireGameEvent('spell_shop_ui_update_res', { player_ID = pID, _res = _res } )
end

--[[ test function, feel free to remove
 function SpellShopUI:RemoveAbilities( player )
	 local hero = player:GetAssignedHero()
	 hero:RemoveAbility('abaddon_aphotic_shield')
	 hero:RemoveAbility('abaddon_borrowed_time')
	 hero:RemoveAbility('abaddon_death_coil')
	 hero:RemoveAbility('abaddon_frostmourne')
	 hero:AddAbility('invoker_empty1')
	 hero:AddAbility('invoker_empty1')
	 hero:AddAbility('invoker_empty1')
	 hero:AddAbility('invoker_empty1')
end]]