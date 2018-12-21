local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"

local _M = class()

LoginInterface = _M.Instance()

-- 登录
function _M:Login(accout, password, cb)
    return LoginLogic:Login(accout,password,cb)
end

-- 获取登录用户的Uid
function _M:GetUid()
    return LoginLogic:LoadUid()
end