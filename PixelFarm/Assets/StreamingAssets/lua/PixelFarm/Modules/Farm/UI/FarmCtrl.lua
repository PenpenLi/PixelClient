
local _M = class(CtrlBase)

function _M:StartView()
    print("FarmCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Farm, FarmViewNames.Farm, PANEL_MID(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(FarmCtrlNames.Farm)
end

return _M