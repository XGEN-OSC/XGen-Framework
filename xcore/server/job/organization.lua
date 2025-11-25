---@class XCore
XCore = XCore or {}

---@class XCore.Organization
---@field public organizationId string the unique organization ID
---@field public accountId string the account ID associated with this organization
---@field public jobData Config.Job the job configuration data associated with this organization
XCore.Organization = {}

---@type FunctionFactory
local functionFactory = nil

---@type table<string,XCore.Organization>
local cache = {}

---Loads the organization with the given organization ID.
---@nodiscard
---@param orgId string the unique organization ID
---@return XCore.Organization? organization the loaded organization
local function load(orgId)
    local raw = Database.Select([[
        SELECT * FROM organizations
        WHERE organizationId = ?
    ]], { orgId })
    if not raw then return nil end
    ---@cast raw { Columns: { ToTable: fun() : table<string, any> } }
    local data = raw.Columns.ToTable()
    local org = {}

    functionFactory:Apply(org)
    return org
end

---Creates a new organization with the given organization ID.
---@param id string the unique organization ID
---@return XCore.Organization organization the created organization
local function create(id)
    local org = {}
    org.organizationId = id
    functionFactory:Apply(org)
    org.accountId = XCore.Account.Create(org).accountId
    Database.Execute([[
        INSERT INTO organizations (organizationId, accountId)
        VALUES (?, ?)
    ]], { org.organizationId, org.accountId })
    return org
end

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
    if not Config.jobs[organizationId] then
        errorf("Job configuration for organization ID '{organizationId}' not found", { organizationId = organizationId })
    end
    if cache[organizationId] then
        return cache[organizationId]
    end
    local org = load(organizationId)
    org.jobData = Config.jobs[organizationId]
    cache[organizationId] = org
    if org then return org end

    org = create(organizationId)
    org.jobData = Config.jobs[organizationId]
    cache[organizationId] = org
    return org
end
