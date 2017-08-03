--bobassembly
function check_doublefurnace(mod)
	if (mod == "DoubleFurnace") then
		add_to_table({
			{"3x3", "double-furnace"}
		})
	end
end

function check_AssemblyZero(mod)
	if (mod == "AssemblyZero") then
		add_to_table({
			{"1x1", "assembling-machine-0"},
			{"1x1", "assembling-machine-x"},
			{"2x2", "assembling-machine-z"}
		})
	end
end

function check_FlareStack(mod)
	if (mod == "Flare Stack") then
		add_to_table({
			{"1x1", "flare-stack"},
			{"1x1", "incinerator"},
			{"1x1", "electric-incinerator"},
			{"1x1", "vent-stack"}
		})
	end
end
