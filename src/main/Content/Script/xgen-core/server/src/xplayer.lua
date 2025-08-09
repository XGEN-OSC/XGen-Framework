---@class XPlayer : DBSC
---@field identifier string the identifier of the player
---@field joined string the timestamp when the player joined
---@field last_seen string the timestamp when the player was last seen
---@field current_character XCharacter? the character this player is currently playing
---@field hPlayer HPlayer? the connected HELIX player
XPlayer = DBSC:new({
    name = "xgen_player",
    columns = {
        { name = "identifier", type = "VARCHAR(255)", primary_key = true },
        { name = "joined", type = "TIMESTAMP", default = "CURRENT_TIMESTAMP", not_null = true },
        { name = "last_seen", type = "TIMESTAMP", default = "CURRENT_TIMESTAMP", not_null = true }
    }
})
XPlayer.__index = XPlayer

--- Creates a new player instance.
---@param identifier string The identifier of the player.
---@return XPlayer xPlayer The new player instance.
function XPlayer:new(identifier)
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    instance.identifier = identifier
    if not instance:insert() then
       error("Failed to insert new player into the database.")
    end
    return self:get({identifier = identifier}) --[[@as XPlayer]]
end

---This function will be called when a player connected to the server.
---It will set the last seen timestamp to the current time and call the onJoin function.
function XPlayer:connected()
    self:onJoin()

    self.last_seen = os.date("%Y-%m-%d %H:%M:%S") --[[@as string]]
    if not self:update() then
        error("Failed to update player last seen timestamp.")
    end
end

---This function will be called when a player joins the server, or
---unloads his current character.
function XPlayer:onJoin()
    error("onJoin function should be overwritten by the installed character loading system (external resource).")
end

---Sets the character this player is currently playing.
---@nodiscard
---@param citizenId string the citizen ID of the character to load
---@return boolean success Whether the character was successfully loaded.
function XPlayer:loadCharacter(citizenId)
    local character = XCharacter:get({citizen_id = citizenId}) --[[@as XCharacter?]]
    if not character then
        return false
    end
    if character.xPlayer then
        error("Character is already bound to a player.")
    end
    self.current_character = character
    self.current_character.xPlayer = self
    return true
end

function XPlayer:unloadCharacter()
    if not self.current_character then
        return
    end
    self.current_character.xPlayer = nil
    self.current_character = nil
    self:onJoin()
end

