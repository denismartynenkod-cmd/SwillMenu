-- ======================================================
-- SWILL MENU + ПОРТАЛЫ (ПЛАВАЮЩАЯ КНОПКА РАБОЧАЯ)
-- ======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== ПЕРЕМЕННЫЕ ПОРТАЛОВ =====
local portals = {}
local isActive = false
local portalConnection = nil
local portalAnimConnection = nil

-- ===== ПЕРЕМЕННЫЕ ДЛЯ ПЕРЕТАСКИВАНИЯ =====
local isDragging = false
local dragStart = nil
local startPos = nil
local clickTime = 0

-- ===== СОЗДАНИЕ ГЛАВНОГО МЕНЮ =====
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "MainMenu"
menuGui.ResetOnSpawn = false
menuGui.Parent = gui

-- ОСНОВНАЯ РАМКА
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = menuGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- ТЕНЬ
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(-0.5, -10, -0.5, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://13160439108"
shadow.ImageTransparency = 0.7
shadow.Parent = mainFrame

-- ===== ЛЕВАЯ ПАНЕЛЬ =====
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0.3, 0, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 0)
leftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 12)
leftCorner.Parent = leftPanel

-- ЗАГОЛОВОК
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ SWILL MENU"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Center
titleLabel.Parent = leftPanel

-- ФУНКЦИЯ СОЗДАНИЯ ПУНКТОВ МЕНЮ
local function createMenuItem(name, yPos, icon)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.9, 0, 0.1, 0)
    btn.Position = UDim2.new(0.05, 0, yPos, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BackgroundTransparency = 0.8
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0
    btn.Parent = leftPanel
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    return btn
end

local btnMyScripts = createMenuItem("MyScripts", 0.2, "📜")
local btnSettings = createMenuItem("Settings", 0.35, "⚙️")
local btnPortals = createMenuItem("Portals", 0.5, "🌀")

-- ===== ПЕРЕГОРОДКА =====
local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(0.002, 0, 0.9, 0)
divider.Position = UDim2.new(0.3, 0, 0.05, 0)
divider.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- ===== ПРАВАЯ ПАНЕЛЬ =====
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0.7, 0, 1, 0)
rightPanel.Position = UDim2.new(0.3, 0, 0, 0)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainFrame

-- === КОНТЕНТ: MYSCRIPTS ===
local scriptsContent = Instance.new("Frame")
scriptsContent.Name = "MyScriptsContent"
scriptsContent.Size = UDim2.new(1, 0, 1, 0)
scriptsContent.BackgroundTransparency = 1
scriptsContent.Visible = true
scriptsContent.Parent = rightPanel

local scriptLabel = Instance.new("TextLabel")
scriptLabel.Size = UDim2.new(1, -20, 1, -20)
scriptLabel.Position = UDim2.new(0, 10, 0, 10)
scriptLabel.BackgroundTransparency = 1
scriptLabel.Text = "📜 MY SCRIPTS\n\n▶️ Run Portal Script\n🔄 Load Animation\n⚡ Speed Boost"
scriptLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
scriptLabel.TextSize = 18
scriptLabel.Font = Enum.Font.GothamMedium
scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
scriptLabel.TextYAlignment = Enum.TextYAlignment.Top
scriptLabel.Parent = scriptsContent

local runPortalBtn = Instance.new("TextButton")
runPortalBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
runPortalBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
runPortalBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
runPortalBtn.Text = "🌀 Запустить порталы"
runPortalBtn.TextColor3 = Color3.fromRGB(20, 20, 30)
runPortalBtn.TextSize = 18
runPortalBtn.Font = Enum.Font.GothamBold
runPortalBtn.BorderSizePixel = 0
runPortalBtn.Parent = scriptsContent

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = runPortalBtn

-- === КОНТЕНТ: SETTINGS ===
local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = rightPanel

