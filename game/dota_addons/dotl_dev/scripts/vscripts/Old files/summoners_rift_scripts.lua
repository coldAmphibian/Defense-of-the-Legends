function AntiBlockStart(trigger)
	if trigger.activator then
		trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_phased", nil)
		end
	end

function AntiBlockEnd(trigger)
	if trigger.activator then
		trigger.activator:RemoveModifierByName("modifier_phased")
		end
	end

function BushStart(trigger)
	if trigger.activator then
		trigger.activator:AddNewModifier(trigger.activator, nil, "modifier_invisible", nil)
		end
	end

function BushEnd(trigger)
	if trigger.activator then
		trigger.activator:RemoveModifierByName("modifier_invisible")
		end
	end