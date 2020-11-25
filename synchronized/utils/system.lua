local function trace(str)
    print("^5"..Fox.prefix.."^7"..str)
end

local function catchTableNotNil(table)
    if table == nil then return {} end
    return table
end

Fox.utils = {}

Fox.trace = trace
Fox.utils.tableNotNil = catchTableNotNil