local Stats = {}

function Stats:new(object)
    object =
        object or
        {
            isOpened = true,
            monitorBG = nil,
            walletBG = nil,
            lineSprites = {},
            callback = {},
            callbackFlag = {},
            visible = true,
            offsetX = 10,
            monitorBGX = 0,
            monitorBGY = 0,
            walletBGX = 0,
            walletBGY = 90,
            lineX = 0,
            lineY = 32,
            moodImages = {},
            moodX = 0,
            moodY = 130,
            font = love.graphics.newFont("res/fonts/BIZUDGothic-Bold.ttf", 42)
        }    


    object.monitorBG = Anime:new("Monitor BG", love.graphics.newImage("res/images/ui/ui_stats_bg.png"))
    object.monitorBGX = love.graphics.getWidth() - object.monitorBG.spriteSheet:getWidth() - object.offsetX
    object.walletBG = Anime:new("Wallet BG", love.graphics.newImage("res/images/ui/ui_wallet_bg.png"))
    object.walletBGX = love.graphics.getWidth() - object.walletBG.spriteSheet:getWidth()
    for i=1, 6 do
        object.lineSprites[i] = Anime:new("Stress Line "..i, love.graphics.newImage("res/images/ui/ui_stats_line"..i..".png"))
    end
    object.lineX = object.monitorBGX + 47

    for i=1, 6 do
        object.moodImages[i]= Anime:new("Mood "..i, love.graphics.newImage("res/images/ui/ui_PortraitMC_stress"..i..".png"))
    end
    object.moodX = object.monitorBGX - 50

    setmetatable(object, self)
    self.__index = self
    return object
end

function Stats:draw()
    local stressTier = math.floor(player.stress / (player.maxStress / 5)) + 1

    -- draw monitor
    self.monitorBG:draw(self.monitorBGX, self.monitorBGY)
    self.lineSprites[stressTier]:draw(self.lineX, self.lineY)
    self.moodImages[stressTier]:draw(self.moodX, self.moodY)
    love.graphics.print({{126 / 255, 215 / 255, 55 / 255, 1}, player.stress}, self.font, 1185, 55)

    -- draw wallet
    self.walletBG:draw(self.walletBGX, self.walletBGY)
    love.graphics.print("$ " .. player.cash, font, self.walletBGX + 17, self.walletBGY + 90)             
end

return Stats
