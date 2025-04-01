local HttpService = game:GetService("HttpService")

-- Hàm kiểm tra Key từ GitHub
local function checkKeyFromGithub()
    local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
    
    local success, response = pcall(function()
        return HttpService:GetAsync(keyCheckUrl)
    end)
    
    if success then
        local keyData = HttpService:JSONDecode(response)
        return keyData
    else
        warn("Lỗi khi lấy dữ liệu từ GitHub: " .. response)
        return nil
    end
end

-- Hàm kiểm tra HWID và Key từ API
local function checkHwidAndKey(hwid, key)
    local hwidCheckUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Checkhwid?hwid=" .. HttpService:UrlEncode(hwid) .. "&key=" .. HttpService:UrlEncode(key)
    
    local success, response = pcall(function()
        return HttpService:GetAsync(hwidCheckUrl)
    end)
    
    if success then
        return response
    else
        warn("Lỗi khi kiểm tra HWID và Key: " .. response)
        return nil
    end
end

-- Hàm thêm HWID vào API
local function addHwidToApi(hwid, key)
    local hwidAddUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Addhwid?hwid=" .. HttpService:UrlEncode(hwid) .. "&key=" .. HttpService:UrlEncode(key) .. "&user=free"
    
    local success, response = pcall(function()
        return HttpService:GetAsync(hwidAddUrl)
    end)
    
    if success then
        return response
    else
        warn("Lỗi khi thêm HWID vào API: " .. response)
        return nil
    end
end

-- Hàm lấy HWID
local function getHwid()
    -- Cần phải dùng cách nào đó để lấy HWID của máy, đây chỉ là giả định
    return "0a6a9b220273d282"  -- Thay thế bằng cách lấy HWID thực tế
end

-- Kiểm tra Key và HWID
local function checkKeyAndHwid()
    -- Kiểm tra nếu Key chưa được thiết lập
    if not getgenv().Key or getgenv().Key == "" then
        game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
        return
    end

    -- Kiểm tra Key từ GitHub
    local keyData = checkKeyFromGithub()
    if keyData == nil then
        game.Players.LocalPlayer:Kick("⚠️ Không thể kiểm tra Key!")
        return
    end

    local hwid = getHwid()
    -- Kiểm tra HWID và Key từ API
    local checkResponse = checkHwidAndKey(hwid, getgenv().Key)

    if checkResponse then
        print("Key và HWID hợp lệ.")
    else
        print("Key hoặc HWID không hợp lệ.")
        game.Players.LocalPlayer:Kick("⚠️ Key hoặc HWID không hợp lệ!")
        return
    end

    -- Nếu HWID chưa được thêm, thêm vào API
    local addHwidResponse = addHwidToApi(hwid, getgenv().Key)
    if addHwidResponse then
        print("HWID đã được thêm vào hệ thống.")
    else
        print("Lỗi khi thêm HWID vào hệ thống.")
    end

    -- Chạy script theo game
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
end

-- Kiểm tra Key và HWID khi game bắt đầu
checkKeyAndHwid()
