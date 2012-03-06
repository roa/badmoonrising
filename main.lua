#/usr/bin/lua

require( "getRequest" )
require( "answerRequest" )

local socket = require( "socket" )

local server = assert( socket.bind( "127.0.0.1", "9035" ) )

local ip, port = server:getsockname()

local selectlist = {}

while 1 do
    local client = server:accept()
    local ready = {}
    local err = ""

    
    if client then
        client:settimeout(1)
        table.insert( selectlist, client )
    end

    list, _, err = socket.select( selectlist, nil, 1 )
    
    if err then print(err) end

    for i, cli in ipairs(list) do

        local line, err = client:receive()

        if not err then
            local getList = getRequest(line)
            if getList[1] == "GET" then
                client:send( answerRequest( getList[2] ) )
            end
        end

        client:close()
        table.remove( selectlist, i )
    end
end
