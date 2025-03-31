repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Lấy Key từ getgenv()
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key
local httpService = game:GetService("HttpService")

-- URL API
local apiBaseUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"
local checkUrl = apiBaseUrl .. "/Checkhwid?hwid=" .. hwid .. "&key=" .. key
local addUrl = apiBaseUrl .. "/Addhwid?hwid=" .. hwid .. "&key=" .. key

-- Gửi yêu cầu kiểm tra HWID + Key
local success, response = pcall(function()
    return game:HttpGet(checkUrl)
end)

if not success or not response then
    warn("❌ Lỗi kết nối API!")
    return
end

local hwidStatus
pcall(function()
    hwidStatus = httpService:JSONDecode(response)
end)

if not hwidStatus then
    warn("❌ Lỗi đọc JSON từ API!")
    return
end

if hwidStatus.status == "false" then
    warn("⚠️ HWID chưa tồn tại, đang thêm vào API...")
    game:HttpGet(addUrl)
    warn("✅ HWID đã được thêm! Vui lòng chạy lại script.")
    return
end

-- Kiểm tra nếu HWID bị blacklist
if hwidStatus.Blacklist then
    game.Players.LocalPlayer:Kick("❌ HWID của bạn đã bị khóa!")
    return
end

-- Kiểm tra key hết hạn
if hwidStatus.Time and hwidStatus.Duration and os.time() > hwidStatus.Time + hwidStatus.Duration then
    game.Players.LocalPlayer:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- Nếu hợp lệ, chạy script theo Game ID
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
