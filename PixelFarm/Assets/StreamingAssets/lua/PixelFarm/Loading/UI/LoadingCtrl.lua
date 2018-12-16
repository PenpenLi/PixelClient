
local _LoadingCtrl = class(CtrlBase)

function _LoadingCtrl:StartView()
    print("LoadingCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Loading, LoadingViewNames.Loading, PANEL_TOP(), self.args)
end

function _LoadingCtrl:ShowMainView()
    if LocalDataManager:GetUid().len > 0 then
        CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    else
        CtrlManager:OpenCtrl(MoudleNames.Main, MainCtrlNames.Main)
    end
    CtrlManager:CloseCtrl(LoadingCtrlNames.Loading)
end

return _LoadingCtrl