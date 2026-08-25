-- ======================================================
-- SWILL: 3 КНОПКИ (РЕСЕТ УДАЛЯЕТ ПОРТАЛЫ)
-- ======================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== СОЗДАНИЕ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SwillGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- ===== ОСНОВНАЯ ПАНЕЛЬ (ПРАВЫЙ ВЕРХНИЙ УГОЛ) =====
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 120, 0, 180)
panel.Position = UDim2.new(1, -140, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
panel.BackgroundTransparency = 0.15
panel.BorderSizePixel = 0
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

-- ===== КНОПКА РЕСЕТ (УДАЛЯЕТ ВСЕ ПОРТАЛЫ) =====
local resetBtn = Instance.new("TextButton")
resetBtn.Name = "ResetBtn"
resetBtn.Size = UDim2.new(0.9, 0, 0.25, 0)
resetBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
resetBtn.Text = "🗑️ Ресет"
resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.TextSize = 18
resetBtn.Font = Enum.Font.GothamBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = panel

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetBtn

-- ===== КНОПКА 1 (ПОРТАЛ №1) =====
local portal1Btn = Instance.new("TextButton")
portal1Btn.Name = "Portal1Btn"
portal1Btn.Size = UDim2.new(0.42, 0, 0.25, 0)
portal1Btn.Position = UDim2.new(0.05, 0, 0.4, 0)
portal1Btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
portal1Btn.Text = "1"
portal1Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
portal1Btn.TextSize = 24
portal1Btn.Font = Enum.Font.GothamBold
portal1Btn.BorderSizePixel = 0
portal1Btn.Parent = panel

local p1Corner = Instance.new("UICorner")
p1Corner.CornerRadius = UDim.new(0, 8)
p1Corner.Parent = portal1Btn

-- ===== КНОПКА 2 (ПОРТАЛ №2) =====
local portal2Btn = Instance.new("TextButton")
portal2Btn.Name = "Portal2Btn"
portal2Btn.Size = UDim2.new(0.42, 0, 0.25, 0)
portal2Btn.Position = UDim2.new(0.53, 0, 0.4, 0)
portal2Btn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
portal2Btn.Text = "2"
portal2Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
portal2Btn.TextSize = 24
portal2Btn.Font = Enum.Font.GothamBold
portal2Btn.BorderSizePixel = 0
portal2Btn.Parent = panel

local p2Corner = Instance.new("UICorner")
p2Corner.CornerRadius = UDim.new(0, 8)
p2Corner.Parent = portal2Btn

-- ======================================================
-- ===== ЛОГИКА ПОРТАЛОВ =====
-- ======================================================

local portal1 = nil
local portal2 = nil
local portalConnection = nil

local function createPortal(position, color, name)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = Vector3.new(6, 8, 1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.3
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.Neon
    part.Parent = workspace

    local glow = Instance.new("PointLight")
    glow.Color = color == "Bright blue" and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 150, 0)
    glow.Range = 15
    glow.Brightness = 2
    glow.Parent = part

    return part
end

local function destroyPortals()
    -- Отключаем телепортацию
    if portalConnection then
        portalConnection:Disconnect()
        portalConnection = nil
    end
    -- Удаляем порталы
    if portal1 and portal1.Parent then
        portal1:Destroy()
        portal1 = nil
    end
    if portal2 and portal2.Parent then
        portal2:Destroy()
        portal2 = nil
    end
    print("[SWILL] Все порталы удалены")
end

local function startTeleport()
    -- Если уже есть подключение — отключаем
    if portalConnection then
        portalConnection:Disconnect()
        portalConnection = nil
    end

    portalConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not portal1 or not portal1.Parent or not portal2 or not portal2.Parent then
            return
        end

        local char = player.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        if (root.Position - portal1.Position).Magnitude < 3 then
            root.CFrame = portal2.CFrame + Vector3.new(0, 0, 2)
        end

        if (root.Position - portal2.Position).Magnitude < 3 then
            root.CFrame = portal1.CFrame + Vector3.new(0, 0, 2)
        end
    end)
end

-- ===== НАЖАТИЕ КНОПОК =====
-- Ресет — удаляет ВСЕ порталы
resetBtn.MouseButton1Click:Connect(function()
    destroyPortals()
end)

portal1Btn.MouseButton1Click:Connect(function()
    if portal1 then portal1:Destroy() end
    portal1 = createPortal(Vector3.new(10, 5, 0), "Bright blue", "Portal1")
    startTeleport()
end)

portal2Btn.MouseButton1Click:Connect(function()
    if portal2 then portal2:Destroy() end
    portal2 = createPortal(Vector3.new(-10, 5, 0), "Bright orange", "Portal2")
    startTeleport()
end)

print("[SWILL] 3 кнопки: Ресет (удаляет порталы) | 1 | 2")
