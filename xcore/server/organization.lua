---@class XCore
XCore = XCore or {}

---@class XCore.Organization
---@field public organizationId string the unique organization ID
---@field public accountId string the account ID associated with this organization
XCore.Organization = {}

---@type FunctionFactory
local functionFactory = nil

---Returns the account associated with this organization.
---@nodiscard
---@return XCore.Account account the organization's account
function XCore.Organization:GetAccount()
    local account = XCore.Account.ById(self.accountId)
    if not account then
        error(string.format("Account with ID '%s' not found for organization '%s'", self.accountId, self.organizationId))
    end
    return account
end

---Returns the unique identifier of the organization.
---@nodiscard
---@return string identifier the organization's unique ID
function XCore.Organization:GetIdentifier()
    return self.organizationId
end

---Returns the XCore.XId of the organization.
---@nodiscard
---@return string xId the organization's XId
function XCore.Organization:GetXId()
    return "organization:" .. self.organizationId
end

functionFactory = FunctionFactory.ForXClass(XCore.Organization)

---Retrieves an organization by its organization ID.
---@nodiscard
---@param organizationId string the unique organization ID
---@return XCore.Organization organization the retrieved organization
function XCore.Organization.ById(organizationId)
    local data = {}

    data.organizationId = organizationId
    data.accountId = XCore.Account.Create(data).accountId

    functionFactory:Apply(data)

    return data
end
