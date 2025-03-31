repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

local hwid = gethwid and gethwid() or "Unknown"

local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

local hwidApi = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid?hwid=" .. hwid

local success, keyData = pcall(function()
    return game:HttpGet(keyCheckUrl)
end)

if not success or not keyData then
    game.Players.LocalPlayer:Kick("❌ Không thể kết nối đến server kiểm tra Key!")
    return
end

local keys = game:GetService("HttpService"):JSONDecode(keyData)

if not keys[getgenv().Key] then
    game.Players.LocalPlayer:Kick("❌ Key không hợp lệ!")
    return
end

local hwidSuccess, hwidResponse = pcall(function()
    return game:HttpGet(hwidApi)
end)

if not hwidSuccess or not hwidResponse then
    game.Players.LocalPlayer:Kick("❌ Không thể kiểm tra HWID!")
    return
end

local hwidStatus = game:GetService("HttpService"):JSONDecode(hwidResponse)

if not hwidStatus.HWID_Status then
    game.Players.LocalPlayer:Kick("❌ HWID không hợp lệ hoặc đã hết hạn!")
    return
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
    game.Players.LocalPlayer:Kick("⚠️ Game này chưa được hỗ trợ!")
end
