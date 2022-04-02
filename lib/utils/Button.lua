local Button = {}

function Button:new(name, x, y, width, height, image, hoverImage, text, font, object)
    if width == nil then width = image.width end
    if height == nil then height = image.height end
    object = object or {
        name = name,
        x = x,
        y = y,
        width = width,
        height = height,
        image = image,
        text = text,
        font = font,
        hoverImage = hoverImage or image,
        onclick = function(x, y, button) end,
        onclickOutside = function(x, y, button) end,
        onhover = function(x, y, dx, dy, istouch) end,
        isHover = false,        
        visible = true
    }
    
    sh:curScene().mouseCallbacks[object.name] = object

    setmetatable(object, self)
    self.__index = self
    -- table.insert(sh:curScene().mouseCallbacks, object)
    
    return object
end

function Button:isWithin(mx, my)
    x1 = self.x
    y1 = self.y
    x2 = self.x + self.width
    y2 = self.y + self.height

    if (mx > x1 and mx < x2 and my > y1 and my < y2) then return true end
    return false
end

function Button:mousepressed(x, y, button)
    if self.visible ~= true then return end
    if button == 1 then
        mouse.pressed = true
        if self:isWithin(x, y) then        
            if self.onclick ~= nil then self.onclick(x, y, button) end
        else
            if self.onclickOutside ~= nil then self.onclickOutside(x, y, button) end
        end
    end
end

function Button:mousemoved(x, y, dx, dy, istouch)
    if self.visible ~= true then return end
    if self:isWithin(x, y) then        
        self.isHover = true
		if self.onclick ~= nil then self.onhover(x, y, dx, dy, istouch) end
    else
        self.isHover = false
    end
end

function Button:draw()
    if self.visible ~= true then return end
    if self.isHover == true then
        self.hoverImage:draw(self.x, self.y)
    else
        self.image:draw(self.x, self.y)
    end
    if self.text ~=nil then
        love.graphics.printf(self.text, self.font, self.x + 20, self.y + 10, self.width)
    end
end

return Button
