local function caller_id(index)
    local info = debug.getinfo(index, "Sl")
    return ("%s:%d"):format(info.short_src, info.currentline)
end

local _print = print
function print(...)
    _print("[INFO] ", ..., "(" .. tostring(caller_id(3)) .. ")")
end

---Prints a formatted string to the console.
---@param msg string the message to format
---@param args table<string,any> the arguments to replace in the message. Use {key} in the message to denote where to replace.
---@diagnostic disable-next-line: lowercase-global
function printf(msg, args)
    for k, v in pairs(args) do
        msg = msg:gsub("{" .. k .. "}", tostring(v))
    end
    print(msg)
end

local _error = error
function error(msg, level)
    _error("[ERROR] " .. msg .. " (" .. tostring(caller_id(3)) .. ")", (level or 1) + 1)
end

---Raises a formatted error.
---@param msg string the message to format
---@param args table<string,any> the arguments to replace in the message. Use {key} in the message to denote where to replace.
---@param level number?
---@diagnostic disable-next-line: lowercase-global
function errorf(msg, args, level)
    for k, v in pairs(args) do
        msg = msg:gsub("{" .. k .. "}", tostring(v))
    end
    error(msg, (level or 1) + 1)
end
