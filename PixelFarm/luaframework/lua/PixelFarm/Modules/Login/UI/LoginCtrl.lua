local LoginLogic = require "PixelFarm.Login.Logic.LoginLogic"

local _LoginCtrl = class(CtrlBase)

function _LoginCtrl:StartView()
    print("_LoginCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Login, LoginViewNames.Login, PANEL_MID(), self.args)
end

function _LoginCtrl:Login(accout, password)
    LoginLogic:Login(accout,password,function ()
        CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
        CtrlManager:CloseCtrl(LoginCtrlNames.Login)
    end)
end

return _LoginCtrl