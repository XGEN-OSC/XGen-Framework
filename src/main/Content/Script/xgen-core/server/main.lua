local function init()
    DB.init()
    local account = XAccount:new()
    account:addBalance(100000, 50)
    account:removeBalanceFloat(0.5)
    print(account:getFormattedBalance())
end

init()