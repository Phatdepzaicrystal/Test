repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🛑 Nhập Key ở đây (Nếu không nhập, bị kick)
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- 🔎 Lấy HWID
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

-- 🗂️ Link kiểm tra Key trên GitHub
local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- 🌐 API kiểm tra HWID
local hwidCheckUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid?hwid=" .. hwid

-- 🌐 API thêm HWID nếu chưa có
local hwidAddUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Addhwid?hwid=" .. hwid .. "&user=free"

-- 🛠️ Kiểm tra Key hợp lệ từ GitHub
local success, keyData = pcall(function()
    return game:HttpGet(keyCheckUrl)
end)

if not success or not keyData then
    game.Players.LocalPlayer:Kick("❌ Không thể kết nối đến server kiểm tra Key!")
    return
end

local keys = game:GetService("HttpService"):JSONDecode(keyData)

-- 🕒 Lấy thời gian hiện tại
local currentTime = os.time()

-- 📌 Kiểm tra xem Key có hợp lệ không
if not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return
end

local keyExpiry = keys[getgenv().Key]

-- ⏳ Kiểm tra xem Key có hết hạn không
if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    game.Players.LocalPlayer:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- 🛠️ Kiểm tra HWID hợp lệ
local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpGet(hwidCheckUrl)
end)

if not hwidSuccess or not hwidResponse then
    game.Players.LocalPlayer:Kick("❌ Không thể kiểm tra HWID!")
    return
end

local hwidStatus = game:GetService("HttpService"):JSONDecode(hwidResponse)

if not hwidStatus.HWID_Status then
    -- 📝 Nếu HWID chưa có, thêm vào API
    game:HttpGet(hwidAddUrl)
    game.Players.LocalPlayer:Kick("✅ HWID của bạn đã được thêm, vui lòng chạy lại script!")
    return
end

-- 📜 Chạy script theo game ID
local gameScripts = {
    [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"
}

if gameScripts[game.PlaceId] then
    if game.PlaceId ~= 116495829188952 then
        getgenv().Language = "English"
    end
    loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
else
    game.Players.LocalPlayer:Kick("⚠️ Game này chưa được hỗ trợ!")
end
