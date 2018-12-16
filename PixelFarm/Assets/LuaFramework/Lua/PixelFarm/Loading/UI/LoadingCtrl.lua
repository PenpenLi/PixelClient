LoginLogic = require "PixelFarm.Login.Logic.LoginLogic"

local _LoadingCtrl = class(CtrlBase)

function _LoadingCtrl:StartView()
    print("LoadingCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Loading, LoadingViewNames.Loading, PANEL_TOP(), self.args)
end

function _LoadingCtrl:ShowMainView()
    if #LocalDataManager:GetUid() > 0 then
        LoginLogic:Login(LocalDataManager:GetUid(),"123",function ()
            CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
        end)
    else
        CtrlManager:OpenCtrl(MoudleNames.Login, LoginCtrlNames.Login)
    end
    CtrlManager:CloseCtrl(LoadingCtrlNames.Loading)
end

return _LoadingCtrl