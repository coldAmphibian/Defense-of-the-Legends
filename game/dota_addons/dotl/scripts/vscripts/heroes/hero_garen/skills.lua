        function GarenSpin(args)
		local cool=args.ability:GetCooldownTimeRemaining()
		if cool < 8  then
        args.ability:ToggleAbility()
		end
    end
	
        function GarenPassiveOnCooldown(args)
		aby=args
		--SetThink( "GarenPassiveAdd", self, "garenpassadd", nil )
		local cool=args.ability:EndCooldown()
		cool=args.ability:StartCooldown(10)
		print("Perseverance on cooldown")
		GameRules:GetGameModeEntity():SetThink( "GarenPassiveAdd", self, "garenpassadd", 10 )
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
		args.ability:SetLevel(1)
		print("Leveling Passive")
    end
	
		function GarenPassiveAdd()
		--aby.ability:SetLevel(0)
		aby.ability:SetLevel(1)
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

