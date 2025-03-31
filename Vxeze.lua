repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local hwid = gethwid and gethwid() or "Unknown"

local keyURL = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local apiURL = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Addhwid?hwid=" .. hwid

local gameScripts = {
    [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/Npclockdeadrails"
}

local function checkKey(key)
    local success, response = pcall(function()
        return HttpService:GetAsync(keyURL)
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data[key] ~= nil
    else
        warn("❌ Không thể kiểm tra Key!")
        return false
    end
end

local function checkHWID()
    local success, response = pcall(function()
        return HttpService:GetAsync(apiURL)
    end)
    if success then
        local data = HttpService:JSONDecode(response)
        return data.HWID_Status
    else
        warn("❌ Không thể kết nối API!")
        return false
    end
end

if checkKey(getgenv().Key) and checkHWID() then
    print("✅ Key hợp lệ, HWID hợp lệ!")

    -- Kiểm tra Game ID & Chạy Script
    if gameScripts[game.PlaceId] then
        if game.PlaceId ~= 116495829188952 then
            getgenv().Language = "English"
        end
        loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
    else
        LocalPlayer:Kick("⚠️ Not Support !")
    end
else
    LocalPlayer:Kick("❌ Key hoặc HWID không hợp lệ!")
end
