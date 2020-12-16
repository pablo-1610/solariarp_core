Fox.keybinds = {}

Fox.keybinds.binds = {
    [289] = function() Fox.utils.openSelfInventory() end
}

Fox.keybinds.createBinds = function()
    Fox.thread.tick(function()
        while true do
            Wait(1)
            for bind,action in pairs(Fox.keybinds.binds) do
                if IsControlJustPressed(0, bind) then action() end
            end
        end
    end, "keybinds")
end