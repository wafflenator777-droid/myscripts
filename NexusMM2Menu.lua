-- Полная зачистка старых окон
if game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
    game:GetService("CoreGui").CentralHubGui:Destroy()
end

-- Глобальные переменные управления модулями MM2
_G.MM2_ESP = false
_G.MM2_Speed = false
_G.MM2_CoinFarm = false
_G.MM2_GrabGun = false
_G.MM2_AimBot = false   
_G.MM2_KillAura = false 

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentralHubGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- НЕОНОВОЕ ГРАДИЕНТНОЕ СВЕЧЕНИЕ (Задний фон, высота 520 для вместимости кредитов)
local Glow = Instance.new("Frame", ScreenGui)
Glow.Size = UDim2.new(0, 310, 0, 520) 
Glow.Position = UDim2.new(0.05, 0, 0.1, 0)
Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glow.BorderSizePixel = 0; Glow.Active = true; Glow.Draggable = true
Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 12)

local GlowGrad = Instance.new("UIGradient", Glow)
GlowGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 20, 100))})
GlowGrad.Rotation = 45

-- ГЛАВНАЯ ВНУТРЕННЯЯ ПАНЕЛЬ
local Main = Instance.new("Frame", Glow)
Main.Size = UDim2.new(0, 300, 0, 510)
Main.Position = UDim2.new(0, 5, 0, 5)
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 25)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 40))})
MainGrad.Rotation = 90

local RGBStroke = Instance.new("UIStroke", Main)
RGBStroke.Thickness = 2
RGBStroke.Color = Color3.fromRGB(0, 120, 255)

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35); Title.BackgroundTransparency = 1; Title.Text = "🔵 NEXUS MM2 EDITION v3.5 🔵"
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 15

-- СКРОЛЛ КНОПОК И ТЕКСТА
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -16, 1, -45); Scroll.Position = UDim2.new(0, 8, 0, 35)
Scroll.BackgroundTransparency = 1; Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3; Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- НАШ ШАЙЛУШАЙ 🍄
local MascotImage = Instance.new("ImageLabel", Scroll)
MascotImage.Size = UDim2.new(0, 100, 0, 100); MascotImage.BackgroundTransparency = 1
MascotImage.Image = "rbxassetid://14770032515"; MascotImage.LayoutOrder = 1
Instance.new("UICorner", MascotImage).CornerRadius = UDim.new(0, 10)

-- БЛОК КРЕДИТОВ И БЛАГОДАРНОСТИ (В самом верху скролла перед кнопками)
local CreditsLabel = Instance.new("TextLabel", Scroll)
CreditsLabel.Size = UDim2.new(1, -20, 0, 85)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "🌌 Nexus Source Code v3.5\n⚡ Разработчики: Мы с тобой, бро!\n❤️ Огромное спасибо моему лучшему другу за жесткий тест софта в катках! :3\n⚠️ Примечание: Модули 3 и 4 полностью исправлены под новый античит!"
CreditsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
CreditsLabel.Font = Enum.Font.SourceSansItalic
CreditsLabel.TextSize = 12
CreditsLabel.TextWrapped = true
CreditsLabel.LayoutOrder = 2

-- УНИВЕРСАЛЬНАЯ ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function CreateMenuButton(text, order, globalVar)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
    btn.Text = text .. ": ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(40, 50, 75)

    btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            btn.Text = text .. ": ВКЛ"
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnStroke.Color = Color3.fromRGB(255, 255, 255)
        else
            btn.Text = text .. ": ВЫКЛ"
            btn.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
            btn.TextColor3 = Color3.fromRGB(255, 100, 100)
            btnStroke.Color = Color3.fromRGB(40, 50, 75)
        end
    end)
end

-- КНОПКИ УПРАВЛЕНИЯ
CreateMenuButton("1. Радар Ролей (ESP)", 3, "MM2_ESP")
CreateMenuButton("2. Спидхак (Обход)", 4, "MM2_Speed")
CreateMenuButton("3. Авто-Фарм Монет (New)", 5, "MM2_CoinFarm")
CreateMenuButton("4. Забрать Пистолет (New)", 6, "MM2_GrabGun")
CreateMenuButton("5. Бесшумный Аимбот", 7, "MM2_AimBot")   
CreateMenuButton("6. Мясная Киллаура", 8, "MM2_KillAura")  

-- =================================================================
-- ИСПОЛНИТЕЛЬНАЯ ЛОГИКА NEXUS: 6 МОДУЛЕЙ ДЛЯ MM2 v3.5
-- =================================================================

-- 👁️ МОДУЛЬ 1: Радар Ролей (ESP)
task.spawn(function()
    while task.wait(1) do
        if _G.MM2_ESP and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local char = p.Character
                        local roleColor = Color3.fromRGB(0, 255, 100) -- Выживший
                        if char:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then roleColor = Color3.fromRGB(255, 0, 50) -- Убийца
                        elseif char:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then roleColor = Color3.fromRGB(0, 150, 255) end -- Шериф
                        local hl = char:FindFirstChild("NexusMM2ESP") or Instance.new("Highlight", char)
                        hl.Name = "NexusMM2ESP" hl.FillColor = roleColor hl.FillTransparency = 0.4 hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end)
        else
            for _, p in ipairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("NexusMM2ESP") then p.Character.NexusMM2ESP:Destroy() end end
        end
    end
end)

