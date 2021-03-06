local Dialog = {}
local utf8 = require("utf8")

function Dialog:new(portraits, text, font, x, y, limit, align, ticks, increment, object)
    object = object or {
        text = text,
        font = font,
        x = x or 10,
        y = y or 500,
        limit = limit or 760,
        align = align or "left",
        ticks = ticks or 0.025,
        increment = increment or 1,
        enabled = false,
        counter = 0,
        str_index = 1,
        display_text = "",
        displaying = false,
        selectedPortraitName = "",
        portraits = {}, -- <- two Anime objects would go here, with positions set in Portraits.ini
        callback = {},
        callbackFlag = {}
    }
    -- TODO: display portraits along with the text, probably have an object store it
    -- load the portraits from the Portraits.ini, and decide from logic which portrait to highlight/display
    setmetatable(object, self)
	table.insert(sh:curScene().updates, object)
    self.__index = self
    return object
end

function Dialog:update(dt)
    if self.enabled == true then
        self.counter = self.counter + dt
        if self.counter >= self.ticks then
            self:updateDialogText()
            self.counter = self.counter - self.ticks
        end
    end
end

function Dialog:draw()
    love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
    love.graphics.printf(self.display_text, self.font, self.x, self.y, self.limit, self.align)      
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
    if self.enabled == true then        
        local selectedPortraitDisplayName = portraitDisplayNames[self.selectedPortraitName]
        if selectedPortraitDisplayName ~= nil then
            -- love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
            love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
            love.graphics.printf(selectedPortraitDisplayName, self.font, self.x, self.y-70, self.limit, self.align)    
            love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
        end
        local selectedPortrait = portraits[self.selectedPortraitName]        
        if selectedPortrait ~= nill then
            local position = portraitPositions[self.selectedPortraitName]
            if position ~= nil then
                selectedPortrait:draw(position.x, position.y)
            else
                selectedPortrait:draw(0, 0)
            end
        end
    end
end

function Dialog:addIncrement(num)
    self.str_index = self.str_index + num
end

function Dialog:updateDialogText()
    local text = self.text
    local byteoffset = utf8.offset(text, self.str_index) or 0

    if byteoffset - 1 <= #text then
        self.displaying = true
        self:addIncrement(self.increment)
        
        print("byteoffset: "..byteoffset.." displaytextlength: "..#self.display_text.." textlength: "..#text)        
        self.display_text = text:sub(1, byteoffset - 1)
      
        local pitches = {
            [1] = 0.96,
            [2] = 0.98,
            [3] = 1.00,
            [4] = 1.02,
            [5] = 1.04
        }
        srcBlip:setPitch(pitches[randomInt(1, 5)])
        srcBlip:setVolume(0.5  * settings["Sound"].masterVolume * settings["Sound"].sfxVolume)
        srcBlip:play()
        
    end

    if byteoffset - 1 > #text or byteoffset == 0 then
        srcBlip:stop()
        if self.callback["textend"] ~= nil then
            if self.callbackFlag["textend"] == false then
                self.callback["textend"](self)
                self.callbackFlag["textend"] = true
            end
        end
        self.displaying = false        
    end
end

function Dialog:skipDialog()
    if (self.displaying == true) and (self.enabled == true) then
        local text = self.text
        self.str_index = #text - 1
        return true
    end
    return false
end

function Dialog:setNewDialog(text, selectedPortraitName)
    if self.displaying == false then
        self.text = text        
        self.selectedPortraitName = selectedPortraitName
        self.str_index = 1
        self.displaying = true                        
        if self.callbackFlag["textend"] ~= nil then
            self.callbackFlag["textend"] = false
        end                
    end
end

function Dialog:start()
    self.enabled = true    
    self.displaying = true
end

function Dialog:stop()
    self.str_index = 1
    self.text = ""
    self.display_text = ""
    self.displaying = false
    self.enabled = false
end

function Dialog:registerCallback(event, callback)
    self.callback[event] = callback
    self.callbackFlag[event] = false
end

return Dialog
