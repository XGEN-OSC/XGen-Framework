---@diagnostic disable: inject-field
---@class XCore
XCore = XCore or {}

---@type table<string, XCore.Player>
local players = {}

---@class XPlayerData
---@field permissions table<string> the player's permissions

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
    local playerData = {
        permissions = JSON.parse(data.permissions)
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
XCore.Player = {}

---Returns the HPlayer object associated with this XPlayer.
---@nodiscard
---@return HPlayer hPlayer the helix player object
function XCore.Player:GetHPlayer()
    return self.hPlayer
end

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

    -- add all functions to the xPlayer object
    for k, v in pairs(XCore.Player) do
        xPlayer[k] = v
    end

    players[licenseId] = xPlayer
    return xPlayer
end
