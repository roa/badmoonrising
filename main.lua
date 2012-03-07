#/usr/bin/lua

require( "getRequest" )
require( "answerRequest" )

local socket = require( "socket" )

local server = assert( socket.bind( "127.0.0.1", "9035" ) )

local ip, port = server:getsockname()

local selectlist = {}

while true do
    local client = server:accept()
    local err = ""
    
    if client then
        client:settimeout(0.1)
        table.insert( selectlist, client )
    end

    list, _, err = socket.select( selectlist, nil, 0.1 )
    
    if err then print( err ) end

    for i, cli in ipairs( list ) do
        local request = {}

        while true do
            local line
            local err
            local rest
            local key
            local value

            line, err, rest = client:receive()
            key, value = cutHeader( line, " " )
            
            if key ~= nil and value ~= nil then
                request[key] = value
            end
            if rest ~= nil then
                request.post = rest
                break
            end
        end
        
        if request.GET ~= nil then
            local getList = getRequest( request.GET, " " )
            if getList[1] ~= nil then
                client:send( answerRequest( getList[2] ) )
            end
        end
        if request.POST ~= nil then
            local getList = getRequest( request.POST, " " )
            if getList[1] ~= nil then
                client:send( answerRequest( getList[2] ) )
            end
        end

        --Debug Information
        for k,l in pairs( request ) do
            print( " key: " .. k .. " value: " .. l )
        end

        client:close()
        table.remove( selectlist, i )
    end
end
