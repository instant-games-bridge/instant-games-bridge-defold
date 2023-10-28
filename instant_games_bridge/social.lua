local util = require("instant_games_bridge.util")

local social = {}

function social.isShareSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isShareSupported")
end

function social.share(options)
	util.run(util.JS_BRIDGE_DEFOLD, "social.share", options)
end

function social.isJoinCommunitySupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isJoinCommunitySupported")
end

function social.joinCommunity(options)
	util.run(util.JS_BRIDGE_DEFOLD, "socialJoinCommunity", options)
end

function social.isInviteFriendsSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isInviteFriendsSupported")
end

function social.inviteFriends()
	util.run(util.JS_BRIDGE_DEFOLD, "socialInviteFriends")
end

function social.isCreatePostSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isCreatePostSupported")
end

function social.createPost(options)
	util.run(util.JS_BRIDGE_DEFOLD, "socialCreatePost", options)
end

function social.isAddToFavoritesSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isAddToFavoritesSupported")
end

function social.addToFavorites()
	util.run(util.JS_BRIDGE_DEFOLD, "socialAddToFavorites")
end

function social.isAddToHomeScreenSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isAddToHomeScreenSupported")
end

function social.addToHomeScreen()
	run(util.JS_BRIDGE_DEFOLD, "social.addToHomeScreen")
end

function social.isRateSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isRateSupported")
end

function social.rate()
	util.run(util.JS_BRIDGE_DEFOLD, "social.rate")
end

function social.isExternalLinksAllowed()
	return util.get(util.JS_BRIDGE_ORIGINAL, "social.isExternalLinksAllowed")
end

return social