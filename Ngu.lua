repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"

local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

local hwidCheckUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Checkhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key

local hwidAddUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Addhwid?hwid=" .. hwid .. "&key=" .. getgenv().Key .. "&user=free"

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
    warn("ℹ️ HWID chưa tồn tại, đang thêm vào API...")

    local addSuccess, addResponse = pcall(function()
        return game:HttpGet(hwidAddUrl)
    end)

    if not addSuccess or not addResponse then
        warn("❌ Lỗi khi thêm HWID vào API!")
        return
    end

    warn("✅ HWID của bạn đã được thêm thành công! Tiếp tục chạy script...")
end

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
