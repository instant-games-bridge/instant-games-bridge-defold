local util = require("instant_games_bridge.util")

local platform = {}

function platform.id()
	return util.get(util.JS_BRIDGE_ORIGINAL, "platform.id")
end

function platform.language()
	return util.get(util.JS_BRIDGE_ORIGINAL, "platform.language")
end

function platform.payload()
	return util.get(util.JS_BRIDGE_ORIGINAL, "platform.payload")
end

function platform.tld()
	return util.get(util.JS_BRIDGE_ORIGINAL, "platform.tld")
end

function platform.sendMessage(message)
	util.run(util.JS_BRIDGE_ORIGINAL, "platform.sendMessage", message)
end

return platform