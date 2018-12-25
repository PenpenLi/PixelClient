local Plant = require "PixelFarm.Modules.Farm.Data.Plant"
local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"

local _M = class()

function _M:GetPlants()
    local plants = {}

    local data = {
        {name="小麦", unLockLevel = 1, cost = 1},{name="玉米", unLockLevel = 3},{name="胡萝卜", unLockLevel = 5},
        {name="甘蔗", unLockLevel = 99},{name="棉花", unLockLevel = 99},{name="草莓", unLockLevel = 99},
        {name="西红柿", unLockLevel = 99},{name="松树", unLockLevel = 99},{name="土豆", unLockLevel = 99},
        {name="可可树", unLockLevel = 99},{name="橡胶树", unLockLevel = 99},{name="丝绸树", unLockLevel = 99},
        {name="辣椒", unLockLevel = 99},{name="水稻", unLockLevel = 99},{name="玫瑰", unLockLevel = 99},
        {name="茉莉", unLockLevel = 99},{name="咖啡树", unLockLevel = 99}
    }

    local player = PlayerInterface:CurrentPlayer()
    for i,v in ipairs(data) do
        local plant = Plant.new()
        plant:Init(v)

        if plant.unLockLevel <= player.level then
            plant.isLock = false
        end

        plants[i] = plant 
    end

    return plants
end

-- 获取当前的土地数量
function _M:GetTotalLand()
    local player = PlayerInterface:CurrentPlayer()
    return player.people / 25
end

-- 操作结算
function _M:OperComplete(plant, grow, gain)
    local cost = -1 * plant.cost * grow
    PlayerInterface:UpdateOffsetCoin(cost)
end

return _M