---@meta HELIX

---@class Database
Database = {}

---Initializes the database at the specified path.
---@param path string The path to the database.
function Database.Initialize(path) end

---Executes a SQL statement.
---@nodiscard
---@param sql string The SQL statement to execute.
---@param values table<any> The values to bind to the SQL statement.
---@return boolean success
function Database.Execute(sql, values) end

---Selects data from the database.
---@nodiscard
---@param sql string The SQL statement to select data.
---@param values table<any> The values to bind to the SQL statement.
---@return table<{Column: table<string, any>}> results The results of the query.
function Database.Select(sql, values) end

---@class Controller

---@class HPlayer : Controller
HPlayer = {}