local langLabel = Instance.new("TextLabel")
langLabel.Size = UDim2.new(1, -20, 0.2, 0)
langLabel.Position = UDim2.new(0, 10, 0, 10)
langLabel.BackgroundTransparency = 1
langLabel.Text = "🌐 Язык: Русский"
langLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
langLabel.TextSize = 18
langLabel.Font = Enum.Font.GothamMedium
langLabel.TextXAlignment = Enum.TextXAlignment.Left
langLabel.Parent = settingsContent

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(1, -20, 0.2, 0)
transLabel.Position = UDim2.new(0, 10, 0.25, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "🔮 Прозрачность скрипта: 50%"
transLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
transLabel.TextSize = 18
transLabel.Font = Enum.Font.GothamMedium
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = settingsContent

local wolfLabel = Instance.new("TextLabel")
wolfLabel.Size = UDim2.new(1, -20, 0.2, 0)
wolfLabel.Position = UDim2.new(0, 10, 0.5, 0)
wolfLabel.BackgroundTransparency = 1
wolfLabel.Text = "🐺 Волк спит: ❌"
wolfLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
wolfLabel.TextSize = 18
wolfLabel.Font = Enum.Font.GothamMedium
wolfLabel.TextXAlignment = Enum.TextXAlignment.Left
wolfLabel.Parent = settingsContent

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.6, -20, 0.2, 0)
speedLabel.Position = UDim2.new(0, 10, 0.75, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🚀 Скорость: 16"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
speedLabel.TextSize = 18
speedLabel.Font = Enum.Font.GothamMedium
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = settingsContent

local speedSlider = Instance.new("Frame")
speedSlider.Size = UDim2.new(0.3, 0, 0.08, 0)
speedSlider.Position = UDim2.new(0.65, 0, 0.77, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = settingsContent

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = speedSlider

local fill = Instance.new("Frame")
fill.Size = UDim2.new(0.5, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
fill.BorderSizePixel = 0
fill.Parent = speedSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = fill

-- === КОНТЕНТ: PORTALS ===
local portalsContent = Instance.new("Frame")
portalsContent.Name = "PortalsContent"
portalsContent.Size = UDim2.new(1, 0, 1, 0)
portalsContent.BackgroundTransparency = 1
portalsContent.Visible = false
portalsContent.Parent = rightPanel

local portalInfo = Instance.new("TextLabel")
portalInfo.Size = UDim2.new(1, -20, 0.5, -20)
portalInfo.Position = UDim2.new(0, 10, 0, 10)
portalInfo.BackgroundTransparency = 1
portalInfo.Text = "🌀 ПОРТАЛЫ\n\nПортал 1: Готов\nПортал 2: Готов\nСтатус: Ожидание"
portalInfo.TextColor3 = Color3.fromRGB(200, 200, 210)
portalInfo.TextSize = 18
portalInfo.Font = Enum.Font.GothamMedium
portalInfo.TextXAlignment = Enum.TextXAlignment.Left
portalInfo.TextYAlignment = Enum.TextYAlignment.Top
portalInfo.Parent = portalsContent

local deletePortalBtn = Instance.new("TextButton")
deletePortalBtn.Size = UDim2.new(0.4, 0, 0.15, 0)
deletePortalBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
deletePortalBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
deletePortalBtn.Text = "🗑️ Удалить порталы"
deletePortalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
deletePortalBtn.TextSize = 18
deletePortalBtn.Font = Enum.Font.GothamBold
deletePortalBtn.BorderSizePixel = 0
deletePortalBtn.Parent = portalsContent

local btnCorner3 = Instance.new("UICorner")
btnCorner3.CornerRadius = UDim.new(0, 8)
btnCorner3.Parent = deletePortalBtn

-- ======================================================
-- ===== ПЛАВАЮЩАЯ КНОПКА (ИСПРАВЛЕННАЯ) =====
-- ======================================================

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Name = "FloatingButton"
floatingBtn.Size = UDim2.new(0, 65, 0, 65)
floatingBtn.Position = UDim2.new(0.85, -35, 0.85, -35)
floatingBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
floatingBtn.BackgroundTransparency = 0.1
floatingBtn.Image = "rbxassetid://13160439108"
floatingBtn.ImageTransparency = 0.3
floatingBtn.AutoButtonColor = true
floatingBtn.Parent = menuGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 35)
floatCorner.Parent = floatingBtn

-- Текст на кнопке
local floatLabel = Instance.new("TextLabel")
floatLabel.Size = UDim2.new(1, 0, 1, 0)
floatLabel.BackgroundTransparency = 1
floatLabel.Text = "🌀"
floatLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
floatLabel.TextSize = 32
floatLabel.Font = Enum.Font.GothamBold
floatLabel.Parent = floatingBtn

-- Свечение
local glowFrame = Instance.new("Frame")
glowFrame.Size = UDim2.new(1.4, 0, 1.4, 0)
glowFrame.Position = UDim2.new(-0.2, 0, -0.2, 0)
glowFrame.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
glowFrame.BackgroundTransparency = 0.6
glowFrame.BorderSizePixel = 0
glowFrame.Parent = floatingBtn

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 45)
glowCorner.Parent = glowFrame

-- ===== АНИМАЦИЯ ПЛАВАНИЯ (ЧЕРЕЗ Tween) =====
local floatTween = nil
local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)

