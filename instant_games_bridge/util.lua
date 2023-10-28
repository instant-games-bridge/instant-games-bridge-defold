local json = require("instant_games_bridge.json")

function string:split( inSplitPattern )
	outResults = { }
	local theStart = 1
	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end

local util = {}

util.JS_BRIDGE_ORIGINAL = "bridge"
util.JS_BRIDGE_DEFOLD = "bridge_defold"

-- JS code constructor and runner for convenience
function util.run(prefix, func, ...)
	local arg = {...}
	local code = prefix .. "." .. func .. "("

	for i, val in ipairs(arg) do
		if type(val) == "string" then
			code = code .. "\"" .. val ..  "\""
		elseif type(val) == "table" then
			code = code .. json.encode(val)
		else
			code = code .. tostring(val)
		end

		if i < table.maxn(arg) then
			code = code .. ","
		end
	end

	code = code .. ")"

	return html5.run(code)
end

function util.get(prefix, prop)
	local code = prefix .. "." .. prop
	return html5.run(code)
end

return util