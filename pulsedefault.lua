local io = { popen = io.popen }
local setmetatable = setmetatable

local pulsedefault = {}

local function worker(format, sinkmap)
    local f = io.popen("pactl info | grep 'Default Sink' | cut -d' ' -f3")
	local sink = f:read("*line")
    f:close()

    local result = sinkmap[sink]
    if result == nil then result = "?" end

    return {result}
end

return setmetatable(pulsedefault, { __call = function(_, ...) return worker(...) end })
