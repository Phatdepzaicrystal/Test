repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local httpService = game:GetService("HttpService")

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ You must enter key!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"
local apiBase = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"

local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local success, keyData = pcall(function() return game:HttpGet(keyCheckUrl) end)

if not success or not keyData then
    game.Players.LocalPlayer:Kick("❌ Lỗi tải Key từ GitHub!")
    return
end

local keys = pcall(function() return httpService:JSONDecode(keyData) end) and httpService:JSONDecode(keyData) or nil
if not keys or not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return
end

local hwidCheckUrl = apiBase .. "/Checkhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key
local hwidSuccess, hwidResponse = pcall(function() return game:HttpGet(hwidCheckUrl) end)

if not hwidSuccess or not hwidResponse then
    game.Players.LocalPlayer:Kick("❌ Lỗi kết nối API!")
    return
end

local hwidStatus = pcall(function() return httpService:JSONDecode(hwidResponse) end) and httpService:JSONDecode(hwidResponse) or nil
if not hwidStatus or hwidStatus.status ~= "true" then
    local hwidAddUrl = apiBase .. "/Addhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key .. "&user=free"
    game:HttpGet(hwidAddUrl)
    game.Players.LocalPlayer:Kick("✅ HWID của bạn đã được thêm! Chạy lại script.")
    return
end

if hwidStatus.message == "Key đã bị sử dụng trên HWID khác!" then
    game.Players.LocalPlayer:Kick("❌ Key này đã được dùng trên thiết bị khác!")
    return
end

local gameScripts = {
    [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"
}

if gameScripts[game.PlaceId] then
    loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
else
    game.Players.LocalPlayer:Kick("⚠️ Game không được hỗ trợ!")
end
