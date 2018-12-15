
local _LoadingCtrl = class(CtrlBase)

function _LoadingCtrl:StartView()
    print("LoadingCtrl startView ~~~~~~~")
	ViewManager.Instance():Start(self, MoudleNames.Loading, LoadingPanelNames.Loading, PANEL(LayerNames.Low), self.args)
end

return _LoadingCtrl