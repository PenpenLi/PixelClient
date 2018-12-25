local Player = require "PixelFarm.Modules.PlayerInfo.Data.Player"

local _M = class()

function _M:CurrentPlayer()
    local player = self:LoadPlayer()
    if player == nil then
        player = Player.new()
        player:Init()
        self:SavePlayer(player)
    end
    return player
end

function _M:UpdateUid(uid)
    local player = self:CurrentPlayer()
    player.uid = uid
    self:SavePlayer(player)
end

function _M:UpdateLevel(lv)
    local player = self:CurrentPlayer()
    player.level = lv
    self:SavePlayer(player)
end

function _M:SavePlayer(player)
    LocalDataManager:Save(MoudleNames.PlayerInfo .. "_Player", player)
end

function _M:LoadPlayer()
    local key = MoudleNames.PlayerInfo .. "_Player"
    local playerTab = LocalDataManager:Load(key)
    local player = Player.new()
    player:Init(playerTab)
    return player
end

return _M