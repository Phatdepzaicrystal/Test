repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key or nil

if not key then
    game.Players.LocalPlayer:Kick("⚠️ Vui lòng nhập Key.")
    return
end

local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local hwidCheckUrl = "https://<API_URL>/Checkhwid?hwid=" .. hwid .. "&key=" .. key

local function getData(url)
    local response = game:HttpGet(url)
    if response and response ~= "" then
        return HttpService:JSONDecode(response)
    end
    return nil
end

local keyData = getData(keyCheckUrl)
if keyData and keyData[key] then
    local hwidResponse = getData(hwidCheckUrl)
    
    if hwidResponse and hwidResponse.status == "true" then
        print("✅ Key và HWID hợp lệ.")
        
        -- Chạy script theo game
        local gameScripts = {
            [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"
        }

        if gameScripts[game.PlaceId] then
            loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
        else
            game.Players.LocalPlayer:Kick("⚠️ Not Support!")
        end
    else
        game.Players.LocalPlayer:Kick(hwidResponse.message or "⚠️ HWID không hợp lệ.")
    end
else
    game.Players.LocalPlayer:Kick("⚠️ Key không tồn tại trong danh sách GitHub.")
end
