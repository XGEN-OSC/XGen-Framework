local function payPaycheck()
    for _, character in ipairs(XCore.Character.AllActive()) do
        ---@cast character XCore.Character
        character:PayPaycheck()
    end
end

Timer.SetInterval(payPaycheck, Config.paycheckInterval * 60 * 1000)
