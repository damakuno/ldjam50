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
        callback = {}
    }

    assert(type(object.dialogfile) == "string", 'Parameter "dialogfile" must be a string.')
    local file = assert(io.open(object.dialogfile, "r"), "Error loading dialog file : " .. object.dialogfile)

    for key, values in pairs(LIP.load(path..".ini")) do      
        if values.type == "Button" then   
            object.dialogButtons[values.name] = Button:new(
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

    local story = object.story[object.story_index]    
    object.dialog = Dialog:new(object.portraits, story.text, object.font, 20, 500, 700)
    object.dialog.selectedPortraitName = object.story[object.story_index].alias
    table.insert(sh:curScene().mouseCallbacks, object)
    setmetatable(object, self)
    self.__index = self
    return object
end

function Story:update(dt)
    self.dialog:update(dt)
end

function Story:draw()
    self.dialog:draw()
    for key, value in pairs(self.dialogButtons) do
        if value ~= nil then value:draw() end
    end
end

function Story:mousepressed(x, y, button)
    if button == 1 and self.started == true and self.dialog.str_index > 2 then        
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
            self.dialogButtons[values.name] = Button:new(
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
    self.dialog = Dialog:new(self.portaits, story.text, self.font, 20, 500, 700)
    self.dialog.selectedPortraitName = self.story[self.story_index].alias
end

function Story:registerCallback(event, callback)
    if event == "storyend" then
        local storyEndCallback = function(dialog)
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
