local sim = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(sim)
local resource = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-core")
RESOURCE_START(resource)
table.insert(RESOURCES, resource)
local env = ENVIRONMENT_GET(server, resource)

local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]
local XCharacterSystem = Server.XCharacterSystem

Test.new("XCharacterSystem.startCharacterSelection should throw error by default", function (self)
    return Test.assertError(function ()
        XCharacterSystem.startCharacterSelection(nil)
    end, "startCharacterSelection function should be overwritten by the installed character selection system (external resource).")
end)

Test.new("XCharacterSystem.startCreateNewCharacter should throw error by default", function (self)
    return Test.assertError(function ()
        XCharacterSystem.startCreateNewCharacter(nil)
    end, "startCreateNewCharacter function should be overwritten by the installed character creation system (external resource).")
end)

Test.new("XCharacterSystem.onCharacterLoaded should throw error by default", function (self)
    return Test.assertError(function ()
        XCharacterSystem.onCharacterLoaded(nil, nil)
    end, "onCharacterLoaded function should be overwritten by the installed character spawn system (external resource).")
end)