local function startFloatAnimation()
    if floatTween then floatTween:Cancel() end
    local offsetY = 15
    local targetPos = UDim2.new(
        floatingBtn.Position.X.Scale,
        floatingBtn.Position.X.Offset,
        floatingBtn.Position.Y.Scale,
        floatingBtn.Position.Y.Offset + offsetY
    )
    floatTween = TweenService:Create(floatingBtn, tweenInfo, {Position = targetPos})
    floatTween:Play()
end

-- Запускаем анимацию
startFloatAnimation()

-- ===== ЛОГИКА ПЕРЕТАСКИВАНИЯ (только для ПК/мыши) =====
local isDragging = false
local dragStartPos = nil
local btnStartPos = nil

floatingBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        dragStartPos = input.Position
        btnStartPos = floatingBtn.Position
        if floatTween then floatTween:Cancel() end
    end
end)

floatingBtn.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartPos
        local newX = btnStartPos.X.Offset + delta.X
        local newY = btnStartPos.Y.Offset + delta.Y
        
        -- Ограничение по экрану
        local screenSize = gui.AbsoluteSize
        local btnSize = floatingBtn.AbsoluteSize
        newX = math.max(0, math.min(screenSize.X - btnSize.X, newX))
        newY = math.max(0, math.min(screenSize.Y - btnSize.Y, newY))
        
        floatingBtn.Position = UDim2.new(0, newX, 0, newY)
    end
end)

floatingBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        startFloatAnimation()
    end
end)

-- ===== ОТКРЫТИЕ МЕНЮ (ПО НАЖАТИЮ) =====
local isOpen = false

local function toggleMenu()
    isOpen = not isOpen
    local targetSize = isOpen and UDim2.new(0.5, 0, 0.7, 0) or UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
end

-- Нажатие на кнопку
floatingBtn.MouseButton1Click:Connect(function()
    if not isDragging then
        toggleMenu()
    end
end)

-- Для мобильных устройств (тач)
floatingBtn.TouchTap:Connect(function()
    toggleMenu()
end)

-- ===== ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК =====
local function switchTab(tabName)
    scriptsContent.Visible = (tabName == "MyScripts")
    settingsContent.Visible = (tabName == "Settings")
    portalsContent.Visible = (tabName == "Portals")
end

btnMyScripts.MouseButton1Click:Connect(function()
    switchTab("MyScripts")
    btnMyScripts.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    btnSettings.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btnPortals.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
end)

btnSettings.MouseButton1Click:Connect(function()
    switchTab("Settings")
    btnMyScripts.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btnSettings.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
    btnPortals.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
end)

