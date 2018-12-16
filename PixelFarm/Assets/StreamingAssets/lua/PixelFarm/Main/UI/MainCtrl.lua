
local _MainCtrl = class(CtrlBase)

function _MainCtrl:StartView()
    print("_MainCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_MID(), self.args)
end


return _MainCtrl