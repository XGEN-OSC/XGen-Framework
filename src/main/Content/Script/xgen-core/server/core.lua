---@class Core
Core = {}

---@type table<HPlayer, XPlayer>
local players = {}

---Returns the XPlayer instance associated with the given player.
---@nodiscard
---@param player HPlayer the helix player object
---@return XPlayer xPlayer The XPlayer instance associated with the player.
function Core.getXPlayer(player)
    if players[player] then
        return players[player]
    end

    -- TODO: Implement identifier extraction from HPlayer. This
    -- requires more intel on the HELIX API.

    local identifier = "???"
    local xPlayer = XPlayer:get({identifier = identifier}) --[[@as XPlayer?]]
    xPlayer = xPlayer or XPlayer:new(identifier)
    xPlayer.hPlayer = player --[[@as HPlayer]]
    players[player] = xPlayer
    return xPlayer
end

---Injects a remote resource function with the given name into a module
---of the core.
---@param name string the name and module of the function (e.g. XPlayer.onJoin)
---@param cb fun(...) : ... the function to inject
function Core.injectFunction(name, cb)
    local funcPath = StringUtils.split(name, ".")
    local module = _G
    
    for i = 1, #funcPath - 1 do
        local part = funcPath[i]
        if not module[part] then
            error("Module " .. part .. " not found in path: " .. name)
        end
        if type(module[part]) ~= "table" then
            error("Expected table for module " .. part .. " in path: " .. name .. ", got " .. type(module[part]))
        end
        module = module[part]
    end
    
    local functionName = funcPath[#funcPath]
    module[functionName] = cb
end
