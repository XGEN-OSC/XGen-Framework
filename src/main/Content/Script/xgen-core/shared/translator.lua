---@class Translator A translator can be used to translate
---translation keys to the current language.
Translator = {}

---@type table<string, string> A table containing the loaded language.
local translations = {}

---Sets the translations for the current language. The values are allowed to
---use placeholders in the form of `$lua_expression$` for Lua expressions and
---`{key}` for values from a table.
---@see StringUtils.format
---@param locale table<string, string> A table containing the translations
---for the current language.
function Translator.setTranslations(locale)
    translations = locale
end

---Translates a key to the current language.
---@nodiscard
---@param key string the key of the translation to translate.
---The key is used to look up the translation in the current language,
---if the key dosn't exist, the key itself is returned.
---@param values table<string, any> replacement values to use for the placeholders
---in the translation. Placeholders can be in the form of `$lua_expression$`
---for Lua expressions and `{key}` for values from the table.
---@see StringUtils.format
---@return string translated the translated and formatted string
function Translator.translate(key, values)
    local translation = translations[key] or key
    return StringUtils.format(translation, values)
end
