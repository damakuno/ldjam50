local MailItem = {}

function MailItem:new(content, button, object)
    -- TODO: Load the MailItemLayout.ini into MailItemConfig
    object = object or {
        title="",
        content = content,
        daySent=0,
        button = button,
        background = nil,
        callback = {},
        callbackFlag = {},
        visible = true,
        isRead=false
    }

    -- TODO: specify button onclickOutside event to hide the content and background, the button doesn't need an image.
    -- the button should cover the window of the pop-out content
    -- altrnatively if this system is too complicated we can show the email content in the dialog box
    -- if no time, skip this functionality alltogether, make emails just a "display"
    setmetatable(object, self)
    self.__index = self	
    return object
end

function MailItem:openMail()
    self.isRead = true
    mail.isMailOpen = true
end

function MailItem:closeMail()
    mail.isMailOpen = false
end

function MailItem:update(dt)

end

function MailItem:draw()
    self.button:draw()
    -- TODO: draw the MailItem pop up when the button is clicked
    -- TODO: don't draw after clicking outside of the button
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function MailItem:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return MailItem
