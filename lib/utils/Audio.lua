local Audio = {}

function Audio:new(object)
    -- TODO: Load the MailLayout.ini into mailConfig
    object =
        object or
        {
            
        }

    -- sfx
    object.srcNotif = love.audio.newSource("res/audio/sfx_new_mail.mp3", "static")
    object.srcOption = love.audio.newSource("res/audio/sfx_button.mp3", "static")
    object.srcLocation = love.audio.newSource("res/audio/sfx_goto.mp3", "static")
    object.srcOpenMail = love.audio.newSource("res/audio/sfx_open_mail.mp3", "static")
    object.srcDialogueClick = love.audio.newSource("res/audio/sfx_dialogue_click.mp3", "static")
    --bgm
    object.srcDefaultBGM = love.audio.newSource("res/audio/bgm_default.mp3", "stream")

    setmetatable(object, self)
    self.__index = self
    return object
end

function Audio:playDefaultBGM()
    self.srcDefaultBGM:setVolume(0.35)
    self.srcDefaultBGM:setLooping(true)
    self.srcDefaultBGM:play()
end

function Audio:playLocationClickSFX()
    self.srcLocation:setVolume(0.2)
    self.srcLocation:setLooping(false)
    self.srcLocation:play()
end

function Audio:playNotifSFX()
    self.srcNotif:setVolume(0.2)
    self.srcNotif:setLooping(false)
    self.srcNotif:play()
end

function Audio:playDialogueClick()
    self.srcDialogueClick:setVolume(0.2)
    self.srcDialogueClick:setLooping(false)
    self.srcDialogueClick:play()
end

function Audio:playOptionClick()
    self.srcOption:setVolume(0.2)
    self.srcOption:setLooping(false)
    self.srcOption:play()
end

function Audio:playOpenMail()
    self.srcOpenMail:setVolume(0.2)
    self.srcOpenMail:setLooping(false)
    self.srcOpenMail:play()
end

function Audio:update(dt)
end

function Audio:draw()

end

-- use callbacks by calling for example: self.callback["stressMaxed"](some, parameters)
-- and also set the flag to true if you only want to trigger it once: self.callbackFlag["stressMaxed"] = true
function Audio:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Audio
