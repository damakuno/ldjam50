local Mail = {}

function Mail:new(mailConfig, object)
    -- TODO: Load the MailLayout.ini into mailConfig
    object = object or {
        -- TODO: List of Mail email elements, Button objects, initialize them and store them into emailButtons for easy access.
        -- TODO: store the background image in "background"
        -- TODO: email buttons should draw text on them, so mailConfig should included content for the email
        emailButtons = {},
        background = nil,
        callback = {},
        callbackFlag = {},
        visible = true
    }

    -- TODO: do the for loop here to initalize the MailButtons and store them
    setmetatable(object, self)
    self.__index = self	
    return object
end

function Mail:update(dt)

end

function Mail:draw()
    -- TODO: draw the mail elements and the background here according to mailConfig
    -- TODO: draw text content alongside the buttons, specify offset from the x,y of Button objects and fontsize here I guess
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Mail:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Mail
