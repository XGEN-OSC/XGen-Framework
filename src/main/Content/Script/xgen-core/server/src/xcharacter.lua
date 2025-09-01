---@class Server
Server = Server or {}

---@class Server.XCharacter : Server.DBSC A single character in the game, 
---bound to a player.
---@field citizen_id string The unique identifier for the character.
---@field owner Server.XPlayer The player who owns this character.
---@field firstname string The first name of the character.
---@field lastname string The last name of the character.
---@field date_of_birth string The date of birth of the character in YYYY-MM-DD format.
---@field account Server.XAccount the players primary banking account
---@field xPlayer Server.XPlayer the player this character is bound to
Server.XCharacter = Server.DBSC:new({
    name = "xgen_character",
    columns = {
        { name = "citizen_id", type = "VARCHAR(255)", primary_key = true },
        { name = "owner", type = "XPlayer" },
        { name = "firstname", type = "VARCHAR(255)", not_null = true },
        { name = "lastname", type = "VARCHAR(255)", not_null = true },
        { name = "date_of_birth", type = "TIMESTAMP", not_null = true },
        { name = "account", type = "XAccount", not_null = false }
    }
})
Server.XCharacter.__index = Server.XCharacter

---Creates a new character instance.
---@nodiscard
---@param owner Server.XPlayer The player who owns this character.
---@param firstname string
---@param lastname string
---@param date_of_birth string
---@return Server.XCharacter character The new character instance.
function Server.XCharacter:new(owner, firstname, lastname, date_of_birth)
    local instance = {}
    setmetatable(instance, self)
    ---@cast instance Server.XCharacter
    instance.citizen_id = StringUtils.generate("AAAA-0000")
    instance.owner = owner
    instance.firstname = firstname
    instance.lastname = lastname
    instance.date_of_birth = date_of_birth
    instance.account = Server.XAccount:new()
    if not instance:insert() then
        error("Failed to create character: " .. instance.citizen_id .. "(citizen id already in use?)")
    end
    return instance
end

---Returns the characters full name.
---@nodiscard
---@return string name the full name of the character.
function Server.XCharacter:getName()
    return self.firstname .. " " .. self.lastname
end
