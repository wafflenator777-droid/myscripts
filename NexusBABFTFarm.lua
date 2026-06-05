
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Конфиг управления фермой
local Config = {
    AutoFarm = false,
    FarmSpeed = 130,
    HeightOffset = 50
}

local pGui = LocalPlayer:WaitForChild("PlayerGui")
if pGui:FindFirstChild("NexusBabftFarmHub") then pGui.NexusBabftFarmHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", pGui)
ScreenGui.Name = "NexusBabftFarmHub"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 115) -- Идеально компактная высота под 3 элемента
MainFrame.Position = UDim2.new(0, 850, 0, 40)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
MainFrame.BorderSizePixel = 0; MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local BlueStroke = Instance.new("UIStroke", MainFrame)
BlueStroke.Thickness = 2; BlueStroke.Color = Color3.fromRGB(0, 120, 255)

-- 1. ЗАГОЛОВОК (Жестко забит на самый верх)
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0) -- Самый верх
Title.BackgroundTransparency = 1
Title.Text = "🚢 NEXUS BABFT FARMER 🥇"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 13

local Btn = Instance.new("TextButton", MainFrame)
Btn.Size = UDim2.new(1, -20, 0, 32)
Btn.Position = UDim2.new(0, 10, 0, 42) -- Ровно под заголовком
Btn.BackgroundColor3 = Color3.fromRGB(24, 32, 48)
Btn.Text = "BABFT Gold Farm: OFF"
Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
Btn.Font = Enum.Font.SourceSansBold
Btn.TextSize = 11
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

local Stroke = Instance.new("UIStroke", Btn)
Stroke.Color = Color3.fromRGB(0, 80, 180); Stroke.Thickness = 1

Btn.MouseButton1Down:Connect(function()
    Config.AutoFarm = not Config.AutoFarm
    Btn.BackgroundColor3 = Config.AutoFarm and Color3.fromRGB(0, 140, 50) or Color3.fromRGB(24, 32, 48)
    Btn.Text = Config.AutoFarm and "BABFT Farm: ACTIVE 🔥" or "BABFT Gold Farm: OFF"
end)

local CreditsLabel = Instance.new("TextLabel", MainFrame)
CreditsLabel.Size = UDim2.new(1, -20, 0, 22)
CreditsLabel.Position = UDim2.new(0, 10, 0, 82) -- Самый низ фрейма
CreditsLabel.BackgroundColor3 = Color3.fromRGB(18, 24, 36)
CreditsLabel.Text = "coded by SHAYLUSHAY & Nexus 2.0"
CreditsLabel.TextColor3 = Color3.fromRGB(100, 180, 255); CreditsLabel.Font = Enum.Font.SourceSansItalic; CreditsLabel.TextSize = 10
Instance.new("UICorner", CreditsLabel).CornerRadius = UDim.new(0, 6)

local function GetSortedStages()
    local stages = {}
    local boatStages = Workspace:FindFirstChild("BoatStages")
    local normalStages = boatStages and boatStages:FindFirstChild("NormalStages")
    
    if normalStages then
        for _, stage in ipairs(normalStages:GetChildren()) do
            if string.find(stage.Name, "CaveStage") then
                local darkness = stage:FindFirstChild("DarknessPart")
                if darkness then table.insert(stages, darkness) end
            end
        end
    end
    
    table.sort(stages, function(a, b) return a.Position.Z < b.Position.Z end)
    return stages
end

local isTweening = false

task.spawn(function()
    while true do
        task.wait(0.5)
        
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        
        if Config.AutoFarm and root and hum and hum.Health > 0 and not isTweening then
            isTweening = true
            local activeStages = GetSortedStages()
            
            for _, targetPart in ipairs(activeStages) do
                if not Config.AutoFarm or not root or hum.Health <= 0 then break end
                if targetPart.Position.Z <= root.Position.Z + 10 then continue end
                
                root.Velocity = Vector3.zero
                local distance = (root.Position - targetPart.Position).Magnitude
                local duration = distance / Config.FarmSpeed
                
                local targetCFrame = CFrame.new(targetPart.Position.X, targetPart.Position.Y + Config.HeightOffset, targetPart.Position.Z)
                local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
                tween:Play()
                
                local startWait = tick()
                while tween.PlaybackState == Enum.PlaybackState.Playing and Config.AutoFarm and hum.Health > 0 do
                    if tick() - startWait > duration + 1 then break end
                    root.Velocity = Vector3.zero
                    RunService.Heartbeat:Wait()
                end
            end
            
            local endZone = Workspace:FindFirstChild("BoatStages") and Workspace.BoatStages:FindFirstChild("NormalStages") and Workspace.BoatStages.NormalStages:FindFirstChild("TheEnd")
            local chest = endZone and endZone:FindFirstChild("GoldenChest") and endZone.GoldenChest:FindFirstChild("ChestTop")
            
            if chest and Config.AutoFarm and root and hum.Health > 0 then
                root.Velocity = Vector3.zero
                local distanceToEnd = (root.Position - chest.Position).Magnitude
                local durationToEnd = distanceToEnd / 22
                
                local endTween = TweenService:Create(root, TweenInfo.new(durationToEnd, Enum.EasingStyle.Linear), {CFrame = chest.CFrame * CFrame.new(0, -2, 0)})
                endTween:Play()
                
                local startWait = tick()
                while endTween.PlaybackState == Enum.PlaybackState.Playing and Config.AutoFarm and hum.Health > 0 do
                    if tick() - startWait > durationToEnd + 1 then break end
                    root.Velocity = Vector3.zero
                    RunService.Heartbeat:Wait()
                end
                
                root.Velocity = Vector3.zero
                task.wait(7)
                if hum then hum.Health = 0 end
            end
            isTweening = false
        end
    end
end)

RunService.Stepped:Connect(function()
    if Config.AutoFarm and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Swimming then hum:ChangeState(Enum.HumanoidStateType.Running) end
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)
