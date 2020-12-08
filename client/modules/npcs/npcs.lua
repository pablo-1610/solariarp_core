local npcs = {}

Fox.npcs = {}



local function create(model, frozen, ignoreAll, weapon, scenario, x, y, z, heading, clientSide,invincible)
    Fox.clientutils.requestModel(model)
    local currentPed = CreatePed(9, GetHashKey(model), x, y, z, heading, not clientSide, false)
    Fox.clientutils.forgetModel(model)
    Fox.trace("Creating new NPC, id is "..#npcs.." and model is "..model)
    if frozen then Citizen.SetTimeout(1000, function() FreezeEntityPosition(currentPed, true) end) end
    if invincible then SetEntityInvincible(currentPed, true) end
    if ignoreAll then SetBlockingOfNonTemporaryEvents(currentPed, true) end
    if weapon then GiveWeaponToPed(currentPed, GetHashKey(weapon), 1500, false, true) end
    if scenario then Citizen.SetTimeout(1200, function() TaskStartScenarioInPlace(currentPed, scenario, -1, false) end) end 
    SetEntityAsMissionEntity(currentPed, true, true)
    local uniqueID = #npcs
    npcs[#npcs] = currentPed
    return currentPed, uniqueID
end
Fox.npcs.create = create

local function delete(id)
    if not npcs[id] then return end
    DeleteEntity(npcs[id])
end
Fox.npcs.delete = delete

local function moove(id, to)
    if not npcs[id] then return end
    SetEntityCoords(npcs[id], to, 0,0,0,0)
end
Fox.npcs.moove = moove

local function stopAnim(id, smooth)
    if not npcs[id] then return end
    if smooth then ClearPedTasks(npcs[id]) else ClearPedTasksImmediately(npcs[id]) end
end
Fox.npcs.stopAnim = stopAnim

local function playAnim(id, anim, smooth)
    if not npcs[id] then return end
    stopAnim(id, 0)
    if smooth then TaskStartScenarioInPlace(npcs[id], anim, 0, 1) else TaskStartScenarioInPlace(npcs[id], anim, 0, 0) end
end
Fox.npcs.playAnim = playAnim

local function setIgnore(id, bool)
    if not npcs[id] then return end
    SetBlockingOfNonTemporaryEvents(npcs[id], bool)
end
Fox.npcs.setIgnore = setIgnore

local function setHealth(id, float)
    if not npcs[id] then return end
    SetEntityHealth(npcs[id], float)
end
Fox.npcs.setHealth = setHealth

local function setArmor(id, float)
    if not npcs[id] then return end
    SetPedArmour(npcs[id], float)
end
Fox.npcs.setArmor = setArmor

local function getHealth(id)
    if not npcs[id] then return end
    return GetEntityHealth(npcs[id])
end
Fox.npcs.getHealth = getHealth

local function getArmor(id)
    if not npcs[id] then return end
    return GetPedArmour(npcs[id])
end
Fox.npcs.getArmor = getArmor

local function getTotalHealth(id)
    if not npcs[id] then return end
    return getHealth(id) + getArmor(id)
end
Fox.npcs.getTotalHealth = getTotalHealth

local function kill(id)
    if not npcs[id] then return end
    ApplyDamageToPed(npcs[id], GetEntityMaxHealth(npcs[id]), 0)
end
Fox.npcs.kill = kill
