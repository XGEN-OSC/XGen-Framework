---@class Core
Core = {}

---Returns the XPlayer instance associated with the given player.
---@nodiscard
---@param player HPlayer the helix player object
---@return XPlayer xPlayer The XPlayer instance associated with the player.
function Core.getXPlayer(player)
    -- TODO: Implement identifier extraction from HPlayer. This
    -- requires more intel on the HELIX API.
    local identifier = "???"
    local xPlayer = XPlayer:get({identifier = identifier}) --[[@as XPlayer?]]
    xPlayer = xPlayer or XPlayer:new(identifier)
    return xPlayer
end
