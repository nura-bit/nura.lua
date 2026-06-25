-- ========================
--  BLOX FRUITS HUB v1.1
--  Для Delta (CoreGui fix)
-- ========================

local Player = game.Players.LocalPlayer
wait(2) -- задержка для Delta

local CoreGui = game:GetService("CoreGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.15
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "⭐ Blox Hub"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.Size = UDim2.new(1, -20, 1, -55)
Container.Position = UDim2.new(0, 10, 0, 45)
Container.BackgroundTransparency = 1

-- Функция кнопки
local function AddButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.Size = UDim2.new(1, 0, 0, 35)
    local y = #Container:GetChildren() * 40 + 5
    btn.Position = UDim2.new(0, 0, 0, y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
end

-- ========== ФУНКЦИИ ==========

local function ShowServerTime()
    local seconds = workspace.DistributedGameTime
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    local msg = string.format("🕐 %02d:%02d:%02d", h, m, s)
    print(msg)
    Player:Chat(msg)
end

local function FindServerWith59()
    local seconds = workspace.DistributedGameTime
    local m = math.floor((seconds % 3600) / 60)
    if m == 59 then
        Player:Chat("✅ Уже на сервере с :59!")
        return true
    else
        Player:Chat("⏳ Переход на другой сервер...")
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
        return false
    end
end

local farming = false
local farmCoroutine = nil

local function StartFarm()
    if farming then return end
    farming = true
    farmCoroutine = coroutine.create(function()
        while farming do
            local char = Player.Character
            if not char then wait(1) break end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then wait(1) break end

            local mobs = {}
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
                    if v:FindFirstChild("HumanoidRootPart") then
                        table.insert(mobs, v)
                    end
                end
            end
            if #mobs == 0 then 
                wait(1) 
            else
                table.sort(mobs, function(a,b)
                    return (a.HumanoidRootPart.Position - hrp.Position).Magnitude < 
                           (b.HumanoidRootPart.Position - hrp.Position).Magnitude
                end)
                local target = mobs[1]
                if target and target.Humanoid.Health > 0 then
                    hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
            wait(0.5)
        end
    end)
    coroutine.resume(farmCoroutine)
    Player:Chat("⚔️ Фарм включён")
end

local function StopFarm()
    farming = false
    Player:Chat("⛔ Фарм остановлен")
end

local function TeleportCenter()
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        Player:Chat("📍 Телепорт в центр")
    end
end

-- ========== КНОПКИ ==========
AddButton("🕐 Время сервера", ShowServerTime)
AddButton("🔍 Найти сервер :59", FindServerWith59)
AddButton("⚔️ Включить фарм", StartFarm)
AddButton("⛔ Остановить фарм", StopFarm)
AddButton("📍 Телепорт в центр", TeleportCenter)

print("✅ Blox Hub для Delta загружен!")
