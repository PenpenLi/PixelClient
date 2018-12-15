
PanelManager = class()

function PANEL(panelName)
    return PanelManager.Instance().panelDic[panelName]
end

function PanelManager:Init(cb)
    self.UICanvas = find("Canvas")
    self.panelDic = {}

    resMgr:LoadPrefab(MoudleNames.Common .. "_prefab", "Panel",function (prefabs)
        if prefabs and prefabs[0] then

            for _,v in pairs(PanelNames) do
                local obj = newObject(prefabs[0])
                obj:GetTransform():SetParent(self.UICanvas)
                obj.name = tostring(v .. "Panel")

                self.panelDic[v] = obj
            end
            
            if cb then cb() end
        end
    end)
end