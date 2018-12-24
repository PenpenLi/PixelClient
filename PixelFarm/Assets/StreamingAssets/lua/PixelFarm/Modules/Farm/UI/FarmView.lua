
local _M = class(ViewBase)

function _M:OnCreate()
    print("FarmView oncreate  ~~~~~~~")

    self.backBtn = self.transform:Find("back").gameObject
    self.backBtn:SetOnClick(function ()
        self:OnBackClick()
    end)

    self.landBlock = self:InitLandBlock(self.transform, "land")

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

function _M:InitData()
    local landData = {
        {name="小麦"},{name="玉米"},{name="胡萝卜"},
        {name="甘蔗"},{name="棉花"},{name="草莓"},
        {name="西红柿"},{name="松树"},{name="土豆"},
        {name="可可树"},{name="橡胶树"},{name="丝绸树"},
        {name="辣椒"},{name="水稻"},{name="玫瑰"},
        {name="茉莉"},{name="咖啡树"}}
    for _,land in ipairs(landData) do
        local obj = newObject(self.landBlock.landItem)
        obj.transform:SetParent(self.landBlock.landParent.transform, false)
        obj.transform.localScale = Vector3(1,1,1)
        obj:SetActive(true)
        local nameText = obj.transform:Find("name"):GetComponent("Text")
        nameText.text = land.name
    end
end

function _M:OnBackClick()
    self.iCtrl:Close()
end

function _M:OnDestroy()
    
end

return _M