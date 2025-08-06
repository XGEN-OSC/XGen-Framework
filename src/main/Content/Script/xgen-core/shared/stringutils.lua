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
        return tostring(load("return " .. lua)())
    end)
    if not values then
        return str
    end
    str = str:gsub("{(.-)}", function(key)
        return tostring(values[key] or "")
    end)
    return str
end