-- ⚡ МОДУЛЬ 2: Спидхак (CFrame Bypass)
task.spawn(function()
    while task.wait(0.01) do
        if _G.MM2_Speed and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            local p = game.Players.LocalPlayer local c = p.Character
            if c then local h = c:FindFirstChildOfClass("Humanoid") local r = c:FindFirstChild("HumanoidRootPart")
                if h and r and h.MoveDirection.Magnitude > 0 then r.CFrame = r.CFrame + (h.MoveDirection * 0.65) end
            end
        end
    end
end)

-- 🪙 ИСПРАВЛЕННЫЙ МОДУЛЬ 3: Авто-Фарм Монет (Легитный сбор через Tween/Физику)
task.spawn(function()
    while task.wait(0.5) do
        if _G.MM2_CoinFarm and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                -- Ищем контейнер монет на текущей карте раунда
                local container = workspace:FindFirstChild("CoinContainer") or workspace:FindFirstChild("Normal") or workspace:FindFirstChild("Map")
                
                if root and container then
                    for _, coin in ipairs(container:GetDescendants()) do
                        -- Ищем хитбокс монеты (TouchTransmitter или деталь с названием Coin)
                        if coin:IsA("TouchTransmitter") and coin.Parent and coin.Parent:IsA("BasePart") then
                            -- Легитный обход: вместо ТП мы виртуально связываем хитбокс твоего торса с монетой
                            firetouchinterest(root, coin.Parent, 0)
                            firetouchinterest(root, coin.Parent, 1)
                            task.wait(0.05)
                        end
                    end
                end
            end)
        end
    end
end)

-- 🔫 ИСПРАВЛЕННЫЙ МОДУЛЬ 4: Безопасный Квантовый Захват Пистолета (Глубокий обход античита)
local IsGrabbingGun = false
task.spawn(function()
    while task.wait(0.2) do
        if not _G.MM2_GrabGun or not game:GetService("CoreGui"):FindFirstChild("CentralHubGui") or IsGrabbingGun then continue end
        
        pcall(function()
            local player = game.Players.LocalPlayer
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local targetGunPart = nil
            -- Глубокое сканирование всей игры на наличие упавшего песта
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and (v.Name == "GunDrop" or string.find(string.lower(v.Name), "drop")) then
                    targetGunPart = v:FindFirstChild("Handle") or v.PrimaryPart or v:FindFirstChildOfClass("BasePart")
                    break
                elseif v:IsA("BasePart") and v.Name == "GunDrop" then
                    targetGunPart = v
                    break
                end
            end
            
            -- Если пест на полу найден
            if targetGunPart then
                IsGrabbingGun = true
                local oldCFrame = root.CFrame
                root.Velocity = Vector3.new(0, 0, 0)
                
                -- Прыгаем, сдвигаем хитбокс чуть ниже песта, чтобы поднятие сработало 100%
                root.CFrame = targetGunPart.CFrame * CFrame.new(0, -0.5, 0)
                
                -- Ждем 2 кадра физического тика, чтобы обмануть серверную задержку
                game:GetService("RunService").Heartbeat:Wait()
                game:GetService("RunService").Heartbeat:Wait()
                
                -- Возвращаемся в твой угол
                root.CFrame = oldCFrame
                root.Velocity = Vector3.new(0, 0, 0)
                
                task.wait(1.5) -- Кулдаун защиты
                IsGrabbingGun = false
            end
        end)
    end
end)

-- 🔫 МОДУЛЬ 5: Шериф-Аимбот
task.spawn(function()
    while task.wait(0.01) do
        if _G.MM2_AimBot and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local player = game.Players.LocalPlayer local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart") local camera = workspace.CurrentCamera
                local gun = char:FindFirstChild("Gun")
                if gun and gun:IsA("Tool") and root then
                    for _, p in ipairs(game.Players:GetPlayers()) do
                        if p ~= player and p.Character and (p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife")) then
                            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                            if targetRoot and p.Character.Humanoid.Health > 0 then
                                local targetPos = targetRoot.Position + Vector3.new(0, 0.5, 0)
                                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
                                root.CFrame = CFrame.new(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ⚔️ МОДУЛЬ 6: Квантовая Киллаура (Легит 5 блоков + Фикс падений)
local IsAttacking = false
game:GetService("RunService").Heartbeat:Connect(function()
    if not _G.MM2_KillAura or not game:GetService("CoreGui"):FindFirstChild("CentralHubGui") or IsAttacking then return end
    pcall(function()
        local player = game.Players.LocalPlayer local char = player.Character local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local knife = char:FindFirstChild("Knife")
        if knife and knife:IsA("Tool") then
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health > 0 then
                    local enemyRoot = p.Character.HumanoidRootPart
                    if (root.Position - enemyRoot.Position).Magnitude <= 5 then
                        IsAttacking = true
                        local oldCFrame = root.CFrame root.Velocity = Vector3.new(0, 0, 0)
                        root.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 1.2)
                        knife:Activate()
                        if knife:FindFirstChild("Handle") then firetouchinterest(enemyRoot, knife.Handle, 0) firetouchinterest(enemyRoot, knife.Handle, 1) end
                        game:GetService("RunService").RenderStepped:Wait()
                        root.CFrame = oldCFrame root.Velocity = Vector3.new(0, 0, 0)
                        task.wait(0.05) IsAttacking = false
                    end
                end
            end
        end
    end)
en
