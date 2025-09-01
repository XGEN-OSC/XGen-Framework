local Server = ENVIRONMENT_GET_VAR(ENVIRONMENT, "Server") --[[@as Server]]

local XAccount = Server.XAccount

Test.new("XAccount should exist", function()
    return Test.assert(XAccount ~= nil, "XAccount should exist")
end)

Test.new("XAccount.hasBalanceFloat should return true for sufficient balance", function (self)
    local account = XAccount:new()
    account:addBalanceFloat(11.50)
    return Test.assert(account:hasBalanceFloat(10.50), "Account should have sufficient balance")
end)

Test.new("XAccount.hasBalanceFloat should return true for sufficient balance", function()
    local account = XAccount:new()
    account:addBalanceFloat(10.50)

    return Test.assert(account:hasBalanceFloat(10.50), "Account should have sufficient balance")
end)

Test.new("XAccount.hasBalanceFloat should return false for insufficient balance", function()
    local account = XAccount:new()
    account:addBalanceFloat(10.50)

    return Test.assert(not account:hasBalanceFloat(11.00), "Account should not have sufficient balance")
end)

Test.new("XAccount.hasBalance should return true for sufficient balance", function()
    local account = XAccount:new()
    account:addBalance(11, 50)
    return Test.assert(account:hasBalance(10, 50), "Account should have sufficient balance")
end)

Test.new("XAccount.hasBalance should return true for sufficient balance", function()
    local account = XAccount:new()
    account:addBalance(10, 50)

    return Test.assert(account:hasBalance(10, 50), "Account should have sufficient balance")
end)

Test.new("XAccount.hasBalance should return false for insufficient balance", function()
    local account = XAccount:new()
    account:addBalance(10, 50)

    return Test.assert(not account:hasBalance(11, 0), "Account should not have sufficient balance")
end)

Test.new("XAccount.addBalance should add balance correctly", function()
    local account = XAccount:new()
    account:addBalance(10, 50)

    local major, minor = account:getBalance()
    return Test.assert(major == 10 and minor == 50, "Account balance should be 10 major and 50 minor")
end)

Test.new("XAccount.addBalance should handle overflow correctly", function()
    local account = XAccount:new()
    account:addBalance(10, 150) -- This should result in 11 major and 50 minor

    local major, minor = account:getBalance()
    return Test.assert(major == 11 and minor == 50, "Account balance should be 11 major and 50 minor after overflow")
end)

Test.new("XAccount.addBalance should not allow negative amounts", function()
    local account = XAccount:new()

    return Test.assertError(function()
        account:addBalance(-10, -50)
    end, "Cannot add a negative amount to the account balance.")
end)

Test.new("XAccount.addBalanceFloat should add balance correctly", function()
    local account = XAccount:new()
    account:addBalanceFloat(10.50)

    return Test.assert(account:getBalanceFloat() == 10.50, "Account balance should be 10.50")
end)

Test.new("XAccount.addBalanceFloat should handle overflow correctly", function()
    local account = XAccount:new()
    account:addBalanceFloat(10.50) -- 10 major, 50 minor
    account:addBalanceFloat(0.75) -- This should result in 11 major, 25 minor

    return Test.assert(account:getBalanceFloat() == 11.25, "Account balance should be 11.25 after overflow")
end)

Test.new("XAccount.addBalanceFloat should not allow negative amounts", function()
    local account = XAccount:new()

    return Test.assertError(function()
        account:addBalanceFloat(-10.50)
    end, "Cannot add a negative amount to the account balance.")
end)

Test.new("XAccount.removeBalanceFloat should remove balance correctly", function()
    local account = XAccount:new()
    account:addBalanceFloat(10.50)
    account:removeBalanceFloat(5.25)

    return Test.assert(account:getBalanceFloat() == 5.25, "Account balance should be 5.25 after removal")
end)

Test.new("XAccount.removeBalanceFloat should not allow negative amounts", function()
    local account = XAccount:new()

    return Test.assertError(function()
        account:removeBalanceFloat(-10.50)
    end, "Cannot remove a negative amount from the account balance.")
end)

