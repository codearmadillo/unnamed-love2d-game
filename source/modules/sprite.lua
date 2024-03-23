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
        playback = nil,
        scale = {
            x = 1,
            y = 1
        }
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
        return self:drawQuad(x, y, self.playback.frameX, self.playback.frameY)
    end
    love.graphics.draw(self.sprite)
end

function Sprite:update(dt)
    if self.playback == nil then goto AnimationFinished end
    if self.playback.finished then goto AnimationFinished end

    -- Increase animation state
    self.playback.state = self.playback.state + dt;

    -- If new frame occurred, move quad pointer
    if self.playback.state >= (1 / self.playback.framesPerSecond) then
        -- bump state
        self.playback.state = self.playback.state - (1 / self.playback.framesPerSecond)

        -- increase X
        local frameX = self.playback.frameX + 1
        local frameY = self.playback.frameY

        local isAnimationLooping = false

        -- if X > columns, set X to 1, and increase Y by 1
        if frameX > self.columns then
            frameX = 1
            frameY = frameY + 1
        else
            -- animation is within row - check if frameX exceeded limit
            if frameX > self.playback.toX then
                frameX = self.playback.fromX
                frameY = self.playback.fromY
                isAnimationLooping = true
            end
        end

        if frameY > self.playback.toY then
            frameX = self.playback.fromX
            frameY = self.playback.fromY
            isAnimationLooping = true
        end

        if self.playback.repeats then
            self.playback.frameX = frameX
            self.playback.frameY = frameY
        else
            if isAnimationLooping then
                self.playback.finished = true
                if self.playback.finishedCallback ~= nil then
                    self.playback.finishedCallback(self)
                end
            else
                self.playback.frameX = frameX
                self.playback.frameY = frameY
            end
        end
    end

    ::AnimationFinished::
end

function Sprite:clearPlayback()
    self.playback = nil
end

function Sprite:setPlaybackRepeat(playbackRepeats)
    if self.playback == nil then
        return
    end
    self.playback.repeats = playbackRepeats
end

function Sprite:setPlaybackFinishedCallback(cb)
    if self.playback == nil then
        return
    end
    self.playback.finishedCallback = cb
end

function Sprite:setPlaybackSpeed(framesPerSecond)
    if self.playback == nil then
        return
    end
    self.playback.framesPerSecond = framesPerSecond
end

function Sprite:setPlayback(fromX, fromY, toX, toY)
    self.playback = {
        fromX = fromX, fromY = fromY,
        toX = toX, toY = toY,
        frameX = fromX, frameY = fromY,
        framesPerSecond = 12,
        state = 0,
        repeats = true, finished = false, finishedCallback = nil
    }
end

function Sprite:resetPlayback()
    self.playback.finished = false
    self.playback.frameX = self.playback.fromX
    self.playback.frameY = self.playback.fromY
end

function Sprite:setScale(x, y)
    self.scale.x = x
    self.scale.y = y
end

function Sprite:setScaleX(x)
    self.scale.x = x
end

function Sprite:setScaleY(Y)
    self.scale.y = y
end

return Sprite

