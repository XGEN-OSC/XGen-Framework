---Copies the given value. If it's a table, performs a deep copy.
---@generic T
---@nodiscard
---@param orig T the value to copy
---@return T copy the copied value
function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}

        for key, value in pairs(orig) do
            copy[table.deepcopy(key)] = table.deepcopy(value)
        end

        return copy
    else
        return orig
    end
end

---Compares two tables for equality. Performs a deep comparison.
---@nodiscard
---@param t1 table the first table
---@param t2 table the second table
---@return boolean equal whether the tables are equal
function table.equal(t1, t2)
    if t1 == t2 then return true end
    if type(t1) ~= 'table' or type(t2) ~= 'table' then return false end

    for k, v in pairs(t1) do
        if not table.equal(v, t2[k]) then
            return false
        end
    end

    for k, v in pairs(t2) do
        if not table.equal(v, t1[k]) then
            return false
        end
    end

    return true
end
