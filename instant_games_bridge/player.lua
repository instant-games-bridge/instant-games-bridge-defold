local util = require("instant_games_bridge.util")

local player = {}

function player.isAuthorizationSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "player.isAuthorizationSupported")
end

function player.isAuthorized()
	return util.get(util.JS_BRIDGE_ORIGINAL, "player.isAuthorized")
end

function player.id()
	return util.get(util.JS_BRIDGE_ORIGINAL, "player.id")
end

function player.name()
	return util.get(util.JS_BRIDGE_ORIGINAL, "player.name")
end

-- TODO
function player.photos()
	local photos = util.get(util.JS_BRIDGE_ORIGINAL, "player.photos")
	return photos:split(",")
end

function player.authorize()
	return util.run(util.JS_BRIDGE_DEFOLD, "playerAuthorize")
end

return player