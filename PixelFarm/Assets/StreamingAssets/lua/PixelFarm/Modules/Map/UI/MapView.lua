
local _MapView = class(ViewBase)

local _mapSize = {
    w = 2560,
    h = 1280
}

local _cellSize = {
    w = 64,
    h = 64
}

function _MapView:OnCreate()
    print("_MapView oncreate  ~~~~~~~")

    self.mapRoot = self.transform:Find("cells/Viewport/Content").gameObject
    self.mapCell = self.transform:Find("cells/cell").gameObject

    self:InitMap()
end

function _MapView:InitMap()
    local wCount = _mapSize.w / _cellSize.w
    local hCount = _mapSize.h / _cellSize.h
    print("wCount = " .. wCount)
    print("hCount = " .. hCount)

    for i=1,wCount do
        for j=1,hCount do
            local cellObj = newObject(self.mapCell)
            cellObj.transform.parent = self.mapRoot.transform
            cellObj.transform.localScale = Vector3(1,1,1)
            cellObj.transform.localPosition = Vector3(i*_cellSize.w - _mapSize.w * 0.5, j*_cellSize.h - _mapSize.h * 0.5, 0)
            cellObj:SetActive(true)
        end
    end
end

function _MapView:OnDestroy()
    
end

return _MapView