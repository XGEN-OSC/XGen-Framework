---@class DBSC (Database Synchronized Class)
---@field private __meta DBSC.Meta
---@field private __cache table<string, DBSC> cached objects
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
    instance.__cache = {}
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
        if key.default then
            sql = sql .. " DEFAULT " .. key.default
        end
        if i < #self.__meta.columns then
            sql = sql .. " NOT NULL, "
        end
    end
    sql = sql .. ")"

    return Database.Execute(sql, {})
end

---Inserts the object into the database.
---@nodiscard
---@return boolean success whether the insert was successful
function DBSC:insert()
    local pks = {}
    local pksString = ""
    local sql = "INSERT INTO " .. self.__meta.name .. " ("
    local values = {}

    local thisVals = {}

    for i, key in ipairs(self.__meta.columns) do
        if key.auto_increment then
            goto continue
        end
        if key.primary_key then
            pks[key.name] = self[key.name]
            pksString = pksString .. ":" .. tostring(self[key.name])
        end
        if key.default then
            if i >= #self.__meta.columns then
                sql = sql:sub(1, -3)
            end
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

    if not Database.Execute(sql, thisVals) then
        return false
    end

    self.__cache[pksString] = self:get(pks)

    return true
end


---Updates the object in the database.
---@nodiscard
---@return boolean success whether the update was successful
function DBSC:update()
    local sql = "UPDATE " .. self.__meta.name .. " SET "
    local values = {}
    local conditions = {}
    local condValues = {}

    for i, key in ipairs(self.__meta.columns) do
        if key.primary_key then
            table.insert(conditions, key.name .. " = ?")
            table.insert(condValues, self[key.name])
        else
            sql = sql .. key.name .. " = ?"
            table.insert(values, self[key.name])
            if i < #self.__meta.columns then
                sql = sql .. ", "
            end
        end
    end

    sql = sql .. " WHERE " .. table.concat(conditions, " AND ")
    for _, value in ipairs(condValues) do
        table.insert(values, value)
    end
    return Database.Execute(sql, values)
end

---Loads an object by its primary keys
---@param primary_keys table<string, any> the values of the primary keys
---@return DBSC? object The loaded object or nil if not found
function DBSC:get(primary_keys)
    local pksString = ""
    for _, value in pairs(primary_keys) do
        pksString = pksString .. ":" .. tostring(value)
    end

    if self.__cache[pksString] then
        return self.__cache[pksString]
    end

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
    local result = results and results[1] and results[1].Column or nil
    if result then
        local instance = {}
        setmetatable(instance, self)
        for _, key in ipairs(self.__meta.columns) do
            instance[key.name] = result[string.upper(key.name)]
        end

        self.__cache[pksString] = instance

        return instance
    end

    return nil
end

function DBSC:getWhere(conditions)
    local sql = "SELECT * FROM " .. self.__meta.name .. " WHERE "
    local values = {}
    local conds = {}

    for key, value in pairs(conditions) do
        table.insert(conds, key .. " = ?")
        table.insert(values, value)
    end

    sql = sql .. table.concat(conds, " AND ")

    local results = Database.Select(sql, values)
    if not results then return nil end

    local instances = {}
    for _, result in ipairs(results) do
        local instance = {}
        setmetatable(instance, self)
        for _, key in ipairs(self.__meta.columns) do
            instance[key.name] = result.Column[string.upper(key.name)]
        end
        table.insert(instances, instance)

    end

    return instances
end

---Deletes the object from the database.
---@nodiscard
---@return boolean success whether the delete was successful
function DBSC:delete()
    local pksString = ""
    for _, key in ipairs(self.__meta.columns) do
        if key.primary_key then
            pksString = pksString .. ":" .. tostring(self[key.name])
        end
    end

    if not self.__cache[pksString] then
        return true
    end

    local sql = "DELETE FROM " .. self.__meta.name .. " WHERE "
    local values = {}
    local conditions = {}

    for _, key in ipairs(self.__meta.columns) do
        if key.primary_key then
            table.insert(conditions, key.name .. " = ?")
            table.insert(values, self[key.name])
        end
    end

    sql = sql .. table.concat(conditions, " AND ")
    if not Database.Execute(sql, values) then
        return false
    end

    self.__cache[pksString] = nil

    return true
end
