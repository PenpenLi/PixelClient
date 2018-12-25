
local _M = class(ViewBase)

function _M:OnCreate()
    print("FarmView oncreate  ~~~~~~~")

    self.landBlock = self:InitLandBlock(self.transform, "land")
    self.operBlock = self:InitOperBlock(self.transform, "oper")

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

    return block
end

function _M:InitData()
    local plantData = self.iCtrl:GetPlants()
    for _,plant in ipairs(plantData) do
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
    self:ShowOper()
end

function _M:ShowOper()
    self.operBlock.transform.gameObject:SetActive(true)
end

function _M:HideOper()
    self.operBlock.transform.gameObject:SetActive(false)
end

function _M:OnDestroy()
    
end

return _M