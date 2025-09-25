---@class Pack
Pack = {}

---Packs all the functions of the given class into the given object.
---The object will also be returned for convenience (chaining).
---Packing is required, when you want to make an object available for
---outside resources, since metatables are not shared between
---different resources.
---@param obj table The object to pack the functions into.
---@param clazz table The class containing the functions to pack.
---@return table obj The object with the packed functions.
function Pack.Pack(obj, clazz)
    for k, v in pairs(clazz) do
        if type(v) == "function" then
            obj[k] = v
        elseif type(v) == "table" and getmetatable(v) then
            obj[k] = Pack.Pack(v, getmetatable(v))
        end
    end
    return obj
end
