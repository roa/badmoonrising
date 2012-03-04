#!/usr/bin/lua

function getRequest (request)
    local s = 0
    local e = 0
    local list = {}
    for counter = 1, 3, 1 do
        e = request:find( " ", s )
        if e == nil then break
        else
            list[counter] = request:sub( s, e - 1 )
            s = e + 1
        end
    end
    return list
end

