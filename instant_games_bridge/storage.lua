local util = require("instant_games_bridge.util")

local storage = {}

function storage.defaultType()
	return util.get(util.JS_BRIDGE_ORIGINAL, "storage.defaultType")
end

function storage.isSupported(storageType)
	return util.run(util.JS_BRIDGE_ORIGINAL, "storage.isSupported", storageType)
end

function storage.isAvailable(storageType)
	return util.run(util.JS_BRIDGE_ORIGINAL, "storage.isAvailable", storageType)
end

function storage.get(key)
	util.run(util.JS_BRIDGE_DEFOLD, "storageGet", key)
end

function storage.set(key, value)
	util.run(util.JS_BRIDGE_DEFOLD, "storageSet", key, value)
end

function storage.delete(key)
	util.run(util.JS_BRIDGE_DEFOLD, "storageDelete", key)
end

return storage