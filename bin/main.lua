#/usr/bin/lua

require( "../lib/getRequest" )
require( "../lib/answerRequest" )
require( "../lib/readConf" )

readConfig()

local socket = require( "socket" )
local server = assert( socket.bind( getIP(), getPort() ) )
local ip, port = server:getsockname()
local selectlist = {}

while true do
    local client = server:accept()
    local err = ""
    
    if client then
        client:settimeout(0)
        table.insert( selectlist, client )
    end

    readlist, _, err = socket.select( selectlist, nil, 0.1 )
    
    if err then print( err ) end

    for i, cli in ipairs( readlist ) do
        -- request stores the header + body
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

        -- Debug Information prints complete request
        --for k,l in pairs( request ) do
        --    print( " key: " .. k .. " value: " .. l )
        --end

        client:close()
        table.remove( selectlist, i )
    end
end
