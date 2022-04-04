function progressDay()
    fadeAlpha = 1
    triggerFade = true
    player:resetActions()
    calendar:goToNextDay()
    -- special events can be handled by looking at curDate
    -- TODO: probably add bills to emails here
    -- check if player has enough money to pay hospital
    if curDate == 7 then
        --TODO: logic for ending
        if player.acceptance >= 35 then
            debug_text = "acceptance best ending"
            gameEnd("ending3_good")
        elseif player.acceptance < 35 and player.acceptance >= 15 then
            debug_text = "acceptance average ending"
            gameEnd("ending3_average")
        elseif player.acceptance < 15 then
            debug_text = "acceptance low ending"
            gameEnd("ending3_bad")
        end
    elseif player.stress == 100 then
        debug_text = "stress ending"
        gameEnd("ending2")
    elseif player.cash < bills then
        if player.latePaymentStrikes == 0 then
            mail:SendBillsWarningMail()
            player.latePaymentStrikes = 1
        else
            debug_text = "gameEnd trigger"            
            gameEnd("ending1")
        end
    else
        player:reduceCash(bills)
    end
    bills = bills + 5 -- dummy constant now. TODO turn into variable cumulative debt?
end

function gameEnd(ending)
    story:setNewStory("dialog/endings/"..ending)
    storyType = "Ending"
    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)
    story.dialogButtons["option1"].onclick = function()
        love.event.quit("restart")
    end
    story.dialogButtons["option2"].onclick = function()  
        love.event.quit(0)
    end
    story:start()
end

