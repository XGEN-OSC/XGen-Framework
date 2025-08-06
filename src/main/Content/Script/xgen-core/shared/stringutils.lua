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
    str = str:gsub("$(.-)$", function(lua)
        local ok, result = pcall(function (...)
            local fn = assert(load("return " .. string.sub(lua, 1, -2) .. ""))
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
        return tostring(values[key] or "")
    end)
    return str
end


---Dumps a table into a string representation.
---@nodiscard
---This is useful for debugging purposes.
---@param table table The table to dump.
---@return string str The string representation of the table.
function StringUtils.dumpTable(table)
    if type(table) ~= "table" then
        return tostring(table)
    end
    local str = "{ "
    for k, v in pairs(table) do
        if type(v) == "table" then
            str = str .. k .. " = " .. StringUtils.dumpTable(v) .. ", "
        elseif type(v) == "string" then
            str = str .. k .. ' = "' .. v .. '", '
        else
            str = str .. k .. " = " .. tostring(v) .. ", "
        end
    end

    str = str:sub(1, -3) -- Remove the last comma and space

    str = str .. " }"
    return str
end
