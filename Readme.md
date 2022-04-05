# Instant Games Bridge

Plugin of [InstantGamesBridge](https://github.com/mewtongames/instant-games-bridge) for Defold.

Roadmap: https://trello.com/b/NjF29vTW. Join community: https://t.me/instant_games_bridge.

- [Установка](#installation)
- [Инициализация](#initialize)
- [API](#api)
- [Вызов нативных методов платформы](#native_sdk)
- [Заглушка для других платформ, отличных от html](#mock)
- [Заглушка для нативных вызовов](#mock-native)

<a name="installation"></a>

## Установка

Вы можете использовать его в своем собственном проекте, добавив этот проект в
качестве [зависимости библиотеки Defold](https://defold.com/manuals/libraries/).

<a name="initialize"></a>

## Инициализация

Для начала необходимо инициализировать SDK с помощью метода init:

```lua
local instantgamesbridge = require("instantgamesbridge.instantgamesbridge")

instantgamesbridge.init(function(success)
    if success == "success" then
        -- инициализация прошла успешно
    else
        -- ошибка инициализации
    end
end)
```

Если будет использоваться метод `social_join_community()` то в файл game.project необходимо добавить раздел
instant_games_bridge и указать идентификатор группы ВК (vk_group_id).

```
[instant_games_bridge]
vk_group_id = 199747461
```

Для подписки на событие необходимо определить соответсвующий метод таблицы callbacks:

```lua
local instantgamesbridge = require("instantgamesbridge.instantgamesbridge")

local function interstitial_state_changed(state)
end

local function rewarded_state_changed(state)
end

-- функции событий можно назначить до инициализации SDK
instantgamesbridge.callbacks.interstitial_state_changed = interstitial_state_changed
instantgamesbridge.callbacks.rewarded_state_changed = rewarded_state_changed

-- инициализация SDK
instantgamesbridge.init(function(success)
    if success == "success" then
        -- показываем межстраничную рекламу 
        instantgamesbridge.ads_show_interstitial(function(result)
        end)

        -- показываем рекламу за вознаграждение 
        instantgamesbridge.ads_show_rewarded(function(result)
        end)
    else
        -- ошибка инициализации
    end
end)
```

<a name="api"></a>

## API

| Instant Games Bridge JS SDK                   | instantgamesbridge Lua API |
| ---------------------------------- | ----------------- |
| **Инициализация**
| `instantGamesBridge.initialize(bridgeOptions)` | `init(callback)`<br> Инициализация модуля<br> после инициализации будет вызвана функция callback(success) с результатом
| **Язык**
| `instantGamesBridge.platform.language`         | `get_language()`<br> Язык платформы
| **Платформа**
| `instantGamesBridge.platform.id`               | `get_platform_id()`<br> Возвращает тип платформы: 'vk', 'yandex', 'mock'
| `instantGamesBridge.platform.sdk`              | `call_native_sdk(method, parameters, callback)`<br> Вызывает нативный метод для платформы [подобнее](#native_sdk)<br> method: метод или поле объекта нативной платформы<br> parameters: параметры вызываемого метода<br> callback: функция обратного вызова
| `instantGamesBridge.platform.payload`          | `get_payload()`<br> Возвращает значение payload из URL
| **Константы платформ**
| ---                                | PLATFORM_VK<br> PLATFORM_YANDEX<br> PLATFORM_MOCK
| **Разное**
| ---                                | get_plugin_version()<br> Получить версию плагина
| **Реклама**
| `instantGamesBridge.advertisement.setMinimumDelayBetweenInterstitial(seconds)` | `ads_set_minimum_delay_between_interstitial()`<br> Устанавливает минимальное время между показом межстраничной рекламы
| `instantGamesBridge.advertisement.showInterstitial(interstitialOptions)()`     | `ads_show_interstitial(interstitial_options, callback)`<br> Показывает межстраничную рекламу<br> interstitial_options параметры вызова<br> callback(result) функция обратного вызова или nil
| `instantGamesBridge.advertisement.showRewarded()`   | `ads_show_rewarded(callback)`<br> Показывает рекламу за вознаграждение<br> callback(result) функция обратного вызова
| | События:
| `instantGamesBridge.advertisement.on('interstitial_state_changed', state => {})` | `callbacks.interstitial_state_changed(state)`<br> Межстраничная реклама
| `instantGamesBridge.advertisement.on('rewarded_state_changed', state => {})` | `callbacks.rewarded_state_changed(state)`<br> Реклама за вознаграждение
| **Данные**
| `instantGamesBridge.game.getData(key)`  | `game_get_data(key, callback)`<br> Получить значение поля key<br> key = string<br> callback(result) Функция обратного вызова с результатом
| `instantGamesBridge.game.setData(key, value)`   | `game_set_data(key, value, callback)`<br> Установить значение поля key<br> key = string<br> value = string, number или boolean<br> callback(result) Функция обратного вызова с результатом выполнения операции
| **Социальные действия**
| `instantGamesBridge.social`       | `social()`<br> Возвращает таблицу с информацией о возможных социальных действиях<br> {isShareSupported, isCommunitySupportedbr, isInviteFriendsSupported}
| `instantGamesBridge.social.share()`  | `social_share(callback)`<br> Поделиться<br> callback(result) Функция обратного вызова с результатом
| `instantGamesBridge.social.joinCommunity()`   | `social_join_community(callback)`<br> Вступить в сообщество<br> callback(result) Функция обратного вызова с результатом
| `instantGamesBridge.social.inviteFriends()`   | `social_invite_friends(callback)`<br> Пригласить друзей<br> callback(result) Функция обратного вызова с результатом

<a name="native_sdk"></a>

## Вызов нативных методов платформы

Для вызова нативного метода, получения объекта или поля предназначена
функция `call_native_sdk(method, parameters, callback)`.

- method: строка, путь до метода, объекта или поля разделенного точками. Если указан путь до объекта или поля объекта,
  то parameters и callback будет проигнорирован.
- parameters: параметр вызываемого метода (string, number, boolean, table). Если необходимо передать несколько
  параметров, то параметры необходимо поместить в массив (таблицу). Порядок параметров определяется индексом
  массива.  **Не поддерживается передача функций в качестве параметров!**
- callback: функция обратного вызова, необходимо указывать, если нативный метод возвращает промис. Если callback == nil,
  то функция возвращает результат, иначе nil.

**Результат возвращаемый функцией формируется по правилам:**

1. Параметр method ссылается на объект или поле объекта:

- Если результат string, number или boolean то возвращается таблица с результатом {value = result}.
- Если результат object, то возвращается таблица.
- В случае если произошло исключение, то данные об ошибке возвращаются в виде таблицы {error = "error description"}.

2. Параметр method ссылается на функцию:

- Если результат string, number, boolean, то возвращается таблица с результатом {value = result}.
- Если результат object, то возвращается таблица.
- В случае если произошло исключение, или промис завершился ошибкой, то данные об ошибке возвращаются в виде таблицы
  {error = "error description"}.

callback(result): result - результат выполнения промиса, если промис завершился ошибкой, то result = {error = "error
description"}.

### Расширенные действия с промисами

Бывают ситуации, когда промис возвращает объект с функциями, которые может потребоваться выполнить позже. Для этих
ситуаций предусмотрен механизм сохранения объекта на уровне JS и дальнейшего его использования при следующих вызовах
API.

В этих случаях формат параметра `method` для функции `call_native_sdk` может примнимать вид:

- `var=path1.path2.path3`: объект path1.path2.path3 будет сохранен в переменную var
- `var:method`: вызов метода из ранее сохраненного объекта
- `var2=var:method2`: вызов метода (необходимо что-бы он был промисом) из ранее сохраненного объекта и сохранение
  результата в переменной var2

### Примеры различных вариантов вызова

| Запрос к СДК          | Тип       | Вызов функции и результат
|-----------------------|-----------|------------------------------------------------------
| environment           | object    | call_native_sdk("environment")<br> table
| environment.i18n.lang | string    | call_native_sdk("environment.i18n.lang")<br> {value = string}
| env                   | undefined | call_native_sdk("env")<br> {error = 'Field or function "env" not found!'}
| player.getUniqueID()  | function  | call_native_sdk("player.getUniqueID")<br> {value = string}
| feedback.canReview()  | function  | call_native_sdk("feedback.canReview", nil, callback)<br> nil<br> После завершения промиса будет вызван callback.
| getLeaderboards().then(lb => {}) | function  | call_native_sdk("lb=getLeaderboards", nil, callback)<br> nil<br> После завершения промиса будет вызван callback.<br> Результат будет сохранен в переменной JS.
| lb.setLeaderboardScore() | function  | call_native_sdk("lb=setLeaderboardScore")<br> После завершения промиса будет вызван callback.<br> При вызове функции будет обращение к ранее сохраненной переменной JS, если она не найдена функция вернет {error = "The 'lb' object has not been previously saved!"}

### Пример нативной работы с платформой Yandex:

```lua
local instantgamesbridge = require("instantgamesbridge.instantgamesbridge")

instantgamesbridge.init(function(result)
    if result then
        -- Получить переменные окружения Яндекса, эквивалент ysdk.environment
        local environment = instantgamesbridge.call_native_sdk("environment")

        -- Получить язык интерфейса Яндекс.Игр в формате ISO 639-1, эквивалент ysdk.environment.i18n.lang
        local language = instantgamesbridge.call_native_sdk("environment.i18n.lang")

        -- Получить таблицы лидеров, эквивалент ysdk.getLeaderboards()
        -- промис возвращает объект, сохраним его в переменную lb
        instantgamesbridge.call_native_sdk("lb=getLeaderboards", nil, function(leaderboards)
            pprint(leaderboards)
            -- Запись нового рекорда, эквивалент lb.setLeaderboardScore('leaderboard2021', 120);
            -- будем обращаться к переменной lb
            instantgamesbridge.call_native_sdk("lb:setLeaderboardScore", { "leaderboard2021", 120 })
            -- Получить данные таблицы лидеров, эквивалент lb.getLeaderboardEntries('leaderboard2021')
            instantgamesbridge.call_native_sdk("lb:getLeaderboardEntries", "leaderboard2021", nil, function(result)
                pprint(result)
            end)

            -- Получить данные таблицы лидеров с параметрами
            -- эквивалент lb.getLeaderboardEntries('leaderboard2021', {quantityTop: 10, includeUser: true, quantityAround: 3})
            local parameters = {
                "leaderboard2021",
                { quantityTop = 10, includeUser = true, quantityAround = 3 }
            }
            instantgamesbridge.call_native_sdk("lb:getLeaderboardEntries", parameters, function(result)
                pprint(result)
            end)
        end)
    end
end)
```

Представленный выше код эквивалентен коду JS:

```js
YaGames
    .init()
    .then(ysdk => {
        // Получить переменные окружения Яндекса
        let environment = ysdk.environment;

        // Получить язык интерфейса Яндекс.Игр в формате ISO 639-1
        let language = ysdk.environment.i18n.lang;

        // Получить таблицы лидеров
        ysdk.getLeaderboards().then(function (lb) {
            console.log(lb);
            // Запись нового рекорда
            lb.setLeaderboardScore('leaderboard2021', 120);
            // Получить данные таблицы лидеров
            lb.getLeaderboardEntries('leaderboard2021').then(function (result) {
                console.log(result);
            });

            // Получить данные таблицы лидеров с параметрами
            let parameters = {quantityTop: 10, includeUser: true, quantityAround: 3};
            lb.getLeaderboardEntries('leaderboard2021', parameters).then(function (result) {
                console.log(result);
            });
        });
    });
```

<a name="mock"></a>

## Заглушка для других платформ, отличных от html

Для платформ отличных от html предусмотрены заглушки для удобства отладки.

При использовании функций:

- game_get_key(key, callback)
- game_set_key(key, value, callback)

данные будут сохраняться/считываться с помощью sys.save()/sys.load() локально в/из файла "instantgamesbridge.dat" (можно
поменять)

```lua
local mock_api = require("instantgamesbridge.mock_api")

-- установим имя для файла локального хранилища данных
mock_api.file_storage = "my_storage.dat"

-- установка данных payload
mock_api["platform.payload"] = { value = "payload" }
```

Каждая функция-заглушка Instant Games Bridge API может быть представлена таблицей данных или функцией выполняющее
действие и/или возвращающая данные. Любые функции/данные можно переопределять для удобства работы/отладки.

<a name="mock-native"></a>

## Заглушка для нативных вызовов

Заглушки для нативных вызовов выделены в отдельный модуль, чтобы его подключить используйте функцию `set_native_api`

```lua
--native_api.lua
local M = {}

M["environment"] = {
    app = {
        id = "app_id"
    },
    browser = {
        lang = "ru"
    },
    i18n = {
        lang = "ru",
        tld = "ru"
    }
}

return M
```

```lua
local mock = require("instantgamesbridge.mock")
local native_api = require("native_api")
local instantgamesbridge = require("instantgamesbridge.instantgamesbridge")

-- Устанавливаем заглушку для нативных функций
mock.set_native_api(native_api)
-- Обращаемся к нативной функции
local result = instantgamesbridge.call_native_sdk("environment")
pprint(result)
```
