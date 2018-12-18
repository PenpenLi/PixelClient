require "PixelFarm/PBLua/login_pb"

local _LoginLogic = class()

-- 登录
function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic] Login account = " .. accout .. " password = " .. password)

    print(login_pb.LoginRequest())

    LocalDataManager:SaveUid(accout)

    local login = login_pb.LoginRequest()
    login.account = accout
    login.password = password
    
    local msg = login:SerializeToString()
    print("login msg = " .. msg)


    Event.AddListener(Protocal.KeyOf("LoginResponse"), function(buffer)
        print(buffer)
        local data = buffer:ReadBuffer()

        local msg = login_pb.LoginResponse()
        msg:ParseFromString(data)
        print(' msg:>'..msg.uid)
    end) 
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("LoginRequest"))
    buffer:WriteBuffer(msg)
    networkMgr:SendMessage(buffer)

    if cb then
        cb()
    end
end

return _LoginLogic