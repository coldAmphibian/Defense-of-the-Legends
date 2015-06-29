-- Used to keep track of projectiles after creation
ProjectileHolder = {} 

--This function will create the 7 projectiles to volly, in a 57.5 degree cone
function volly(args)
	local caster = args.caster
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = args.ability,
        EffectName = args.EffectName,
        iMoveSpeed = args.MoveSpeed,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = args.FixedDistance,
        fStartRadius = args.StartRadius,
        fEndRadius = args.EndRadius,
        Source = args.caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		bDeleteOnHit = true,
		vVelocity = 0.0,
	}
	--Creates the 7 projectiles in the 57.5 degree cone
	for i=-27.5,27.5,(27.5/3) do
		info.vVelocity = RotatePosition(Vector(0,0,0), QAngle(0,i,0), caster:GetForwardVector()) * args.MoveSpeed
		projectile = ProjectileManager:CreateLinearProjectile(info)
	end
end
--This Function determines the effects when a volly projectile hits a hero
function vollyHit(args)
	local modiferName = "modifier_item_orb_of_venom_slow"
	local target = args.target
	local caster = args.caster
	local totalDamage = caster:GetAverageTrueAttackDamage() + args.BonusDamage 
	
	--A Unit can only get his once per spell cast, so this checks if they have been hit by another projectile from most recent cast
	if target:GetContext("VollyHitCheck") ~= nil and target:GetContext("VollyHitCheck") == 1 then
	--Do nothing, condition for not doing damage
	else
		--A damage table is needed to be passed to the global function ApplyDamage
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = totalDamage,
			damage_type = DAMAGE_TYPE_PHYSICAL,}
			--PrintTable(damageTable)
		ApplyDamage(damageTable)	
	end
	
	--The Slow amount is based on the level of the spell "Frost Shot", so this bit will get the level and calculate the slow from that
	local frostArrow = caster:FindAbilityByName("ashe_frost_shot")
	if frostArrow ~= nil then
		frostArrowLevel = frostArrow:GetLevel()
	end
	local slowAmount = 0
	if (frostArrowLevel ~= nil) then
		slowAmount = -(10 + (frostArrowLevel * 5))
	end
	
	--The properties of a modifier to be added must be in a modifier table
	local ModifierTable = 
	{
		duration = 2,
		slow = slowAmount
	}
	target:AddNewModifier(caster,args.ability,modiferName,ModifierTable)
	
	--Sets the flag the a unit has been recently hit, and creates a thinker to change it after a 1.5 seconds
	target:SetContextNum("VollyHitCheck",1,1.0)
	--target:SetContextThink("Volly Thinker",function() return VollyThinker(target,1), 1.5)
	Timers:CreateTimer(1.5, function() return VollyThinker(target,1) end)
end
--This Function acts as thinker that will change the flag for being recently hit by volly to false
function VollyThinker(target,runCount)
	target:SetContextNum("VollyHitCheck",0,0)
return nil
end

function hawkshot(args)
	local caster = args.caster
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = args.ability,
        EffectName = args.EffectName,
        iMoveSpeed = 1,
        vSpawnOrigin = args.target_points,
        fDistance = 99999,
        fStartRadius = 1000,
        fEndRadius = 1000,
        Source = args.caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
		bProvidesVision = true,
		fVisionRadius = 1000,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_NONE,
        fExpireTime = GameRules:GetGameTime() + 5.0,
		bDeleteOnHit = false,
	}
	--PrintTable(info)
	projectile = ProjectileManager:CreateLinearProjectile(info)
end

function hawkshotVision(args)
	--PrintTable(args)
	hawk = CreateUnitByName("flying_dummy_unit", args.target_points[1], false, args.caster, args.caster, args.caster:GetTeamNumber())
	--print (hawk)
	local dummy = hawk:FindAbilityByName("flying_dummy_unit_passive")
	dummy:SetLevel(1)
	Timers:CreateTimer(5, function() return unitKiller(hawk) end)
end

function unitKiller(unit)
unit:RemoveSelf()
return nil
end

function levelSpell(args)
	local spell = args.Spell
	local caster = args.caster
	local spellHandle = caster:FindAbilityByName(spell)
	spellHandle:SetLevel(1)
end

function crystal_arrow_start(args)
	local caster = args.caster
	--A Liner Projectile must have a table with projectile info
	local info = 
	{
		Ability = args.ability,
        EffectName = args.EffectName,
        iMoveSpeed = 1800,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = 99999,
        fStartRadius = 64,
        fEndRadius = 64,
        Source = args.caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO,
        fExpireTime = GameRules:GetGameTime() + 10.0,
		vVelocity = caster:GetForwardVector() * 1800,
		bProvidesVision = true,
		iVisionRadius = 1000,
		iVisionTeamNumber = 2,
		bDeleteOnHit = false,
	}
	--PrintTable(info)
	local projectileID = ProjectileManager:CreateLinearProjectile(info)
	addToProjectileHolder(info, projectileID)
	--print (projectile)
end

