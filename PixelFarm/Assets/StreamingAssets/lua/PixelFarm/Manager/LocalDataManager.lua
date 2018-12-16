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

return _LocalDataManager