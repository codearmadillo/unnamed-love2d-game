local ioUtils = require("source/utils/io")
local i18n = {}

function i18n:create()
    local module = {
        defaultLocale = nil,
        locale = nil,
        localePath = nil,
        keys = {}
    }
    setmetatable(module, self)
    self.__index = self
    return module
end

function i18n:config(locale, defaultLocale, localePath)
    self.defaultLocale = defaultLocale
    self.localePath = localePath
    self.locale = locale
end

function i18n:setLocale(locale)
    self:load(locale)
end

function i18n:getLocaleFilePath(locale)
    return self.localePath .. "/" .. locale .. ".csv"
end

function i18n:load(locale)
    -- Determine locale
    if locale == nil then locale = self.defaultLocale end

    -- Check that the file exist
    local path = self:getLocaleFilePath(locale)
    if ioUtils:fileExists(path) == false then
        print('Failed to load locale "' .. locale .. '" - file "' .. path .. '" does not exist')
        return
    end

    -- Load lines
    local lines = ioUtils:readFileLines(path)

    -- Create new table for keys
    local keys = {}

    -- Fill new keys
    for _, line in ipairs(lines) do
        local lineIterator = line:gmatch("[^;]+")
        local key = lineIterator()
        local value = lineIterator()
        keys[key] = value
    end

    -- Switch keys and locale
    self.locale = locale
    self.keys = keys
end

function i18n:get(key)
    if self.keys[key] ~= nil then return self.keys[key] end
    return key
end

return i18n:create()