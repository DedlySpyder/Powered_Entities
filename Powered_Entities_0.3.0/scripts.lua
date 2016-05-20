--Build in manual mode
function manualModeOnBuild(entity)
	local positionBox = searchBox(entity)
	local flag
	
	if (entity.name =="power-pad") then
		--Search for entities
		local foundEntities = entity.surface.find_entities(positionBox)
		
		--Try to build a pole
		for _, entityFound in pairs(foundEntities) do
			--Make sure a machine was found
			if (entityFound.name ~= "power-pad") then
				flag = buildInvisablePole(entityFound)
			else debugLog("Found a pad") end
			if flag then break end
		end
		
		--If it could not, create the power pad pole
		if not flag then
			entity.surface.create_entity{name="power-pad-pole", position=entity.position, force=entity.force}
		end
	else
		--Search for power pads
		local foundPowerPads = entity.surface.count_entities_filtered{area=positionBox, name="power-pad"}
		
		--Build a power pole if there was a power pad
		if (foundPowerPads > 0) then
			flag = buildInvisablePole(entity)
			if flag then debugLog("Built a pole") end
		end
		
		--If it could place a power pole, destroy the default power pole
		if flag then
			destroyEntity(entity, {"power-pad-pole"})
		end
	end
end

--Destruction in manual mode
function manualModeOnDestroy(entity)
	local positionBox = searchBox(entity)
	if (entity.name == "power-pad") then
		--If a pad is found, destroy any poles
		destroyEntity(entity, allInvisablePowerPoles)
	else
		--Otherwise, destroy only the non-power pad poles
		destroyEntity(entity, invisablePowerPoles)
		
		--Search for power pads
		local foundPowerPads = entity.surface.find_entities_filtered{area=positionBox, name="power-pad"}
		for _, powerPad in pairs(foundPowerPads) do
			debugLog("Found some pads to rebuild default pole")
			--Rebuild the default pole
			entity.surface.create_entity{name="power-pad-pole", position=powerPad.position, force=entity.force}
		end
	end
end

--Build a power pole
function buildInvisablePole(entity)
	
	--Check for a 1x1 entity
	if checkEntityList(entity, entities1x1) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-1x1", position=entity.position, force=entity.force}
		return true
	end
	
	--Check for a 2x2 entity
	if checkEntityList(entity, entities2x2) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-2x2", position=entity.position, force=entity.force} 
		return true
	end
	
	--Check for a 3x3 entity
	if checkEntityList(entity, entities3x3) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-3x3", position=entity.position, force=entity.force} 
		return true
	end
	
	--Check for a 4x4 entity
	if checkEntityList(entity, entities4x4) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-4x4", position=entity.position, force=entity.force} 
		return true
	end
	
	--Check for a 5x5 entity
	if checkEntityList(entity, entities5x5) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-5x5", position=entity.position, force=entity.force} 
		return true
	end
	
	--Check for a 9x10 entity
	if checkEntityList(entity, entities9x10) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-9x10", position=entity.position, force=entity.force} 
		return true
	end
	
	--Check for a 1x1 entity
	if checkEntityList(entity, entitiesCustom) then
		--Build a power pole for the entity
		entity.surface.create_entity{name="invisable-electric-pole-custom", position=entity.position, force=entity.force} 
		return true
	end
	return false
end

--Compares an entity to one of the arrays that stores entity names
function checkEntityList(entity, entityList)
	for _, listEntity in ipairs(entityList) do
		if (listEntity == entity.name) then
			return true
		end
	end
	return false
end

--Destroy power poles around the specified entity, using the array (entitiesToDestroy) to compare to
function destroyEntity(entity, entitiesToDestroy)
	debugLog("Starting to destroy")
	
	local positionBox = searchBox(entity)
	
	--Search for any power poles
	local foundEntities = entity.surface.find_entities_filtered{area=positionBox, type="electric-pole"}
	for _, checkedEntity in pairs(foundEntities) do
		for _, entityToDestroy in pairs(entitiesToDestroy) do
			if (checkedEntity.name == entityToDestroy) then 
				--If the found pole is on the list, destroy it
				checkedEntity.destroy()
				break
			end
		end
	end
end

--Scripts to handle transistion between modes

--Places all poles for manual mode
function placeAllPolesManual()
	for _, force in pairs(game.forces) do
		
		--Check for research completed
		if force.technologies["powered-entities"].researched then
			force.recipes["power-pad"].enabled = true
			
			--Avoid duplicate poles
			destroyAllInvisablePoles(force)
			
			--Find where to place new poles and place them
			local forceEntities = Surface.find_all_entities({name="power-pad", force=force})
			for _, entity in pairs(forceEntities) do
				--Extra checks will be needed to see which pole to build
				manualModeOnBuild(entity)
			end
		end
	end
end

--Places all poles for automatic mode
function placeAllPolesAutomatic(techForce)
	
	--techForce will force the placement on research completed
	if (techForce ~= nil) then
		--Place new poles
		placeAllPolesAutomaticInternal(techForce)
	else
		for _, force in pairs(game.forces) do
			if force.technologies["powered-entities"].researched then
				--Avoid duplicate poles
				destroyAllInvisablePoles(force)
				
				--Place new poles
				placeAllPolesAutomaticInternal(force)
			end
		end
	end
end

--Internal functions

--Used by placeAllPolesAutomatic to actually find the entities that need poles
function placeAllPolesAutomaticInternal(force)
	force.recipes["power-pad"].enabled = false
	local forceEntities = Surface.find_all_entities({force=force})
	
	for _, entity in pairs(forceEntities) do
		buildInvisablePole(entity)
	end
end

--Destroys all power poles used by the mod
function destroyAllInvisablePoles(force)
	local forcePoles = Surface.find_all_entities({force=force, type="electric-pole"})
	
	for _, entity in pairs(forcePoles) do
		for _, listEntity in ipairs(allInvisablePowerPoles) do
			if (entity.name == listEntity) then
				entity.destroy()
				break
			end
		end
	end
end

--Returns a search BoundingBox
function searchBox(entity)
	local selectionBox = entity.prototype.selection_box
	return Area.offset(selectionBox, entity.position)
end