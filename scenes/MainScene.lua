function progressDay()
    player:resetActions()
    calendar:goToNextDay()
    -- special events can be handled by looking at curDate
    -- TODO: probably add bills to emails here
end

local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)                      
        player = Player:new()
        portraits = {}
        for k, v in pairs(LIP.load("config/Portraits.ini")) do
            portraits[v.name] = Anime:new(v.name, love.graphics.newImage(v.image), v.width, v.height)
        end
        
        map = Map:new(mapConfig)
        story = Story:new("dialog/hospital_act1", portraits, dialog_font)        
        -- status text to display on button hover
        status_text = ""
        
        phone = Phone:new()

        calendar = Calendar:new()
        calendar:load()

        stats = Stats:new()        
        
        map.mapButtons["Hospital"].onhover = function()
            status_text = "Visit your sister at the hospital"
        end
        map.mapButtons["Hospital"].onclick = function()
            player:addActions("Hospital", 1)
            status_text = ""            
            map:hide()
            if player:actionCount("Hospital") == 1 then
                story:setNewStory("dialog/hospital_act"..curDate)
            else 
                if curDate >= 4 then
                    story:setNewStory("dialog/hospital_actx2_awake")
                else
                    story:setNewStory("dialog/hospital_actx1_comatose")
                end
            end
            story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)
            if story.dialogButtons["option2"] == nil then
                story.dialogButtons["option1"].onclick = function()                    
                    --handle last action, probably different stat values for certain dates
                    player:addAcceptance(10)     
                    if player.actions == player.maxActions then progressDay() end         
                    story:stop()
                    map:show()
                end
            else
                story.dialogButtons["option1"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/hospital_act"..curDate.."_1")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                         
                        --handle last action for hospital option 1
                        player:addAcceptance(10)     
                        if player.actions == player.maxActions then progressDay() end         
                        story:stop()
                        map:show()
                    end
                end  
                story.dialogButtons["option2"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/hospital_act"..curDate.."_2")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                        
                        --handle last action for hospital option 2
                        player:reduceStress(5)
                        if player.actions == player.maxActions then progressDay() end         
                        story:stop()
                        map:show()
                    end
                end        
            end
            story:start()
        end
        
        map.mapButtons["Work"].onhover = function()
            status_text = "Go to work"
        end

        map.mapButtons["Work"].onclick = function()              
            player:addActions("Work", 1)
            status_text = ""            
            map:hide()
            if player:actionCount("Work") == 1 then
                story:setNewStory("dialog/work_act"..curDate)      
            else
                random_choice = randomInt(1, 2)
                debug_text = "random_choice rolled: "..random_choice
                story:setNewStory("dialog/work_actx"..random_choice)
            end    
            story:registerCallback("storyend", function() debug_text = story.path.."storyend triggered" end)            
            if story.dialogButtons["option2"] == nil then
                story.dialogButtons["option1"].onclick = function()                    
                    --handle last action, probably different values for certain dates
                    player:addCash(50)
                    player:addStress(13)                
                    if player.actions == player.maxActions then
                        debug_text = "player actions reached "..player.maxActions
                        progressDay()
                    end
                    story:stop()
                    map:show()                    
                end
            else
                story.dialogButtons["option1"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/work_act"..curDate.."_1")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()
                        debug_text = "option1 clicked"  
                        --handle last action for work option 1
                        player:addCash(50)
                        player:addStress(13)   
                        if player.actions == player.maxActions then progressDay() end         
                        story:stop()
                        map:show()
                    end
                end  
                story.dialogButtons["option2"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/work_act"..curDate.."_2")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()
                        debug_text = "work_act option1 clicked"  
                        --handle last action for work option 2
                        player:addCash(50)
                        player:addStress(13)
                        if player.actions == player.maxActions then progressDay() end         
                        story:stop()
                        map:show()
                    end
                end
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
        love.graphics.printf(status_text, dialog_font, 20, story.backgroundY + 20, story.background.spriteSheet:getWidth() - 20) 
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1) 
        player_stats_text = "cash: "..player.cash.." stress: "..player.stress.."/"..player.maxStress.." acceptance: "..player.acceptance
        love.graphics.print(player_stats_text, 1000, 40)
        love.graphics.print("actions: "..player.actions, 1000, 60)
        love.graphics.print("curDate: "..curDate, 1000, 80)
        love.graphics.print("Hospital: "..player.locationActions["Hospital"], 1000, 100)
        love.graphics.print("Work: "..player.locationActions["Work"], 1000, 120)
        love.graphics.print("Park: "..player.locationActions["Park"], 1000, 140)
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