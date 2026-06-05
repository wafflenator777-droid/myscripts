-- Полная очистка старых версий хаба перед запуском
if game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
    game:GetService("CoreGui").CentralHubGui:Destroy()
end

-- Глобальные переменные для будущих модулей
_G.HideSeek_ESP = false
_G.HideSeek_Speed = false
_G.HideSeek_InfJump = false
_G.HideSeek_TP = false
_G.HideSeek_SurvivorESP = false -- Наша новая 5-я функция!

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentralHubGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- ГРАДИЕНТНОЕ СВЕЧЕНИЕ ФОНА (Уменьшили высоту до 420, чтобы убрать пустоту)
local Glow = Instance.new("Frame", ScreenGui)
Glow.Size = UDim2.new(0, 310, 0, 420) 
Glow.Position = UDim2.new(0.05, 0, 0.1, 0)
Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glow.BorderSizePixel = 0; Glow.Active = true; Glow.Draggable = true
Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 12)

local GlowGrad = Instance.new("UIGradient", Glow)
GlowGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 20, 100))})
GlowGrad.Rotation = 45

-- ГЛАВНАЯ ВНУТРЕННЯЯ ПАНЕЛЬ
local Main = Instance.new("Frame", Glow)
Main.Size = UDim2.new(0, 300, 0, 410)
Main.Position = UDim2.new(0, 5, 0, 5)
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 25)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 40))})
MainGrad.Rotation = 90

local RGBStroke = Instance.new("UIStroke", Main)
RGBStroke.Thickness = 2
RGBStroke.Color = Color3.fromRGB(0, 120, 255)

-- ШАПКА / ЗАГОЛОВОК
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35); Title.BackgroundTransparency = 1; Title.Text = "🔵 NEXUS HIDE & SEEK v2.5 🔵"
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 15

-- СКРОЛЛ КНОПОК
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -16, 1, -45); Scroll.Position = UDim2.new(0, 8, 0, 35)
Scroll.BackgroundTransparency = 1; Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3; Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 100, 255)

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- НАШ ШАЙЛУШАЙ 🍄
local MascotImage = Instance.new("ImageLabel", Scroll)
MascotImage.Size = UDim2.new(0, 100, 0, 100); MascotImage.BackgroundTransparency = 1 -- Немного уменьшили картинку под размер окна
MascotImage.Image = "rbxassetid://14770032515"; MascotImage.LayoutOrder = 1
Instance.new("UICorner", MascotImage).CornerRadius = UDim.new(0, 10)

-- УНИВЕРСАЛЬНАЯ ФУНКЦИЯ СОЗДАНИЯ КНОПОК
local function CreateMenuButton(text, order, globalVar)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, -20, 0, 40) -- Сделали кнопки чуть компактнее
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

-- СОЗДАЕМ 5 АККУРАТНЫХ КНОПОК БЕЗ ПУСТОТЫ
CreateMenuButton("1. Подсветка Водящего (ESP)", 2, "HideSeek_ESP")
CreateMenuButton("2. Спидхак (Обход)", 3, "HideSeek_Speed")
CreateMenuButton("3. Прыжки по Воздуху", 4, "HideSeek_InfJump")
CreateMenuButton("4. Скрытый Телепорт", 5, "HideSeek_TP")
CreateMenuButton("5. Подсветка Выживших (Я — It)", 6, "HideSeek_SurvivorESP")

-- =================================================================
-- 3. ПОЛНАЯ ИСПРАВЛЕННАЯ ЛОГИКА ФУНКЦИЙ С БАЙПАСОМ
-- =================================================================
-- =================================================================
-- ИСПОЛНИТЕЛЬНАЯ ЛОГИКА NEXUS: ПАК ИЗ 5 МОДУЛЕЙ ДЛЯ HIDE & SEEK
-- =================================================================

-- Вспомогательная функция для бесперебойного поиска Искателя (It) в игре
local function GetItPlayer()
    if workspace:GetAttribute("It") then
        return tostring(workspace:GetAttribute("It"))
    end
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.Character and (p.Character:FindFirstChild("It") or p:FindFirstChild("IsIt")) then
            return p.Name
        end
    end
    return nil
end

-- Переменная для контроля анти-мигания
local LastItPlayer = nil


