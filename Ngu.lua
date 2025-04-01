local HttpService = game:GetService("HttpService")

-- Lấy HWID (nếu có)
local hwid = gethwid and gethwid() or "Unknown"

-- URL kiểm tra Key từ GitHub (từ file keys.json)
local keyCheckUrl = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"

-- URL kiểm tra HWID
local hwidCheckUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Checkhwid?hwid=" .. HttpService:UrlEncode(hwid) .. "&key=" .. HttpService:UrlEncode(getgenv().Key)

-- URL thêm HWID
local hwidAddUrl = "https://ac756656-2e64-4605-812d-d350905188e3-00-38lyz4e9bv6wh.worf.replit.dev/Addhwid?hwid=" .. HttpService:UrlEncode(hwid) .. "&key=" .. HttpService:UrlEncode(getgenv().Key) .. "&user=free"

-- Kiểm tra nếu Key chưa được thiết lập
if not getgenv().Key or getgenv().Key == "" then
    game.Players.LocalPlayer:Kick("⚠️ Bạn chưa nhập Key!")
    return
end

-- Kiểm tra Key từ GitHub
local function checkKeyFromGithub()
    local response = syn.request({
        Url = keyCheckUrl,
        Method = "GET"
    })

    if response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)

        -- Kiểm tra xem Key có trong danh sách không
        if data[getgenv().Key] then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- Kiểm tra HWID qua API
local function checkHwid()
    local response = syn.request({
        Url = hwidCheckUrl,
        Method = "GET"
    })

    if response.StatusCode == 200 then
        local data = HttpService:JSONDecode(response.Body)
        
        -- Nếu HWID đã tồn tại trong hệ thống, cho phép tiếp tục
        if data["status"] == "valid" then
            return true
        elseif data["status"] == "invalid" then
            -- Nếu HWID không hợp lệ, thử thêm HWID mới
            local addResponse = syn.request({
                Url = hwidAddUrl,
                Method = "GET"
            })
            if addResponse.StatusCode == 200 then
                local addData = HttpService:JSONDecode(addResponse.Body)
                if addData["status"] == "added" then
                    return true
                else
                    game.Players.LocalPlayer:Kick("⚠️ Không thể thêm HWID mới.")
                    return false
                end
            else
                game.Players.LocalPlayer:Kick("⚠️ Lỗi khi thêm HWID.")
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

-- Kiểm tra Key và HWID
if checkKeyFromGithub() then
    if checkHwid() then
        -- Nếu cả Key và HWID đều hợp lệ, xác định game và load script tương ứng
        local gameScripts = {
            [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/VxezeHubMain2",
            [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/main/Npclockdeadrails"
        }

        if gameScripts[game.PlaceId] then
            -- Thiết lập ngôn ngữ cho game
            if game.PlaceId ~= 116495829188952 then
                getgenv().Language = "English"
            end
            -- Load script từ URL
            loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
        else
            -- Game không hỗ trợ, kick người chơi
            game.Players.LocalPlayer:Kick("⚠️ Not Support!")
        end
    else
        -- HWID không hợp lệ hoặc không thể thêm HWID mới, kick người chơi
        game.Players.LocalPlayer:Kick("⚠️ HWID không hợp lệ!")
    end
else
    -- Key không hợp lệ, kick người chơi
    game.Players.LocalPlayer:Kick("⚠️ Key không hợp lệ!")
end
