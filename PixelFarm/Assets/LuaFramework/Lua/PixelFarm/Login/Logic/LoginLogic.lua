require "3rd.pblua.login_pb"

local _LoginLogic = class()

-- 登录
function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic] Login account = " .. accout .. " password = " .. password)

    LocalDataManager:SaveUid(accout)

    local login = login_pb.LoginRequest()
    login.account = accout
    login.password = password
    
    local msg = login:SerializeToString()
    print("login msg = " .. msg)


    Event.AddListener("101", function(buffer)
        print(buffer)
        local data = buffer:ReadBuffer()

        local msg = login_pb.LoginResponse()
        msg:ParseFromString(data)
        print(' msg:>'..msg.uid)
    end) 
    local buffer = ByteBuffer.New()
    buffer:WriteShort(100)
    buffer:WriteBuffer(msg)
    networkMgr:SendMessage(buffer)

    if cb then
        cb()
    end
end

return _LoginLogic