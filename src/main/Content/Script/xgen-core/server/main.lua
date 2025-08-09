local function init()
    DB.init()
    local xPlayer = XPlayer:new("player_identifier")
    local xCharacter = XCharacter:new(xPlayer, "John", "Doe", "1990-01-01")
    local account = xCharacter.account
    account:addBalanceFloat(100.0)

    local account2 = XAccount:new()
    account2:addBalance(50, 75)

    account2:sendFloat(25.50, account, "Payment for services")
    print(StringUtils.dumpTable(account2:getTransactions()))
end

init()