
local _M = class(CtrlBase)

function _M:StartView()
    print("_MainCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Main, MainViewNames.Main, PANEL_LOW(), self.args)
end

function _M:ShowFarm()
    CtrlManager:OpenCtrl(MoudleNames.Farm, FarmCtrlNames.Farm)
end

function _M:ShowFactory()
    CtrlManager:OpenCtrl(MoudleNames.Factory, FactoryCtrlNames.Factory)
end

function _M:ShowTech()
    CtrlManager:OpenCtrl(MoudleNames.Tech, TechCtrlNames.Tech)
end

function _M:ShowJetty()
    CtrlManager:OpenCtrl(MoudleNames.Jetty, JettyCtrlNames.Jetty)
end

function _M:ShowMine()
    CtrlManager:OpenCtrl(MoudleNames.Mine, MineCtrlNames.Mine)
end

function _M:ShowZoo()
    CtrlManager:OpenCtrl(MoudleNames.Zoo, ZooCtrlNames.Zoo)
end

function _M:ShowAirport()
    CtrlManager:OpenCtrl(MoudleNames.Airport, AirportCtrlNames.Airport)
end

function _M:ShowTrain()
    CtrlManager:OpenCtrl(MoudleNames.Train, TrainCtrlNames.Train)
end

return _M