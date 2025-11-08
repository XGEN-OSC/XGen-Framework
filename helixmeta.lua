---@meta HELIX

---@param package string
---@param name string
---@param callback fun(...) : ...
function exports(package, name, callback) end

---@class HPlayerState
local HPlayerState = {}

---Returns the unique Helix license id for the player.
---@nodiscard
---@return string license the helix license id
function HPlayerState:GetHelixUserId() end

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
---@nodiscard
---@param sql string the SQL query to execute
---@param data table<any> the optional data parameters for the query
---@return table<{Columns: { ToTable: fun() : table<string, any> }}> results the results of the query
function Database.Execute(sql, data) end

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
