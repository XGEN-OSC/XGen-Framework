---@class StringUtils A collection of utility functions
---for string manipulation.
StringUtils = {}

---Replaces placeholders between dollar signs in a string
---with the result of evaluating the Lua expression and 
---placeholders between curly braces in a string
---with corresponding values from a table.
---@nodiscard
---@param str string The string containing placeholders.
---@param values table<string, any>? A table with the keys and values
---of the placeholders to replace.
---@return string formatted the formatted string
function StringUtils.format(str, values)
    str = str:gsub("${(.-)}", function(lua)
        local ok, result = pcall(function (...)
            local luaStr = "return " .. string.sub(lua, 1, -1)
            local fn = assert(load(luaStr))
            local ok, result = pcall(fn)
            return tostring(result)
        end)
        if not ok then
            return "$" .. lua
        end
        return result
    end)
    if not values then
        return str
    end
    str = str:gsub("{(.-)}", function(key)
        return tostring(values[key])
    end)
    return str
end


---Dumps a table into a string representation.
---@nodiscard
---This is useful for debugging purposes.
---@param tbl table The table to dump.
---@param parents table<table>? parent tables
---@return string str The string representation of the table.
function StringUtils.dumpTable(tbl, parents)
    parents = parents or {tbl}
    if type(tbl) ~= "table" then
        return tostring(tbl)
    end

    local function append(tbl)
        local par = {}
        for k, v in pairs(parents) do
            table.insert(par, v)
        end
        table.insert(par, tbl)
        return par
    end

    local function isParent(tbl)
        for _, v in ipairs(parents) do
            if v == tbl then
                return true
            end
        end
        return false
    end

    local str = "{ "
    local empty = true

    for k, v in pairs(tbl) do
        empty = false
        if type(v) == "table" then
            if isParent(v) then
                str = str .. k .. " = <circular reference (" .. tostring(v) .. ")>, "
            else
                str = str .. k .. " = " .. StringUtils.dumpTable(v, append(v)) .. ", "
            end
        elseif type(v) == "string" then
            str = str .. k .. ' = "' .. v .. '", '
        else
            str = str .. k .. " = " .. tostring(v) .. ", "
        end
    end

    if not empty then
        str = str:sub(1, -3)
    else
        str = str:sub(1, -2)
    end

    str = str .. " }"
    return str
end


---Generates a formatted string based on the provided format.
---@nodiscard
---@param format string The format for the string. A will be replaced with a random upper case letter,
---a will be replaced with a random lower case letter, and 0 will be replaced with a random digit,
---and . will be replaced with any uppercase letter or number.
---@return string formatted The formatted string.
function StringUtils.generate(format)
    local formatted = format:gsub("A", function() return string.char(math.random(65, 90)) end)
    formatted = formatted:gsub("a", function() return string.char(math.random(97, 122)) end)
    formatted = formatted:gsub("0", function() return math.random(0, 9) end)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local function randomChar()
        local random = math.random(1, #chars)
        return chars:sub(random, random)
    end
    formatted = formatted:gsub("%.", function() return randomChar() end)
    return formatted
end

---Splits a string into substrings seperated by the given seperator.
---@nodiscard
---@param str string the string to split.
---@param sep string the separator to use.
---@return table<string> strings the split substrings
function StringUtils.split(str, sep)
    local t = {}
    local start = 1
    local sepStart, sepEnd = string.find(str, sep, start, true)
    while sepStart do
        table.insert(t, string.sub(str, start, sepStart - 1))
        start = sepEnd + 1
        sepStart, sepEnd = string.find(str, sep, start, true)
    end
    table.insert(t, string.sub(str, start))
    return t
end
