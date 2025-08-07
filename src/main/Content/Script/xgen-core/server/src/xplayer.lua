---@class XPlayer : DBSC
---@field identifier string the identifier of the player
---@field joined string the timestamp when the player joined
---@field last_seen string the timestamp when the player was last seen
XPlayer = DBSC:new({
    name = "xgen_player",
    columns = {
        { name = "identifier", type = "VARCHAR(255)", primary_key = true },
        { name = "joined", type = "TIMESTAMP", default = "CURRENT_TIMESTAMP" },
        { name = "last_seen", type = "TIMESTAMP", default = "CURRENT_TIMESTAMP" }
    }
})
XPlayer.__index = XPlayer

--- Creates a new player instance.
---@param identifier string The identifier of the player.
---@return XPlayer xPlayer The new player instance.
function XPlayer:new(identifier)
    local instance = {}
    setmetatable(instance, self)
    instance.identifier = identifier
    return instance
end

function XPlayer:connected()
    self.last_seen = os.date("%Y-%m-%d %H:%M:%S") --[[@as string]]
end
