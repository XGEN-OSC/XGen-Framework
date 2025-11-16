---@meta HELIX

---@param package string
---@param name string
---@param obj any
function exports(package, name, obj) end

---@class HPlayerState
local HPlayerState = {}

---Returns the unique Helix license id for the player.
---@nodiscard
---@return string license the helix license id
function HPlayerState:GetHelixUserId() end

---Returns the name of the player.
---@nodiscard
---@return string name the name of the player
function HPlayerState:GetName() end

---@class HPlayer
HPlayer = {}

---returns the helix player state
---@nodiscard
---@return HPlayerState hPlayerState the helix player state for the HPlayer
function HPlayer:GetLyraPlayerState() end

---@class Database
Database = {}

---Initializes the database with the given database name.
---@param dbName string the name of the database file
function Database.Initialize(dbName) end

---Executes the given SQL query with optional data parameters.
---@param sql string the SQL query to execute
---@param data table<any> the optional data parameters for the query
---@return table<{Columns: { ToTable: fun() : table<string, any> }}> results the results of the query
function Database.Execute(sql, data) end

---Executes the given SQL query asynchronously with optional data parameters.
---@param sql string the SQL query to execute
---@param data table<any>? the optional data parameters for the query
---@param callback fun(results: table<{Columns: { ToTable: fun() : table<string, any> }}>)? results the results of the query) the callback function to handle the results
function Database.ExecuteAsync(sql, data, callback) end

---@class JSON
JSON = {}

---Converts the given data table to a JSON string.
---@nodiscard
---@param data table<any>|table<string, any> the data to convert to JSON
---@return string json the resulting JSON string
function JSON.stringify(data) end

---Parses the given JSON string into a data table.
---@nodiscard
---@param json string the JSON string to parse
---@return table<any>|table<string, any> data the resulting data table
function JSON.parse(json) end

---@param eventName string
---@param ... any
function TriggerLocalServerEvent(eventName, ...) end

---@param hPlayer HPlayer
---@param eventName string
---@param ... any
function TriggerClientEvent(hPlayer, eventName, ...) end
