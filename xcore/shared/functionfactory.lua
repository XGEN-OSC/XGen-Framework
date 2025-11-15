---@class FunctionFactory a function factory allowes to create functions producing
---functions for xObjects. By trapping the given xObject inside the produced function,
---the self reference problem when calling a function on a referenced object from another
---resource is solved.
FunctionFactory = {}
FunctionFactory.__index = FunctionFactory

---Creates a new function to generate functions for given xobjects.
---@nodiscard
---@param func fun(xObject: any, ...: any) : any the function for which to create a factory
---@return fun(xObject: any) : fun(...: any) : any factoryFunction the function factory
local function createFactory(func)
    return function(xObject)
        return function(_, ...)
            -- ignore the first parameter since it is the
            -- xObject, but the version that might be based on a
            -- wrong self reference, so correct it with the trapped xObject
            return func(xObject, ...)
        end
    end
end

---Creates a function factory for all functions in the given xClass.
---@nodiscard
---@param xClass table<string, any> the xClass containing functions
---@return FunctionFactory factory the function factory for the xClass
function FunctionFactory.ForXClass(xClass)
    local factory = {}
    for name, func in pairs(xClass) do
        if type(func) == "function" then
            factory[name] = createFactory(func)
        end
    end
    setmetatable(factory, FunctionFactory)
    return factory
end

---Applies all functions from the function factory to the given xObject.
---@param xObject table the xObject to which the functions should be applied
function FunctionFactory:Apply(xObject)
    for name, factory in pairs(self) do
        xObject[name] = factory(xObject)
    end
end
