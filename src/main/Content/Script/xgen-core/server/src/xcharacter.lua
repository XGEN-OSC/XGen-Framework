---@class XCharacter : DBSC A single character in the game, 
---bound to a player.
---@field citizen_id string The unique identifier for the character.
---@field owner XPlayer The player who owns this character.
---@field firstname string The first name of the character.
---@field lastname string The last name of the character.
---@field date_of_birth string The date of birth of the character in YYYY-MM-DD format.
---@field account XAccount the players primary banking account
XCharacter = DBSC:new({
    name = "xgen_character",
    columns = {
        { name = "citizen_id", type = "VARCHAR(255)", primary_key = true },
        { name = "owner", type = "XPlayer" },
        { name = "firstname", type = "VARCHAR(255)", not_null = true },
        { name = "lastname", type = "VARCHAR(255)", not_null = true },
        { name = "date_of_birth", type = "DATE", not_null = true },
        { name = "account", type = "XAccount", not_null = false }
    }
})
XCharacter.__index = XCharacter

---Creates a new character instance.
---@nodiscard
---@param owner XPlayer The player who owns this character.
---@return XCharacter character The new character instance.
function XCharacter:new(owner, firstname, lastname, date_of_birth)
    local instance = {}
    setmetatable(instance, self)
    ---@cast instance XCharacter
    instance.citizen_id = StringUtils.generate("AAAA-0000")
    instance.owner = owner
    instance.firstname = firstname
    instance.lastname = lastname
    instance.date_of_birth = date_of_birth
    instance.account = XAccount:new()
    if not instance:insert() then
        error("Failed to create character: " .. instance.citizen_id .. "(citizen id already in use?)")
    end
    return instance
end

---Returns the characters full name.
---@nodiscard
---@return string name the full name of the character.
function XCharacter:getName()
    return self.firstname .. " " .. self.lastname
end
