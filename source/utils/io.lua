local ioUtils = {}

function ioUtils:readFileLines(path)
    local file = io.open(path, "r")
    if not file then
        print('Failed to open file at "' .. path .. '" - file does not exist')
        return {}
    end
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    return lines
end

function ioUtils:fileExists(path)
    local file = io.open(path, "rb")
    if not file then
        return false
    end
    file:close()
    return true
end

return ioUtils