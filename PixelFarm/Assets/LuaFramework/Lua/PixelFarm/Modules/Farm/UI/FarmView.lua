
local _M = class(ViewBase)

function _M:Init()
    self.maxLand = 0
    self.plantData = {}
end

function _M:OnCreate()
    print("FarmView oncreate  ~~~~~~~")

    self.landBlock = self:InitLandBlock(self.transform, "land")
    self.operBlock = self:InitOperBlock(self.transform, "oper")

    self:Init()
    self:InitData()
end

function _M:InitLandBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.landParent = transform.gameObject
    block.landItem = transform:Find("item").gameObject
    return block
end

function _M:InitOperBlock(trans, path)
    local block = {}
    local transform = trans:Find(path)
    block.transform = transform
    block.maskObj = transform:Find("mask").gameObject
    block.growSlider = transform:Find("bg/part1/slider"):GetComponent("Slider")
    block.growNumText = transform:Find("bg/part1/num"):GetComponent("Text")
    block.gainSlider = transform:Find("bg/part2/slider"):GetComponent("Slider")
    block.gainNumText = transform:Find("bg/part2/num"):GetComponent("Text")

    block.maskObj:SetOnClick(function ()
        self:HideOper()
    end)

    block.growSlider.onValueChanged:AddListener(function ()
        self:OnGrowSliderChanged()
    end)

    block.data = {}
    block.grow = 0
    block.gain = 0

    return block
end

function _M:InitData()
    self.maxLand = self.iCtrl:GetTotalLand()

    self.plantData = self.iCtrl:GetPlants()
    for _,plant in ipairs(self.plantData) do
        local obj = newObject(self.landBlock.landItem)
        obj.transform:SetParent(self.landBlock.landParent.transform, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)

        obj:SetOnClick(function ()
            self:OnPlantItemClick(plant)
        end)

        local nameText = obj.transform:Find("name"):GetComponent("Text")
        local lockObj = obj.transform:Find("lock").gameObject
        nameText.text = plant.name
        if plant.isLock then
            lockObj:SetActive(true)
        else
            lockObj:SetActive(false)
        end
    end
end

function _M:OnPlantItemClick(plant)
    self.operBlock.data = plant

    self.operBlock.growSlider.minValue = plant.growNum
    self.operBlock.growSlider.maxValue = self.maxLand
    self.operBlock.growSlider.value = plant.growNum
    self.operBlock.growNumText.text = plant.growNum .. " / " .. self.maxLand

    self.operBlock.gainSlider.value = 0
    self.operBlock.gainSlider.maxValue = plant.gainNum
    self.operBlock.gainNumText.text = 0 .. " / " .. plant.gainNum

    self:ShowOper()
end

function _M:OnGrowSliderChanged()
    local curValue = self.operBlock.growSlider.value
    self.operBlock.growNumText.text = math.floor(curValue) .. " / " .. self.maxLand

    local plant = self.operBlock.data
    local offset = math.floor(curValue) - plant.growNum
    local totalCost = -1 * offset * plant.cost
    local isEnough = self.iCtrl:CheckCoin(totalCost)
    if not isEnough then
        Toast("金币不足")
    else
        self.operBlock.grow = offset
    end
end

function _M:ShowOper()
    self.operBlock.transform.gameObject:SetActive(true)
end

function _M:HideOper()
    self.operBlock.transform.gameObject:SetActive(false)
    self.iCtrl:OperComplete(self.operBlock.data, self.operBlock.grow, self.operBlock.gain)
end

function _M:OnDestroy()
    
end

return _M