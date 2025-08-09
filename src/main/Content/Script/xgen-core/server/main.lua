local function init()
    DB.init()
    local xPlayer = XPlayer:new("player_identifier")
    local xCharacter = XCharacter:new(xPlayer, "John", "Doe", "1990-01-01")
    local account = xCharacter.account
    account:addBalanceFloat(100.0)
    print(StringUtils.dumpTable(xCharacter))
end

init()