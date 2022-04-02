local MainScene = require "scenes.MainScene"
local SceneHandler = {}

function SceneHandler:new(sceneIndex, object)
    object = object or
	{
		Scenes = {
			[1] = MainScene			
		},
		Timers = {
			[1] = {}
		},
		SceneIndex = 1 or sceneIndex
	}
    setmetatable(object, self)
    self.__index = self
    return object
end

function SceneHandler:setScene(numIndex) 
	self.SceneIndex = numIndex
	self.Scenes[self.SceneIndex].load()
end

function SceneHandler:curScene()
	return self.Scenes[self.SceneIndex]
end

return SceneHandler
