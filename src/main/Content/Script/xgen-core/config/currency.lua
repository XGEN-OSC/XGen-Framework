---@class Config
Config = Config or {}

---@class Config.Currency configuration for the currency
---used in the framework.
Config.Currency = {}

---@type string the symbol used for the currency
Config.Currency.symbol = '$'

---@type string the name of the currency
Config.Currency.name = 'Dollar'

---@class Config.Currency.format configuration for the
---currency formatting.
Config.Currency.format = {
    ---@type string the symbol used to seperate the thousands
    thousandsSeparator = ',',

    ---@type string the symbol used to seperate the decimal places
    decimalSeparator = '.',
}
