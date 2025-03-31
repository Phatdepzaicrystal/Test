repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local httpService = game:GetService("HttpService")

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"

-- Đường dẫn kiểm tra key trên GitHub
local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- API kiểm tra HWID + Key
local hwidCheckUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid"

-- API thêm HWID nếu chưa có
local hwidAddUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Addhwid"

-- Kiểm tra Key từ GitHub
local success, keyData = pcall(function()
    return game:HttpGet(keyCheckUrl)
end)

if not success or not keyData then
    warn("❌ Lỗi khi tải Key từ GitHub!")
    return
end

local keys
pcall(function()
    keys = httpService:JSONDecode(keyData)
end)

if not keys then
    warn("❌ Lỗi khi đọc JSON từ GitHub!")
    return
end

local currentTime = os.time()

if not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return
end

local keyExpiry = keys[getgenv().Key]

if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    game.Players.LocalPlayer:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- Gửi yêu cầu kiểm tra HWID
local hwidCheckBody = httpService:JSONEncode({ hwid = hwid, key = getgenv().Key })
local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpPost(hwidCheckUrl, hwidCheckBody, Enum.HttpContentType.ApplicationJson)
end)

if not hwidSuccess or not hwidResponse then
    warn("❌ Lỗi kết nối API!")
    return
end

local hwidStatus
pcall(function()
    hwidStatus = httpService:JSONDecode(hwidResponse)
end)

if not hwidStatus then
    warn("❌ Lỗi đọc JSON từ API!")
    return
end

-- Nếu HWID chưa tồn tại, gửi lên API để lưu
if not hwidStatus.HWID_Status then
    warn("ℹ️ Đang thêm HWID mới vào hệ thống...")
    
    local hwidAddBody = httpService:JSONEncode({ hwid = hwid, key = getgenv().Key })
    local addSuccess, addResponse = pcall(function()
        return game:HttpPost(hwidAddUrl, hwidAddBody, Enum.HttpContentType.ApplicationJson)
    end)

    if addSuccess then
        warn("✅ HWID đã được thêm thành công!")
    else
        warn("❌ Lỗi khi thêm HWID!")
        return
    end
end

warn("✅ Key và HWID hợp lệ, tiếp tục chạy script!")

-- Chạy script theo game ID
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
    game.Players.LocalPlayer:Kick("⚠️ Game không được hỗ trợ!")
end
