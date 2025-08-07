---@class XCharacter : DBSC A single character in the game, 
---bound to a player.
---@field citizen_id string The unique identifier for the character.
---@field owner string The identifier of the player who owns this character.
XCharacter = DBSC:new({
    name = "xgen_character",
    columns = {
        { name = "citizen_id", type = "VARCHAR(255)", primary_key = true },
        { name = "owner", type = "VARCHAR(255)", foreign_key = "xgen_player(identifier)" }
    }
})
XCharacter.__index = XCharacter

---Creates a new character instance.
---@nodiscard
---@param owner string The identifier of the player who owns this character.
---@return XCharacter character The new character instance.
function XCharacter:new(owner)
    local instance = {}
    setmetatable(instance, self)
    instance.citizen_id = StringUtils.generate("AAAA-0000")
    instance.owner = owner
    return instance
end