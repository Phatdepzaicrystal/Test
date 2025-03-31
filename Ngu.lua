repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local http = game:GetService("HttpService")
local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key or nil

if not key or key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- 🔍 Check Key trên GitHub
local githubUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/main/keys.json"
local success, githubResponse = pcall(function() return game:HttpGet(githubUrl) end)

if not success then
    game.Players.LocalPlayer:Kick("⚠️ Không thể kết nối GitHub!")
    return
end

local keyData = http:JSONDecode(githubResponse)
if not keyData[key] then
    game.Players.LocalPlayer:Kick("❌ Key Không Hợp Lệ!")
    return
end

-- 🔍 Kiểm tra thời hạn Key
local currentTime = os.time()
local keyExpiry = keyData[key]

if keyExpiry ~= "lifetime" and currentTime > keyExpiry then
    game.Players.LocalPlayer:Kick("❌ Key của bạn đã hết hạn!")
    return
end

-- 🔍 Check HWID trên API
local apiUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid"
local checkUrl = apiUrl .. "?hwid=" .. hwid .. "&key=" .. key

local success, apiResponse = pcall(function() return game:HttpGet(checkUrl) end)
if not success then
    game.Players.LocalPlayer:Kick("⚠️ Không thể kết nối API!")
    return
end

local apiResult = http:JSONDecode(apiResponse)

-- 🔍 Nếu HWID chưa có → Thêm vào API
if not apiResult.HWID_Status then
    warn("ℹ️ Thêm HWID mới...")
    local addUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Addhwid"
    local addFullUrl = addUrl .. "?hwid=" .. hwid .. "&key=" .. key

    local addSuccess, addResponse = pcall(function() return game:HttpGet(addFullUrl) end)
    if addSuccess then
        local addResult = http:JSONDecode(addResponse)
        if addResult.status == "true" then
            warn("✅ HWID Đã Thêm Thành Công!")
        else
            game.Players.LocalPlayer:Kick("❌ Không thể thêm HWID!")
            return
        end
    else
        game.Players.LocalPlayer:Kick("⚠️ Lỗi khi thêm HWID!")
        return
    end
elseif apiResult.message == "HWID Blacklisted" then
    game.Players.LocalPlayer:Kick("❌ HWID của bạn bị chặn!")
    return
end

-- 🔍 Danh sách game hỗ trợ
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
