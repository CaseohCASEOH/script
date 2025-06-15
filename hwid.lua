-- please do not steal without saying credits or do not say "made by you"
-- explanation: this script grabs your clientid then generates hwid for it then creates file, if file is renamed or deleted or edited it will overwrite file with same hwid 
local function hwidgenerator(device) -- change function name to any name
    local h = 0 -- not recommended to touch this
    for i = 1, #device do h = (h * 1337 + device:byte(i)) % 2^31 end -- not recommended to touch this
    math.randomseed(h) -- not recommended to touch this
    local characters = "abcdefghijklmnopqrstuvwxyz0123456789" -- add more or remove few if you wanted
    local result = {} -- your hwid result
    for i = 1, 50 do -- you can change how many characters generated
        table.insert(result, characters:sub(math.random(1, #characters), math.random(1, #characters))) -- random generated hwid
    end
    return table.concat(result) -- not recommended to touch this
end

if not isfile("hwid.key") or readfile("hwid.key") ~= hwidgenerator(game:GetService("RbxAnalyticsService"):GetClientId()) then -- you can change file name
    writefile("hwid.key", hwidgenerator(game:GetService("RbxAnalyticsService"):GetClientId())) -- only works on executors support file
end

-- blacklist/whitelist system using the hwid
-- blacklist system
-- local blacklist = { -- do not touch it but you can change "hwid" or add more banned hwid, you can change variables
--     ["hwid_1"] = true,
--     ["hwid_2"] = true,
-- }

-- local protectcall, hwid = pcall(readfile, "hwid.key") -- do not touch this but if you wanna change file name, pcall supposed to handle crashes
-- if protectcall and blacklist[hwid] then -- if hwid matches in blacklist then kick the user
--     game:GetService("Players").LocalPlayer:Kick("blacklisted") -- put any reason there
-- end

-- whitelist system 
-- local whitelist= {
--     ["hwid_1"] = true,
--     ["hwid_2"] = true,
-- }

-- local protectcall, hwid = pcall(readfile, "hwid.key")
-- if protectcall and not whitelist[hwid] then -- if hwid does not meet in the whitelist 
--     game:GetService("Players").LocalPlayer:Kick("unwhitelisted") -- then kick the user
-- end
