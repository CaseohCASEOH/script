local function generation(device)
    local h = 0
    for i = 1, #device do h = (h * 1337 + device:byte(i)) % 2^31 end
    math.randomseed(h)
    local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    local result = {}
    for i = 1, 50 do
        table.insert(result, chars:sub(math.random(1, #chars), math.random(1, #chars)))
    end
    return table.concat(result)
end

if not isfile("hwid.key") or readfile("hwid.key") ~= generation(game:GetService("RbxAnalyticsService"):GetClientId()) then
    writefile("hwid.key", generation(game:GetService("RbxAnalyticsService"):GetClientId()))
end