---@class XAccount : DBSC a XAccount represents a banking account.
---@field bid string the unique identifier of the account
---@field balance_major integer the major balance of the account
---@field balance_minor integer the minor balance of the account
XAccount = DBSC:new({
    name = "xgen_account",
    columns = {
        { name = "bid", type = "VARCHAR(255)", primary_key = true },
        { name = "balance_major", type = "INT", default = 0, not_null = true },
        { name = "balance_minor", type = "INT", default = 0, not_null = true }
    }
})
XAccount.__index = XAccount

---Creates a new XAccount instance.
---@nodiscard
---@return XAccount account The new XAccount instance.
function XAccount:new()
    local account = {}
    setmetatable(account, self)
    account.bid = StringUtils.generate("AA-AAAA-0000")
    account:insert()
    return account
end

---Returns the current balance of the account as a floating point number.
---@nodiscard
---@return number balance The current balance of the account.
function XAccount:getBalanceFloat()
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
function XAccount:getBalance()
    return self.balance_major, self.balance_minor
end

---Adds the given amount to the account balance.
---@param major number The major part of the amount to add to the account balance.
---@param minor number The minor part of the amount to add to the account balance.
function XAccount:addBalance(major, minor)
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
function XAccount:addBalanceFloat(amount)
    if amount < 0 then
        error("Cannot add a negative amount to the account balance.")
    end

    local major = math.floor(amount)
    local minor = math.floor((amount - major) * 100)
    self:addBalance(major, minor)
end

function XAccount:__tostring()
    return string.format("XAccount(%s, %d.%02d)", self.bid, self.balance_major, self.balance_minor)
end
