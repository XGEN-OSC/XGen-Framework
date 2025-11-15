---@class XCore
XCore = XCore or {}

---@class XCore.Account
---@field public accountId string the unique account ID
---@field public balance number the account balance
---@field public owner string the identifier of the owner (for players: 'citizen:<citizen_id>', for businesses: 'business:<business_id>')
XCore.Account = {}

---@type FunctionFactory
local functionFactory = nil

local function createAccountId()
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    local accountId = ''
    for i = 1, 8 do
        local randIndex = math.random(1, #charset)
        accountId = accountId .. charset:sub(randIndex, randIndex)
    end
    accountId = accountId .. "-"
    for i = 1, 4 do
        local random = math.random(0, 9)
        accountId = accountId .. tostring(random)
    end
    return accountId
end

---Returns the account balance.
---@nodiscard
---@return number balance the account balance
function XCore.Account:GetBalance()
    return self.balance
end

---Sets the account balance to the given amount.
---@param amount number the new account balance
function XCore.Account:SetBalance(amount)
    self.balance = amount
end

---Adds the given amount to the account balance.
---@param amount number the amount to add
function XCore.Account:AddBalance(amount)
    self.balance = self.balance + amount
end

---Removes the given amount from the account balance.
---@param amount number the amount to remove
function XCore.Account:RemoveBalance(amount)
    self.balance = self.balance - amount
end

---Returns the owner of the account.
---@nodiscard
---@return XCore.Character owner the owner of the account
function XCore.Account:GetOwner()
    if self.owner:sub(1, 8) == "citizen" then
        local citizenId = self.owner:sub(10)
        local character = XCore.Character.ByCitizenID(citizenId)
        if character then
            return character
        else
            error("Character with citizen ID '" ..
                citizenId .. "' not found for account '" .. self.accountId .. "'. Manually deleted?")
        end
    else
        error("Owner type for owner identifier '" ..
            self.owner .. "' not (yet) supported for account '" .. self.accountId .. "'.")
    end
end

---Saves the account data to the database.
function XCore.Account:Save()
    Database.ExecuteAsync([[
        REPLACE INTO accounts (account_id, balance, owner)
        VALUES (?, ?, ?);
    ]], { self.accountId, self.balance, self.owner })
end

-- create the factory here, so the static functions won't be included
functionFactory = FunctionFactory.ForXClass(XCore.Account)

---Creates a new account for the given owner.
---@nodiscard
---@param owner XCore.Player the player who will own the account
---@return XCore.Account account the newly created account
function XCore.Account.Create(owner)
    local account = {}

    account.accountId = createAccountId()
    account.balance = 0
    account.owner = "citizen:" .. owner:GetIdentifier()
    functionFactory:Apply(account)
    account:Save()

    return account
end

---Retrieves an account by its account ID.
---@nodiscard
---@param accountId string the unique account ID
---@return XCore.Account? account the retrieved account or nil if not found
function XCore.Account.ById(accountId)
    local result = Database.Execute([[
        SELECT *
        FROM accounts
        WHERE account_id = ?
    ]], { accountId })
    local row = result[1]
    ---@cast row { Columns: { ToTable: fun() : table<string, any> } }?
    if not row then return nil end
    local data = row.Columns:ToTable()
    if not data then return nil end
    local account = data
    functionFactory:Apply(account)
    return account
end
