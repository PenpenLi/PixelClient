
local _M = class(ViewBase)

function _M:OnCreate()
    print("_MainView oncreate  ~~~~~~~")

    self.ctrlBtn = self.transform:Find("ctrlBtn").gameObject
    self.ctrlBtnText = self.transform:Find("ctrlBtn/text"):GetComponent("Text")
    self.ctrlBlock = self:InitCtrlBlock(self.transform, "ctrlGroup")

    self.ctrlBtn:SetOnClick(function ()
        self:OnCtrlClick()
    end)
end

function _M:InitCtrlBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.farmBtn = transform:Find("farmBtn").gameObject
    block.factoryBtn = transform:Find("factoryBtn").gameObject
    block.techBtn = transform:Find("techBtn").gameObject
    block.jettyBtn = transform:Find("jettyBtn").gameObject
    block.mineBtn = transform:Find("mineBtn").gameObject
    block.zooBtn = transform:Find("zooBtn").gameObject
    block.airportBtn = transform:Find("airportBtn").gameObject
    block.trainBtn = transform:Find("trainBtn").gameObject

    block.farmBtn:SetOnClick(function ()
        self:OnFarmClick()
        self.ctrlBlock.transform.gameObject:SetActive(false)
    end)

    block.factoryBtn:SetOnClick(function ()
        self:OnFactoryClick()
    end)

    block.techBtn:SetOnClick(function ()
        self:OnTechClick()
    end)

    block.jettyBtn:SetOnClick(function ()
        self:OnJettyClick()
    end)

    block.mineBtn:SetOnClick(function ()
        self:OnMineClick()
    end)

    block.zooBtn:SetOnClick(function ()
        self:OnZooClick()
    end)

    block.airportBtn:SetOnClick(function ()
        self:OnAirportClick()
    end)

    block.trainBtn:SetOnClick(function ()
        self:OnTrainClick()
    end)

    return block
end

function _M:OnCtrlClick()
    self.ctrlBlock.transform.gameObject:SetActive(not self.ctrlBlock.transform.gameObject.activeSelf)
    if self.ctrlBlock.transform.gameObject.activeSelf then
        self.ctrlBtnText.text = "《"
    else
        self.ctrlBtnText.text = "》"
    end
end

function _M:OnFarmClick()
    self.iCtrl:ShowFarm()
end

function _M:OnFactoryClick()
    self.iCtrl:ShowFactory()
end

function _M:OnTechClick()
    self.iCtrl:ShowTech()
end

function _M:OnJettyClick()
    self.iCtrl:ShowJetty()
end

function _M:OnMineClick()
    self.iCtrl:ShowMine()
end

function _M:OnZooClick()
    self.iCtrl:ShowZoo()
end

function _M:OnAirportClick()
    self.iCtrl:ShowAirport()
end

function _M:OnTrainClick()
    self.iCtrl:ShowTrain()
end

function _M:OnDestroy()
    
end

return _M