---@diagnostic disable: inject-field, invisible, cast-type-mismatch
---@class XCore
XCore = XCore or {}

---@type table<string, XCore.Player>
local players = {}

---@type table<string, fun(xPlayer: XCore.Player): fun(...: any) : any>
local functionFactory = {}
functionFactory.getHPlayer = function(xPlayer)
    return function()
        return xPlayer.hPlayer
    end
end
functionFactory.hasPermission = function(xPlayer)
    return function(permission)
        return xPlayer.permissions[permission] == true
    end
end

---@class XPlayerData
---@field permissions table<string, boolean> the player's permissions

---Loads player data from the database based on their license ID.
---@param license string the player's license ID
---@return XPlayerData? playerData the loaded player data
local function load_player_data(license)
    local result = Database.Execute([[
        SELECT *
        FROM player_data
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
---@return XPlayerData defaultData the default player data
local function default_player_data()
    return {
        permissions = {}
    }
end

---@class XCore.Player
---@field private hPlayer HPlayer the helix player object
---@field private permissions table<string, boolean> the player's permissions
XCore.Player = {}

---Returns the XPlayer object for the given HPlayer.
---@nodiscard
---@param hPlayer HPlayer the helix player object
---@return XCore.Player xPlayer the xcore player object
function XCore.GetPlayer(hPlayer)
    local hPlayerState = hPlayer:GetLyraPlayerState()
    local licenseId = hPlayerState:GetHelixUserId()
    local xPlayer = players[licenseId]
    if xPlayer then return xPlayer end

    local data = load_player_data(licenseId) or default_player_data()
    data.hPlayer = hPlayer

    ---@cast data XCore.Player

    for key, factory in pairs(functionFactory) do
        data[key] = factory(data)
    end

    players[licenseId] = xPlayer
    return xPlayer
end

exports('xcore', 'GetPlayer', XCore.GetPlayer)
