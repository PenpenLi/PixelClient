require "PixelFarm/PBLua/login_pb"

local _LoginLogic = class()

-- 登录
-- cb(succeed, err)
function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic] Login account = " .. accout .. " password = " .. password)

    local login = login_pb.LoginRequest()
    login.account = accout
    login.password = password
    local msg = login:SerializeToString()

    Event.AddListener(Protocal.KeyOf("LoginResponse"), function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic] Login response = ")

        local msg = login_pb.LoginResponse()
        msg:ParseFromString(data)

        print("[LoginLogic] Login response = ")

        if msg.code == msg.LoginResponseCode.SUCCESS then
            LocalDataManager:SaveUid(msg.uid)

            if cb then
                cb(true)
            end
        else
            if cb then
                cb(false, msg.err)
            end
        end
    end) 
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("LoginRequest"))
    buffer:WriteBuffer(msg)
    networkMgr:SendMessage(buffer)
end

function _LoginLogic:Registe(accout, password, cb)
    print("[LoginLogic] Registe account = " .. accout .. " password = " .. password)

    local registe = login_pb.RegisteRequest()
    registe.account = accout
    registe.password = password
    local msg = registe:SerializeToString()

    Event.AddListener(Protocal.KeyOf("RegisteResponse"), function(buffer)
        local data = buffer:ReadBuffer()

        local msg = login_pb.RegisteResponse()
        msg:ParseFromString(data)

        print("[LoginLogic] Registe response = " .. tostring(msg.code) .. " uid = " .. tostring(msg.uid))
        
        print(msg.RegisteResponse.RegisteResponseCode.SUCCESS)
        if msg.code == msg.RegisteResponseCode.SUCCESS then
            LocalDataManager:SaveUid(msg.uid)
            print("~~~~~~~~~~")
            print(cb)
            if cb then
                cb(true)
            end
        else
            if cb then
                cb(false, msg.err)
            end
        end
    end) 
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("RegisteRequest"))
    buffer:WriteBuffer(msg)
    networkMgr:SendMessage(buffer)
end

return _LoginLogic