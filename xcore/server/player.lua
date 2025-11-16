---@class XCore
XCore = XCore or {}

---@type table<string, XCore.Player>
local players = {}

---@type FunctionFactory
local functionFactory = nil

---@class XCore.PlayerData
---@field permissions table<string,boolean> the player's permissions

---Loads player data from the database based on their license ID.
---@param license string the player's license ID
---@return XCore.PlayerData? playerData the loaded player data
local function load_player_data(license)
    local result = Database.Execute([[
        SELECT *
        FROM players
        WHERE license = ?
    ]], { license })
    local row = result[1]
    ---@cast row { Columns: { ToTable: fun() : table<string, any> } }?
    if not row then return nil end
    local data = row.Columns:ToTable()
    if not data then return nil end
    local permissionList = JSON.parse(data.permissions)
    local permissionTable = {}
    for _, perm in ipairs(permissionList) do
        permissionTable[perm] = true
    end
    local playerData = {
        permissions = permissionTable
    }
    return playerData
end

---Returns the default player data structure.
---@return XCore.PlayerData defaultData the default player data
local function default_player_data()
    return {
        permissions = {}
    }
end

---@class XCore.Player
---@field public hPlayer HPlayer the helix player object
---@field public permissions table<string,boolean> the player's permissions
XCore.Player = {}

---Checks if the player has the specified permission.
---@nodiscard
---@non-static
---@param permission string the permission to check
---@return boolean hasPermission whether the player has the permission
function XCore.Player:HasPermission(permission)
    return self.permissions[permission] == true
end

---Returns the name of the player.
---@nodiscard
---@non-static
---@return string name the name of the player
function XCore.Player:GetName()
    return self.hPlayer:GetLyraPlayerState():GetName()
end

---Returns the unique identifier (license ID) of the player.
---@nodiscard
---@non-static
---@return string identifier the player's license ID
function XCore.Player:GetIdentifier()
    return self.hPlayer:GetLyraPlayerState():GetHelixUserId()
end

---Returns all characters owned by the player.
---@nodiscard
---@non-static
---@return table<XCore.Character> xCharacters the list of characters owned by the player
function XCore.Player:GetAllCharacters()
    return XCore.Character.ByOwnerID(self:GetIdentifier())
end

functionFactory = functionFactory.ForXClass(XCore.Player)

---Returns the XPlayer object for the given license ID.
---@nodiscard
---@param license string the player's license ID
---@return XCore.Player? xPlayer the xcore player object, or nil if not found
function XCore.Player.ByIdentifier(license)
    return players[license]
end

---Returns the XPlayer object for the given HPlayer.
---@nodiscard
---@param hPlayer HPlayer the helix player object
---@return XCore.Player xPlayer the xcore player object
function XCore.Player.BySource(hPlayer)
    local hPlayerState = hPlayer:GetLyraPlayerState()
    local licenseId = hPlayerState:GetHelixUserId()
    local xPlayer = players[licenseId]
    if xPlayer then return xPlayer end

    local data = load_player_data(licenseId) or default_player_data()
    data.hPlayer = hPlayer

    ---@cast data XCore.Player

    functionFactory:Apply(data)

    players[licenseId] = xPlayer
    return xPlayer
end

exports('xcore', 'Player', XCore.Player)
