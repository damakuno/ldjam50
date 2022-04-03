local function setPlayerText()
    player_stats_text = "cash: "..player.cash.." stress: "..player.stress.."/"..player.maxStress.." acceptance: "..player.acceptance     
end

local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)
        player = { cash = 0, stress = 30, maxStress = 100, acceptance = 0 }
        setPlayerText()

        portraits = {}
        for k, v in pairs(LIP.load("config/Portraits.ini")) do
            portraits[v.name] = Anime:new(v.name, love.graphics.newImage(v.image), v.width, v.height)
        end
        
        map = Map:new(mapConfig)
        story = Story:new("dialog/hospital_act1", portraits, font)        
        -- status text to display on button hover
        status_text = ""
        
        phone = Phone:new()

        calendar = Calendar:new()
        calendar:load()

        stats = Stats:new()        
        -- DAY 1 Hospital
        map.mapButtons["Hospital"].onhover = function()
            status_text = "Visit your sister at the hospital"
        end
        map.mapButtons["Hospital"].onclick = function()
            status_text = ""
            debug_text = "hospital clicked"
            map:hide()
            story:setNewStory("dialog/hospital_act1")
            story:registerCallback("storyend", function() debug_text = "hospital_act1 storyend triggered" end)
            story.dialogButtons["option1"].onclick = function()
                debug_text = "hospital_act1 option1 clicked"           
                story:stop()
                map:show()
            end            
            story:start()
        end

        -- DAY 1 Work
        map.mapButtons["Work"].onhover = function()
            status_text = "Go to work"
        end

        map.mapButtons["Work"].onclick = function()  
            status_text = ""               
            debug_text = "work clicked"                                   
            map:hide()
            story:setNewStory("dialog/work_act1")
            story:registerCallback("storyend", function() debug_text = "work storyend triggered" end)            
            story.dialogButtons["option1"].onclick = function()
                debug_text = "option1 clicked"
                story:stop()            
                map:show() 
            end
            story:start()
        end
    end,
    draw = function(self)
        map:draw()
        story:draw()
        phone:draw()
        stats:draw()
        calendar:draw()
        love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
        love.graphics.printf(status_text, font, 20, story.backgroundY + 20, story.background.spriteSheet:getWidth() - 20) 
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1) 
        love.graphics.print(player_stats_text, 1000, 40)
    end,
    update = function(self, dt)
        for i, obj in ipairs(self.updates) do
            if obj ~= nil then obj:update(dt) end
        end
    end,
    mousepressed = function(self, x, y, button)
        for i, obj in pairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousepressed ~=nil then obj:mousepressed(x, y, button) end
        end
    end,
    mousemoved = function(self, x, y, dx, dy, istouch)
        for i, obj in pairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousemoved ~=nil then obj:mousemoved(x, y, dx, dy, istouch) end
        end
    end
}

return Scene