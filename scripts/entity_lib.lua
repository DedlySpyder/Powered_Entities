require("config")
require("util")

Entity_Lib = {}

function Entity_Lib.init()
	Entity_Lib.BLACKLISTED_TYPE = { "construction-robot", "logistic-robot" }
	Entity_Lib.WHITELISTED_USAGE_PRIORITIES = { "primary-input", "secondary-input", "lamp" }
	
	if not Config.ENABLE_INSERTER then
		table.insert(Entity_Lib.BLACKLISTED_TYPE, "inserter")
	end

	if Config.ENABLE_SOLAR then
		table.insert(Entity_Lib.WHITELISTED_USAGE_PRIORITIES, "solar")
	end

	if Config.ENABLE_ACCUMULATOR then
		table.insert(Entity_Lib.WHITELISTED_USAGE_PRIORITIES, "tertiary")
		table.insert(Entity_Lib.WHITELISTED_USAGE_PRIORITIES, "managed-accumulator")
	end
end

Entity_Lib.init()


function Entity_Lib.isBlacklistedType(entity)
	local entityType = entity["type"]
	for _, value in ipairs(Entity_Lib.BLACKLISTED_TYPE) do
		if entityType == value then return true end
	end
	
	return false
end

function Entity_Lib.isElectricConsumer(entityPrototype)
	local usagePriority = Entity_Lib.getElectricEnergyUsagePriority(entityPrototype)
	
	if usagePriority then
		for _, value in pairs(Entity_Lib.WHITELISTED_USAGE_PRIORITIES) do
			if usagePriority == value then return true end 
		end
	end
	
	return false
end

-- Returns nil if this entity isn't electric
function Entity_Lib.getElectricEnergyUsagePriority(entityPrototype)
	if entityPrototype["electric_energy_source_prototype"] then
		return entityPrototype["electric_energy_source_prototype"]["usage_priority"]
	end
end

function Entity_Lib.canBePoweredEntity(entity)
	return not Entity_Lib.isBlacklistedType(entity) and not string.find(entity.name, Config.INVISIBLE_POLE_BASE_NAME_ESCAPED)
end

-- Works for entity prototypes and data.raw[*][*] entries
function Entity_Lib.getEntitySize(entity)
	local selectionBox = entity["selection_box"]
	if selectionBox then
		selectionBox = Util.standardizeBoundingBox(selectionBox)
		local x = math.ceil(math.abs(selectionBox.left_top.x) + math.abs(selectionBox.right_bottom.x))
		local y = math.ceil(math.abs(selectionBox.left_top.y) + math.abs(selectionBox.right_bottom.y))
		return math.max(x, y)
	end
end

function Entity_Lib.getPowerPoleName(entity)
	size = Entity_Lib.getEntitySize(entity)
	
	if size then
		return Config.INVISIBLE_POLE_BASE_NAME .. size
	end
end

function Entity_Lib.getEntitySizeFromPowerPoleName(name)
	return string.match(name, "%d+$")
end
