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

function Sprite:draw(x, y, arg1, arg2)
    local quadX = nil
    local quadY = nil

    -- arg1 is simply a number in sequence
    if (arg2 == nil) then
        quadX = arg1 % self.columns
        quadY = math.floor(arg1 % self.columns)
    else
        quadX = arg1
        quadY = arg2
    end

    local quad = self.quads[quadY][quadX]

    love.graphics.draw(self.sprite, quad, x, y)
end

return Sprite

