local mod = RegisterMod("Gizmo's Playhouse", 1)
local game=Game()

-- Code handling Kok item
local KOK_ITEM_ID = Isaac.GetItemIdByName("Kok")
local KOK_DAMAGE = 1.69

function mod:KokEvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(KOK_ITEM_ID)
        local damageToAdd = KOK_DAMAGE * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.KokEvaluateCache)

-- Code handling Nuke item
local NUKE_ITEM_ID = Isaac.GetItemIdByName("Nuke")

function mod:NukeUse(_)
    local roomEntities = Isaac.GetRoomEntities()
    for _, entity in ipairs(roomEntities) do
        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and not entity:IsBoss() then
            entity:Kill()
        end
    end

    return true
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.NukeUse, NUKE_ITEM_ID)

--Code handling Cocaine item
local COCAINE_ITEM_ID = Isaac.GetItemIdByName("Cocaine")
local COCAINE_DAMAGE = 0.69
local COCAINE_MOVESPEED = 0.35

function mod:CocaineEvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(COCAINE_ITEM_ID)
        local damageToAdd = COCAINE_DAMAGE * itemCount
        player.Damage = player.Damage + damageToAdd
    end
    if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
        local itemCount = player:GetCollectibleNum(COCAINE_ITEM_ID)
        local movespeedToAdd = COCAINE_MOVESPEED  * itemCount
        player.MoveSpeed = player.MoveSpeed + movespeedToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.CocaineEvaluateCache)

-- Code handling Lab-Made Virus item
-- LMV standing for Lab-Made Virus
local LMV_ITEM_ID = Isaac.GetItemIdByName("Lab-Made Virus")
local LMV_POISON_CHANCE = 0.5
local LMV_POISON_LENGTH = 5
local LMV_ONE_INTERVAL_OF_POISON = 20

function mod:LmvNewRoom()
    local playerCount = game:GetNumPlayers()

    for playerIndex = 0, playerCount -1 do
        local player = Isaac.GetPlayer(playerIndex)
        local copyCount = player:GetCollectibleNum(LMV_ITEM_ID)

        if copyCount > 0 then
            local rng = player:GetCollectibleRNG(LMV_ITEM_ID)

            local entities = Isaac.GetRoomEntities()
            for _, entity in ipairs(entities) do
                if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                    if rng:RandomFloat() < LMV_POISON_CHANCE then
                        entity:AddPoison(
                            EntityRef(player),
                            LMV_POISON_LENGTH + (LMV_ONE_INTERVAL_OF_POISON * copyCount * 2),
                            player.Damage
                        )
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.LmvNewRoom)