#!/usr/bin/lua

function getRequest ( request, delimiter )
    local s = 0
    local e = 0
    local list = {}
    for counter = 1, 3, 1 do
        e = request:find( delimiter, s )
        if e == nil then break
        else
            list[counter] = request:sub( s, e - 1 )
            s = e + 1
        end
    end
    return list
end

function cutHeader ( header, delimiter )
    local e = 0
    if header == nil then 
        return nil, nil 
    end
    e = header:find( delimiter, 0 )
    if e == nil or e == 0 then 
        return nil, nil
    else
        return header:sub( 0, e - 1 ), header:sub( e )
    end
end

