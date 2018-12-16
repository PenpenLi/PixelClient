local _LocalDataManager = class()
LocalDataManager = _LocalDataManager.Instance()

LocalDataKey = {
    PLAYER_UID = "player_uid"
}

-- 获取本地用户ID
function _LocalDataManager:GetUid()
    if PlayerPrefs.HasKey(LocalDataKey.PLAYER_UID) then
        return PlayerPrefs.GetString(LocalDataKey.PLAYER_UID)
    else
        return ""
    end
end

function _LocalDataManager:SaveUid(uid)
    if uid and #uid > 0 then
        PlayerPrefs.SetString(LocalDataKey.PLAYER_UID, uid)
    else
        print("[LocalDataManager] SaveUid error!  uid = " .. uid)
    end
end

return _LocalDataManager