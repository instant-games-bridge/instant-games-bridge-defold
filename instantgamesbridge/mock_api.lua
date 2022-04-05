local callback_ids = require("instantgamesbridge.callback_ids")

local data = {}
local M = {}

local function get_storage_file_name()
    local appname = sys.get_config("project.title")
    if sys.get_sys_info().system_name == "Linux" then
        appname = string.format("config/%s", appname)
        return sys.get_save_file(appname, M.file_storage)
    end
    return sys.get_save_file(appname, M.file_storage)
end

local function save_storage()
    sys.save(get_storage_file_name(), data)
end

M.send = function(callback_id, message)
end

M.file_storage = "instantgamesbridge.dat"

-- инициализация
M["init"] = function()
    return "success"
end

-- платформа
M["platform.id"] = { value = "mock" }
M["platform.language"] = { value = sys.get_sys_info().language }
M["platform.payload"] = { value = "payload" }

-- данные
M["game.getData"] = function(key)
    return { value = data[key] }
end
M["game.setData"] = function(key, value)
    data[key] = value
    save_storage()
end

-- социальные действия
M["social"] = {
    isShareSupported = false,
    isCommunitySupported = false,
    isInviteFriendsSupported = false,
}

return M