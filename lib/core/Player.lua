local Player = {}

function Player:new(actions, maxActions, cash, maxCash, stress, maxStress, acceptance, maxAcceptance, object)    
    object = object or {
        actions = actions or 0,
        maxActions = maxActions or 2,        
        cash = cash or 0,
        maxCash = maxCash or 9999,
        stress = stress or 0, 
        maxStress = maxStress or 100, 
        acceptance = acceptance or 0,
        maxAcceptance = maxAcceptance or 100,
        locationActions = {},
        latePaymentStrikes = 0
    }

    object.locationActions["Hospital"] = 0
    object.locationActions["Work"] = 0
    object.locationActions["Park"] = 0

    setmetatable(object, self)
    self.__index = self	
    return object
end

function Player:update(dt)

end

function Player:addCash(value)
    local result = self.cash + value
    if result < self.maxCash then
        self.cash = result
    else
        self.cash = self.maxCash
    end
end

function Player:reduceCash(value)
    local result = self.cash - value
    if result > 0 then
        self.cash = result
    else
        self.cash = 0
    end
end

function Player:addStress(value)
    local result = self.stress + value
    if result < self.maxStress then
        self.stress = result
    else
        self.stress = self.maxStress
    end
end

function Player:reduceStress(value)
    local result = self.stress - value
    if result > 0 then
        self.stress = result
    else
        self.stress = 0
    end
end

function Player:addAcceptance(value)
    local result = self.acceptance + value
    if result < self.maxAcceptance then
        self.acceptance = result
    else
        self.acceptance = self.maxAcceptance
    end
end

function Player:reduceAcceptance(value)
    local result = self.acceptance - value
    if result > 0 then
        self.acceptance = result
    else
        self.acceptance = 0
    end
end

function Player:addActions(type, value)
    self.locationActions[type] = self.locationActions[type] + value
    self.actions = self.actions + value
end

function Player:resetActions()
    for k, v in pairs(self.locationActions) do
        self.locationActions[k] = 0
    end
    self.actions = 0
end

function Player:actionCount(type)
    return self.locationActions[type]
end

function Player:draw()

end




return Player
