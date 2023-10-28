local util = require("instant_games_bridge.util")

local advertisement = {}

function advertisement.isBannerSupported()
	return util.get(util.JS_BRIDGE_ORIGINAL, "advertisement.isBannerSupported")
end

function advertisement.showBanner(options)
	util.run(util.JS_BRIDGE_ORIGINAL, "advertisement.showBanner", options)
end

function advertisement.hideBanner()
	util.run(util.JS_BRIDGE_ORIGINAL, "advertisement.hideBanner")
end

function advertisement.bannerState()
	return util.get(util.JS_BRIDGE_ORIGINAL, "advertisement.bannerState")
end

function advertisement.getMinimumDelayBetweenInterstitial()
	return util.get(util.JS_BRIDGE_ORIGINAL, "advertisement.minimumDelayBetweenInterstitial")
end

function advertisement.setMinimumDelayBetweenInterstitial(delayOptions)
	util.run(util.JS_BRIDGE_ORIGINAL, "advertisement.setMinimumDelayBetweenInterstitial", delayOptions)
end

function advertisement.interstitialState()
	return util.get(util.JS_BRIDGE_ORIGINAL, "advertisement.interstitialState")
end

function advertisement.showInterstitial(options)
	util.run(util.JS_BRIDGE_ORIGINAL, "advertisement.showInterstitial", options)
end

function advertisement.rewardedState()
	return util.get(JS_BRIDGE_ORIGINAL, "advertisement.rewardedState")
end

function advertisement.showRewarded()
	util.run(util.JS_BRIDGE_ORIGINAL, "advertisement.showRewarded")
end

return advertisement