repeat wait() until game:IsLoaded() and game.Players.LocalPlayer

local HttpService = game:GetService("HttpService")
local hwid = gethwid and gethwid() or "Unknown"
local key = getgenv().Key or nil

if not key then
    game.Players.LocalPlayer:Kick("⚠️ You must enter key!.")
    return
end

local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local hwidCheckUrl = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev/Checkhwid?hwid=" .. hwid .. "&key=" .. key

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
        print("✅Success")
        
        -- Chạy script theo game
        local gameScripts = {
            [2753915549] = function()
                getgenv().Language = "English"
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
            end,
            [4442272183] = function()
                getgenv().Language = "English"
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
            end,
            [7449423635] = function()
                getgenv().Language = "English"
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2"))()
            end,
            [116495829188952] = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"))()
            end
        }

        local scriptFunction = gameScripts[game.PlaceId]
        
        if scriptFunction then
            scriptFunction()
        else
            game.Players.LocalPlayer:Kick("⚠️ Not Support !")
        end
    else
        game.Players.LocalPlayer:Kick(hwidResponse.message or "⚠️ Invaild HWID ")
    end
else
    game.Players.LocalPlayer:Kick("⚠️ Invaild Key")
end
