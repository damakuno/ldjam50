local Mail = {}

function Mail:new(mailConfig, object)
    -- TODO: Load the MailLayout.ini into mailConfig
    object =
        object or
        {
            -- TODO: List of Mail email elements, Button objects, initialize them and store them into emailButtons for easy access.
            -- TODO: store the background image in "background"
            -- TODO: email buttons should draw text on them, so mailConfig should included content for the email
            emailButtons = {},
            background = nil,
            openedMailBG = nil,
            openedMailBGX = 958,
            openedMailBGY = 0,
            closeButton = nil,
            mailItemInitialY = 334,
            mailItemTitleTransform = love.math.newTransform(972, 348),
            mailItemContentTransform = love.math.newTransform(972, 380, 0, 0.75),
            callback = {},
            callbackFlag = {},
            visible = true,
            isMailOpen = false,
            mailItemList = {},
            curMailId = "" -- if isMailOpen == true, stores the mailId reference for mailItemList
        }

    -- TODO: do the for loop here to initalize the MailButtons and store them
    -- populate mailItemList with MailItems
    for key, values in pairs(mailItemConfig) do
        object.mailItemList[values.name] = MailItem:new(
            values.content,
            Button:new(
                values.name,
                values.x,
                values.y,
                values.width,
                values.height,
                Anime:new(values.name .. "img", love.graphics.newImage(values.image), values.width, values.height),
                Anime:new(
                    values.name .. "img_hover",
                    love.graphics.newImage(values.imageHover),
                    values.width,
                    values.height
                ),
                "",
                font
            )
        )
        object.mailItemList[values.name].title = values.title
        object.mailItemList[values.name].daySent = values.daySent
        object.mailItemList[values.name].button.text = values.title
        object.mailItemList[values.name].button.onclick = function ()
            object.mailItemList[values.name]:openMail()
            object.curMailId = values.name
            object.closeButton.visible = true
            for key, values in pairs(object.mailItemList) do
                values.button.visible = false
            end
        end
    end

    object.openedMailBG = Anime:new("Opened Mail BG", love.graphics.newImage("res/images/ui/ui_mail_bg.png"), 295, 389)
    object.openedMailBGY = love.graphics.getHeight() - object.openedMailBG.spriteSheet:getHeight()
    object.closeButton = Button:new("Mail close button",1214,347,33,33,Anime:new("Mail close button" .. "img", love.graphics.newImage("res/images/ui/ui_close_mail_button.png"), 33, 33),Anime:new("Mail close button" .. "img_hover",love.graphics.newImage("res/images/ui/ui_close_mail_button.png"),33,33),"",font)
    object.closeButton.onclick = function ()
        object.mailItemList[object.curMailId]:closeMail()
        object.closeButton.visible = false
        for key, values in pairs(object.mailItemList) do
            values.button.visible = true
        end
    end

    setmetatable(object, self)
    self.__index = self
    return object
end

function Mail:update(dt)
end

function Mail:draw()
    -- if a specific mail item is open, dont draw the mail items
    if self.isMailOpen then
        -- draw bg
        self.openedMailBG:draw(self.openedMailBGX, self.openedMailBGY)
        love.graphics.print(self.mailItemList[self.curMailId].title, font, self.mailItemTitleTransform)
        love.graphics.print(self.mailItemList[self.curMailId].content, font, self.mailItemContentTransform)
        self.closeButton:draw()
    else
        -- draw list of MailItems
        local tempid = 0
        for key, values in pairs(self.mailItemList) do
            if curDate >= values.daySent then
                values.button.y = self.mailItemInitialY + tempid * (values.button.height + 7)
                values:draw()
                tempid = tempid + 1
            end
        end
    end
    -- TODO: draw text content alongside the buttons, specify offset from the x,y of Button objects and fontsize here I guess
end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Mail:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Mail
