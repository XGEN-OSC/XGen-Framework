local sim = SIMULATION_CREATE("HELIX")

local core = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-core")
local multicharacter = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-multicharacter")
local charcreator = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-charcreator")
local spawn = RESOURCE_LOAD(sim, "src/main/Content/Script/xgen-spawn")

RESOURCE_START(core)
RESOURCE_START(multicharacter)
RESOURCE_START(charcreator)
RESOURCE_START(spawn)

local server = SIMULATION_GET_SERVER(sim)
local environment = ENVIRONMENT_GET(server, core)
local XPlayer = ENVIRONMENT_GET_VAR(environment, "XPlayer") --[[@as XPlayer]]
local XCharacter = ENVIRONMENT_GET_VAR(environment, "XCharacter") --[[@as XCharacter]]

local xPlayer = XPlayer:new("identifier")
xPlayer:connected()

local xCharacter = XCharacter:new(xPlayer, "John", "Doe", "2025-04-01")
if xPlayer:loadCharacter(xCharacter.citizen_id) then
    print("Character loaded successfully for " .. xPlayer.identifier)
end