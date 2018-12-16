

AppName = "PixelFarm"

App = {
    serverIp = "127.0.0.1",
    serverPort = 7000
}

-- 模块名称
MoudleNames = {
    Common = "Common",
    Loading = "Loading",
    Main = "Main",
    Login = "Login"
}

-- UI层级
UIPanelNames = {
    Low = "Low",
    Mid = "Mid",
    High = "High",
    Top = "Top"
}

UIPanelOrder = {UIPanelNames.Low, UIPanelNames.Mid, UIPanelNames.High, UIPanelNames.Top}

require "PixelFarm/Loading/LoadingDefine"
require "PixelFarm/Main/MainDefine"
require "PixelFarm/Login/LoginDefine"