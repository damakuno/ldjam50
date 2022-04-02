local function setPlayerText()
    player_stats_text = "cash: "..player.cash.." stress: "..player.stress.."/"..player.maxStress.." acceptance: "..player.acceptance     
end

local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)
        player = { cash = 0, stress = 30, maxStress = 100, acceptance = 0 }   
        setPlayerText()
        map = Map:new(mapConfig)
        
        -- map button behaviour
        map.mapButtons["Hospital"].onclick = function(x, y, button)
            debug_text = player.stress - 5
            player.stress = (player.stress - 5)
            setPlayerText()
        end
    end,
    draw = function(self)
        map:draw()
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