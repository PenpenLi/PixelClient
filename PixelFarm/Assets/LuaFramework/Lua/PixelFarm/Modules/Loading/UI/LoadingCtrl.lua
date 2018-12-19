local LoginLogic = require "PixelFarm.Modules.Login.Logic.LoginLogic"

local _LoadingCtrl = class(CtrlBase)

function _LoadingCtrl:StartView()
    print("LoadingCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Loading, LoadingViewNames.Loading, PANEL_HIGH(), self.args)
end

function _LoadingCtrl:ShowMainView()
    if #LocalDataManager:GetUid() > 0 then
        LoginLogic:Login(LocalDataManager:GetUid(),"",function (succeed, err)
            if succeed then
                CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
            else
                CtrlManager:OpenCtrl(MoudleNames.Login, LoginCtrlNames.Login)
            end
        end)
    else
        CtrlManager:OpenCtrl(MoudleNames.Login, LoginCtrlNames.Login)
    end
    CtrlManager:CloseCtrl(LoadingCtrlNames.Loading)
end

return _LoadingCtrl