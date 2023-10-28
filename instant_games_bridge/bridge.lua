local bridge = {}

local util = require("instant_games_bridge.util")

bridge.player = require("instant_games_bridge.player")
bridge.platform = require("instant_games_bridge.platform")
bridge.device = require("instant_games_bridge.device")
bridge.game = require("instant_games_bridge.game")
bridge.storage = require("instant_games_bridge.storage")
bridge.advertisement = require("instant_games_bridge.advertisement")
bridge.social = require("instant_games_bridge.social")
bridge.leaderboard = require("instant_games_bridge.leaderboard")

local init_successful = false

local function js_listener(self, message_id, message)
	if message_id == "initialize" then
		if message == true then
			init_successful = true
		end
	end
end

function bridge.init(self)
	if jstodef then
		jstodef.add_listener(js_listener)
	end
end

function bridge.final(self)
	if jstodef then
		jstodef.remove_listener(js_listener)
	end
end

return bridge