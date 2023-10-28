local util = require("instant_games_bridge.util")

local leaderboard = {}

function leaderboard.isSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "leaderboard.isSupported")
end

function leaderboard.isNativePopupSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "leaderboard.isNativePopupSupported")
end

function leaderboard.showNativePopup(options)
	util.run(util.JS_BRIDGE_DEFOLD, "leaderboardShowNativePopup", options)
end

function leaderboard.isSetScoreSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "leaderboard.isSetScoreSupported")
end

function leaderboard.setScore(options)
	util.run(util.JS_BRIDGE_DEFOLD, "leaderboardSetScore", options)
end

function leaderboard.isGetScoreSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "leaderboard.isGetScoreSupported")
end

function leaderboard.getScore(options)
	util.run(util.JS_BRIDGE_DEFOLD, "leaderboardGetScore", options)
end

function leaderboard.leaderboardIsGetEntriesSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "leaderboard.isGetEntriesSupported")
end

function leaderboard.leaderboardGetEntries(options)
	util.run(util.JS_BRIDGE_DEFOLD, "leaderboardGetEntries")
end

return leaderboard