SceneHandler = require "lib.utils.SceneHandler"
Timer = require "lib.utils.Timer"
Anime = require "lib.utils.Anime"
Button = require "lib.utils.Button"
LIP = require "lib.utils.LIP"
Dialog = require "lib.utils.Dialog"
Map = require "lib.core.Map"
Mail = require "lib.core.Mail"
MailItem = require "lib.core.MailItem"
Calendar = require "lib.core.Calendar"
Story = require "lib.core.Story"
Phone = require "lib.core.Phone"
Stats = require "lib.core.Stats"
Player = require "lib.core.Player"

sh = SceneHandler:new()

globalUpdates = {}
globalMouseCallbacks = {}
mouse = { x = 0, y = 0, dx = 0, dy = 0, pressed = false }

function love.load()
    debug_text = "debug"
    love.window.setMode(1280, 720)
    font = love.graphics.newFont("res/fonts/Pangolin-Regular.ttf", 24)
    dialog_font = love.graphics.newFont("res/fonts/Pangolin-Regular.ttf", 36)
    srcBlip = love.audio.newSource("res/audio/blip2.wav", "static")
    mapConfig = LIP.load('config/MapLayout.ini')
    mailItemConfig = LIP.load('config/MailItems.ini')
    settings = LIP.load('config/Settings.ini')
    sh:setScene(1)    
end

function love.draw()
    sh:curScene():draw()
    love.graphics.setColor(135 / 255, 76 / 255, 71 / 255, 1)
    if settings["Misc"].debug == 1 then
        love.graphics.print(debug_text, 500, 20)    
        love.graphics.print("x: "..mouse.x.." y: "..mouse.y, 500, 40)
    end
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 1)
end

function love.update(dt)
    sh:curScene():update(dt)
    for i, obj in ipairs(globalUpdates) do
        if obj ~= nil then obj:update(dt) end
    end
end

function love.keyreleased(key)
    if key == "rctrl" then debug.debug() end
end

function love.mousemoved(x, y, dx, dy, istouch)
    mouse.x = x
    mouse.y = y
    mouse.dx = dx
    mouse.dy = dy
    if sh:curScene().mousemoved ~= nil then
        sh:curScene():mousemoved(x, y, dx, dy, istouch)
    end
    for i, obj in ipairs(globalMouseCallbacks) do
        if obj ~= nil and obj.mousemoved ~=nil then obj:mousemoved(x, y, dx, dy, istouch) end
    end
end

function love.mousepressed(x, y, button)
    if sh:curScene().mousepressed ~= nil then
        sh:curScene():mousepressed(x, y, button)
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
    math.randomseed(os.time())
    math.random()
    math.random() 
    math.random()
    return math.floor(math.random() * (max - min + 1) + min)
end