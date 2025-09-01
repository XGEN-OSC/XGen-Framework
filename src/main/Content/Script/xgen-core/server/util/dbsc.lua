---@class Server
Server = Server or {}

---@class Server.DBSC (Database Synchronized Class)
---@field private __meta DBSC.Meta
---@field private __cache table<string, Server.DBSC> cached objects
Server.DBSC = {}
Server.DBSC.__index = Server.DBSC

---@class DBSC.Meta
---@field name string the name of the table in the database
---@field columns table<DBSC.Meta.Column> a table of columns in the database

---@class DBSC.Meta.Column
---@field name string the name of the column
---@field type string the type of the column
---@field primary_key boolean? whether the column is a primary key
---@field foreign_key string? the foreign key reference if applicable
---@field foreign_key_class Server.DBSC? the class of the foreign key reference
---@field auto_increment boolean? whether the column should auto-increment
---@field default string? the default value for the column
---@field not_null boolean? whether the column cannot be null
---@field unique boolean? whether the column should be unique

---Creates a new class extending the DBSC class.
---@nodiscard
---@param meta DBSC.Meta the metadata for the class
---@return Server.DBSC class a new class extending the DBSC class
function Server.DBSC:new(meta)
    local instance = setmetatable({}, self)
    self.__index = self
    instance.__meta = meta
    instance.__cache = {}
    function instance:new(values)
        local obj = setmetatable(values, self) --[[@as Server.DBSC]]
        self.__index = self
        if not obj:insert() then
            error("Failed to insert new object into the database")
        end
        return self:get({ [self:primaryKey().name] = obj[self:primaryKey().name] }) --[[@as Server.DBSC]]
    end
    return instance
end

---Returns the column that is the primary key of this table.
---@return DBSC.Meta.Column? column the primary key column or nil if not found
function Server.DBSC:primaryKey()
    for _, column in ipairs(self.__meta.columns) do
        if column.primary_key then
            return column
        end
    end
end

---Initializes the DBSC subclass.
function Server.DBSC:init()
    local sql = "CREATE TABLE IF NOT EXISTS " .. self.__meta.name .. " ("
    for i, key in ipairs(self.__meta.columns) do

        if Server[key.type] then
            local dbsc_class = Server[key.type]
            local class_table = dbsc_class.__meta.name
            local reference = dbsc_class:primaryKey()
            key.type = reference.type
            key.foreign_key = class_table .. "(" .. reference.name .. ")"
            key.foreign_key_class = dbsc_class
            key.foreign_key_ref_name = reference.name
        end

        sql = sql .. key.name .. " " .. key.type
        if key.primary_key then
            sql = sql .. " PRIMARY KEY"
        end
        if key.auto_increment then
            sql = sql .. " AUTO_INCREMENT"
        end
        if key.foreign_key then
            sql = sql .. " REFERENCES " .. key.foreign_key .. " ON DELETE CASCADE"
        end
        if key.default then
            local defaultVal = tostring(key.default)
            if type(key.default) == "string" then
                defaultVal = "'" .. defaultVal .. "'"
            end
            sql = sql .. " DEFAULT " .. defaultVal
        end
        if key.not_null then
            sql = sql .. " NOT NULL"
        end
        if key.unique then
            sql = sql .. " UNIQUE"
        end
        if i < #self.__meta.columns then
            sql = sql .. ", "
        end
    end
    sql = sql .. ")"

    return Database.Execute(sql, {})
end

---Inserts the object into the database.
---@nodiscard
---@return boolean success whether the insert was successful
function Server.DBSC:insert()
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

        if key.foreign_key_class then
            local val = self[key.name][key.foreign_key_ref_name]
            table.insert(thisVals, val)
            goto continue
        end

        table.insert(thisVals, self[key.name])
        ::continue::
    end
    sql = sql .. ") VALUES (" .. table.concat(values, ", ") .. ")"

    if not Database.Execute(sql, thisVals) then
        return false
    end

    self:get(pks)

    return true
end


---Updates the object in the database.
---@nodiscard
---@return boolean success whether the update was successful
function Server.DBSC:update()
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

            if key.foreign_key_class then
                local val = self[key.name][key.foreign_key_ref_name]
                table.insert(values, val)
            else
                table.insert(values, self[key.name])
            end

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
---@return Server.DBSC? object The loaded object or nil if not found
function Server.DBSC:get(primary_keys)
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
        instance.__index = instance
        self.__index = self
        for _, key in ipairs(self.__meta.columns) do
            if key.foreign_key_class then
                local foreignKeyClass = key.foreign_key_class
                instance[key.name] = foreignKeyClass:get({[key.foreign_key_ref_name] = result[string.upper(key.name)]})
            else
                instance[key.name] = result[string.upper(key.name)]
            end
        end

        self.__cache[pksString] = instance

        return instance
    end

    return nil
end

---Returns a list of objects matching the given conditions.
---@nodiscard
---@param conditions table<string, any> the conditions to match
---@return table<Server.DBSC> instances a list of matching objects
function Server.DBSC:getWhere(conditions)
    local sql = "SELECT * FROM " .. self.__meta.name .. " WHERE "
    local values = {}
    local conds = {}

    for key, value in pairs(conditions) do
        table.insert(conds, key .. " = ?")
        table.insert(values, value)
    end

    sql = sql .. table.concat(conds, " AND ")

    local results = Database.Select(sql, values)
    if not results then return {} end

    local instances = {}
    for _, result in ipairs(results) do
        local instance = {}
        setmetatable(instance, self)
        for _, key in ipairs(self.__meta.columns) do
            if key.foreign_key_class then
                local foreignKeyClass = key.foreign_key_class
                instance[key.name] = foreignKeyClass:get({[key.foreign_key_ref_name] = result.Column[string.upper(key.name)]})
            else
                instance[key.name] = result.Column[string.upper(key.name)]
            end
        end
        table.insert(instances, instance)

    end

    return instances
end

---Deletes the object from the database.
---@nodiscard
---@return boolean success whether the delete was successful
function Server.DBSC:delete()
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
