---@class XTransaction : DBSC
XTransaction = DBSC:new({
    name = "xgen_transaction",
    columns = {
        { name = "transaction_id", type = "VARCHAR(255)", primary_key = true },
        { name = "from_bid", type = "VARCHAR(255)", not_null = true },
        { name = "to_bid", type = "VARCHAR(255)", not_null = true },
        { name = "amount_major", type = "INT", not_null = true },
        { name = "amount_minor", type = "INT", not_null = true },
        { name = "reason", type = "TEXT", not_null = true },
        { name = "timestamp", type = "TIMESTAMP", not_null = true }
    }
})
XTransaction.__index = XTransaction

---Creates a new Transaction object.
---@nodiscard
---@param from_bid string the bid of the account this transaction is from
---@param to_bid string the bid of the account this transaction is to
---@param amount_major number the major amount of the transaction
---@param amount_minor number the minor amount of the transaction
---@param reason string the reason for the transaction
---@return XTransaction xTransaction the transaction
function XTransaction:new(from_bid, to_bid, amount_major, amount_minor, reason)
    local instance = {}
    setmetatable(instance, self)
    instance.transaction_id = StringUtils.generate("TX-....-....-....-....")
    instance.from_bid = from_bid
    instance.to_bid = to_bid
    instance.reason = reason
    instance.amount_major = amount_major
    instance.amount_minor = amount_minor
    instance.timestamp = os.date("%Y-%m-%d %H:%M:%S")
    if not instance:insert() then
        error("Failed to create transaction: " .. instance.transaction_id .. "(transaction id already in use?)")
    end
    return instance
end
