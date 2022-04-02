local Phone = {}

function Phone:new(object)
    object =
        object or
        {
            isOpened = false,
            background = nil,
            callback = {},
            callbackFlag = {},
            visible = true,
            defaultX = 1000,
            closedY = 680,
            openedY = 360
        }

    setmetatable(object, self)
    self.__index = self
    return object
end

function Phone:open()
    self.isOpened = true;
end

function Phone:close()
    self.isOpened = false;
end

function Phone:draw()
-- draw phone according to opened/closed
end

return Phone