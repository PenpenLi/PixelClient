
CtrlManager = class()

local self = CtrlManager
self.aliveViewCtrls = {} -- 已经打开的ui
local OpenQueue = CList.new()
local IsOpenning = false
local OpenningBean = nil -- 正在打开的界面
local OpenningTimer = nil -- 打开定时器
local OpenningCtrlName = nil --当前正在加载的界面
local OpenningOkCallBackList = {} -- 打开成功回调

function CtrlManager:OpenCtrl(moduleName, ctrlName, ...)
    local i, cName, viewCtrl = self:GetContainsCtrl(ctrlName)
    if viewCtrl then
        print('[CreateGameCtrl]已打开:' .. ctrlName)
        viewCtrl:UpdateInfo(...)
        return viewCtrl
    end

    require('DouWan/' .. gameName .. '/' .. ctrlName)
    local gameCtrlClass = _G[ctrlName]
    local ctrlBean = {}
    if gameCtrlClass then
        viewCtrl = gameCtrlClass.new(ctrlName, isShowLoading, ...)
        ctrlBean = {ctrlName, viewCtrl, isDeling = false}
        self.aliveViewCtrls[#self.aliveViewCtrls + 1] = ctrlBean
    end
    return viewCtrl:StartView()
end

-- 没有加载界面，快速显示界面，时候做及时状态显示界面
function OpenCtrlNoLoading(gameName, ctrlName, ...)
    OnOpenCtrl(gameName, ctrlName, false, ...)
end

-- 删除后重新加载
function ReOpenCtrl(gameName, ctrlName, ...)
    RemoveGameCtrl(ctrlName, true)
    OpenCtrl(gameName, ctrlName, ...)
end

-- 关闭ctrl，并清理数据
function CloseCtrl(ctrlName)
    RemoveGameCtrl(ctrlName, true)
    local curCtrl = GetCurrentCtrl()
    if curCtrl and curCtrl[2] then
        curCtrl[2]:OnShow()
    end
    -- GetCurrentCtrl():OnShow()
end

-- 创建一个ctrl，
function CreateGameCtrl(gameName, ctrlName, isShowLoading, ...)
    -- 正在打开监听
    IsOpenning = true
    OpenningBean = {m_gameName = gameName, m_ctrlName = ctrlName, args = ...}
    OpenningCtrlName = ctrlName
    local i, cName, viewCtrl = GetContainsCtrl(ctrlName)
    if viewCtrl then
        print('[CreateGameCtrl]已打开:' .. le(ctrlName))
        viewCtrl:UpdateInfo({...})
        _OpenNextCtrl()
        return viewCtrl
    end
    print('[CreateGameCtrl] bundleName = ' .. gameName .. ", ctrlName = " .. le(ctrlName))
    require('DouWan/' .. gameName .. '/' .. ctrlName)
    local gameCtrlClass = _G[ctrlName]
    local ctrlBean = {}
    if gameCtrlClass then
        viewCtrl = gameCtrlClass.new(ctrlName, isShowLoading, ...)
        ctrlBean = {ctrlName, viewCtrl, isDeling = false}
        self.aliveViewCtrls[#self.aliveViewCtrls + 1] = ctrlBean
    end
    -- 监听打开完成回调
    viewCtrl.OpenViewCallback = function(viewName)
        -- print('[CreateGameCtrl]' .. le(ctrlName) .. '|' .. le(viewCtrl.isDeling) .. '|' .. le(ctrlBean.isDeling))
        if ctrlBean.isDeling or viewCtrl.isDeling then
            -- viewCtrl:Destroy()
            DestroyGameCtrl(ctrlBean)
        end
        _OpenNextCtrl()
    end
    return viewCtrl:StartView()
end

-- 打开队列
function _OpenNextCtrl()
    if OpenningCtrlName and OpenningOkCallBackList[OpenningCtrlName] then
        OpenningOkCallBackList[OpenningCtrlName](OpenningCtrlName)
        OpenningOkCallBackList[OpenningCtrlName] = nil
    end
    OpenningCtrlName = nil -- 正在打开的界面置空
    IsOpenning = false -- 没有正在打开的
    -- print('[_OpenNextCtrl]' .. le(OpenQueue:GetSize()))
    local tempData = OpenQueue:PopFront()
    if tempData then
        -- print('[_OpenNextCtrl]' .. le(tempData.m_ctrlName))
        OpenCtrl(tempData.m_gameName, tempData.m_ctrlName, tempData.args)
    end
end

-- 设置打开界面成功监听
function SetOpenOkCallBack(CtrlName, callback)
    OpenningOkCallBackList[CtrlName] = callback
end

-- 判断是否存在
function CtrlManager:GetContainsCtrl(ctrlName)
    for i, v in pairs(self.aliveViewCtrls) do
        if v[1] == ctrlName then
            return i, v[1], v[2]
        end
    end
    return nil
end

-- 更新界面信息，相当于刷新
function UpdateCtrl(gameName, ctrlName, args)
    local i, cName, viewCtrl = GetContainsCtrl(ctrlName)
    if viewCtrl then
        viewCtrl:UpdateInfo(args)
    else
        print(le('viewCtrl is null'))
    end
end

-- 移除某个界面
function RemoveGameCtrl(ctrlName, isNext)
    CloseCoroutine()
    local i, cName, viewCtrl = GetContainsCtrl(ctrlName)
    if viewCtrl then
        -- viewCtrl:Destroy()
        DestroyGameCtrl(self.aliveViewCtrls[i])
        self.aliveViewCtrls[i] = nil
        -- 重新排序
        ReIndexContinuous()
    else
        print(ld('[UI管理器]' .. tostring(ctrlName) .. '并没有打开！') .. tostring(isNext))
    end
    print(ld('[RemoveGameCtrl]' .. tostring(ctrlName)) .. tostring(isNext))
    -- 打开队列判断
    if isNext and OpenningCtrlName and OpenningCtrlName == ctrlName then
        _OpenNextCtrl()
    end
    -- 内存回收
    collectgarbage('collect')
end

-- 隔空移除界面后让界面的index保持连续
function ReIndexContinuous()
    local tempList = {}
    local index = 1
    for i, v in pairs(self.aliveViewCtrls) do
        tempList[index] = v
        index = index + 1
    end
    self.aliveViewCtrls = tempList
    tempList = nil
end

-- 获取当前的控制器
function CloseCurrentCtrl()
    CloseCoroutine()
    if #self.aliveViewCtrls > 0 then
        -- print('当前UI: ' .. le(self.aliveViewCtrls[#self.aliveViewCtrls][1]))
        -- self.aliveViewCtrls[#self.aliveViewCtrls][2]:Destroy()
        DestroyGameCtrl(self.aliveViewCtrls[#self.aliveViewCtrls])
        self.aliveViewCtrls[#self.aliveViewCtrls] = nil
    else
        print(le('not open any ctrls!!!'))
    end
end

-- 返回当前界面控制器和名字
function GetCurrentCtrl()
    if #self.aliveViewCtrls > 0 then
        print(le(self.aliveViewCtrls[#self.aliveViewCtrls][1]))
        return self.aliveViewCtrls[#self.aliveViewCtrls]
    else
        print(le('not open any ctrls!!!'))
        return nil
    end
end

function GetCurrentActiveCtrl()
    if #self.aliveViewCtrls > 0 then
        print(le(self.aliveViewCtrls[#self.aliveViewCtrls][1]))
        for i=#self.aliveViewCtrls,1,-1 do
            local ctrl = self.aliveViewCtrls[i][2]
            if ctrl:IsActive() then
                return self.aliveViewCtrls[i]
            end
        end
        return nil
    else
        print(le('not open any ctrls!!!'))
        return nil
    end
end

function GetCurrentCtrlName()
    local ctrl = GetCurrentCtrl()
    if ctrl then
        return ctrl[1]
    end

    return nil
end

function GetCurrentActiveCtrlName()
    local ctrl = GetCurrentActiveCtrl()
    if ctrl then
        return ctrl[1]
    end

    return nil
end

-- 获取某个界面的状态
function IsCtrlShowing(ctrlName)
    -- PrintTable(self.aliveViewCtrls)
    print(le(TableCount(self.aliveViewCtrls)))
    local i, cName, viewCtrl = GetContainsCtrl(ctrlName)
    if viewCtrl then
        return true
    end
    print(le('当前为空！'))
    return false
end

function GetCtrl(ctrlName)
    local i, cName, viewCtrl = GetContainsCtrl(ctrlName)
    if viewCtrl then
        return viewCtrl
    end
    print(le('当前为空！' .. tostring(ctrlName)))
    return nil
end

-- 关闭所有面板
function CloseAll(isShowHideEffectBg)
    OpenQueue = CList.new() -- 队列清空
    OpenningCtrlName = nil -- 正在打开的界面置空
    IsOpenning = false -- 没有正在打开的
    -- print("[CloseAll]"..lt(self.aliveViewCtrls))
    for i, v in pairs(self.aliveViewCtrls) do
        -- print(le('Closs all UI.....') .. le(v[1]))
        -- v[2]:Destroy()
        DestroyGameCtrl(v)
        -- print(le('Closs all UI.....') .. le(v[2].isDeling))
        self.aliveViewCtrls[i] = nil
    end
end

-- 辅助删除
function DestroyGameCtrl(ctrlBean)
    if ctrlBean then
        ctrlBean.isDeling = true
        ctrlBean[2]:Destroy()
    end
end
