local XGEN_TARGET = RESOURCE_LOAD(SIM, "src/main/Content/Script/xgen-target")
RESOURCE_START(XGEN_TARGET)
table.insert(RESOURCES, XGEN_TARGET)

local environment = ENVIRONMENT_GET(SERVER, XGEN_TARGET)