function crystal_arrow_hit(args)
	local caster = args.caster
	local modiferName = "modifier_stunned"
	local distance = 0
	local projectileID = 0
	--print (args.target_points[1])
	projectileID,distance = findClosestInProjectileHolder(args.target_points[1])
	ProjectileManager:DestroyLinearProjectile(projectileID)
	local stunTime = 1
	if distance < 2800 then
		stunTime = 1 + 2.5 * (distance/2800)
	else
		stunTime = 3.5
	end
	local ModifierTable = 
	{
		duration = stunTime
	}
	args.target:AddNewModifier(caster,args.ability,modiferName,ModifierTable)
	local damage = args.Damage
	--A damage table is needed to be passed to the global function ApplyDamage
	local damageTable = {
		victim = args.target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,}
	ApplyDamage(damageTable)
	
	--Create A dummy unit to give sight after the projectile hits
	hawk = CreateUnitByName("flying_dummy_unit", args.target_points[1], false, args.caster, args.caster, args.caster:GetTeamNumber())
	--print (hawk)
	local dummy = hawk:FindAbilityByName("flying_dummy_unit_passive")
	dummy:SetLevel(1) --Makes unit invisible and unselectiable 
	hawk:SetDayTimeVisionRange(500)
	hawk:SetNightTimeVisionRange(500)
	Timers:CreateTimer(3, function() return unitKiller(hawk) end) --Makes it so the dummy unit is killed after a few seconds
end

function addToProjectileHolder(infoTable, projectileID)
	local projectileEntry =
	{
		projectileID = projectileID,
		creationTime = GameRules:GetGameTime(),
		SpawnOrigin = infoTable.vSpawnOrigin,
		VelocityVector = infoTable.vVelocity
	}
	table.insert(ProjectileHolder, projectileEntry)
	Timers:CreateTimer(30, function() return projectileHolderCleaner() end)
end

function projectileHolderCleaner()
	table.remove(ProjectileHolder,1)
end

function findClosestInProjectileHolder(locationVector)
	local currentTime = GameRules:GetGameTime() 
	local BestProjectile = 1
	local BestDistanceDiff = 999999 -- Basically just a large number to start with
	for listCount = 1, #ProjectileHolder do
		projectile = ProjectileHolder[listCount]
		projectileLocation = projectile.SpawnOrigin + ( projectile.VelocityVector * ( currentTime - projectile.creationTime))
		DistanceDiff = (projectileLocation - locationVector):Length2D()
		if DistanceDiff < BestDistanceDiff then 
			BestProjectile = listCount
			BestDistanceDiff = DistanceDiff
		end
	end
	local projectile = ProjectileHolder[BestProjectile]
	local travilDistanceVector = projectile.VelocityVector * ( currentTime - projectile.creationTime)
	--local travilDistanceFloat = math.sqrt((travilDistanceVector.x * travilDistanceVector.x) + (travilDistanceVector.y * travilDistanceVector.y))
	local travilDistanceFloat = travilDistanceVector:Length2D()
	local projectileReturnID = projectile.projectileID
	projectileLocation = projectile.SpawnOrigin + ( projectile.VelocityVector * ( currentTime - projectile.creationTime))
	--print (projectileLocation)
	--PrintTable(ProjectileHolder)
	return projectileReturnID, travilDistanceFloat
end

function FocusThinkerStarter(args)
	--print("FocusThinkerStarter")
	local caster = args.caster
	caster:SetContextNum("lastAttack",GameRules:GetGameTime(),0)
	FocusThinker(caster)
end

function FocusThinker(caster)
	local lastAttack = caster:GetContext("lastAttack")
	local focusStacks = caster:GetContext("focusStacks")
	if lastAttack == nil then
		lastAttack = 0
	end
	if focusStacks == nil then
		focusStacks = 0
	end
	
	local currentTime = GameRules:GetGameTime()
	
	--Determines how many stack counters will be added to focus
	local heroLevel = caster:GetLevel()
	local newStacks = 4
	if heroLevel ~= nil then
		newStacks = 4 + math.floor((caster:GetLevel() - 1) / 4)
		if newStacks > 8 then
			newStacks = 8
		end
	end
	
	
	
	if currentTime - lastAttack >= 2.99 then
		focusStacks = focusStacks + newStacks
	end
	
	--Level check in if is done to fix a UI error, by constantly levelling the spell it causes some shine effect
	local spell = caster:FindAbilityByName("ashe_focus_crit")
	if focusStacks >= 100 and spell:GetLevel() ~= 1 then 
		local spell = caster:FindAbilityByName("ashe_focus_crit")
		spell:SetLevel(1)
	end
	caster:SetContextNum("focusStacks",focusStacks,0)
	--print (focusStacks)
	Timers:CreateTimer(1, function() return FocusThinker(caster) end)
end

function ashe_attack_hit(args)
	--print ("I have Attacked")
	local caster = args.caster
	caster:SetContextNum("lastAttack",GameRules:GetGameTime(),0)
	local spell = caster:FindAbilityByName("ashe_focus_crit")
	critState = caster:GetContext("critStateAtStartOfAttack")
	if critState == 1 then
		--print (caster:HasModifier("modifier_juggernaut_blade_dance"))
		spell:SetLevel(0)
		caster:SetContextNum("focusStacks",0,0)
		caster:SetContextNum("critStateAtStartOfAttack",0,0)
		caster:RemoveModifierByName("modifier_juggernaut_blade_dance")
	end
end

function ashe_attack_start(args)
	--print ("I am attacking")
	local caster = args.caster
	local spell = caster:FindAbilityByName("ashe_focus_crit")
	local spellLevel = spell:GetLevel()
	if spellLevel == 0 then
		caster:SetContextNum("critStateAtStartOfAttack",0,0)
	else
		caster:SetContextNum("critStateAtStartOfAttack",1,0)
	end
end