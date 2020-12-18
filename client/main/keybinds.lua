Fox.keybinds = {}

local ragdoll = false

Fox.keybinds.binds = {
    [51] = function() Fox.utils.openSelfInventory() end, -- F2
    [318] = function() Fox.utils.openPersonnalMenu() end, -- F5
    [83] = function() 
        if not ragdoll then
            ragdoll = true
            Wait(10)
            Citizen.CreateThread(function()
                while ragdoll do
                    SetPedToRagdoll(GetPlayerPed(-1), 1000, 1000, 0, 0, 0, 0)
                    ResetPedRagdollTimer(GetPlayerPed(-1))
                    Wait(100)
                end
                SetPedToRagdoll(PlayerPedId(), 1, 1, 0, 0, 0, 0)
            end)
        else ragdoll = false end
    end
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