btnPortals.MouseButton1Click:Connect(function()
    switchTab("Portals")
    btnMyScripts.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btnSettings.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btnPortals.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
end)

-- ======================================================
-- ===== ЛОГИКА ПОРТАЛОВ =====
-- ======================================================

local function createPortal(position, name, color)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = Vector3.new(6, 8, 1)
    part.Position = position
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 0.4
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
    isActive = false
    if portalConnection then
        portalConnection:Disconnect()
        portalConnection = nil
    end
    if portalAnimConnection then
        portalAnimConnection:Disconnect()
        portalAnimConnection = nil
    end
    for _, p in pairs(portals) do
        if p and p.Parent then
            p:Destroy()
        end
    end
    portals = {}
    portalInfo.Text = "🌀 ПОРТАЛЫ\n\nПортал 1: Удалён\nПортал 2: Удалён\nСтатус: Неактивны"
end

local function createPortals()
    destroyPortals()
    
    local pos1 = Vector3.new(10, 5, 0)
    local pos2 = Vector3.new(-10, 5, 0)
    
    local portal1 = createPortal(pos1, "Portal1", "Bright blue")
    local portal2 = createPortal(pos2, "Portal2", "Bright orange")
    
    portals[1] = portal1
    portals[2] = portal2
    isActive = true
    
    portalInfo.Text = "🌀 ПОРТАЛЫ\n\nПортал 1: Активен\nПортал 2: Активен\nСтатус: Работают"
    
    portalAnimConnection = RunService.Heartbeat:Connect(function()
        if not isActive or not portal1.Parent or not portal2.Parent then
            return
        end
        local t = tick() * 1.5
        portal1.Position = pos1 + Vector3.new(0, math.sin(t) * 0.5, 0)
        portal2.Position = pos2 + Vector3.new(0, math.sin(t + 1) * 0.5, 0)
    end)
    
    portalConnection = RunService.Heartbeat:Connect(function()
        if not isActive or not portal1.Parent or not portal2.Parent then
            return
        end
        
        local char = player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        if (root.Position - portal1.Position).Magnitude < 3 then
            root.CFrame = portal2.CFrame + Vector3.new(0, 0, 2)
            local effect = Instance.new("Part")
            effect.Size = Vector3.new(3, 3, 3)
            effect.Position = portal2.Position
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 0.5
            effect.Material = Enum.Material.Neon
            effect.BrickColor = BrickColor.new("Bright green")
            effect.Parent = workspace
            Debris:AddItem(effect, 0.5)
            spawn(function()
                for i = 1, 10 do
                    effect.Size = effect.Size + Vector3.new(0.5, 0.5, 0.5)
                    effect.Transparency = effect.Transparency + 0.05
                    task.wait(0.05)
                end
                effect:Destroy()
            end)
        end
        
        if (root.Position - portal2.Position).Magnitude < 3 then
            root.CFrame = portal1.CFrame + Vector3.new(0, 0, 2)
            local effect = Instance.new("Part")
            effect.Size = Vector3.new(3, 3, 3)
            effect.Position = portal1.Position
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 0.5
            effect.Material = Enum.Material.Neon
            effect.BrickColor = BrickColor.new("Bright green")
            effect.Parent = workspace
            Debris:AddItem(effect, 0.5)
            spawn(function()
                for i = 1, 10 do
                    effect.Size = effect.Size + Vector3.new(0.5, 0.5, 0.5)
                    effect.Transparency = effect.Transparency + 0.05
                    task.wait(0.05)
                end
                effect:Destroy()
            end)
        end
    end)
end

runPortalBtn.MouseButton1Click:Connect(createPortals)
deletePortalBtn.MouseButton1Click:Connect(destroyPortals)

btnMyScripts.BackgroundColor3 = Color3.fromRGB(255, 200, 100)

print("[SWILL] Меню загружено. Нажми на летающую кнопку 🌀")
