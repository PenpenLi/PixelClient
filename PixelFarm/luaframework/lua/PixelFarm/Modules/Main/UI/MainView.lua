
local _MainView = class(ViewBase)

function _MainView:OnCreate()
    print("_MainView oncreate  ~~~~~~~")

    self.iCtrl:ShowMap()
end

function _MainView:OnDestroy()
    
end

return _MainView