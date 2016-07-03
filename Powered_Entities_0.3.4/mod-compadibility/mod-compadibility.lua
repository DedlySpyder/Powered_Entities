require "bobs-mods"

--Format for each entry in the table is {"entity_type", "entity_name"}
--Valid entity_types are as follows:
--1x1, 2x2, 3x3, 4x4, 5x5, 9x10, custom

--Iterates over all of the mods and adds compadible entities to the arrays
function modCompadibility()
	for mod, _ in pairs(game.active_mods) do
		check_bobassembly(mod)
		check_boblogistics(mod)
		check_bobmining(mod)
		check_bobmodules(mod)
		check_bobplates(mod)
		check_bobpower(mod)
		check_bobtech(mod)
		check_bobwarfare(mod)
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