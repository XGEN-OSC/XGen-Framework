---@class Config
---@field Currency Config.Currency
Config = Config or {}

---@class Config.Currency configuration for the currency
---used in the framework.
---@field symbol string the symbol used for the currency
---@field name string the name of the currency
---@field format Config.Currency.format configuration for the currency formatting
Config.Currency = {}

--the symbol used for the currency
Config.Currency.symbol = '$'

--the name of the currency
Config.Currency.name = 'Dollar'

---@class Config.Currency.format configuration for the
---currency formatting.
---@field thousandsSeparator string the symbol used to seperate the thousands
---@field decimalSeparator string the symbol used to seperate the decimal places
Config.Currency.format = {}

--the symbol used to seperate the thousands
Config.Currency.format.thousandsSeparator = ','

--the symbol used to seperate the decimal places
Config.Currency.format.decimalSeparator = '.'
