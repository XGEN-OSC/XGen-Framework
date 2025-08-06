---@class DBSC (Database Synchronized Class)
---@field private __meta DBSC.Meta
DBSC = {}
DBSC.__index = DBSC

---@class DBSC.Meta
---@field name string the name of the table in the database
---@field columns table<string, DBSC.Meta.Column> a table of columns in the database

---@class DBSC.Meta.Column
---@field type string the type of the column
---@field primary_key boolean whether the column is a primary key
---@field foreign_key string? the foreign key reference if applicable
---@field auto_increment boolean? whether the column should auto-increment

---Creates a new class extending the DBSC class.
---@nodiscard
---@param meta DBSC.Meta the metadata for the class
---@return DBSC class a new class extending the DBSC class
function DBSC:new(meta)
    local instance = setmetatable({}, self)
    instance.__meta = meta
    return instance
end

---Initializes the DBSC subclass.
function DBSC:init()
    local sql = "CREATE TABLE IF NOT EXISTS " .. self.__meta.name .. " ("
    for i, key in ipairs(self.__meta.columns) do
        sql = sql .. key.name .. " " .. key.type
        if key.primary_key then
            sql = sql .. " PRIMARY KEY"
        end
        if key.auto_increment then
            sql = sql .. " AUTO_INCREMENT"
        end
        if key.foreign_key then
            sql = sql .. " REFERENCES " .. key.foreign_key
        end
        if i < #self.__meta.columns then
            sql = sql .. ", "
        end
    end
    sql = sql .. ")"

    return Database.Execute(sql, {})
end

---Loads an object by its primary keys
---@param primary_keys table<string, any> the values of the primary keys
---@return DBSC? object The loaded object or nil if not found
function DBSC:get(primary_keys)
    local sql = "SELECT * FROM " .. self.__meta.name .. " WHERE "
    local values = {}
    local conditions = {}

    for _, key in ipairs(self.__meta.columns) do
        if key.primary_key then
            table.insert(conditions, key.name .. " = ?")
            table.insert(values, primary_keys[key.name])
        end
    end

    sql = sql .. table.concat(conditions, " AND ")

    local results = Database.Select(sql, values)
    local result = results and results[1].Column or nil
    if result then
        local instance = {}
        setmetatable(instance, self)
        for _, key in ipairs(self.__meta.columns) do
            instance[key.name] = result[string.upper(key.name)]
        end
        return instance
    end

    return nil
end

function DBSC:insert()
    local sql = "INSERT INTO " .. self.__meta.name .. " ("
    local values = {}

    local thisVals = {}

    for i, key in ipairs(self.__meta.columns) do
        if key.auto_increment then
            goto continue
        end
        sql = sql .. key.name
        if i < #self.__meta.columns then
            sql = sql .. ", "
        end
        table.insert(values, "?")
        table.insert(thisVals, self[key.name])
        ::continue::
    end
    sql = sql .. ") VALUES (" .. table.concat(values, ", ") .. ")"

    return Database.Execute(sql, thisVals)
end
