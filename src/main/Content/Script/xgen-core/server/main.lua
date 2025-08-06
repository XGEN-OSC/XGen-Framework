function DUMP(table)
    local str = "{ "
    for k, v in pairs(table) do
        if type(v) == "table" then
            str = str .. k .. " = " .. DUMP(v) .. ", "
        elseif type(v) == "string" then
            str = str .. k .. ' = "' .. v .. '", '
        else
            str = str .. k .. " = " .. tostring(v) .. ", "
        end
    end
    str = str .. "}"
    return str
end

local function init()
    DB.init()
    XPlayer:init() -- Initialize the XPlayer table
    local xPlayer = XPlayer:new("Player1", math.random(18, 40))
    xPlayer:insert()
    local result = XPlayer:get({ name = "Player1" }) --[[@as XPlayer]]
    print("loaded player: " .. DUMP(result))

    print("Database initialized successfully.")
end

init() -- TODO: Call this in the initialization event for this resource