Test.new("XAccount.removeBalance should remove balance correctly", function()
    local account = XAccount:new()
    account:addBalance(10, 50)
    account:removeBalance(5, 25)

    local major, minor = account:getBalance()
    return Test.assert(major == 5 and minor == 25, "Account balance should be 5 major and 25 minor after removal")
end)

Test.new("XAccount.removeBalance should handle underflow correctly", function()
    local account = XAccount:new()
    account:addBalance(10, 50) -- 10 major, 50 minor

    return Test.assertError(function()
        account:removeBalance(11, 0)
    end, "Insufficient funds to remove from account balance.")
end)

Test.new("XAccount.removeBalance should not allow negative amounts", function()
    local account = XAccount:new()

    return Test.assertError(function()
        account:removeBalance(-10, -50)
    end, "Cannot remove a negative amount from the account balance.")
end)

Test.new("XAccount.getFormattedBalance should return the correct string", function()
    local account = XAccount:new()
    account:addBalance(10, 50)

    return Test.assert(account:getFormattedBalance() == "10.50", "Formatted balance should be '10.50'")
end)

Test.new("XAccount.getFormattedBalance should return the correct string with minor part", function()
    local account = XAccount:new()
    account:addBalance(1000, 99)

    return Test.assert(account:getFormattedBalance() == "1,000.99", "Formatted balance should be '1000.99'")
end)

Test.new("XAccount.getFormattedBalance should return the correct string with minor part", function()
    local account = XAccount:new()
    account:addBalance(100000, 99)

    return Test.assert(account:getFormattedBalance() == "100,000.99", "Formatted balance should be '100,000.99'")
end)

Test.new("XAccount.send should transfer balance correctly", function()
    local account1 = XAccount:new()
    local account2 = XAccount:new()

    account1:addBalanceFloat(20.00)
    account1:send(10, 0, account2, "transfer")

    return Test.assert(account1:getBalanceFloat() == 10.00 and account2:getBalanceFloat() == 10.00,
        "Account 1 should have 10.00 and Account 2 should have 10.00 after transfer")
end)


Test.new("XAccount.send should not allow sending more than balance", function()
    local account1 = XAccount:new()
    local account2 = XAccount:new()

    account1:addBalanceFloat(10.00)

    return Test.assertError(function()
        account1:send(11, 0, account2, "transfer")
    end, "Insufficient funds to send from account balance.")
end)

Test.new("XAccount.sendFloat should transfer balance correctly", function()
    local account1 = XAccount:new()
    local account2 = XAccount:new()

    account1:addBalanceFloat(20.00)
    account1:sendFloat(10.00, account2, "transfer")

    return Test.assert(account1:getBalanceFloat() == 10.00 and account2:getBalanceFloat() == 10.00,
        "Account 1 should have 10.00 and Account 2 should have 10.00 after transfer")
end)

Test.new("XAccount.sendFloat should not allow sending more than balance", function()
    local account1 = XAccount:new()
    local account2 = XAccount:new()

    account1:addBalanceFloat(10.00)

    return Test.assertError(function()
        account1:sendFloat(11.00, account2, "transfer")
    end, "Insufficient funds to send from account balance.")
end)

Test.new("XAccount.getTransactions should return an empty table if no transactions exist", function()
    local account = XAccount:new()
    return Test.assertEqual(account:getTransactions(), {}, "Account should have no transactions")
end)

Test.new("XAccount.getTransactions should return all transactions associated with the account", function()
    local account1 = XAccount:new()
    local account2 = XAccount:new()

    account1:addBalanceFloat(20.00)
    account1:sendFloat(10.00, account2, "transfer")

    local transactions = account1:getTransactions()
    return Test.assert(#transactions == 1 and transactions[1].from_bid == account1.bid and transactions[1].to_bid == account2.bid,
        "Account 1 should have one transaction to Account 2")
end)

Test.new("XAccount.tostring should return the correct string representation", function()
    local account = XAccount:new()
    account:addBalance(10, 50)

    return Test.assertEqual(tostring(account), "XAccount(" .. tostring(account.bid) .. ", 10.50)", "String representation should be 'XAccount(" .. tostring(account.bid) .. "10.50)'")
end)
