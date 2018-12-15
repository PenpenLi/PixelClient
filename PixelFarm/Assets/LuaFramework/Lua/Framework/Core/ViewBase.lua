
---创建一个ViewBase类
ViewBase = class()

--[[
-- viewName:ui界面名称，和对应的prefab同名
-- bundleName:对应的加载资源名称，和游戏名称一致
-- uilayer:界面所在的层级，UILayer.PanelMiddle,等的
-- 可选参数super:继承类
--]]
ClassView = function(viewName, bundleName, uilayer, super)
    local c = class(super or ViewBase)
    c.viewName = viewName
    c.uilayer = uilayer
    c.bundleName = bundleName or "shared"
    _G[viewName] = c
end

-- singleGameName:游戏名称，view:界面名称
CreateView = function(iCtrl, singleGameName, view, ...)
    if isString(view) then
        local viewName = view
        -- require("DouWan/" .. string.sub(viewName, 1, -5) .. "/" .. viewName)
        require("DouWan/" .. singleGameName .. "/" .. viewName)
        view = _G[viewName]
        if view then
            view = view.new(...)
            view.iCtrl = iCtrl
            view.OpenViewCallback = iCtrl.OpenViewCallback
            view:Create()
        else
            Util.LogError('CreateView ' .. viewName .. " not find!") 
        end
    end
    return view
end

-- 结构体
function ViewBase:ctor(...)
    self.prefabName = self.viewName 
    self.isDeling = false -- 异步加载删除界面标记
    self.isHiding = false -- 隐藏界面
    self.args = {...} 
    self.OpenViewCallback = nil
    self.iCtrl = nil -- 控制器
end

-- 刷新界面
function ViewBase:Refresh()
    ViewManager.Close()
    ViewManager.Open(self.viewName, unpack(self._args))
end

--更新界面信息
function ViewBase:UpdateInfo(...)
end

-- 查找调用class方法
function ViewBase:Func(funcName)
    return function(...)
        local func = self[funcName]
        if func then
            func(self, ...)
        else
            print(le("no func " .. self.viewName .. ":" .. funcName))
        end
    end
end

-- 从ab创建，加载prefab,
function ViewBase:Create()
    -- print(ld("=====Create"))
    -- print(ld("=====" .. self.bundleName .. "||" .. tostring(self.prefabName)).."|"..tostring(self.isDeling))
    -- panelMgr:CreatePanel(self.bundleName, self.prefabName, self.uilayer, function(obj)
    --     print(ld("=====" .. obj.name .. "||" .. tostring(self.uilayer)).."|"..tostring(self.isDeling))
    --     -- 删除处理
    --     if self.isDeling then
    --         GameObject.Destroy(obj.gameObject)
    --         if self.OpenViewCallback then self.OpenViewCallback(self.prefabName) end
    --         return
    --     end
    --     self.gameObject = obj
    --     self.transform = obj:GetTransform()
    --     -- self.transform.localScale = Vector3(Game.GetFixScale(), Game.GetFixScale(), 0)
    --     -- if gViewScale then
    --     --     self.transform.localScale = gViewScale
    --     -- end
    --     local aspect = obj:GetComponent("AspectRatioFitter")
    --     if not obj then
    --         aspect = obj:AddComponent("AspectRatioFitter")
    --     end
    --     aspect.aspectRatio = AspectRatioNum
    --     aspect.aspectMode = AspectMode.EnvelopeParent
    --     -- 关闭加载界面
    --     self:CloseLoadView()
    --     if self.OpenViewCallback then self.OpenViewCallback(self.prefabName) end
    --     -- 回调子类OnCreate
    --     SafeCallFunc(self.OnCreate, self, obj)
    --     -- self:OnCreate(obj)
        
    --     self:ShowStartAnimation()
    -- end)

    self:LoadBundleObj(self.bundleName,self.prefabName,function (prefab)
        if prefab then
            local obj = newObject(prefab)
            obj:GetTransform():SetParent(self.uilayer)
            obj.name = tostring(self.prefabName)

            -- print(ld("=====" .. obj.name .. "||" .. tostring(self.uilayer)).."|"..tostring(self.isDeling))
            -- 删除处理
            if self.isDeling then
                GameObject.Destroy(obj.gameObject)
                if self.OpenViewCallback then self.OpenViewCallback(self.prefabName) end
                return
            end
            self.gameObject = obj
            self.transform = obj:GetTransform()
            -- self.transform.localScale = Vector3(Game.GetFixScale(), Game.GetFixScale(), 0)
            -- if gViewScale then
            --     self.transform.localScale = gViewScale
            -- end
            local aspect = obj:GetComponent("AspectRatioFitter")
            if not obj then
                aspect = obj:AddComponent("AspectRatioFitter")
            end
            aspect.aspectRatio = AspectRatioNum
            aspect.aspectMode = AspectMode.EnvelopeParent
            -- 关闭加载界面
            self:CloseLoadView()
            if self.OpenViewCallback then self.OpenViewCallback(self.prefabName) end
            -- 回调子类OnCreate
            SafeCallFunc(self.OnCreate, self, obj)
            -- self:OnCreate(obj)
            
            -- self:ShowStartAnimation()
        end
    end)
end

function ViewBase:OnCreate(obj)
end

-- 可重载
function ViewBase:OnDestroy()
end

function ViewBase:OnDestroyFinish()
end

-- 非特殊情况，不可重载
function ViewBase:Destroy()
    self:ClearData()
end

function ViewBase:OnHide()
end
function ViewBase:OnShow()
end

function ViewBase:Hide()
    self.isHiding = true
    if self.gameObject then
        self.gameObject.gameObject:SetActive(false)
    end
end

-- 结束要做的
function ViewBase:ClearData()
    self.transform = nil
    -- SafeCallFunc(self.OnDestroy, self)
    self:OnDestroy()
    self:UnRegistWebReq()
    self:StopAllTimer()

    if self._isShowHideAnimation then
        self:ShowCloseAnimation()
    else
        GameObject.Destroy(self.gameObject)
        self:OnDestroyFinish()
    end
    self:UnRegistNetEvent()
    self._mPrefabCachePool = {}
end