local Scene = {        
    updates = {},
    mouseCallbacks = {},
	load = function(self)        
        triggerFade = false
        timeOfDay = "morning"
        bills = 35
        hoverButtonName = ""
        storyType = ""
        player = Player:new()        
        portraits = {}
        portraitPositions = {}
        portraitDisplayNames = {}
        for k, v in pairs(LIP.load("config/Portraits.ini")) do
            portraits[v.name] = Anime:new(v.name, love.graphics.newImage(v.image), v.width, v.height)
            portraitDisplayNames[v.name] = v.displayName
            portraitPositions[v.name] = {x = v.x, y = v.y}
        end
        
        map = Map:new(mapConfig)
        story = Story:new("dialog/hospital_act1", portraits, dialog_font)        
        -- status text to display on button hover
        status_text = ""
        
        phone = Phone:new()

        calendar = Calendar:new()
        calendar:load()

        stats = Stats:new()
        mail = Mail:new()
        
        map.mapButtons["Hospital"].onhover = function()
            status_text = "Visit your sister at the hospital"
        end
        map.mapButtons["Hospital"].onclick = function()
            storyType = "Hospital"
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
                    debug_text = "hopsital option 1 clicked"
                    --handle last action, probably different stat values for certain dates
                    player:addAcceptance(7)     
                    story:stop()
                    if player.actions == player.maxActions then progressDay() end    
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
                        player:addAcceptance(7)         
                        story:stop()
                        if player.actions == player.maxActions then 
                            progressDay()                                                      
                        -- trigger ending if it's day 7 and player visits hospital                    
                        elseif curDate == 7 then
                            progressDay()
                        end   
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
                        story:stop()
                        if player.actions == player.maxActions then
                            progressDay()                             
                        -- trigger ending if it's day 7 and player visits hospital                    
                        elseif curDate == 7 then
                            progressDay()
                        end     
                        map:show()
                    end
                end        
            end
            story:start()
        end
        
        map.mapButtons["Work"].onhover = function()
            status_text = "Go to work to earn money"
        end

        day3_option2_selected = false
        map.mapButtons["Work"].onclick = function()    
            storyType = "Work"          
            player:addActions("Work", 1)
            status_text = ""            
            map:hide()
            if player:actionCount("Work") == 1 and not (curDate == 4 and player:actionCount("Hospital") == 1) then
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
                    if curDate == 4 or curDate == 5 or curDate == 6 then
                        player:addCash(25)
                    -- extra pay and stress if option2 selected on day 3
                    elseif curDate == 3 and (player:actionCount("Work") == 2 or player:actionCount("Work") == 3) and day3_option2_selected == true then
                        player:addCash(70)
                        player:addStress(5)
                    else
                        player:addCash(50)
                    end
                    player:addStress(13)      
                    story:stop()          
                    if player.actions == player.maxActions then
                        debug_text = "player actions reached "..player.maxActions
                        progressDay()
                    end
                    map:show()                    
                end
            else
                story.dialogButtons["option1"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/work_act"..curDate.."_1")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                        
                        --handle last action for work option 1
                        if curDate == 5 or curDate == 6 then
                            player:addCash(25)
                        else
                            player:addCash(50)
                        end
                        player:addStress(13)      
                        story:stop()
                        if player.actions == player.maxActions then progressDay() end    
                        map:show()
                    end
                end
                story.dialogButtons["option2"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/work_act"..curDate.."_2")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                        
                        --handle last action for work option 2
                        -- half pay for days 5,6
                        if curDate == 5 or curDate == 6 then
                            player:addCash(25)
                        -- extra pay and stress if option2 selected on day 3
                        elseif curDate == 3 then
                            day3_option2_selected = true
                            player:addCash(70)
                            player:addStress(5)
                        else
                            player:addCash(50)
                        end
                        player:addStress(13)    
                        story:stop()
                        if player.actions == player.maxActions then progressDay() end     
                        map:show()
                    end
                end
            end
            story:start()
        end

        map.mapButtons["Park"].onhover = function()
            status_text = "Go to the park to release stress"
        end
        map.mapButtons["Park"].onclick = function() 
            storyType = "Park"
            -- don't count as action on day 4 (visit the sister instead)
            if curDate ~= 4 then player:addActions("Park", 1) end
            status_text = ""            
            map:hide()
            if player:actionCount("Park") == 1 or curDate == 4 then
                story:setNewStory("dialog/park_act"..curDate)      
            else
                random_choice = randomInt(1, 2)
                debug_text = "random_choice rolled: "..random_choice
                story:setNewStory("dialog/park_actx"..random_choice)
            end    
            story:registerCallback("storyend", function() debug_text = story.path.."storyend triggered" end)            
            if story.dialogButtons["option2"] == nil then
                story.dialogButtons["option1"].onclick = function()                    
                    --handle last action, probably different values for certain dates                    
                    -- on day 4, continue shouldn't reduce stress, park is closed
                    if curDate ~= 4 then 
                        player:reduceStress(8) 
                    end
                    story:stop()
                    if player.actions == player.maxActions then
                        debug_text = "player actions reached "..player.maxActions
                        progressDay()
                    end
                    map:show()                    
                end
            else
                story.dialogButtons["option1"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/park_act"..curDate.."_1")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                        
                        --handle last action for park option 1                  
                        player:addAcceptance(5)
                        player:reduceStress(8)         
                        story:stop()
                        if player.actions == player.maxActions then progressDay() end 
                        map:show()
                    end
                end  
                story.dialogButtons["option2"].onclick = function()
                    story:stop()
                    story:setNewStory("dialog/park_act"..curDate.."_2")
                    story:start()
                    story:registerCallback("storyend", function() debug_text = story.path.." storyend triggered" end)                    
                    story.dialogButtons["option1"].onclick = function()                        
                        --handle last action for work option 2             
                        player:reduceStress(8)     
                        story:stop()
                        if player.actions == player.maxActions then progressDay() end     
                        map:show()
                    end
                end
            end
            story:start()
        end

        fadeAlpha = 0
    end,
    draw = function(self)
        love.graphics.setBackgroundColor(238 / 255, 238 / 255, 238 / 255, 1)
        map:draw()
        story:draw()
        phone:draw()
        stats:draw()
        love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
        love.graphics.printf(status_text, dialog_font, 20, story.backgroundY + 20, story.background.spriteSheet:getWidth() - 20)         
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 205, 1)        
        love.graphics.printf(timeOfDay, font, 995, 280, 200)
        love.graphics.printf("bill: "..bills, font, 1125, 280, 200) 
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1) 
        player_stats_text = "cash: "..player.cash.." stress: "..player.stress.."/"..player.maxStress.." acceptance: "..player.acceptance
        
        if settings["Misc"].debug == 1 then
            love.graphics.print(player_stats_text, 1000, 40)
            love.graphics.print("actions: "..player.actions, 1000, 60)
            love.graphics.print("curDate: "..curDate, 1000, 80)
            love.graphics.print("Hospital: "..player.locationActions["Hospital"], 1000, 100)
            love.graphics.print("Work: "..player.locationActions["Work"], 1000, 120)
            love.graphics.print("Park: "..player.locationActions["Park"], 1000, 140)
            love.graphics.print("hoverButtonName: "..hoverButtonName, 1000, 160)
        end
        love.graphics.setColor(0 / 255, 0 / 255, 0 / 255, fadeAlpha) 
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(),love.graphics.getHeight())
    end,
    update = function(self, dt)
        if triggerFade == true then
            fadeAlpha = fadeAlpha - dt
            if fadeAlpha < 0 then
                triggerFade = false
            end
        end
        for i, obj in ipairs(self.updates) do
            if obj ~= nil then obj:update(dt) end
        end
    end,
    mousepressed = function(self, x, y, button)
        if triggerFade == true then return end
        for i, obj in pairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousepressed ~=nil then obj:mousepressed(x, y, button) end
        end
    end,
    mousemoved = function(self, x, y, dx, dy, istouch)        
        if map.mapButtons["Park"].isHover then
            hoverButtonName = "Park"
        elseif map.mapButtons["Hospital"].isHover then
            hoverButtonName = "Hospital"
        elseif map.mapButtons["Work"].isHover then
            hoverButtonName = "Work"
        elseif story.dialogButtons["option1"] ~= nil then
            if story.dialogButtons["option1"].isHover then
                hoverButtonName = "option1"
            else
                hoverButtonName = ""
            end
            if story.dialogButtons["option2"] ~= nil then
                if story.dialogButtons["option2"].isHover then
                    hoverButtonName = "option2"
                else
                    hoverButtonName = ""
                end
            end
        else
            hoverButtonName = ""
        end        

        for i, obj in pairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousemoved ~=nil then obj:mousemoved(x, y, dx, dy, istouch) end
        end
    end
}

return Scene