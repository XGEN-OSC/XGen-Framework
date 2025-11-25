---@class ORM
---@field name string the name of the ORM table
---@field meta ORM.Meta the meta information of the ORM table
---@field pkQuery ORM.Query the cached primary key query
ORM = ORM or {}

---@class ORM.Meta
---@field public columns table<string, ORM.Column> the columns of the ORM table

---@class ORM.Column
---@field public name string the name of the column
---@field public type string the data type of the column
---@field public isPrimaryKey boolean whether the column is a primary key
---@field public isNullable boolean whether the column can be null

---@type FunctionFactory
local functionFactory = nil

function ORM:Get(primaryKey)
    return self.pkQuery:First({ primaryKey })
end

function ORM:PrimaryKey()
    for columnName, column in pairs(self.meta.columns) do
        if column.isPrimaryKey then
            return columnName
        end
    end
    error(string.format("No primary key defined for ORM table '%s'", self.name))
end

functionFactory = FunctionFactory.ForXClass(ORM)

---Creates a new ORM table and returns its reference.
---@nodiscard
---@param name string the name of the table
---@param meta ORM.Meta the meta information of the table
---@return ORM orm the created ORM table
function ORM.CreateTable(name, meta)
    local orm = {}
    orm.name = name
    orm.meta = meta
    orm.pkQuery = ORM.Query.Create():Select():All():From(orm.name):Where({ [orm:PrimaryKey()] = "?" }):Limit(1)
    ORM.Query.Create()
        :CreateIfNotExists(orm.name)
        :Columns(meta.columns)
        :Exec()
    functionFactory:Apply(orm)
    return orm
end
