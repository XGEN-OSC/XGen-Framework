---@class XCore
XCore = XCore or {}

---@class XCore.CharacterData
---@field citizenID string the unique citizen ID of this character
---@field ownerID string the license ID of the player who owns this character
---@field accountID string the account ID associated with this character

---@class XCore.Character : XCore.CharacterData
---@field public citizenID string the unique citizen ID of this character
---@field public ownerID string the license ID of the player who owns this character
---@field public accountID string the account ID associated with this character
XCore.Character = {}

local function generate_citizen_id()
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local citizenID = ''
    for i = 1, 10 do
        local randIndex = math.random(1, #charset)
        citizenID = citizenID .. charset:sub(randIndex, randIndex)
    end
    return citizenID
end

---@type table<string, XCore.Character> the loaded characters by their citizen ID
local characters = {}

---@class FunctionFactory
local functionFactory = nil

---Returns the XCore.Player who owns this character.
---@nodiscard
---@return XCore.Player? owner the player who owns this character or nil if the player is not online
function XCore.Character:GetOwner()
    return XCore.Player.ByIdentifier(self.ownerID)
end

---Returns the XCore.Account associated with this character.
---@nodiscard
---@return XCore.Account? account the account associated with this character
function XCore.Character:GetAccount()
    return XCore.Account.ById(self.accountID)
end

---Saves the character data to the database.
function XCore.Character:Save()
    Database.Execute([[
        INSERT INTO characters (citizen_id, owner_id, account_id)
        VALUES (?, ?, ?)
        ON CONFLICT(citizen_id) DO UPDATE SET
            owner_id = excluded.owner_id,
            account_id = excluded.account_id
    ]], {
        self.citizenID,
        self.ownerID,
        self.accountID
    })
end

functionFactory = FunctionFactory.ForXClass(XCore.Character)

---Creates a new Character.
---@nodiscard
---@param owner XCore.Player the player who will own the character.
---@return XCore.Character xCharacter the created character.
function XCore.Character.Create(owner)
    local xCharacter = {}

    xCharacter.citizenID = generate_citizen_id()
    xCharacter.ownerID = owner:GetIdentifier()
    xCharacter.accountID = XCore.Account.Create(xCharacter).accountId

    functionFactory:Apply(xCharacter)
    xCharacter:Save()
    characters[xCharacter.citizenID] = xCharacter
    return xCharacter
end

---Returns the character by its citizen ID.
---@nodiscard
---@param citizenID string the citizen ID of the character.
---@return XCore.Character? xCharacter the character object, or nil if not found.
function XCore.Character.ByCitizenID(citizenID)
    if characters[citizenID] then
        return characters[citizenID]
    end

    local result = Database.Execute([[
        SELECT *
        FROM characters
        WHERE citizen_id = ?
    ]], { citizenID })
    local row = result[1]
    ---@cast row { Columns: { ToTable: fun() : table<string, any> } }?
    if not row then return nil end
    local data = row.Columns:ToTable()
    if not data then return nil end

    local xCharacter = data
    functionFactory:Apply(xCharacter)
    characters[citizenID] = xCharacter
    return xCharacter
end

---Loads all characters owned by the given owner ID.
---@nodiscard
---@param ownerId string the license ID of the owner.
---@return table<XCore.Character> xCharacters the list of characters owned by the owner.
function XCore.Character.ByOwnerID(ownerId)
    local result = Database.Execute([[
        SELECT *
        FROM characters
        WHERE owner_id = ?
    ]], { ownerId })

    ---@cast result table<{ Columns: { ToTable: fun() : table<string, any> } }>

    local xCharacters = {}
    for _, row in ipairs(result) do
        ---@cast row { Columns: { ToTable: fun() : table<string, any> } }
        local data = row.Columns:ToTable()
        if data then
            local xCharacter = data
            functionFactory:Apply(xCharacter)
            characters[xCharacter.citizenID] = xCharacter
            table.insert(xCharacters, xCharacter)
        end
    end
    return xCharacters
end

exports('xcore', 'Character', XCore.Character)
