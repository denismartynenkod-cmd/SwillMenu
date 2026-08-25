-- =============================================
-- SWILL: ПОРТАЛЫ + РЕСЕТ (РАБОЧАЯ ВЕРСИЯ)
-- =============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== СОЗДАЁМ ГЛАВНОЕ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SwillGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- ===== ПАНЕЛЬ КНОПОК =====
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 130, 0, 190)
panel.Position = UDim2.new(1, -150, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- ===== КНОПКА 1 (СОЗДАТЬ ПОРТАЛ 1) =====
local btn1 = Instance.new("TextButton")
btn1.Size = UDim2.new(0.9, 0, 0.25, 0)
btn1.Position = UDim2.new(0.05, 0, 0.05, 0)
btn1.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
btn1.Text = "🌀 1"
btn1.TextColor3 = Color3.fromRGB(255, 255, 255)
btn1.TextSize = 22
btn1.Font = Enum.Font.GothamBold
btn1.BorderSizePixel = 0
btn1.Parent = panel

local btn1Corner = Instance.new("UICorner")
btn1Corner.CornerRadius = UDim.new(0, 8)
btn1Corner.Parent = btn1

-- ===== КНОПКА 2 (СОЗДАТЬ ПОРТАЛ 2) =====
local btn2 = Instance.new("TextButton")
btn2.Size = UDim2.new(0.9, 0, 0.25, 0)
btn2.Position = UDim2.new(0.05, 0, 0.38, 0)
btn2.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
btn2.Text = "🌀 2"
btn2.TextColor3 = Color3.fromRGB(255, 255, 255)
btn2.TextSize = 22
btn2.Font = Enum.Font.GothamBold
btn2.BorderSizePixel = 0
btn2.Parent = panel

local btn2Corner = Instance.new("UICorner")
btn2Corner.CornerRadius = UDim.new(0, 8)
btn2Corner.Parent = btn2

-- ===== КНОПКА РЕСЕТ (УДАЛИТЬ ВСЁ) =====
local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
resetBtn.Position = UDim2.new(0.05, 0, 0.71, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
resetBtn.Text = "🗑️ РЕСЕТ"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextSize = 18
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = panel

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetBtn

-- =============================================
-- ===== ЛОГИКА ПОРТАЛОВ =====
-- =============================================

local portal1 = nil
local portal2 = nil
local teleportConnection = nil

-- ФУНКЦИЯ: СОЗДАТЬ ПОРТАЛ
local function createPortal(pos, color, name)
    local part = Instance.new("Part")
    part.Size = Vector3.new(6, 8, 0.5)
    part.Position = pos
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.Neon
    part.Name = name
    part.Parent = workspace

    -- СВЕЧЕНИЕ
    local light = Instance.new("PointLight")
    light.Range = 12
    light.Brightness = 3
    if color == "Bright blue" then
        light.Color = Color3.fromRGB(0, 150, 255)
    else
        light.Color = Color3.fromRGB(255, 150, 0)
    end
    light.Parent = part

    return part
end

-- ФУНКЦИЯ: УДАЛИТЬ ВСЕ ПОРТАЛЫ
local function resetPortals()
    if teleportConnection then
        teleportConnection:Disconnect()
        teleportConnection = nil
    end
    if portal1 then
        portal1:Destroy()
        portal1 = nil
    end
    if portal2 then
        portal2:Destroy()
        portal2 = nil
    end
    print("[SWILL] Все порталы удалены")
end

-- ФУНКЦИЯ: ВКЛЮЧИТЬ ТЕЛЕПОРТАЦИЮ
local function startTeleport()
    if teleportConnection then
        teleportConnection:Disconnect()
        teleportConnection = nil
    end

    teleportConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not portal1 or not portal2 then return end
        if not portal1.Parent or not portal2.Parent then return end

        local char = player.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local dist1 = (root.Position - portal1.Position).Magnitude
        local dist2 = (root.Position - portal2.Position).Magnitude

        if dist1 < 3 then
            root.CFrame = portal2.CFrame + Vector3.new(0, 0, 2)
        elseif dist2 < 3 then
            root.CFrame = portal1.CFrame + Vector3.new(0, 0, 2)
        end
    end)
end

-- =============================================
-- ===== НАЖАТИЕ КНОПОК =====
-- =============================================

btn1.MouseButton1Click:Connect(function()
    if portal1 then portal1:Destroy() end
    portal1 = createPortal(Vector3.new(15, 3, 0), "Bright blue", "Portal1")
    startTeleport()
    print("[SWILL] Портал 1 создан")
end)

btn2.MouseButton1Click:Connect(function()
    if portal2 then portal2:Destroy() end
    portal2 = createPortal(Vector3.new(-15, 3, 0), "Bright orange", "Portal2")
    startTeleport()
    print("[SWILL] Портал 2 создан")
end)

resetBtn.MouseButton1Click:Connect(function()
    resetPortals()
    print("[SWILL] Ресет выполнен")
end)

print("[SWILL] Готово! Нажми 1 или 2 для создания портала.")
