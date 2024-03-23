local ioUtils = require("source/utils/io")

local Sprite = {}
Sprite.__index = Sprite

function Sprite:new(filePath, columns, rows)
    local self = setmetatable({
        filePath = filePath,
        columns = columns,
        rows = rows,
        sprite = nil,
        quads = {},
        dimensions = {
            width = nil,
            height = nil,
            tileWidth = nil,
            tileHeight = nil
        },
        playback = nil
    }, Sprite)
    self:load()
    return self
end

function Sprite:load()
    if ioUtils:fileExists(self.filePath) == false then
        print('Failed to load sprite "' .. self.filePath .. '" - file does not exist')
        return
    end

    self.sprite = love.graphics.newImage(self.filePath)
    self.dimensions.width = self.sprite:getWidth()
    self.dimensions.height = self.sprite:getHeight()
    self.dimensions.tileWidth = math.floor(self.dimensions.width / self.columns)
    self.dimensions.tileHeight = math.floor(self.dimensions.height / self.rows)

    for y = 1, self.rows do
        self.quads[y] = {}
        for x = 1, self.columns do
            self.quads[y][x] = love.graphics.newQuad(
                (x - 1) * self.dimensions.tileWidth, (y - 1) * self.dimensions.tileHeight,
                self.dimensions.tileWidth, self.dimensions.tileHeight,
                self.sprite
            )
        end
    end
end

function Sprite:drawQuad(x, y, quadX, quadY)
    local quad = self.quads[quadY][quadX]
    love.graphics.draw(self.sprite, quad, x, y)
end

function Sprite:draw(x, y)
    if self.playback then
        self:drawQuad(x, y, self.playback.frameX, self.playback.frameY)
        return
    end
    love.graphics.draw(self.sprite)
end

function Sprite:update(dt)
    if self.playback ~= nil then
        self.playback.state = self.playback.state + dt;
        if self.playback.state >= (1 / self.playback.framesPerSecond) then
            self.playback.state = self.playback.state - (1 / self.playback.framesPerSecond)



            -- increase X
            local frameX = self.playback.frameX + 1
            local frameY = self.playback.frameY

            -- if X > columns, set X to 1, and increase Y by 1
            if frameX > self.columns then
                frameX = 1
                frameY = frameY + 1
            end

            -- check if X and Y are within animation constraints - if not, move them to start
            if frameX > self.playback.toX and frameY > self.playback.toY then
                frameX = self.playback.fromX
                frameY = self.playback.fromY
            end

            -- save new playback state
            self.playback.frameX = frameX
            self.playback.frameY = frameY
        end
    end
end

function Sprite:clearPlayback()
    self.playback = nil
end

function Sprite:setPlayback(fromX, fromY, toX, toY, framesPerSecond)
    self.playback = {
        fromX = fromX, fromY = fromY,
        toX = toX, toY = toY,
        frameX = fromX, frameY = fromY,
        framesPerSecond = framesPerSecond,
        state = 0
    }
end

return Sprite

