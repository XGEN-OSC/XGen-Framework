local function init()
    DB.init()
    local xPlayer = XPlayer:new("player_identifier")
    xPlayer:connected()
end

init()