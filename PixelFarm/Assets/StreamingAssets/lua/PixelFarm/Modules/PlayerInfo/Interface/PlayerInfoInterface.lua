local PlayerLogic = require "PixelFarm.Modules.PlayerInfo.Logic.PlayerInfoLogic"
local _M = class()

-- 当前用户信息
function _M:CurrentPlayer()
    return PlayerLogic:CurrentPlayer()
end

-- 更新用户 uid
function _M:UpdateUid(uid)
    PlayerLogic:UpdateUid(uid)
end

-- 更新角色 等级
function _M:UpdateLevel(lv)
    PlayerLogic:UpdateLevel(lv)
end

return _M