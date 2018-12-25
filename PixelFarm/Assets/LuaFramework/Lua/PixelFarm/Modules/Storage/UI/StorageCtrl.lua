
local _M = class(CtrlBase)

function _M:StartView()
    print("StorageCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Storage, StorageViewNames.Storage, PANEL_MID(), self.args)
end

return _M