repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local Player = game.Players.LocalPlayer

-- Kiểm tra xem có nhập Key không
if not getgenv().Key or getgenv().Key == "" then
    Player:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- Lấy HWID (nếu có)
local hwid = gethwid and gethwid() or "Unknown"

-- API kiểm tra key và HWID
local apiBase = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"
local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local hwidCheckUrl = apiBase .. "/Checkhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key
local hwidAddUrl = apiBase .. "/Addhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key .. "&user=free"

-- Tải danh sách Key từ GitHub
local success, keyData = pcall(function()
    return game:HttpGet(keyCheckUrl)
end)

if not success or not keyData then
    warn("❌ Lỗi khi tải Key từ GitHub!")
    return
end

-- Giải mã JSON
local keys
pcall(function()
    keys = HttpService:JSONDecode(keyData)
end)

if not keys then
    warn("❌ Lỗi khi đọc JSON từ GitHub!")
    return
end

-- Kiểm tra Key có hợp lệ không
local currentTime = os.time()
if not keys[getgenv().Key] then
    Player:Kick("❌ Key không hợp lệ!")
    return
end

-- Kiểm tra Key hết hạn chưa
local keyExpiry = keys[getgenv().Key]
if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    Player:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- Kiểm tra HWID qua API
local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpGet(hwidCheckUrl)
end)

if not hwidSuccess or not hwidResponse then
    warn("❌ Lỗi kết nối API!")
    return
end

-- Giải mã JSON phản hồi từ API
local hwidStatus
pcall(function()
    hwidStatus = HttpService:JSONDecode(hwidResponse)
end)

if not hwidStatus then
    warn("❌ Lỗi đọc JSON từ API!")
    return
end

-- Nếu HWID chưa có trong API, thêm mới
if not hwidStatus.HWID_Status then
    warn("ℹ️ Thêm HWID mới vào API...")
    game:HttpGet(hwidAddUrl)
    warn("✅ HWID đã được thêm thành công!")
    return
end

-- Danh sách Game ID và script tương ứng
local gameScripts = {
    [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
    [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"
}

-- Nếu game được hỗ trợ, chạy script
if gameScripts[game.PlaceId] then
    if game.PlaceId ~= 116495829188952 then
        getgenv().Language = "English"
    end
    loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
else
    Player:Kick("⚠️ Trò chơi này không được hỗ trợ!")
end
