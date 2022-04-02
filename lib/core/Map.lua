local Map = {}

function Map:new(mapConfig, object)
    -- TODO: Load the MapLayout.ini into mapConfig
    object = object or {
        -- TODO: List of map ui elements, Button objects, initialize them and store them into "mapButtons" for easy access.
        -- TODO: store the background image specified in mapConfig to "background"
        mapConfig = mapConfig,
        mapButtons = {},
        background = nil,
        backgroundX = 0,
        backgroundY = 0,
        callback = {},
        callbackFlag = {},
        visible = true
    }

    for key, values in pairs(mapConfig) do        
        if values.type == "Button" then            
            object.mapButtons[values.name] = Button:new(values.name,
                values.x, values.y,
                values.width, values.height,
                Anime:new(values.name.."img", love.graphics.newImage(values.image), values.width, values.height),
                Anime:new(values.name.."img_hover", love.graphics.newImage(values.imageHover), values.width, values.height),
                values.name,
                font
            )
        end
        if values.type == "Background" then        
            object.background = Anime:new(values.name, love.graphics.newImage(values.image), values.width, values.height)
            object.backgroundX = values.x            
            object.backgroundY = values.y
        end
    end
    

    setmetatable(object, self)
    self.__index = self	
    return object
end

function Map:update(dt)
    
end

function Map:draw()    
    if self.visible == true then
        self.background:draw(self.backgroundX, self.backgroundY)
    end
    for key, value in pairs(self.mapButtons) do
        if value ~= nil then value:draw() end
    end
end

function Map:show()
    for key, value in pairs(self.mapButtons) do
        if value ~= nil then value.visible = true end
    end
    self.visible = true
end

function Map:hide()
    for key, value in pairs(self.mapButtons) do          
        if value ~= nil then value.visible = false end
    end
    self.visible = false
end
-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Map:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Map
