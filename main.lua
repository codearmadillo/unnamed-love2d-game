local i18n = require("source/modules/i18n")
local f = require("source/utils/io")

function love.load()
    i18n:config('en', 'en', 'assets/i18n')
    i18n:load()
end