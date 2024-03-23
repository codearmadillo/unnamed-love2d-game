local i18n = require("source/modules/i18n")
local ioUtils = require("source/utils/io")
local Sprite = require("source/modules/sprite")

local AttackSprite
local DeathSprite
local IdleSprite

function love.load()
    i18n:config('en', 'en', 'assets/i18n')
    i18n:load()

    AttackSprite = Sprite:new('assets/images/_Attack2.png', 6, 1)
    AttackSprite:setPlayback(1, 1, 6, 1)
    AttackSprite:setPlaybackSpeed(12)
    AttackSprite:setScaleX(-1)

    DeathSprite = Sprite:new('assets/images/_Death.png', 10, 1)
    DeathSprite:setPlayback(1, 1, 10, 1)
    DeathSprite:setPlaybackSpeed(24)

    IdleSprite = Sprite:new('assets/images/_Idle.png', 10, 1)
    IdleSprite:setPlayback(1, 1, 10, 1)
    IdleSprite:setPlaybackSpeed(6)
end

function love.draw()
    AttackSprite:draw(0, 0)
    DeathSprite:draw(128, 0)
    IdleSprite:draw(256, 0)
end

function love.update(dt)
    AttackSprite:update(dt)
    DeathSprite:update(dt)
    IdleSprite:update(dt)
end