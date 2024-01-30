local mixbox = require("mixbox")

local rgb1 = {0, 33, 133}  -- blue
local rgb2 = {252, 211, 0} -- yellow
t = 0.5                    -- mixing ratio

local rgb = mixbox.lerp(rgb1, rgb2, t)

print(table.unpack(rgb))