	var DEFOLD_MESSAGE_ID = {
		INITIALIZE: "initialize",
		PLAYER_AUTHORIZE: "player.authorize",
		SOCIAL_SHARE: "social.share",
		SOCIAL_JOIN_COMMUNITY: "social.joinCommunity",
		SOCIAL_INVITE_FRIENDS: "social.inviteFriends",
		SOCIAL_ADD_TO_FAVORITES: "social.addToFavorites",
		SOCIAL_ADD_TO_HOME_SCREEN: "social.addToHomeScreen",
		SOCIAL_CREATE_POST: "social.createPost",
		SOCIAL_RATE: "social.rate",
		STORAGE_GET: "storage.get",
		STORAGE_GET_FAILED: "storage.getFailed",
		STORAGE_SET: "storage.set",
		STORAGE_SET_FAILED: "storage.setFailed",
		STORAGE_DELETE: "storage.delete",
		STORAGE_DELETE_FAILED: "storage.deleteFailed",
		LEADERBOARD_SHOW_NATIVE_POPUP: "leaderboard.showNativePopup",
		LEADERBOARD_SHOW_NATIVE_POPUP_FAILED: "leaderboard.showNativePopupFailed",
		LEADERBOARD_SET_SCORE: "leaderboard.setScore",
		LEADERBOARD_SET_SCORE_FAILED: "leaderboard.setScoreFailed",
		LEADERBOARD_GET_SCORE: "leaderboard.getScore",
		LEADERBOARD_GET_SCORE_FAILED: "leaderboard.getScoreFailed",
		LEADERBOARD_GET_ENTRIES: "leaderboard.getEntries",
		LEADERBOARD_GET_ENTRIES_FAILED: "leaderboard.getEntriesFailed",
	}

class InstantGamesBridgeDefold {

	constructor() { }

	playerAuthorize(authorizationOptions) {
		bridge.player.authorize(authorizationOptions)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.PLAYER_AUTHORIZE, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.PLAYER_AUTHORIZE, false);
			})
	}

	socialShare(shareOptions) {
		bridge.social.share(shareOptions)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_SHARE, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_SHARE, false);
			})
	}

	socialJoinCommunity(joinCommunityOptions) {
		bridge.social.joinCommunity(joinCommunityOptions)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_JOIN_COMMUNITY, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_JOIN_COMMUNITY, false);
			})
	}

	socialInviteFriends() {
		bridge.social.inviteFriends()
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_INVITE_FRIENDS, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_INVITE_FRIENDS, false);
			})
	}

	socialAddToFavorites() {
		bridge.social.addToFavorites()
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_ADD_TO_FAVORITES, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_ADD_TO_FAVORITES, false);
			})
	}

	socialAddToHomeScreen() {
		bridge.social.addToHomeScreen()
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_ADD_TO_HOME_SCREEN, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_ADD_TO_HOME_SCREEN, false);
			})
	}

	socialRate() {
		bridge.social.rate()
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_RATE, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_RATE, false);
			})
	}

	socialCreatePost(options) {
		bridge.social.createPost(options)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_CREATE_POST, true);
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.SOCIAL_CREATE_POST, false);
			})
	}

	storageGet(key) {
		bridge.storage.get(key)
			.then(data => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_GET, data)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_GET_FAILED, key)
			})
	}

	storageSet(key, value) {
		bridge.storage.set(key, value)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_SET, key)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_SET_FAILED, key)
			})
	}

	storageDelete(key) {
		bridge.storage.delete(key)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_DELETE, key)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.STORAGE_DELETE_FAILED, key)
			})
	}

	leaderboardShowNativePopup(options) {
		bridge.leaderboard.showNativePopup(options)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_SHOW_NATIVE_POPUP, key)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_SHOW_NATIVE_POPUP_FAILED, error)
			})
	}

	leaderboardSetScore(options) {
		bridge.leaderboard.setScore(options)
			.then(() => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_SET_SCORE, key)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_SET_SCORE_FAILED, error)
			})
	}

	leaderboardGetScore(options) {
		bridge.leaderboard.getScore(options)
			.then((score) => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_GET_SCORE, score)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_GET_SCORE_FAILED, error)
			})
	}

	leaderboardGetEntries(options) {
		bridge.leaderboard.getScore(options)
			.then((entries) => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_GET_ENTRIES, entries)
			})
			.catch(error => {
				JsToDef.send(DEFOLD_MESSAGE_ID.LEADERBOARD_GET_ENTRIES_FAILED, error)
			})
	}
}

window.bridge_defold = new InstantGamesBridgeDefold()