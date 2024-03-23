local Sprite = require("source/modules/sprite")

local Knight = {}
Knight.__index = Knight

local KnightState = {
    IDLE = 0,
    MOVING = 1,
    ATTACKING = 2
}

function Knight:new(x, y)
    local self = setmetatable({
        position = {
            x = x, y = y
        },
        state = KnightState.IDLE,
        states = {}
    }, Knight)

    self.states[KnightState.IDLE] = Sprite:new('assets/images/_Idle.png', 10, 1)
    self.states[KnightState.IDLE]:setPlayback(1, 1, 10, 1)

    self.states[KnightState.ATTACKING] = Sprite:new('assets/images/_Attack2.png', 6, 1)
    self.states[KnightState.ATTACKING]:setPlayback(1, 1, 6, 1)
    self.states[KnightState.ATTACKING]:setPlaybackRepeat(false)
    self.states[KnightState.ATTACKING]:setPlaybackFinishedCallback(function(sprite)
        self.state = KnightState.IDLE
        sprite:resetPlayback()
    end)

    return self
end


function Knight:draw()
    self.states[self.state]:draw()
end

function Knight:update(dt)
    if self.state == KnightState.IDLE then
        if love.keyboard.isDown("a") then
            self.state = KnightState.ATTACKING
        end
    end
    self.states[self.state]:update(dt)
end

return Knight

