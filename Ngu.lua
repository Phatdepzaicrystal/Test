repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Nhập Key nếu chưa có
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- Lấy HWID của thiết bị
local hwid = gethwid and gethwid() or "Unknown"

-- Định nghĩa URL API
local githubKeyUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local checkHwidUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key
local addHwidUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Addhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key .. "&user=free"

-- Kiểm tra Key từ GitHub
local success, keyData = pcall(function()
    return game:HttpGet(githubKeyUrl)
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

local currentTime = os.time()

if not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Invalid Key!")
    return
end

local keyExpiry = keys[getgenv().Key]

if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    game.Players.LocalPlayer:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- Kiểm tra HWID + Key trên API
local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpGet(checkHwidUrl)
end)

if not hwidSuccess or not hwidResponse then
    warn("❌ Error 404!")
    return
end

local hwidStatus
pcall(function()
    hwidStatus = httpService:JSONDecode(hwidResponse)
end)

if not hwidStatus then
    warn("❌ Error JSON ")
    return
end

if not hwidStatus.HWID_Status then
    warn("ℹ️ Thêm HWID vào API...")
    game:HttpGet(addHwidUrl)

    warn("✅ HWID đã được thêm thành công!")
    return
end

-- Chạy script theo Game ID nếu hợp lệ
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
    game.Players.LocalPlayer:Kick("⚠️ Not Support!")
end
