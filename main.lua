SceneHandler = require "lib.utils.SceneHandler"
Timer = require "lib.utils.Timer"
Anime = require "lib.utils.Anime"
Button = require "lib.utils.Button"
LIP = require "lib.utils.LIP"

sh = SceneHandler:new()

globalUpdates = {}
globalMouseCallbacks = {}
mouse = {x = 0, y = 0, dx = 0, dy = 0, pressed = false}

function love.load()

end

function love.draw()

end

function love.update(dt)
end

function love.keyreleased(key)
    if key == "rctrl" then debug.debug() end
end

function love.mousemoved(x, y, dx, dy, istouch)
    mouse.x = x
    mouse.y = y
    mouse.dx = dx
    mouse.dy = dy
    for i, obj in ipairs(globalMouseCallbacks) do
        if obj ~= nil and obj.mousemoved ~=nil then obj:mousemoved(x, y, dx, dy, istouch) end
    end
end

function love.mousepressed(x, y, button)
    if sh:curScene().mousepressed ~= nil then
        sh:curScene().mousepressed(x, y, button)
    end
    for i, obj in ipairs(globalMouseCallbacks) do
        if obj ~= nil and obj.mousepressed ~=nil then obj:mousepressed(x, y, button) end
    end
end

function updates(dt, ...)
    local args = {...}
    for i, arg in ipairs(args) do arg:update(dt) end
end

function draws(...)
    local args = {...}
    for i, arg in ipairs(args) do arg:draw() end
end

function randomInt(min, max)
    return math.floor(math.random() * (max - min) + min)
end