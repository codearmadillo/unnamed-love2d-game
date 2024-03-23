local i18n = require("source/modules/i18n")
local Knight = require("source/objects/knight")
local Sprite = require("source/modules/sprite")

local AttackSprite
local DeathSprite
local IdleSprite

local knight;

function love.load()
    i18n:config('en', 'en', 'assets/i18n')
    i18n:load()
    knight = Knight:new(64, 64)
end

function love.draw()
    knight:draw()
end

function love.update(dt)
    knight:update(dt)
end