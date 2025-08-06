---@class XPlayer : DBSC
---@field id integer the unique identifier for the player
---@field name string the name of the player
XPlayer = DBSC:new({
    name = "xgen_player",
    columns = {
        { name = "name", type = "TEXT", primary_key = true },
        { name = "age", type = "INTEGER"}
    }
})
XPlayer.__index = XPlayer

--- Creates a new player instance.
---@param name string The name of the player.
---@param age integer The age of the player.
---@return XPlayer xPlayer The new player instance.
function XPlayer:new(name, age)
    local instance = {}
    setmetatable(instance, self)
    instance.name = name
    instance.age = age
    return instance
end
