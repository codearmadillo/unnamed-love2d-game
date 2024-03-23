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
    DeathSprite = Sprite:new('assets/images/_Death.png', 10, 1)
    IdleSprite = Sprite:new('assets/images/_Idle.png', 10, 1)
end

function love.draw()
    AttackSprite:draw(0, 0, 1, 1)
    DeathSprite:draw(64, 0, 1, 1)
    IdleSprite:draw(128, 0, 1, 1)
end