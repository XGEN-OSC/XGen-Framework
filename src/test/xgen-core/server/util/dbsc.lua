local sim = SIMULATION_CREATE("HELIX")
local server = SIMULATION_GET_SERVER(sim)
local resource = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-core")
RESOURCE_START(resource)

local environment = ENVIRONMENT_GET(server, resource)
local DBSC = ENVIRONMENT_GET_VAR(environment, "DBSC")

Test.new("DBSC should exist", function (self)
    return Test.assert(DBSC ~= nil, "DBSC should not be nil")
end)

Test.new("DBSC.new should create new DBSC class", function (self)
    local MyClass = DBSC:new({
        name = "my_class",
        columns = {
            { name = "id", type = "integer", primary_key = true, auto_increment = true },
            { name = "name", type = "string" },
            { name = "age", type = "integer" }
        }
    })

    return Test.assert(MyClass ~= nil, "DBSC.new should create a new class")
end)
