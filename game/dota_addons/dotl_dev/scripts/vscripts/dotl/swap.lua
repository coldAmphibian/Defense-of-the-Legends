function TestFunction( event )
	if event.caster.hue == nil then
		event.caster.hue = 0
	end

	if event.caster.hue == 0 then
		event.caster.hue = 1
	else
		if event.caster.hue == 1 then
			event.caster.hue = 0
		end
	end

	DoStuff(event)
end

function DoStuff( event )
	if event.caster.hue == 0 then
		event.caster:SetModel('models/champions/ezreal/ezreal.vmdl')
	else
		event.caster:SetModel('models/champions/sona/sona.vmdl')
	end
end