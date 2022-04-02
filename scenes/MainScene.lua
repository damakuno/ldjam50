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
        -- dialog text, and which character is saying them will be set in a file.
        -- dialog_text = "This is just some dialog, use this test dialog text as you wish. It can be anything really."
        -- dialog = Dialog:new(portraits, dialog_text, font, 20, 500, 700)

        map.mapButtons["Hospital"].onhover = function()
            status_text = "Visit your sister at the hospital"
        end

        map.mapButtons["Hospital"].onclick = function()                            
            map.mapButtons["Hospital"].visible = false                
            story:setNewStory("dialog/hospital_act1")
            story:registerCallback("storyend", function()
                debug_text = "storyend triggered"
                map.mapButtons["Hospital"].visible = true
                player.acceptance = player.acceptance + 5
                setPlayerText()
            end)
            story:start()
        end
    end,
    draw = function(self)
        map:draw()
        story:draw()
        love.graphics.printf(status_text, font, 20, 450, 500)
        love.graphics.print(player_stats_text, 1000, 40)
    end,
    update = function(self, dt)
        for i, obj in ipairs(self.updates) do
            if obj ~= nil then obj:update(dt) end
        end
    end,
    mousepressed = function(self, x, y, button)
        for i, obj in ipairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousepressed ~=nil then obj:mousepressed(x, y, button) end
        end
    end,
    mousemoved = function(self, x, y, dx, dy, istouch)
        for i, obj in ipairs(self.mouseCallbacks) do
            if obj ~= nil and obj.mousemoved ~=nil then obj:mousemoved(x, y, dx, dy, istouch) end
        end
    end
}

return Scene