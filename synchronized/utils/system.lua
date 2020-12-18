local function trace(str)
    print("^5"..Fox.prefix.."^7"..str.."^7")
end

local function debug(str)
    trace("^2[DEBUG] ^7"..str)
end

local function catchTableNotNil(table)
    if table == nil then return {} end
    return table
end

Fox.utils = {}

Fox.trace = trace
Fox.debug = debug
Fox.utils.tableNotNil = catchTableNotNil