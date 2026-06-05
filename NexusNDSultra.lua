-- 1. ПОЛНАЯ ОЧИСТКА ПРЕДЫДУЩИХ ИНТЕРФЕЙСОВ
if game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
    game:GetService("CoreGui").CentralHubGui:Destroy()
end

-- Переключатели функций (Сразу ВКЛ при инжекте)
_G.NDS_PartMagnet = true
_G.NDS_FlyNoClip = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CentralHubGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- СУПЕР-КОМПАКТНЫЙ ФРЕЙМ (Высота 180 под две кнопки)
local Glow = Instance.new("Frame", ScreenGui)
Glow.Size = UDim2.new(0, 310, 0, 180) 
Glow.Position = UDim2.new(0.5, -155, 0.35, 0)
Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Glow.BorderSizePixel = 0; Glow.Active = true; Glow.Draggable = true
Glow.ZIndex = 100
Instance.new("UICorner", Glow).CornerRadius = UDim.new(0, 12)

local GlowGrad = Instance.new("UIGradient", Glow)
GlowGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 20, 100))})
GlowGrad.Rotation = 45

local Main = Instance.new("Frame", Glow)
Main.Name = "MainPanel"
Main.Size = UDim2.new(0, 300, 0, 170)
Main.Position = UDim2.new(0, 5, 0, 5)
Main.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
Main.BorderSizePixel = 0
Main.ZIndex = 101
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 15, 25)), ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 40))})
MainGrad.Rotation = 90

local RGBStroke = Instance.new("UIStroke", Main)
RGBStroke.Thickness = 2; RGBStroke.Color = Color3.fromRGB(0, 120, 255)

-- ЗАГОЛОВОК
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.BackgroundTransparency = 1; Title.Text = "🔵 NEXUS DISASTER ULTRA-PACK 🔵"
Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.Font = Enum.Font.SourceSansBold; Title.TextSize = 14
Title.ZIndex = 102

-- Функция создания статичных кнопок
local function CreateStaticButton(text, yPos, globalVar)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(1, -30, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Синий неон со старта
    btn.Text = text .. ": ВКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.ZIndex = 102
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1; btnStroke.Color = Color3.fromRGB(255, 255, 255)

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

CreateStaticButton("1. Магнит Обломков (Физика)", 55, "NDS_PartMagnet")
CreateStaticButton("2. Полет + NoClip (W,A,S,D)", 105, "NDS_FlyNoClip")

-- =================================================================
-- ИСПОЛНИТЕЛЬНАЯ ЛОГИКА NEXUS NDS: ПОЛЕТ + НОКЛИП + МАГНИТ v11.0
-- =================================================================

local FlySpeed = 2.5 -- Скорость перемещения в полете
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ⚡ ИСПРАВЛЕННЫЙ МОДУЛЬ №1: Полет + Жесткий NoClip (Надежный CFrame Bypass)
task.spawn(function()
    RunService.Stepped:Connect(function()
        -- Если полет активен и меню существует
        if _G.NDS_FlyNoClip and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local camera = workspace.CurrentCamera
                
                if root and humanoid then
                    -- Гасим гравитационную скорость, чтобы персонаж застыл в воздухе
                    root.Velocity = Vector3.new(0, 0, 0)
                    
                    -- ЖЕСТКИЙ NOCLIP: Отключаем коллизию всех деталей персонажа сквозь стены
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    -- Считываем зажатые клавиши ходьбы
                    local flyVector = Vector3.new(0, 0, 0)
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        flyVector = flyVector + camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        flyVector = flyVector - camera.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        flyVector = flyVector - camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        flyVector = flyVector + camera.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        flyVector = flyVector + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        flyVector = flyVector - Vector3.new(0, 1, 0)
                    end
                    
                    -- Если зажата кнопка движения — плавно перемещаем CFrame сквозь текстуры
                    if flyVector.Magnitude > 0 then
                        root.CFrame = root.CFrame + (flyVector.Unit * FlySpeed)
                    end
                end
            end)
        end
    end)
end)


-- 🧲 МОДУЛЬ №2: Магнит Физических Обломков (Unanchored Parts)
-- =================================================================
-- ИСПОЛНИТЕЛЬНАЯ ЛОГИКА NEXUS NDS v11.5: СЕРВЕРНЫЙ МАГНИТ + ПОЛЕТ
-- =================================================================

task.spawn(function()
    while task.wait(0.04) do -- Сверхбыстрый флуд для удержания сетевых прав на физику
        if _G.NDS_PartMagnet and game:GetService("CoreGui"):FindFirstChild("CentralHubGui") then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local disasterStructure = workspace:FindFirstChild("Structure")
                
                if root and disasterStructure then
                    for _, part in ipairs(disasterStructure:GetDescendants()) do
                        -- Фильтруем только незакрепленные блоки (Unanchored)
                        if part:IsA("BasePart") and part.Anchored == false then
                            if not part:IsDescendantOf(player.Character) and not game.Players:GetPlayerFromCharacter(part.Parent) then
                                
                                -- ХАКЕРСКИЙ ТРЮК №1: Забираем Network Ownership себе в обход сервера!
                                -- Имитируем моментальное физическое касание (Touch) твоего торса и летящего обломка.
                                -- Сервер думает, что ты стоишь вплотную, и отдает тебе права на управление физикой этого парта!
                                firetouchinterest(root, part, 0)
                                firetouchinterest(root, part, 1)
                                
                                -- ХАКЕРСКИЙ ТРЮК №2: Переносим деталь через Velocity и CFrame
                                -- Так как сетевые права теперь у нас, это перемещение 100% продублируется ВСЕМ игрокам на сервере!
                                part.Velocity = Vector3.new(0, 0, 0)
                                part.RotVelocity = Vector3.new(0, 0, 0)
                                
                                -- Закручиваем блоки в дикий защитный вихрь вокруг твоего полета
                                part.CFrame = root.CFrame * CFrame.new(math.random(-6, 6), math.random(-3, 6), math.random(-6, 6))
                            end
                        end
                    end
                end
            end)
        end
    end
end)
