---@class Server
Server = Server or {}

---@class Server.XAccount : Server.DBSC a XAccount represents a banking account.
---@field bid string the unique identifier of the account
---@field balance_major integer the major balance of the account
---@field balance_minor integer the minor balance of the account
Server.XAccount = Server.DBSC:new({
    name = "xgen_account",
    columns = {
        { name = "bid", type = "VARCHAR(255)", primary_key = true },
        { name = "balance_major", type = "INT", default = 0, not_null = true },
        { name = "balance_minor", type = "INT", default = 0, not_null = true }
    }
})
Server.XAccount.__index = Server.XAccount

---Creates a new XAccount instance.
---@nodiscard
---@return Server.XAccount account The new XAccount instance.
function Server.XAccount:new()
    local account = {}
    setmetatable(account, self)
    account.bid = StringUtils.generate("AA-AAAA-0000")
    account.balance_major = 0
    account.balance_minor = 0
    account:insert()
    return account
end

---Returns the current balance of the account as a floating point number.
---@nodiscard
---@return number balance The current balance of the account.
function Server.XAccount:getBalanceFloat()
    return self.balance_major + (self.balance_minor / 100)
end

---Returns the current balance of the account, as two seperate integers.
---The first integer is the major balance and the second integer is the
---minor balance.
---the major balance is the whole number part of the balance and the
---minor balance is the fractional part of the balance, multiplied by 100.
---If you don't care about floating point precision, you can use
---`XAccount:getBalanceFloat()` instead.
---@nodiscard
---@return integer balance_major The major balance of the account.
---@return integer balance_minor The minor balance of the account.
function Server.XAccount:getBalance()
    return self.balance_major, self.balance_minor
end

---Checks if the account has at least the given amount of balance.
---@nodiscard
---@param amount number The amount to check against the account balance.
---@return boolean has_balance True if the account has at least the given amount of balance, false otherwise.
function Server.XAccount:hasBalanceFloat(amount)
    return self:getBalanceFloat() >= amount
end

---Checks if the account has at least the given amount of balance.
---@nodiscard
---@param major number The major part of the amount to check against the account balance.
---@param minor number The minor part of the amount to check against the account balance.
---@return boolean has_balance True if the account has at least the given amount of balance, false otherwise.
function Server.XAccount:hasBalance(major, minor)
    major = math.floor(major)
    minor = math.floor(minor)

    if self.balance_major > major then
        return true
    elseif self.balance_major == major and self.balance_minor >= minor then
        return true
    end

    return false
end

---Adds the given amount to the account balance.
---@param major number The major part of the amount to add to the account balance.
---@param minor number The minor part of the amount to add to the account balance.
function Server.XAccount:addBalance(major, minor)
    if major < 0 or minor < 0 then
        error("Cannot add a negative amount to the account balance.")
    end

    major = math.floor(major)
    minor = math.floor(minor)

    local _major = self.balance_major
    local _minor = self.balance_minor

    self.balance_major = self.balance_major + major
    self.balance_minor = self.balance_minor + minor
    if self.balance_minor >= 100 then
        self.balance_major = self.balance_major + math.floor(self.balance_minor / 100)
        self.balance_minor = self.balance_minor % 100
    end

    if not self:update() then
        self.balance_major = _major
        self.balance_minor = _minor
        error("Failed to update account balance.")
    end
end


---Adds a floating point amount to the account balance.
---When using larger amounts, this may lead to floating point precision issues.
---If you want to avoid this, use `XAccount:addBalance(major, minor)` instead.
---@param amount number The amount to add to the account balance.
function Server.XAccount:addBalanceFloat(amount)
    if amount < 0 then
        error("Cannot add a negative amount to the account balance.")
    end

    local major = math.floor(amount)
    local minor = math.floor((amount - major) * 100)
    self:addBalance(major, minor)
end

