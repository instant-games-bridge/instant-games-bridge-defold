local M = {}

local version = "Instant Games Bridge for Defold v1.2.1"
local json_encode = require("instantgamesbridge.json")
local callback_ids = require("instantgamesbridge.callback_ids")
if not html5 then
    instantgamesbridge = require("instantgamesbridge.mock")
end

local is_init = false

local function check_callback(callback)
    if callback == nil or type(callback) == "function" then
        return
    end
    error(string.format("The callback parameter must be a function!"), 3)
end

local function check_key(key)
    if type(key) ~= "string" then
        error("The key must be a string!", 3)
    end
end

local function check_value(value)
    if type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean" then
        error("The value must be a string, number, or boolean!", 3)
    end
end

local function check_table(tbl, parameter_name)
    if tbl == nil or type(tbl) == "table" then
        return
    end
    error(string.format("The '%s' parameter must be a table!", parameter_name), 3)
end

local function get_event_callback_name(callback_id)
    for callback_name, id in pairs(callback_ids) do
        if callback_id == id then
            return callback_name
        end
    end
end

local function decode_result(result)
    if result then
        local is_ok, value = pcall(json.decode, result)
        if is_ok then
            return value
        else
            return result
        end
    end
end

local function on_event_callback(self, message, id)
    local callback_name = get_event_callback_name(id)
    if callback_name ~= nil then
        local callback = M.callbacks[callback_name]
        if callback == nil then
            return
        end
        assert(type(callback) == "function", string.format("callbacks.'%s' must be a function!", callback_name))
        if message == "" then
            callback()
        else
            callback(decode_result(message))
        end
    end
end

---Выполнить функцию instant games bridge API. Если method API является объектом, то в parameters дополнительно можно перечислить
---методы (геттеры).
---@param method string выполняемый метод объект или поле объекта, например: "advertisement.showInterstitial"
---@param parameters any параметры метода, если параметров несколько, то таблица (массив) параметров.
---@param callback function функция обратного вызова, если nil, тогда функция сразу вернет результат
---@param native_api boolean если true, то будет вызван нативный метод
---@return any результат выполнения метода, или nil, если задан callback
local function call_api(method, parameters, callback, native_api)
    if type(parameters) ~= "table" then
        parameters = { parameters }
    end
    parameters = json_encode.encode(parameters)
    if callback then
        instantgamesbridge.call_api(method, parameters, native_api, function(self, message)
            if message == "" then
                callback()
            else
                callback(decode_result(message))
            end
        end)
    else
        local result = instantgamesbridge.call_api(method, parameters, native_api)
        return decode_result(result)
    end
end

M.callbacks = {
    interstitial_state_changed = nil,
    rewarded_state_changed = nil,
}

M.PLATFORM_VK = "vk"
M.PLATFORM_YANDEX = "yandex"
M.PLATFORM_MOCK = "mock"

---Возвращает версию плагина
---@return string
function M.get_plugin_version()
    return version
end

---Инициализация instant games bridge
---@param callback function функция обратного вызова по завершению инициализации: callback(success)
function M.init(callback)
    if is_init then
        error("Instant games bridge already initialized!", 2)
    end
    if callback == nil then
        error("Callback function must be specified!", 2)
    end
    check_callback(callback)
    is_init = true
    instantgamesbridge.init(json_encode.encode(callback_ids), on_event_callback, function(self, message, callback_id)
        callback(message)
    end)
end

---Получить сведения о платформе
---@return string ID платформы
function M.get_platform_id()
    return call_api("platform.id").value
end

---Получить текущий язык
---@return string код языка
function M.get_language()
    return call_api("platform.language").value
end

---Получить payload из URL
---@return string payload
function M.get_payload()
    return call_api("platform.payload").value
end

---Выполнить нативный метод платформы. Если method API является объектом.
---@param method string выполняемый метод объект или поле объекта, например: "feedback.canReview"
---@param parameters any параметры метода, если параметров несколько, то таблица (массив) параметров.
---@param callback function|nil функция обратного вызова
---@return any результат выполнения операции или возвращаемые данные
function M.call_native_sdk(method, parameters, callback)
    if type(method) ~= "string" or method == "" then
        error("The method must be a string!", 2)
    end
    check_callback(callback)
    return call_api(method, parameters, callback, true)
end

---Установить минимальное время между показами рекламы
function M.ads_set_minimum_delay_between_interstitial(seconds)
    call_api("advertisement.setMinimumDelayBetweenInterstitial", seconds)
end

---Показать межстраничную рекламу
---@param callback function функция обратного вызова по завершению рекламы: callback(result)
function M.ads_show_interstitial(interstitial_options, callback)
    check_table(interstitial_options, "interstitial_options")
    check_callback(callback)
    call_api("advertisement.showInterstitial", interstitial_options, callback)
end

---Показать рекламу за вознаграждение
---@param callback function функция обратного вызова по завершению рекламы: callback(result)
function M.ads_show_rewarded(callback)
    check_callback(callback)
    call_api("advertisement.showRewarded", nil, callback)
end

---Получить значение поля key
---@param key string ключ
---@param callback function функция обратного вызова с результатом: callback(result)
function M.game_get_data(key, callback)
    check_key(key)
    check_callback(callback)
    call_api("game.getData", key, callback)
end

---Установить значение поля key
---@param key string ключ
---@param value string|number|boolean значение поля key
---@param callback function функция обратного вызова с результатом выполненной операции: callback(result)
function M.game_set_data(key, value, callback)
    check_key(key)
    check_value(value)
    check_callback(callback)
    call_api("game.setData", { key, value }, callback)
end

---Возвращает информацию о возможных социальных действиях
---@return table
function M.social()
    local parameters = {
        "isShareSupported",
        "isCommunitySupported",
        "isInviteFriendsSupported"
    }
    return call_api("social", parameters)
end

---Поделиться
---@param callback function функция обратного вызова с результатом выполненной операции: callback(result)
function M.social_share(callback)
    check_callback(callback)
    call_api("social.share", nil, callback)
end

---Вступить в сообщество
---@param callback function функция обратного вызова с результатом выполненной операции: callback(result)
function M.social_join_community(callback)
    check_callback(callback)
    call_api("social.joinCommunity", nil, callback)
end

---Пригласить друзей
---@param callback function функция обратного вызова с результатом выполненной операции: callback(result)
function M.social_invite_friends(callback)
    check_callback(callback)
    call_api("social.inviteFriends", nil, callback)
end

return M