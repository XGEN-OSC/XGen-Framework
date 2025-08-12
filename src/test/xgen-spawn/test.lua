local XGEN_SPAWN = RESOURCE_LOAD(SIM, "src/main/Content/Script/xgen-spawn")
RESOURCE_START(XGEN_SPAWN)
table.insert(RESOURCES, XGEN_SPAWN)

local environment = ENVIRONMENT_GET(SERVER, XGEN_SPAWN)
