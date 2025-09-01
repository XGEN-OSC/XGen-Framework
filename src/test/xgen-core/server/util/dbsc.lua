---@diagnostic disable: undefined-field, need-check-nil, discard-returns
local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]

local DBSC = Server.DBSC
local DB = Server.DB
local XAccount = Server.XAccount
DB.init()

Test.new("DBSC should exist", function (self)
    return Test.assert(DBSC ~= nil, "DBSC should not be nil")
end)

Test.new("DBSC.new should create new DBSC class", function (self)
    local MyClass = DBSC:new({
        name = "my_class",
        columns = {
            { name = "id", type = "integer", primary_key = true, auto_increment = true },
            { name = "name", type = "varchar", unique = true },
            { name = "age", type = "integer" }
        }
    })

    return Test.assert(MyClass ~= nil, "DBSC.new should create a new class")
end)

Test.new("DBSC.insert should insert data into the database", function (self)
    ---@class MyClass : Server.DBSC
    ---@field id integer
    local MyClass = DBSC:new({
        name = "my_class",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "name", type = "varchar", unique = true },
            { name = "age", type = "integer" }
        }
    })

    MyClass:init()

    local instance = MyClass:create({ id = 1, name = "John Doe", age = 30 }) --[[@as MyClass]]
    return Test.assert(MyClass:get({ id = instance.id }) ~= nil, "DBSC.get should retrieve the inserted data")
end)

Test.new("DBSC(instance):new should throw error when insertation failed", function (self)
    local MyClass = DBSC:new({
        name = "my_class2",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "name", type = "varchar", unique = true },
            { name = "age", type = "integer" }
        }
    })

    MyClass:init()

    MyClass:create({ id = 1, name = "John Doe", age = 30 })
    return Test.assertError(function()
        MyClass:create({ id = 1, name = "Jane Doe", age = 25 })
    end, "DBSC should throw an error when trying to insert a duplicate primary key")
end)

Test.new("DBSC:insert should work correctly when using default values", function (self)
    ---@class MyClass : Server.DBSC
    ---@field name string
    ---@field age integer
    local MyClass = DBSC:new({
        name = "my_class3",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "name", type = "varchar", default = "Unknown" },
            { name = "age", type = "integer", default = 0 }
        }
    })

    MyClass:init()

    local instance = MyClass:create({ id = 1 }) --[[@as MyClass]]
    return Test.assertEqual(instance.name, "Unknown", "DBSC:insert should use default values when not provided")
end)

Test.new("DBSC:insert should handle foreign keys correctly", function (self)
    local account = XAccount:new()
    ---@class MyClass : Server.DBSC
    local MyClass = DBSC:new({
        name = "my_class4",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "foreign_object", type = "XAccount" },
            { name = "name", type = "varchar" }
        }
    })

    MyClass:init()

    local instance = MyClass:create({ id = 1, foreign_object = account, name = "Linked Instance" }) --[[@as MyClass]]
    return Test.assertEqual(instance.foreign_object.bid, account.bid, "DBSC:insert should handle foreign keys correctly")
end)

Test.new("DBSC:update should update data in the database", function (self)
    local account = XAccount:new()
    local MyClass = DBSC:new({
        name = "my_class5",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "name", type = "varchar" },
            { name = "age", type = "integer" },
            { name = "account", type = "XAccount" }
        }
    })

    MyClass:init()

    local instance = MyClass:create({ id = 1, name = "John Doe", age = 30, account = account }) --[[@as MyClass]]
    instance.name = "Jane Doe"
    instance.age = 25
    instance:update()
    local loaded = MyClass:get({ id = instance.id })
    return Test.assertEqual(loaded.name, "Jane Doe", "DBSC:update should update the name") and
              Test.assertEqual(loaded.age, 25, "DBSC:update should update the age") and
              Test.assertEqual(loaded.account.bid, account.bid, "DBSC:update should update the account")
end)

Test.new("DBSC:getWhere should retrieve data based on conditions", function (self)
    local shared_account = XAccount:new()

    local MyClass = DBSC:new({
        name = "my_class6",
        columns = {
            { name = "id", type = "integer", primary_key = true },
            { name = "name", type = "varchar" },
            { name = "age", type = "integer" },
            { name = "account", type = "XAccount" }
        }
    })

    MyClass:init()

    MyClass:create ({ id = 1, name = "Alice", age = 28, account = shared_account })
    MyClass:create { id = 3, name = "Bob", age = 28, account = shared_account }
    MyClass:create { id = 2, name = "Bob", age = 32, account = shared_account }

    local results = MyClass:getWhere({ age = 32 })
    return Test.assertEqual(#results, 1, "DBSC:getWhere should return the correct number of results") and
           Test.assertEqual(results[1].name, "Bob", "DBSC:getWhere should return the correct result") and
           Test.assertEqual(#MyClass:getWhere({ age = 28 }), 2, "DBSC:getWhere should return the correct number of results for age 28")
end)

Test.new("DBSC:delete should delete entries from database", function (self)
    local account = XAccount:new()
    account:delete()
    return Test.assertEqual(XAccount:get({bid = account.bid}), nil, "DBSC:delete should delete the account")
end)
