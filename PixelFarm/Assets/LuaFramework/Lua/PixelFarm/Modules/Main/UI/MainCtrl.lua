
local _MainCtrl = class(CtrlBase)

function _MainCtrl:StartView()
    print("_MainCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_MID(), self.args)
end

function _MainCtrl:ShowMap()
    CtrlManager:OpenCtrl(MoudleNames.Map, MapCtrlNames.Map)
end

return _MainCtrl