local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)	        
        -- test_bat = Anime:new("bat", love.graphics.newImage("res/images/bat.png"), 200, 139, 1, 1, true, true)
        pp = Anime:new("pp", love.graphics.newImage("res/images/pp.png"), 200, 200)
        pp_hover = Anime:new("pp_hover", love.graphics.newImage("res/images/pp_hover.png"), 200, 200)
        test_button = Button:new(0, 0, 200, 200, pp, pp_hover)
        
        button_clicked = false
        test_button.onclick = function(x, y, button)
            button_clicked = true
        end
    end,
    draw = function(self)
        -- test_bat:draw(0, 0)
        test_button:draw()
        if button_clicked == true then love.graphics.print("button clicked", 200, 10) end
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