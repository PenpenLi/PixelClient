
local _MapCtrl = class(CtrlBase)

function _MapCtrl:StartView()
    print("_MapCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Map, MapViewNames.Map, PANEL_LOW(), self.args)
end


return _MapCtrl