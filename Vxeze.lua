local http_request = (syn and syn.request) or (http and http.request) or request
if not http_request then
    print("❌ Không tìm thấy hàm request, script không thể chạy!")
    return
end

local HttpService = game:GetService("HttpService")

local key_github_url = "https://raw.githubusercontent.com/Phatdepzaicrystal/Key/refs/heads/main/keys.json"
local api_url = "https://90b5e3ad-055e-4b22-851d-bd511d979dbc-00-3591ow60fhoft.riker.replit.dev"

local gameScripts = {
    [2753915549] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [4442272183] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [7449423635] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain2",
    [116495829188952] = "https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/Npclockdeadrails"
}

local hwid = gethwid and gethwid() or "Unknown"

local function send_request(url)
    local response = http_request({ Url = url, Method = "GET" })
    return response and response.Body or "❌ Không nhận được phản hồi từ server!"
end

local function check_key_github(key)
    local key_data = send_request(key_github_url)
    local success, key_json = pcall(HttpService.JSONDecode, HttpService, key_data)

    if success and key_json and key_json[key] then
        return true, "✅ Key hợp lệ!"
    else
        return false, "❌ Key không hợp lệ!"
    end
end

local function check_hwid()
    local check_url = api_url .. "/Checkhwid?hwid=" .. hwid
    local check_response = send_request(check_url)

    local success, check_data = pcall(HttpService.JSONDecode, HttpService, check_response)
    if success and check_data and check_data.HWID_Status then
        return check_data.HWID_Status, check_data.message
    else
        return false, "❌ Lỗi khi kiểm tra HWID!"
    end
end

local function add_hwid()
    local add_url = api_url .. "/Addhwid?hwid=" .. hwid .. "&user=pre"
    local add_response = send_request(add_url)

    local success, add_data = pcall(HttpService.JSONDecode, HttpService, add_response)
    if success and add_data and add_data.status == "true" then
        return true, "✅ HWID đã được thêm vào hệ thống!"
    else
        return false, "❌ Lỗi khi thêm HWID!"
    end
end

print("🔑 Nhập Key của bạn:")
local user_key = io.read()

local key_valid, key_msg = check_key_github(user_key)
if not key_valid then
    print(key_msg)
    return
end

print(key_msg)  -- Key hợp lệ

local hwid_valid, hwid_msg = check_hwid()
if hwid_valid then
    print("✅ HWID hợp lệ, có thể sử dụng script!")
else
    print("⚠️ HWID chưa hợp lệ, đang thêm vào hệ thống...")
    local add_success, add_msg = add_hwid()
    print(add_msg)
    if not add_success then return end
end

if gameScripts[game.PlaceId] then
    if game.PlaceId ~= 116495829188952 then
        getgenv().Language = "English"
    end
    loadstring(game:HttpGet(gameScripts[game.PlaceId]))()
else
    game.Players.LocalPlayer:Kick("⚠️ Not Support!")
end
