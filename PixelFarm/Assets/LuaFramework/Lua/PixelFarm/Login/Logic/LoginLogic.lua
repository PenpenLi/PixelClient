local _LoginLogic = class()

-- 登录
function _LoginLogic:Login(accout, password, cb)
    print("[LoginLogic] Login account = " .. accout .. " password = " .. password)

    LocalDataManager:SaveUid(accout)

    local login = login_pb.LoginRequest();
    login.id = 2000;
    login.name = accout;
    login.email = 'jarjin@163.com';
    
    local msg = login:SerializeToString();
    print("login msg = " .. msg)


    Event.AddListener("1", function(buffer)
        print(buffer)
        local data = buffer:ReadBuffer();

        local msg = login_pb.LoginResponse();
        msg:ParseFromString(data);
        print(' msg:>'..msg.id);
    end); 
    local buffer = ByteBuffer.New();
    buffer:WriteShort(0);
    -- buffer:WriteByte(ProtocalType.PB_LUA);
    buffer:WriteBuffer(msg);
    networkMgr:SendMessage(buffer);

    if cb then
        cb()
    end
end

return _LoginLogic