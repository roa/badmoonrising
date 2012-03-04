#!/usr/bin/lua

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
    local servername = 'Server: BadMoonRising/0.01\r\n'
    local conn = 'Connection: close\r\n'
    local contenttype = 'Content-Type: text/html; charset=iso-8859-1\r\n\r\n'
    
    return status .. date .. servername .. conn .. contenttype
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
