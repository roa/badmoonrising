#!/usr/bin/lua

function answerRequest ( request )
    local fileStatus = 0;
    local req
    local ext

    request = cutTrailingSlash( request )

    if #request == 0 then
        request = "index.html"
    end
    
    req, ext = splitReq( request )

    local fh , err = io.open( "./content/" .. request, "rb" )
    
    if fh == nil then
        fileStatus = 1;
        fh , err = io.open( "./content/error.html", "r" )
        return prepareHeader( fileStatus ) .. prepareContent( fh )
    else
        return prepareHeader( fileStatus, ext ) .. prepareContent( fh, ext )
    end 
end

function prepareHeader ( status, ext )
    
    return prepareStatus( status ) 
        .. prepareDate()
        .. prepareServername() 
        .. prepareConnType( )
        .. prepareContentType( ext )
end 

function prepareContent ( fh, ext )
    local html
    if ext == "html" then
        html = ""
        while true do
            local line = fh.read( fh )
            if not line then break end
            html = html .. line
        end
    elseif ext == "jpg" or ext == "jpeg" then
        html = fh:read("*a")
    else
        html = ""
        while true do
            local line = fh.read( fh )
            if not line then break end
            html = html .. line
        end

    end
    return html
end 

function cutTrailingSlash ( string )
    if string:find( "/" ) == 1 then
        return string:sub( 2 ) 
    else
        return string
    end 
end

function prepareStatus ( fileStatus )
    if fileStatus == 0 then
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

function prepareContentType ( ext )
    local contenttype
    if ext == "html" then
        contenttype = 'Content-Type: text/html; charset=iso-8859-1\r\n\r\n'
    elseif ext == "jpg" or ext == "jpeg" then
        contenttype = 'Content-Type: image/jpeg\r\n\r\n'
    else
        contenttype = 'Content-Type: text/html; charset=iso-8859-1\r\n\r\n'
    end
    return contenttype
end

function splitReq( request )
    local req
    local ext
    local found = request:find( '%.' )
    req = request:sub( 1, found - 1 )
    ext = request:sub( found + 1 )
    return req, ext;
end
