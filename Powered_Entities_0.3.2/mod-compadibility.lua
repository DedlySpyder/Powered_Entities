--Format for each entry in the table is {"entity_type", "entity_name"}
--Valid entity_types are as follows:
--1x1, 2x2, 3x3, 4x4, 5x5, 9x10, custom

--Iterates over all of the mods and adds compadible entities to the arrays
function initialize_arrays()
	for mod, _ in pairs(game.active_mods) do
		--bobassembly
		if (mod == "bobassembly") then
			add_to_table({
				{"2x2", "electronics-machine-1"},
				{"2x2", "electronics-machine-2"},
				{"2x2", "electronics-machine-3"},
				{"3x3", "assembling-machine-4"},
				{"3x3", "assembling-machine-5"},
				{"3x3", "assembling-machine-6"}
			})
		end
		
		--boblogistics 
		if (mod == "boblogistics") then
			add_to_table({
				{"2x2", "bob-robochest"},
				{"2x2", "bob-robochest-2"},
				{"2x2", "bob-robochest-3"},
				{"2x2", "bob-robochest-4"},
				{"2x2", "bob-logistic-zone-expander"},
				{"2x2", "bob-logistic-zone-expander-2"},
				{"2x2", "bob-logistic-zone-expander-3"},
				{"2x2", "bob-logistic-zone-expander-4"},
				{"2x2", "bob-robo-charge-port"},
				{"2x2", "bob-robo-charge-port-2"},
				{"2x2", "bob-robo-charge-port-3"},
				{"2x2", "bob-robo-charge-port-4"},
				{"3x3", "bob-robo-charge-port-large"},
				{"3x3", "bob-robo-charge-port-large-2"},
				{"3x3", "bob-robo-charge-port-large-3"},
				{"3x3", "bob-robo-charge-port-large-4"},
				{"4x4", "bob-roboport-2"},
				{"4x4", "bob-roboport-3"},
				{"4x4", "bob-roboport-4"}
			})
		end
		
		--bobmining
		if (mod == "bobmining") then
			add_to_table({
				{"3x3", "bob-area-mining-drill-1"},
				{"3x3", "bob-area-mining-drill-2"},
				{"3x3", "bob-area-mining-drill-3"},
				{"3x3", "bob-area-mining-drill-4"},
				{"3x3", "bob-mining-drill-1"},
				{"3x3", "bob-mining-drill-2"},
				{"3x3", "bob-mining-drill-3"},
				{"3x3", "bob-mining-drill-4"},
				{"3x3", "bob-pumpjack-1"},
				{"3x3", "bob-pumpjack-2"},
				{"3x3", "bob-pumpjack-3"},
				{"3x3", "bob-pumpjack-4"}
			})
		end
		
		--bobmodules
		if (mod == "bobmodules") then
			add_to_table({
				{"3x3", "basic-beacon-2"},
				{"3x3", "basic-beacon-3"},
				{"3x3", "lab-module"}
			})
		end
		
		--bobplates
		if (mod == "bobplates") then
			add_to_table({
				{"1x1", "void-pump"},
				{"2x2", "air-pump"},
				{"2x2", "air-pump-2"},
				{"2x2", "air-pump-3"},
				{"2x2", "air-pump-4"},
				{"2x2", "water-pump"},
				{"2x2", "water-pump-2"},
				{"2x2", "water-pump-3"},
				{"2x2", "water-pump-4"},
				{"3x3", "electrolyser"},
				{"3x3", "electrolyser-2"},
				{"3x3", "electrolyser-3"},
				{"3x3", "electrolyser-4"},
				{"3x3", "chemical-furnace"},
				{"3x3", "electric-mixing-furnace"},
				{"3x3", "electric-chemical-mixing-furnace"},
				{"3x3", "electric-chemical-mixing-furnace-2"},
				{"3x3", "chemical-plant-2"},
				{"3x3", "chemical-plant-3"},
				{"3x3", "chemical-plant-4"}
			})
		end
		
		--bobpower
		if (mod == "bobpower") then
			add_to_table({
				{"2x2", "large-accumulator"},
				{"2x2", "large-accumulator-2"},
				{"2x2", "large-accumulator-3"},
				{"2x2", "fast-accumulator"},
				{"2x2", "fast-accumulator-2"},
				{"2x2", "fast-accumulator-3"},
				{"2x2", "slow-accumulator"},
				{"2x2", "slow-accumulator-2"},
				{"2x2", "slow-accumulator-3"},
				{"2x2", "solar-panel-small"},
				{"2x2", "solar-panel-small-2"},
				{"2x2", "solar-panel-small-3"},
				{"3x3", "solar-panel-2"},
				{"3x3", "solar-panel-3"},
				{"4x4", "solar-panel-large"},
				{"4x4", "solar-panel-large-2"},
				{"4x4", "solar-panel-large-3"}
			})
		end
		
		--bobtech
		if (mod == "bobtech") then
			add_to_table({
				{"3x3", "lab-2"},
				{"3x3", "lab-alien"}
			})
		end
		
		--bobwarfare
		if (mod == "bobwarfare") then
			add_to_table({
				{"2x2", "bob-laser-turret-2"},
				{"2x2", "bob-laser-turret-3"},
				{"2x2", "bob-laser-turret-4"},
				{"2x2", "bob-laser-turret-5"}
			})
		end
	end
end


--Adds entities to the arrays
function add_to_table(array)
	for _, entity in ipairs(array) do
		local entity_type = entity[1]
		local entity_name = entity[2]
		
		if (entity_type == "1x1") then
			table.insert(entities1x1, entity_name)
		elseif (entity_type == "2x2") then
			table.insert(entities2x2, entity_name)
		elseif (entity_type == "3x3") then
			table.insert(entities3x3, entity_name)
		elseif (entity_type == "4x4") then
			table.insert(entities4x4, entity_name)
		elseif (entity_type == "5x5") then
			table.insert(entities5x5, entity_name)
		elseif (entity_type == "9x10") then
			table.insert(entities9x10, entity_name)
		elseif (entity_type == "custom") then
			table.insert(entitiesCustom, entity_name)
		end
	end
end