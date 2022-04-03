-- Parser for .moonshot files
local Story = {}

function Story:new(path, portraits, font, object)
    object = object or {
        path = path,
        font = font,
        dialogfile = path .. ".dialog",
        dialogButtons = {},
        portraits = portraits,        
        started = false,
        story = {},
        story_index = 1,
        callback = {},
        background = nil,
        backgroundX = 0,
        backgroundY = 0,
        dialogEnd = false,
        dialogArrow = nil,
        dialogArrowX = 0,
        dialogArrowY = 0,
        dialogArrorYOffset = 0,
        dialogArrowTimer = Timer:new(0.5, function() end, false)
    }

    assert(type(object.dialogfile) == "string", 'Parameter "dialogfile" must be a string.')
    local file = assert(io.open(object.dialogfile, "r"), "Error loading dialog file : " .. object.dialogfile)

    for key, values in pairs(LIP.load(path..".ini")) do      
        if values.type == "Button" then   
            object.dialogButtons[values.name] = Button:new(values.name,
                values.x, values.y,
                values.width, values.height,
                Anime:new(values.name.."img", love.graphics.newImage(values.image), values.width, values.height),
                Anime:new(values.name.."img_hover", love.graphics.newImage(values.imageHover), values.width, values.height),                
                values.text,
                font
            )
            object.dialogButtons[values.name].visible = false
        end
    end

    for line in file:lines() do
        local k, v = line:match("(.-) (.+)$")
        if (k and v ~= nil) then
            table.insert(object.story, {
                alias = k,
                text = v
            })
        end
    end
    file:close()
    
    

    object.background = Anime:new("Dialogue BG", love.graphics.newImage("res/images/ui/ui_dialogue_bg.png"))
    object.backgroundY = love.graphics.getHeight() - object.background.spriteSheet:getHeight()

    local story = object.story[object.story_index]    
    object.dialog = Dialog:new(object.portraits, story.text, object.font, 20, object.backgroundY + 20, object.background.spriteSheet:getWidth() - 20)
    object.dialog.selectedPortraitName = object.story[object.story_index].alias    

    object.dialogArrow = Anime:new("Dialog arrow", love.graphics.newImage("res/images/ui/ui_dialogue_arrow.png"))
    object.dialogArrowX = 890
    object.dialogArrowY = 670

    object.dialogArrowTimer:addEvent(0.7, function(timer, ticks, counter, acc)
        if object.dialogArrorYOffset == 5 then 
            object.dialogArrorYOffset = 0
        else
            object.dialogArrorYOffset = 5
        end
    end)
    object.dialogArrowTimer:start()

    sh:curScene().mouseCallbacks["story"] = object
    setmetatable(object, self)
    self.__index = self
    return object
end

function Story:update(dt)
    self.dialog:update(dt)
end

function Story:draw()
    self.background:draw(self.backgroundX, self.backgroundY)    
    self.dialog:draw()
    for key, value in pairs(self.dialogButtons) do
        --TODO add color to the buttons?
        if value ~= nil then value:draw() end
    end
    if self.dialogEnd == true then
        self.dialogArrow:draw(self.dialogArrowX, self.dialogArrowY + self.dialogArrorYOffset)
    end
end

function Story:mousepressed(x, y, button)
    if button == 1 and self.started == true and self.dialog.str_index > 2 then             
        self.dialogEnd = false
        local skipped = self.dialog:skipDialog()
        if self.story_index == #(self.story) then
            return true
        else
            if not (skipped) then
                if self.story_index < #(self.story) then
                    self.story_index = self.story_index + 1
                end
                local story = self.story[self.story_index]
                self.dialog:setNewDialog(story.text, story.alias) -- add active character potrait here
            end
            return false
        end
    end
end

function Story:start()
    self.dialog:start()
    self.started = true
end

function Story:reset()
    self.story = {}
    self.story_index = 1
    self.callback = {}
    self.started = false
    for key, value in pairs(self.dialogButtons) do
        if value ~= nil then
            value:resetCallbacks()
        end
    end
    self.dialogButtons = {}
end

function Story:stop()
    self:reset()
    self.dialog:stop()
end

function Story:setNewStory(path)
    self.dialogfile = path .. ".dialog"
    self:reset()
    assert(type(self.dialogfile) == "string", 'Parameter "dialogfile" must be a string.')
    local file = assert(io.open(self.dialogfile, "r"), "Error loading dialog file : " .. self.dialogfile)

    for key, values in pairs(LIP.load(path..".ini")) do
        if values.type == "Button" then            
            self.dialogButtons[values.name] = Button:new(values.name,
                values.x, values.y,
                values.width, values.height,
                Anime:new(values.name.."img", love.graphics.newImage(values.image), values.width, values.height),
                Anime:new(values.name.."img_hover", love.graphics.newImage(values.imageHover), values.width, values.height),                
                values.text,
                font
            )
            self.dialogButtons[values.name].visible = false
        end
    end

    for line in file:lines() do
        local k, v = line:match("(.-) (.+)$")
        if (k and v ~= nil) then
            table.insert(self.story, {
                alias = k,
                text = v
            })
        end
    end
    file:close()

    

    self.started = false
    local story = self.story[self.story_index]
    self.dialog = Dialog:new(self.portraits, story.text, self.font, 20, self.backgroundY + 20, self.background.spriteSheet:getWidth() - 20)    
    self.dialog.selectedPortraitName = self.story[self.story_index].alias
end

function Story:registerCallback(event, callback)
    if event == "storyend" then
        local storyEndCallback = function(dialog)
            self.dialogEnd = true
            if self.story_index == #(self.story) then
                for key, value in pairs(self.dialogButtons) do
                    if value ~= nil then value.visible = true end
                end            
                callback(self)
            end
        end
        self.dialog:registerCallback("textend", storyEndCallback)
    else
        self.callback[event] = callback
    end
end

function Story:trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

return Story
