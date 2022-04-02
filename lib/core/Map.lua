local Map = {}

function Map:new(mapConfig, object)
    -- TODO: Load the MapLayout.ini into mapConfig
    object = object or {
        -- TODO: List of map ui elements, Button objects, initialize them and store them into "mapButtons" for easy access.
        -- TODO: store the background image specified in mapConfig to "background"
        mapConfig = mapConfig,
        mapButtons = {},
        background = nil,
        callback = {},
        callbackFlag = {},
        visible = true
    }

    -- TODO: do the for loop here to initalize the mapButtons and store them
    setmetatable(object, self)
    self.__index = self	
    return object
end

function Map:update(dt)

end

function Map:draw()
    -- TODO: draw buttons and background image according to the config
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Map:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Map
