local XGEN_BANKING = RESOURCE_LOAD(SIM, "src/main/Content/Script/xgen-banking")
RESOURCE_START(XGEN_BANKING)
table.insert(RESOURCES, XGEN_BANKING)

local environment = ENVIRONMENT_GET(SERVER, XGEN_BANKING)
