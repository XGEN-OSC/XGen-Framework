local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]
local Core = Server.Core

Test.new("Core should exist", function (self)
    return Test.assert(Core ~= nil, "Core should not be nil")
end)

Test.new("Core.getXPlayer should return XPlayer instance", function (self)
    local hPlayer = {}
    local xPlayer = Core.getXPlayer(hPlayer)

    return Test.assert(xPlayer ~= nil, "Core.getXPlayer should return an XPlayer instance") and
           Test.assertEqual(xPlayer.hPlayer, hPlayer, "XPlayer should have the correct HPlayer reference")
end)

Test.new("Core.inject should inject an object into a module", function (self)
    Core.inject("TestModule", { testFunction = function() return "Hello, World!" end })
    local TestModule = ENVIRONMENT_GET_VAR(ENVIRONMENT, "TestModule")

    return Test.assert(TestModule ~= nil, "TestModule should not be nil") and
           Test.assert(TestModule.testFunction ~= nil, "TestModule.testFunction should not be nil") and
           Test.assert(TestModule.testFunction() == "Hello, World!", "TestModule.testFunction should return 'Hello, World!'")
end)

Test.new("Core.inject should throw an error for invalid module path", function (self)
    return Test.assertError(function()
        Core.inject("Invalid.Module.Path", {})
    end, "Module Invalid.Module.Path not found in path: Invalid.Module.Path")
end)

Test.new("Core.inject should throw an error for non-table module", function (self)
    return Test.assertError(function()
        Core.inject("TestModule.testFunction.module", {})
    end, "Expected table for module InvalidModule in path: InvalidModule, got string")
end)
