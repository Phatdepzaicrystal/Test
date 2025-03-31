repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- 🛑 Nhập Key (Nếu không nhập, bị kick)
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- 🔎 Lấy HWID
local hwid = gethwid and gethwid() or "Unknown"

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
    warn("❌ Lỗi khi tải Key từ GitHub!")
    return
end

local keys
local httpService = game:GetService("HttpService")

pcall(function()
    keys = httpService:JSONDecode(keyData)
end)

if not keys then
    warn("❌ Lỗi khi đọc JSON từ GitHub!")
    return
end

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
    warn("❌ Lỗi khi kiểm tra HWID từ API!")
    return
end

local hwidStatus
pcall(function()
    hwidStatus = httpService:JSONDecode(hwidResponse)
end)

if not hwidStatus then
    warn("❌ Lỗi khi đọc JSON từ API HWID!")
    return
end

if not hwidStatus.HWID_Status then
    -- 📝 Nếu HWID chưa có, thêm vào API
    warn("ℹ️ HWID chưa tồn tại, đang thêm vào API...")
    game:HttpGet(hwidAddUrl)

    -- 🛑 Không kick, chỉ in thông báo
    warn("✅ HWID của bạn đã được thêm! Vui lòng chạy lại script.")
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
