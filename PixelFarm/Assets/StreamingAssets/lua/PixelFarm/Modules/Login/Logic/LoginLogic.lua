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

        if msg.code == login_pb.SUCCESS then
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

    Event.AddListener(Protocal.KeyOf("RegisteResponse"), function(buffer)
        local data = buffer:ReadBuffer()

        print("[LoginLogic] Registe response")

        local decode = protobuf.decode("msg.RegisteResponse", data)
        -- local msg = login_pb.RegisteResponse()
        -- msg:ParseFromString(data)

        print("[LoginLogic] Registe response = " .. tabStr(decode) .. type(decode))
        print(decode.code)
        print(decode.err.code)
        print(decode.err.msg)
        
        if decode.code == login_pb.SUCCESS then
            LocalDataManager:SaveUid(decode.uid)
            if cb then
                cb(true)
            end
        else
            if cb then
                cb(false, decode.err)
            end
        end
    end) 

    -- local registe = login_pb.RegisteRequest()
    -- registe.account = accout
    -- registe.password = password
    -- local msg = registe:SerializeToString()

    local registe = {
        account = accout,
        password = password
    }
    local code = protobuf.encode("msg.RegisteRequest", registe)
    local buffer = ByteBuffer.New()
    buffer:WriteShort(Protocal.KeyOf("RegisteRequest"))
    buffer:WriteBuffer(code)
    networkMgr:SendMessage(buffer)
end

return _LoginLogic