-- 👁️ МОДУЛЬ 1: Стабильный ESP на Искателя (Без мигания и ложных срабатываний)
task.spawn(function()
    while task.wait(0.5) do
        if _G.HideSeek_ESP and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local itName = GetItPlayer()
                
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if p.Name == itName then
                            -- Удаляем у старого, если Искатель внезапно сменился
                            if LastItPlayer and LastItPlayer ~= p and LastItPlayer.Character and LastItPlayer.Character:FindFirstChild("NexusItESP") then
                                LastItPlayer.Character.NexusItESP:Destroy()
                            end
                            LastItPlayer = p
                            
                            -- Создаем подсветку ТОЛЬКО ОДИН РАЗ (это убирает мигание гирлянды)
                            if not p.Character:FindFirstChild("NexusItESP") then
                                local hl = Instance.new("Highlight")
                                hl.Name = "NexusItESP"
                                hl.FillColor = Color3.fromRGB(0, 120, 255) -- Наш фирменный синий Nexus
                                hl.FillTransparency = 0.3
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.OutlineTransparency = 0
                                hl.Parent = p.Character
                            end
                        else
                            if p.Character:FindFirstChild("NexusItESP") then p.Character.NexusItESP:Destroy() end
                        end
                    end
                end
            end)
        else
            -- Зачищаем ESP при отключении кнопки в хабе
            LastItPlayer = nil
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("NexusItESP") then p.Character.NexusItESP:Destroy() end
            end
        end
    end
end)


-- ⚡ МОДУЛЬ 2: Спидхак (Обход через CFrame, проверенный в Evade)
task.spawn(function()
    while task.wait(0.01) do
        if _G.HideSeek_Speed and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            local p = game.Players.LocalPlayer
            local c = p.Character
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                local r = c:FindFirstChild("HumanoidRootPart")
                if h and r and h.MoveDirection.Magnitude > 0 then
                    r.CFrame = r.CFrame + (h.MoveDirection * 0.55)
                end
            end
        end
    end
end)


-- 🪂 МОДУЛЬ 3: Бесконечные прыжки по воздуху (Infinite Jump)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.HideSeek_InfJump and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
        local p = game.Players.LocalPlayer
        if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
            p.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end
end)


-- 🎪 МОДУЛЬ 4: Твой допиленный скрытый телепорт (Вверх на 150 блоков)
task.spawn(function()
    local hasTeleported = false
    while task.wait(0.5) do
        if _G.HideSeek_TP and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            if not hasTeleported then
                local p = game.Players.LocalPlayer
                local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if r then
                    -- Твой топовый фикс высоты, обходящий все триггеры возврата!
                    r.CFrame = r.CFrame * CFrame.new(0, 150, 0)
                    hasTeleported = true 
                end
            end
        else
            hasTeleported = false -- Сбрасываем триггер при выключении
        end
    end
end)


-- 🎯 МОДУЛЬ 5: Слежка за выжившими (Survivor ESP, когда ТЫ стал водящим)
task.spawn(function()
    while task.wait(0.5) do
        if _G.HideSeek_SurvivorESP and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local amI_It = false
                local myName = game.Players.LocalPlayer.Name

                -- Сверяем, не выбрала ли игра нас на роль Искателя
                if workspace:GetAttribute("It") and tostring(workspace:GetAttribute("It")) == myName then
                    amI_It = true
                elseif game:GetService("ReplicatedStorage"):FindFirstChild("CurrentIt") and game:GetService("ReplicatedStorage").CurrentIt.Value == myName then
                    amI_It = true
                elseif game.Players.LocalPlayer:FindFirstChild("IsIt") or game.Players.LocalPlayer:GetAttribute("IsIt") == true then
                    amI_It = true
                end

                if amI_It then
                    -- Если мы водим — подсвечиваем синим всех, кто прячется
                    for _, p in ipairs(game.Players:GetPlayers()) do
                        if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local char = p.Character
                            local isCaught = char:FindFirstChild("Caught") or p:GetAttribute("Caught")
                            
                            if not isCaught then
                                if not char:FindFirstChild("NexusSurvivorESP") then
                                    local hl = Instance.new("Highlight")
                                    hl.Name = "NexusSurvivorESP"
                                    hl.FillColor = Color3.fromRGB(0, 150, 255) -- Синий неоновый Нексус
                                    hl.FillTransparency = 0.4
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                    hl.OutlineTransparency = 0
                                    hl.Parent = char
                                end
                            else
                                if char:FindFirstChild("NexusSurvivorESP") then char.NexusSurvivorESP:Destroy() end
                            end
                        end
                    end
                else
                    -- Если мы обычный выживший челик — принудительно гасим радар
                    for _, p in ipairs(game.Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("NexusSurvivorESP") then
                            p.Character.NexusSurvivorESP:Destroy()
                        end
                    end
                end
            end)
        else
            -- Полная зачистка при выключении 5-й кнопки
            for _, p in ipairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("NexusSurvivorESP") then 
                    p.Character.NexusSurvivorESP:Destroy() 
                end
            end
        end
    end
end)
