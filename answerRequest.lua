#!/usr/bin/lua

function answerRequest (request)
    local fileStatus = 0;
    request = cutTrailingSlash( request )
    local fh , err = io.open( "./" .. request, "r" )
    if fh == nil then
        status = 1;
        fh , err = io.open( "./error.html", "r" )
        return prepareHeader( fileStatus ) .. prepareContent( fh )
    else
        return prepareHeader( fileStatus ) .. prepareContent( fh )
    end 
end 

function prepareHeader ( status )
    
    return prepareStatus( status ) 
        .. prepareDate()
        .. prepareServername() 
        .. prepareConnType()
        .. prepareContentType()
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
    else
        return string
    end 
end

function prepareStatus ( fileStatus )
    if fileStatus == 1 then
        local status = 'HTTP/1.1 200 OK\r\n'
        return status
    else
        local status = 'HTTP/1.1 404 Not Found\r\n'
        return status
    end

end

function prepareDate ()
    local date   = 'Date: ' .. os.date ( "%a, %d %b %Y %X" ) .. ' GMT\r\n'
    return date
end

function prepareServername ()
    local servername = 'Server: BadMoonRising/0.01\r\n'
    return servername
end

function prepareConnType ()
    local conntype = 'Connection: close\r\n'
    return conntype
end

function prepareContentType ()
    local contenttype = 'Content-Type: text/html; charset=iso-8859-1\r\n\r\n'
    return contenttype
end
