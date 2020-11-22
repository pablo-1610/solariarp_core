local function trace(str)
    print(Fox.prefix..str)
end

local function catchTableNotNil(table)
    if table == nil then return {} end
    return table
end

Fox.utils = {}

Fox.utils.trace = trace
Fox.utils.tableNotNil = catchTableNotNil