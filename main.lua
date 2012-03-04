#/usr/bin/lua

require( "getRequest" )
require( "answerRequest" )

local socket = require( "socket" )

local server = assert( socket.bind( "127.0.0.1", "9035" ) )

local ip, port = server:getsockname()

while 1 do
    local client = server:accept()
    client:settimeout(10)
    local line, err = client:receive()
    if not err then
        local getList = getRequest(line)
        if getList[1] == "GET" then
            client:send( answerRequest( getList[2] ) )
        end
    end
    client:close()
end
