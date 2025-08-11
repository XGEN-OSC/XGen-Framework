local environment = ENVIRONMENT_GET(SERVER, XGEN_CORE)
local Translator = ENVIRONMENT_GET_VAR(environment, "Translator")

Test.new("Translator should exist", function (self)
    return Test.assert(Translator ~= nil, "Translator should not be nil")
end)

Test.new("Translator.setTranslations should assign translations", function (self)
    local translations = { hello = "Hello", goodbye = "Good Bye" }
    Translator.setTranslations("en", translations)
    return Test.assertEqual(Translator.translate("hello"), "Hello", "Translator.setTranslations should assign translations correctly")
end)

Test.new("Translator.translate should return key if translation does not exist", function (self)
    local translations = { hello = "Hello" }
    Translator.setTranslations("en", translations)
    return Test.assertEqual(Translator.translate("goodbye"), "goodbye", "Translator.translate should return key if translation does not exist")
end)

Test.new("Translator.translate should format translation with values", function (self)
    local translations = { greeting = "Hello, {name}!" }
    Translator.setTranslations("en", translations)
    return Test.assertEqual(Translator.translate("greeting", { name = "World" }), "Hello, World!", "Translator.translate should format translation with values correctly")
end)
