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
    for key, values in pairs(mapConfig) do        
        if values.type == "Button" then            
            object.mapButtons[values.name] = Button:new(
                values.x, values.y,
                values.width, values.height,
                Anime:new(values.name.."img", love.graphics.newImage(values.image), values.width, values.height),
                Anime:new(values.name.."img_hover", love.graphics.newImage(values.imageHover), values.width, values.height)
            )
        end
    end
    
    setmetatable(object, self)
    self.__index = self	
    return object
end

function Map:update(dt)
end

function Map:draw()
    -- TODO: draw buttons and background image according to the config
    for key, value in pairs(self.mapButtons) do
        if value ~= nil then value:draw() end
    end
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Map:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Map
