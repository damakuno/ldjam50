local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)	
        test_bat = Anime:new("bat", love.graphics.newImage("res/images/bat.png"), 200, 139, 1, 1, true, true)
    end,
    draw = function(self)
        test_bat:draw(0, 0)
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
    end
}

return Scene