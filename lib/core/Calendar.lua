local Calendar = {}

function Calendar:new(calendarConfig, object)
    -- TODO: Load the CalendarLayout.ini into CalendarConfig
    object = object or {
        calendarConfig = calendarConfig,
        currentDate = 1,        
        background = nil,
        callback = {},
        callbackFlag = {},
        visible = true
    }
    
    setmetatable(object, self)
    self.__index = self	
    return object
end

-- function for expanding the current date to an array of 5? dates
function Calendar:expandToList()
    curDate = self.currentDate
    -- TODO: return a list of 5? dates
end

function Calendar:update(dt)

end

function Calendar:draw()
    -- draw background if necessary
    -- get the position of the calendar from the config
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
