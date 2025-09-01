---@class Server
Server = Server or {}

---@class Server.Core
Server.Core = {}

---@type table<HPlayer, Server.XPlayer>
local players = {}

---Returns the XPlayer instance associated with the given player.
---@nodiscard
---@param player HPlayer the helix player object
---@return Server.XPlayer xPlayer The XPlayer instance associated with the player.
function Server.Core.getXPlayer(player)
    if players[player] then
        return players[player]
    end

    -- TODO: Implement identifier extraction from HPlayer. This
    -- requires more intel on the HELIX API.

    local identifier = "???"
    local xPlayer = Server.XPlayer:get({identifier = identifier}) --[[@as Server.XPlayer?]]
    xPlayer = xPlayer or Server.XPlayer:new(identifier)
    xPlayer.hPlayer = player --[[@as HPlayer]]
    players[player] = xPlayer
    return xPlayer
end

---Injects a given object / value into a module
---@param obj any
function Server.Core.inject(name, obj)
    local path = StringUtils.split(name, ".")
    local module = _G

    for i = 1, #path - 1 do
        local part = path[i]
        if not module[part] then
            error("Module " .. part .. " not found in path: " .. name)
        end
        if type(module[part]) ~= "table" then
            error("Expected table for module " .. part .. " in path: " .. name .. ", got " .. type(module[part]))
        end
        module = module[part]
    end
    
    local functionName = path[#path]
    module[functionName] = obj
end
