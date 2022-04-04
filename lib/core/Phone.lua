local Phone = {}

function Phone:new(object)
    object =
        object or
        {
            isOpened = true,
            background = nil,
            callback = {},
            callbackFlag = {},
            visible = true,
            offsetX = 5,
            diffY = 244
            -- closedY = 680,
            -- openedY = 360
        }

    object.background = Anime:new("Phone BG", love.graphics.newImage("res/images/ui/ui_phone_bg.png"))

    setmetatable(object, self)
    self.__index = self
    return object
end

function Phone:open()
    self.isOpened = true
end

function Phone:close()
    self.isOpened = false
end

function Phone:draw()
    -- draw phone according to opened/closed
    if self.isOpened then
        self.background:draw(
            1280 - self.background.spriteSheet:getWidth() - self.offsetX,
            720 - self.background.spriteSheet:getHeight()
        )
    else
        self.background:draw(
            1280 - self.background.spriteSheet:getWidth() - self.offsetX,
            720 - self.background.spriteSheet:getHeight() + self.diffY
        )
    end

    calendar:draw()
    mail:draw()
end

return Phone
