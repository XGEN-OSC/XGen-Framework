local function init()
    DB.init()
    XPlayer:init() -- Initialize the XPlayer table
    local xPlayer = XPlayer:new("Player1", math.random(18, 40))
    xPlayer:insert()
    local result = XPlayer:get({ name = "Player1" }) --[[@as XPlayer]]
    print("loaded player: " .. StringUtils.dumpTable(result))

    print("Database initialized successfully.")
end

init() -- TODO: Call this in the initialization event for this resource