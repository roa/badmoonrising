#/usr/bin/lua

function getRequest (request)
    local s = 0
    local e = 0
    local list = {}
    for counter = 1, 3, 1 do
        e = request:find( " ", s )
        if e == nil then break 
        else
            local tmpstr = request:sub( s, e - 1 )
            list[counter] = tmpstr
            s = e + 1
        end
    end
    return list
end

function answerRequest (request)
    request = cutTrailingSlash( request )
    local fh , err = io.open( "./" .. request, "r" )
    if fh == nil then
        fh , err = io.open( "./error.html", "r" )
    end
    return prepareHeader() .. prepareContent( fh )
end

function prepareHeader ()
    local status = 'HTTP/1.1 200 OK\r\n'
    local date   = 'Date: Sun, 04 Mar 2012 18:54:40 GMT\r\n'
    local servername = 'Server: Apache/2.2.14 (Ubuntu)\r\n'
    local conn = 'Connection: close\r\n'
    local contenttype = 'Content-Type: text/html; charset=iso-8859-1\r\n\r\n'

    local html = ""
    html = html .. status
    html = html .. date
    html = html .. servername
    html = html .. conn
    html = html .. contenttype
    return html
end

function prepareContent (fh)
    local html = ""
    while true do
        local line = fh.read(fh)
        if not line then break end
        html = html .. line
    end
    return html
end

function cutTrailingSlash (string)
    if string:find( "/" ) == 1 then
        return string:sub( 2 )
    end
end

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
