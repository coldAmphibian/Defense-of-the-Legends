	    --Garen by Swordz
		
	function ADDamageCalculator(baseDmg,adRatio,Garen)
	
		local GarenAD=Garen:GetBaseDamageMin()
		
		local damageAmount=baseDmg+((adRatio/100)*GarenAD)
		
		return damageAmount
		
	end
		
		
		
	function GarenSpin(args)
		local cool=args.ability:GetCooldownTimeRemaining()
		if cool < 8  then
        args.ability:ToggleAbility()
		end
    end
	
	function GarenSpinDamage(args)
		local damageAmount=ADDamageCalculator(args.BaseDamage,args.ADRatio,args.caster)
		local teamNumber=args.caster:GetTeam()
		
		if teamNumber==2 then
		teamNumber=3
		elseif teamNumber==3 then
		teamNumber=2
		end
		
		--Search for enemies in a radius
		
		local TargetArray=FindUnitsInRadius(teamNumber,
                              args.caster:GetAbsOrigin(),
                              nil,
                              args.Radius,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY ,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
		
		--Deal Damage
		
		for _,enemy in pairs(TargetArray) do
			
			--Creep damage reduction
			if enemy:IsCreep()==true then
			damageAmount=damageAmount*0.75
			end
			
			local damageTable = {
			victim = enemy,
			attacker = args.caster,
			damage = damageAmount,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			}
		
			ApplyDamage(damageTable)
		end
		
	end
	
	function GarenSilenceDamage(args)
		local damageAmount=ADDamageCalculator(args.BaseDamage,args.ADRatio,args.caster)
		local damageTable = {
		victim = args.target,
		damage = damageAmount,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		attacker = args.caster,
		}
		
		local dmg = ApplyDamage(damageTable)
		
	end
	
	function GarenQPurge(args)
		args.caster:Purge(false, true, false, false, true)
	end
	
    function GarenPassiveOnCooldown(args)
		if args.attacker:IsCreep()==false then
			aby=args
			--SetThink( "GarenPassiveAdd", self, "garenpassadd", nil )
			local cool=args.ability:EndCooldown()
			local cooldownAmount=args.ability:GetCooldown(args.ability:GetLevel())
		
			cool=args.ability:StartCooldown(cooldownAmount)
			print("Perseverance on cooldown")
			GameRules:GetGameModeEntity():SetThink( "GarenPassiveAdd", self, "garenpassadd", cooldownAmount )
		end
	end
	
	function GarenUlt(args)
		local enemy=args.target:GetHealthDeficit()
		local damagev=args.MagicDamage+((enemy/100)*args.MissHPPercent)
		local damageTable = {
		victim = args.target,
		attacker = args.caster,
		damage = damagev,
		damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
	end
	
		function LeagueFlash(args)
		cursor=args.ability:GetCursorPosition()
		args.caster:SetAbsOrigin(cursor)
	end
	
	    function GarenPassiveLevel(args)
		local passive = args.ability:SetLevel(1)
    end
	
		function GarenPassiveAdd()
		--aby.ability:SetLevel(0)
		local garenLvl = aby.caster:GetLevel()
		
		if garenLvl>=11 then
		 aby.ability:SetLevel(3)
		
		elseif garenLvl>=6 then
		 aby.ability:SetLevel(2)
		
		elseif garenLvl>=0 then
		 aby.ability:SetLevel(1)
		end 
		
		print("Regained")
	end
	
	function MakeForwardLinearProjectile(args)
        local caster = args.caster
		local originalangles=caster:GetAnglesAsVector()
		local a = caster:GetAnglesAsVector()
		randomyaw=RandomInt((a.y-10),(a.y+10))
		--randomvec=Vector(0,randomyaw,0)
		caster:SetAngles(0,randomyaw,0)
		--caster:SetForwardVector(randomvec)
		--print (a)
        local info =
        {
            Ability = args.ability,
            EffectName = args.EffectName,
            iMoveSpeed = args.MoveSpeed,
            vSpawnOrigin = caster:GetAbsOrigin(),
            vVelocity = caster:GetForwardVector() * 1000,
            fDistance = args.FixedDistance,
            fStartRadius = 0,
            fEndRadius = 300,
            Source = caster,
            bHasFrontalCone = false,
            bReplaceExisting = false,
            bDeleteOnHit = true,
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            fExpireTime = GameRules:GetGameTime() + 10.0,
        }
        local projectile = ProjectileManager:CreateLinearProjectile(info)
		caster:SetAngles(0,originalangles.y,0)
    end
	
	
	function PrintTable(t, indent, done)
--print ( string.format ('PrintTable type %s', type(keys)) )
if type(t) ~= "table" then return end

done = done or {}
done[t] = true
indent = indent or 0

local l = {}
for k, v in pairs(t) do
    table.insert(l, k)
end

table.sort(l)
for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
        local value = t[v]

        if type(value) == "table" and not done[value] then
            done [value] = true
            print(string.rep ("\t", indent)..tostring(v)..":")
            PrintTable (value, indent + 2, done)
        elseif type(value) == "userdata" and not done[value] then
            done [value] = true
            print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
            PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
        else
            if t.FDesc and t.FDesc[v] then
                print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
            else
                print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
            end
        end
    end
end
end

