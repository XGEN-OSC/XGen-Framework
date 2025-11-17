---@class XCore
XCore = XCore or {}

---@class XCore.ItemStack
---@field public itemType string the type of the item
---@field public count number the count of the item
---@field public metadata table<string, any>? optional metadata associated with the item

---@class XCore.Inventory
---@field public id string the unique identifier of the inventory
---@field public items table<number, XCore.ItemStack> the items contained in the inventory
XCore.Inventory = {}

---@type table<string, XCore.Inventory> the loaded inventories by their ID
local inventories = {}

---@type FunctionFactory
local functionFactory = nil

local function random_inventory_id()
    local charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    local inventoryID = ''
    for i = 1, 32 do
        local randIndex = math.random(1, #charset)
        inventoryID = inventoryID .. charset:sub(randIndex, randIndex)
    end
    return inventoryID
end

---Loads the inventory with the given id from the database.
---@nodiscard
---@param id string the id of the inventory to load
---@return XCore.Inventory? inventory the loaded inventory or nil if not found
local function load_inventory(id)
    local result = Database.Execute([[SELECT * FROM inventories WHERE id = ?]], { id })
    local row = result[1]
    ---@cast row { Columns: { ToTable: fun() : table<string, any> } }?
    if not row then return nil end
    local data = row.Columns:ToTable()
    if not data then return nil end
    local inventory = data
    functionFactory:Apply(inventory)
    return inventory
end

---Adds an item stack to the inventory.
---@param slot number the slot to set the item in
---@param item XCore.ItemStack the item stack to add
function XCore.Inventory:SetItem(slot, item)
    self.items[slot] = item
end

---Clears the item in the given slot.
---@param slot number the slot to clear
function XCore.Inventory:ClearSlot(slot)
    self.items[slot] = nil
end

---Returns the item stack in the given slot.
---@param slot number the slot to get the item from
---@return XCore.ItemStack? item the item stack in the slot, or nil if empty
function XCore.Inventory:GetSlot(slot)
    return self.items[slot]
end

---Returns all items in the inventory.
---@nodiscard
---@return table<number, XCore.ItemStack> items the items in the inventory
function XCore.Inventory:GetItems()
    return self.items
end

---Finds all items of the given type in the inventory.
---@nodiscard
---@param itemType string the type of the item to find
---@param metadata table<string, any>? optional metadata to match
---@return table<number, XCore.ItemStack> foundItems a table mapping slots to item stacks
function XCore.Inventory:FindByType(itemType, metadata)
    local foundItems = {}
    for slot, item in pairs(self.items) do
        if item.itemType == itemType then
            if not metadata or table.equal(item.metadata, metadata) then
                foundItems[slot] = item
            end
        end
    end
    return foundItems
end

functionFactory = FunctionFactory.ForXClass(XCore.Inventory)

---Creates a new inventory.
---@nodiscard
---@return XCore.Inventory inventory the created inventory
function XCore.Inventory.Create()
    local inventory = {}

    inventory.id = random_inventory_id()
    functionFactory:Apply(inventory)

    inventories[inventory.id] = inventory

    return inventory
end

---Returns the inventory by its ID.
---@nodiscard
---@param id string the ID of the inventory.
---@return XCore.Inventory? inventory the inventory object, or nil if not found.
function XCore.Inventory.ById(id)
    if inventories[id] then
        return inventories[id]
    end
    local inventory = load_inventory(id)
    if inventory then
        inventories[id] = inventory
    end
    return inventory
end
