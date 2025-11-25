---@class ORM
ORM = ORM or {}

---@class ORM.Query
---@field public type ORM.Query.Type the type of the query
---@field public data ORM.Query.Data.CreateTable the data of the query
---@field public cachedQuery string? the cached query string
ORM.Query = {}

---@class ORM.Query.Data.CreateTable
---@field public name string the name of the table to create

---@enum ORM.Query.Type
ORM.Query.Type = {
    CREATE_TABLE = "CREATE_TABLE"
}

---@type FunctionFactory
local functionFactory = nil

---Builds the query string for the given ORM query.
---@nodiscard
---@param self ORM.Query the query instance
---@return string query the built query string
local function build(self)
    return ""
end

---Starts a CREATE IF NOT EXISTS query for the specified table.
---@param tableName string the name of the table to create
---@return ORM.Query query the current query instance
function ORM.Query:CreateIfNotExists(tableName)
    self.type = ORM.Query.Type.CREATE_TABLE
    self.data = self.data or {}
    self.data.name = tableName
    return self
end

---Specifies a set of columns.
---@param columns table<ORM.Column>|table<string> the columns to specify
---@return ORM.Query query the current query instance
function ORM.Query:Columns(columns)
    local colType = type(columns[1])
    if self.type == ORM.Query.Type.CREATE_TABLE and colType ~= "table" then
        error("Columns for CREATE TABLE must be a table of ORM.Column")
    end

    self.data.columns = columns
    return self
end

---Executes the built query.
---@param data table<any>? the data to execute with the query
---@return boolean success whether the execution was successful
function ORM.Query:Exec(data)
    if not self.cachedQuery then
        self.cachedQuery = build(self)
    end
    return Database.Execute(self.cachedQuery, data or {})
end

functionFactory = FunctionFactory.ForXClass(ORM.Query)

---Creates a new ORM query instance.
---@nodiscard
---@return ORM.Query query the created ORM query instance
function ORM.Query.Create()
    local query = {}
    functionFactory:Apply(query)
    return query
end
