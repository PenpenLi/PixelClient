local FarmLogic = require "PixelFarm.Modules.Farm.Logic.FarmLogic"
local PlayerInterface = require "PixelFarm.Modules.PlayerInfo.Interface.PlayerInfoInterface"

local _M = class(CtrlBase)

function _M:StartView()
    print("FarmCtrl startView ~~~~~~~")
	ViewManager:Start(self, MoudleNames.Farm, FarmViewNames.Farm, PANEL_MID(), self.args)
end

function _M:Close()
    CtrlManager:CloseCtrl(FarmCtrlNames.Farm)
end

function _M:GetPlants()
    return FarmLogic:GetPlants()
end

function _M:GetTotalLand()
    return FarmLogic:GetTotalLand()
end

function _M:CheckCoin(coin)
    return PlayerInterface:CheckCoin(coin)
end

function _M:OperComplete(plant, grow, gain)
    FarmLogic:OperComplete(plant, grow, gain)
end

return _M