local Calendar = {}

function Calendar:new(calendarConfig, object)
    -- TODO: Load the CalendarLayout.ini into CalendarConfig
    object =
        object or
        {
            calendarConfig = calendarConfig,
            currentDate = 1,
            background = nil,
            callback = {},
            callbackFlag = {},
            visible = true,
            -- for date display formatting
            month = "Marzo",
            startDate = 4,
            numDays = 8,
            -- default position when phone is closed
            defaultX = 995,
            defaultY = 490,
            diffY = 244,
        }

    setmetatable(object, self)
    self.__index = self
    return object
end

function Calendar:initDayList()
    dayList = {}
    for i = 1, self.numDays do
        dayList[i] = (self.startDate + i) .. " " .. self.month
    end
end

-- function for expanding the current date to an array of 5? dates
function Calendar:expandToList()
    curDate = self.currentDate
    -- TODO: return a list of 5? dates
end

function Calendar:goToNextDay()
    if curDate < self.numDays then
        -- curDate = curDate + 1
        self.currentDate = self.currentDate + 1
    end
end

function Calendar:load()
    self:initDayList()
    closedTransform = love.math.newTransform(self.defaultX, self.defaultY, 0, 1.25)
    openedTransform = love.math.newTransform(self.defaultX, self.defaultY - self.diffY, 0, 1.25)
end

function Calendar:update(dt)
end

function Calendar:draw()
    calList = self:expandToList()
    -- draw background if necessary

    -- draw date in appropriate position based on whether phone is opened or closed
    if phone.isOpened then
        love.graphics.print(dayList[curDate], font, openedTransform)
    else
        love.graphics.print(dayList[curDate], font, closedTransform)
    end

    -- draw the 5 dates sequentially with an offset between them
    -- use the visible flag if necessary to hide/show it
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Calendar:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Calendar