---Removes the given amount from the account balance.
---@param major number The major part of the amount to remove from the account balance.
---@param minor number The minor part of the amount to remove from the account balance.
function Server.XAccount:removeBalance(major, minor)
    if major < 0 or minor < 0 then
        error("Cannot remove a negative amount from the account balance.")
    end

    major = math.floor(major)
    minor = math.floor(minor)

    local _major = self.balance_major
    local _minor = self.balance_minor

    if self.balance_major < major or (self.balance_major == major and self.balance_minor < minor) then
        error("Insufficient funds to remove from account balance.")
    end

    self.balance_major = self.balance_major - major
    self.balance_minor = self.balance_minor - minor
    if self.balance_minor < 0 then
        self.balance_major = self.balance_major - 1
        self.balance_minor = self.balance_minor + 100
    end

    if not self:update() then
        self.balance_major = _major
        self.balance_minor = _minor
        error("Failed to update account balance.")
    end
end

---Removes a floating point amount from the account balance.
---@param amount number The amount to remove from the account balance.
function Server.XAccount:removeBalanceFloat(amount)
    if amount < 0 then
        error("Cannot remove a negative amount from the account balance.")
    end

    local major = math.floor(amount)
    local minor = math.floor((amount - major) * 100)
    self:removeBalance(major, minor)
end

---Returns the amount of money on this account as a string, using the
---currency formatting defined in `Config.Currency.format`.
---@nodiscard
---@return string formatted_balance The formatted balance of the account.
function Server.XAccount:getFormattedBalance()
    local thousandsSeparator = Config.Currency.format.thousandsSeparator
    local decimalSeparator = Config.Currency.format.decimalSeparator

    local formatted_major = tostring(self.balance_major)
        :reverse():gsub("(%d%d%d)", "%1" .. thousandsSeparator)
        :reverse()
    if formatted_major:sub(1, 1) == thousandsSeparator then
        formatted_major = formatted_major:sub(2)
    end
    local formatted_minor = string.format("%02d", self.balance_minor)

    return string.format("%s%s%s", formatted_major, decimalSeparator, formatted_minor)
end

---Sends the given amount of money to the given account.
---@param major number
---@param minor number
---@param to_account Server.XAccount
---@param reason string
---@return Server.XTransaction transaction the created transaction
function Server.XAccount:send(major, minor, to_account, reason)
    if not self:hasBalance(major, minor) then
        error("Insufficient funds to send money.")
    end

    self:removeBalance(major, minor)
    to_account:addBalance(major, minor)

    local transaction = Server.XTransaction:new(self.bid, to_account.bid, major, minor, reason or "Transfer")
    if not transaction then
        error("Failed to create transaction.")
    end

    return transaction
end


---Sends the given amount of money to the given account.
---@param amount number
---@param to_account Server.XAccount
---@param reason string
---@return Server.XTransaction transaction the created transaction
function Server.XAccount:sendFloat(amount, to_account, reason)
    local major = math.floor(amount)
    local minor = math.floor((amount - major) * 100)

    return self:send(major, minor, to_account, reason)
end

---Returns a table of all transactions associated with this account.
---@nodiscard
---@return table<Server.XTransaction> transactions all transactions of this account.
function Server.XAccount:getTransactions()
    local sent = Server.XTransaction:getWhere({from_bid = self.bid}) --[[@as table<Server.XTransaction>]]
    local received = Server.XTransaction:getWhere({to_bid = self.bid}) --[[@as table<Server.XTransaction>]]
    local transactions = {}

    for _, tx in ipairs(sent) do
        table.insert(transactions, tx)
    end
    for _, tx in ipairs(received) do
        table.insert(transactions, tx)
    end

    return transactions
end

---Returns a string representation of the account.
---@return string str The string representation of the account.
function Server.XAccount:__tostring()
    return string.format("XAccount(%s, %d.%02d)", self.bid, self.balance_major, self.balance_minor)
end
