local Scene = {
    updates = {},
    mouseCallbacks = {},
	load = function(self)	        
        -- test_bat = Anime:new("bat", love.graphics.newImage("res/images/bat.png"), 200, 139, 1, 1, true, true)
        pp = Anime:new("pp", love.graphics.newImage("res/images/pp.png"), 200, 200)
        pp_hover = Anime:new("pp_hover", love.graphics.newImage("res/images/pp_hover.png"), 200, 200)
        test_button = Button:new("test", 0, 0, 200, 200, pp, pp_hover)
        test_dialog = Dialog:new(nil, "Just a test dialog.", font)  
        test_dialog.ticks = 0.07 --ticks control the dialog speed
        
        button_clicked = false
        button_clicked_outside = false
        test_button.onclick = function(x, y, button)
            button_clicked = true
            button_clicked_outside = false
            test_dialog:start()
        end
        test_button.onclickOutside = function(x, y, button)
            button_clicked = false
            button_clicked_outside = true
        end
    end,
    draw = function(self)
        -- test_bat:draw(0, 0)
        test_button:draw()
        if button_clicked == true then love.graphics.print("button clicked", 200, 10)
        else if button_clicked_outside == true then love.graphics.print("button clicked outside", 200, 10) end
        end
        -- love.graphics.print(test_dialog.display_text, 200, 20) 
        test_dialog:draw()
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