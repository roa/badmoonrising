#!/usr/bin/lua

require( "lfs" )

local workDir = lfs.currentdir()

config = {}

function readConfig ()
    confFile = workDir .. "/config/bad.conf"
    io.input( confFile )

    while true do
        line = io.read( "*l" )
        if not line then break end
        cutLine( line )
    end
end

function cutLine ( line )
    local e = 0
    local delimiter = " "
    local key
    local value

    e = line:find( delimiter , 0 )

    if e == nil or e == 0 then
        return nil
    else
        key   = line:sub( 0, e -1 )
        value = line:sub( e + 1 )
    end

    if     key == "root" then
        validateRoot( key, value )
    elseif key == "port" then
        validatePort( key, value )
    elseif key == "listen" then
        validateIP( key, value)
    else
        return nil
    end
end

function validateRoot ( key, value )
    config[key] = value;
end

function validatePort ( key, value )
    config[key] = value;
end

function validateIP ( key, value )
    config[key] = value;
end

function getConf ( key )
    for k, v in pairs(config) do
        if k == key then
            return v
        end
    end
end

function getRoot ()
    return getConf( "root" )
end

function getPort ()
    return getConf( "port")
end

function getIP ()
    return getConf( "listen" )
end
