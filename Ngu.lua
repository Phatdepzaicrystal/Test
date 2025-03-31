repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ You must enter key!!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"
local HttpService = game:GetService("HttpService")
local currentTime = os.time()

-- URL API
local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local hwidCheckUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Checkhwid"
local hwidAddUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Addhwid"

-- Lấy Key từ GitHub
local success, keyData = pcall(function()
    return game:HttpGet(keyCheckUrl)
end)

if not success or not keyData then
    warn("❌ Lỗi khi tải Key từ GitHub!")
    return
end

local keys
pcall(function()
    keys = HttpService:JSONDecode(keyData)
end)

if not keys then
    warn("❌ Error JSON")
    return
end

if not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Invalid Key!")
    return
end

local keyExpiry = keys[getgenv().Key]
if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    game.Players.LocalPlayer:Kick("❌ Key has expired!")
    return
end

-- Kiểm tra HWID
local hwidCheckData = HttpService:JSONEncode({
    hwid = hwid,
    key = getgenv().Key
})

local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpPost(hwidCheckUrl, hwidCheckData, Enum.HttpContentType.ApplicationJson)
end)

if not hwidSuccess or not hwidResponse then
    warn("❌ Error checking HWID. Please wait for admin to fix!")
    return
end

local hwidStatus
pcall(function()
    hwidStatus = HttpService:JSONDecode(hwidResponse)
end)

if not hwidStatus then
    warn("❌ Error JSON")
    return
end

if not hwidStatus.HWID_Status then
    warn("ℹ️ Saved Hwid")

    local hwidAddData = HttpService:JSONEncode({
        hwid = hwid,
        key = getgenv().Key,
        user = "free"
    })

    local addSuccess, addResponse = pcall(function()
        return game:HttpPost(hwidAddUrl, hwidAddData, Enum.HttpContentType.ApplicationJson)
    end)

    if not addSuccess or not addResponse then
        warn("❌ Error while adding HWID!")
        return
    end

    warn("✅ Running Script: Zzz")
else
    if hwidStatus.status == "false" then
        game.Players.LocalPlayer:Kick("❌ Invalid HWID!")
        return
    end
end

-- Tự động chạy script theo game
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
