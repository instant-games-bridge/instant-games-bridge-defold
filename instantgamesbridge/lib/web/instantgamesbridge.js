// https://kripken.github.io/emscripten-site/docs/porting/connecting_cpp_and_javascript/Interacting-with-code.html
let LibraryInstantGamesBridge = {
    // This can be accessed from the bootstrap code in the .html file
    $InstantGamesBridgeLib: {
        _callback: null,
        _igb: null,
        _data: {},

        init_callbacks: function (igb, callback_ids) {
            igb.advertisement.on('interstitial_state_changed', (state) => InstantGamesBridgeLib.send(callback_ids.interstitial_state_changed, state))
            igb.advertisement.on('rewarded_state_changed', (state) => InstantGamesBridgeLib.send(callback_ids.rewarded_state_changed, state))
        },

        send: function (callback_id, data) {
            if (InstantGamesBridgeLib._callback && callback_id > 0) {
                let message = data === undefined || data === null ? "" :
                    typeof (data) === "object" ? JSON.stringify(data) :
                        typeof (data) === "string" ? data : data.toString();
                let msg = allocate(intArrayFromString(message), ALLOC_NORMAL);
                {{{makeDynCall("viii", "InstantGamesBridgeLib._callback")}}}(callback_id, msg);
                Module._free(msg);
            }
        },

        call_api: function (method, parameters, callback_id, native_api) {
            let method_name = UTF8ToString(method);
            let string_parameters = UTF8ToString(parameters);
            let save_as_var = null;
            let saved_object = null;
            if (native_api) {
                let method_parse = method_name.split("=");
                if (method_parse[1]) {
                    save_as_var = method_parse[0];
                    method_name = method_parse[1];
                }
                method_parse = method_name.split(":");
                if (method_parse[1]) {
                    saved_object = InstantGamesBridgeLib._data[method_parse[0]];
                    if (!saved_object) {
                        let error = `The "${method_parse[0]}" object has not been previously saved!`;
                        return JSON.stringify({error: error});
                    }
                    method_name = method_parse[1];
                }
            }
            let path = method_name.split(".");
            let parent_object = native_api ? saved_object ? saved_object :
                InstantGamesBridgeLib._igb.platform.sdk : InstantGamesBridgeLib._igb;
            let result_object = parent_object;
            let last_index = path.length - 1
            for (let index = 0; index < path.length; index++) {
                let item = path[index];
                if (parent_object[item]) {
                    if (index === last_index) {
                        result_object = parent_object[item];
                    } else {
                        parent_object = parent_object[item];
                    }
                } else {
                    let error = `Field or function "${method_name}" not found!`;
                    return JSON.stringify({error: error});
                }
            }
            let array_parameters = JSON.parse(string_parameters);
            switch (typeof result_object) {
                case "string":
                case "number":
                case "boolean":
                    return JSON.stringify({value: result_object});
                case "object":
                    if (native_api) {
                        try {
                            return JSON.stringify(result_object);
                        } catch (error) {
                            return JSON.stringify({error: error});
                        }
                    }
                    let result = {};
                    for (let item in result_object) {
                        let type = typeof (result_object[item]);
                        if (type === "string" || type === "boolean" || type === "number") {
                            result[item] = result_object[item];
                        }
                    }
                    array_parameters.forEach(function (item) {
                        result[item] = result_object[item];
                    });
                    return JSON.stringify(result);
                case "function":
                    try {
                        let called_function = result_object.bind(parent_object);
                        if (callback_id === 0) {
                            let result = called_function(...array_parameters);
                            switch (typeof result) {
                                case "string":
                                case "number":
                                case "boolean":
                                    return JSON.stringify({value: result});
                                case "object":
                                    return JSON.stringify(result);
                            }
                            return JSON.stringify({error: `"${typeof result}" type not supported!`});
                        } else {
                            called_function(...array_parameters).then(
                                function (success) {
                                    if (save_as_var) {
                                        InstantGamesBridgeLib._data[save_as_var] = success
                                    }
                                    InstantGamesBridgeLib.send(callback_id, success);
                                }).catch(
                                function (error) {
                                    InstantGamesBridgeLib.send(callback_id, JSON.stringify({error: error}));
                                })
                        }
                    } catch (error) {
                        return JSON.stringify({error: error});
                    }
                    return;
                default:
                    return JSON.stringify({error: `"${typeof result_object}" type not supported!`});
            }
        },
    },

    // These can be called from within the extension, in C++
    InstantGamesBridge_RegisterCallback: function (callback) {
        InstantGamesBridgeLib._callback = callback;
    },

    InstantGamesBridge_RemoveCallback: function () {
        InstantGamesBridgeLib._callback = null;
    },

    InstantGamesBridge_Init: function (parameters, callback_id) {
        let callback_ids = JSON.parse(UTF8ToString(parameters));
        InstantGamesBridgeLib.init = function (igb, initResult) {
            InstantGamesBridgeLib._igb = igb;
            if (initResult === true) {
                InstantGamesBridgeLib.init_callbacks(igb, callback_ids);
            }
            InstantGamesBridgeLib.send(callback_id, initResult);
        }
        if (window.InstantGamesBridgeInit !== undefined) {
            InstantGamesBridgeLib.init(window.InstantGamesBridgeInstance, window.InstantGamesBridgeInit);
        }
    },

    InstantGamesBridge_CallApi: function (method, parameters, callback_id, native_api) {
        let result = InstantGamesBridgeLib.call_api(method, parameters, callback_id, native_api);
        if (result) {
            if (callback_id > 0) {
                InstantGamesBridgeLib.send(callback_id, result)
            }
            return allocate(intArrayFromString(result), ALLOC_NORMAL);
        }
    },
}

autoAddDeps(LibraryInstantGamesBridge, '$InstantGamesBridgeLib');
mergeInto(LibraryManager.library, LibraryInstantGamesBridge);