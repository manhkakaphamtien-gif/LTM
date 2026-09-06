-- Global Settings & Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configurations Data
local Config = {
    ESP = {
        Enabled = false,
        Line = false,
        Box = false,
        Distance = false,
        Name = false,
        Health = false,
        Skeleton = false,
        FOVSize = 100
    },
    Aim = {
        AimHead = false,
        AimBody = false,
        AimFire = false,
        AimSilent = false,
        Smoothness = 1 -- 1: Lỏng, 10: Siêu chặt
    },
    Memory = {
        Invisibility = false,
        Speed = 16,
        NoReload = false,
        TeleportKill = false,
        Noclip = false,
        RapidFire = 1,
        SpinBot = false
    }
}

------------------------------------------------------------------------
-- UI CREATION (ScreenGui, Floating Icon, Main Frame)
------------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TiênMạnhHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Menu Icon (Di chuyển được)
local FloatingIcon = Instance.new("TextButton")
FloatingIcon.Name = "FloatingIcon"
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
FloatingIcon.BorderSizePixel = 0
FloatingIcon.Text = "TM"
FloatingIcon.TextColor3 = Color3.fromRGB(0, 255, 127)
FloatingIcon.TextSize = 20
FloatingIcon.Font = Enum.Font.SourceSansBold
FloatingIcon.Parent = ScreenGui

local UICornerIcon = Instance.new("UICorner")
UICornerIcon.CornerRadius = UDim.new(1, 0)
UICornerIcon.Parent = FloatingIcon

local UIStrokeIcon = Instance.new("UIStroke")
UIStrokeIcon.Color = Color3.fromRGB(0, 255, 127)
UIStrokeIcon.Thickness = 2
UIStrokeIcon.Parent = FloatingIcon

-- Enable Dragging for Floating Icon
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    FloatingIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatingIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Main Frame UI
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 380)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Toggle Main Frame by Clicking Icon
FloatingIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 130, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 8)
SidebarCorner.Parent = Sidebar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TM HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = Sidebar

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -140, 1, -10)
Container.Position = UDim2.new(0, 135, 0, 5)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Navigation Tabs Setup
local Tabs = {}
local TabButtons = {}

local function CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, 45 + (#TabButtons * 40))
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 15
    Button.Parent = Sidebar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Button

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.CanvasSize = UDim2.new(0, 0, 2, 0)
    Page.ScrollBarThickness = 4
    Page.Visible = (#TabButtons == 0)
    Page.Parent = Container

    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = Page

    Button.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do tab.Visible = false end
        for _, btn in pairs(TabButtons) do btn.TextColor3 = Color3.fromRGB(200, 200, 200) end
        Page.Visible = true
        Button.TextColor3 = Color3.fromRGB(0, 255, 127)
    end)

    table.insert(Tabs, Page)
    table.insert(TabButtons, Button)
    return Page
end

local ESPTab = CreateTab("ESP")
local AimTab = CreateTab("Aim")
local MemoryTab = CreateTab("Memory")
local AdminTab = CreateTab("Admin")

------------------------------------------------------------------------
-- UI CONTROLS HELPERS (Toggle & Slider)
------------------------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.98, 0, 0, 30)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 15
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 40, 0, 20)
    Button.Position = UDim2.new(1, -45, 0.5, -10)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
    Button.Text = ""
    Button.Parent = Frame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Button

    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(50, 50, 50)
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.98, 0, 0, 45)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 14
    Label.Parent = Frame

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, 0, 0, 8)
    SliderBar.Position = UDim2.new(0, 0, 0, 25)
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.Parent = Frame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local isSliding = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(value)
        callback(value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

------------------------------------------------------------------------
-- POPULATING TABS & FEATURES
------------------------------------------------------------------------

-- 1. ESP Tab Controls
CreateToggle(ESPTab, "Cho phép ESP", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
CreateToggle(ESPTab, "ESP Line", Config.ESP.Line, function(v) Config.ESP.Line = v end)
CreateToggle(ESPTab, "ESP Box", Config.ESP.Box, function(v) Config.ESP.Box = v end)
CreateToggle(ESPTab, "ESP Khoảng cách", Config.ESP.Distance, function(v) Config.ESP.Distance = v end)
CreateToggle(ESPTab, "ESP Tên", Config.ESP.Name, function(v) Config.ESP.Name = v end)
CreateToggle(ESPTab, "ESP Máu", Config.ESP.Health, function(v) Config.ESP.Health = v end)
CreateToggle(ESPTab, "ESP Skeleton", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
CreateSlider(ESPTab, "Kích cỡ FOV", 30, 500, Config.ESP.FOVSize, function(v) Config.ESP.FOVSize = v end)

-- 2. Aim Tab Controls
CreateToggle(AimTab, "Aim Đầu", Config.Aim.AimHead, function(v) Config.Aim.AimHead = v if v then Config.Aim.AimBody = false end end)
CreateToggle(AimTab, "Aim Body", Config.Aim.AimBody, function(v) Config.Aim.AimBody = v if v then Config.Aim.AimHead = false end end)
CreateSlider(AimTab, "Mức độ Aim (1: Lỏng -> 10: Siêu chặt)", 1, 10, Config.Aim.Smoothness, function(v) Config.Aim.Smoothness = v end)
CreateToggle(AimTab, "Aim Fire (Tự bắn khi Aim)", Config.Aim.AimFire, function(v) Config.Aim.AimFire = v end)
CreateToggle(AimTab, "Aim Silent", Config.Aim.AimSilent, function(v) Config.Aim.AimSilent = v end)

-- 3. Memory Tab Controls
CreateToggle(MemoryTab, "Tàng hình", Config.Memory.Invisibility, function(v)
    Config.Memory.Invisibility = v
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = v and 1 or 0
            end
        end
    end
end)
CreateSlider(MemoryTab, "Tốc độ (Speed)", 16, 250, Config.Memory.Speed, function(v) Config.Memory.Speed = v end)
CreateToggle(MemoryTab, "No Reload", Config.Memory.NoReload, function(v) Config.Memory.NoReload = v end)
CreateToggle(MemoryTab, "Teleport Kill", Config.Memory.TeleportKill, function(v) Config.Memory.TeleportKill = v end)
CreateToggle(MemoryTab, "Đi xuyên tường (Noclip)", Config.Memory.Noclip, function(v) Config.Memory.Noclip = v end)
CreateSlider(MemoryTab, "Bắn siêu nhanh", 1, 10, Config.Memory.RapidFire, function(v) Config.Memory.RapidFire = v end)
CreateToggle(MemoryTab, "Xoay vòng tròn (SpinBot)", Config.Memory.SpinBot, function(v) Config.Memory.SpinBot = v end)

-- 4. Admin Tab Controls
local AdminLabel = Instance.new("TextLabel")
AdminLabel.Size = UDim2.new(1, 0, 0, 60)
AdminLabel.BackgroundTransparency = 1
AdminLabel.Text = "Lionel Tiến Mạnh"
AdminLabel.TextSize = 28
AdminLabel.Font = Enum.Font.SourceSansBold
AdminLabel.Parent = AdminTab

-- Rainbow Text Loop for Admin
RunService.RenderStepped:Connect(function()
    local hue = tick() % 3 / 3
    AdminLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

------------------------------------------------------------------------
-- CORE LOGIC SYSTEM (ESP & AIM & MEMORY)
------------------------------------------------------------------------

-- FOV Circle Graphic
local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Visible = true

-- Utility Functions
local function GetClosestTarget()
    local closest = nil
    local shortestDist = Config.ESP.FOVSize

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid").Health > 0 then
            local targetPart = Config.Aim.AimHead and plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

-- ESP Drawings Cache
local ESPDrawings = {}

local function ClearESP(plr)
    if ESPDrawings[plr] then
        for _, draw in pairs(ESPDrawings[plr]) do
            draw:Remove()
        end
        ESPDrawings[plr] = nil
    end
end

-- Main Render Engine Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = Config.ESP.FOVSize

    -- Memory Features Loop
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Memory.Speed
        
        if Config.Memory.Noclip then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if Config.Memory.SpinBot and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
        end
    end

    -- Aim Assist System
    if Config.Aim.AimHead or Config.Aim.AimBody then
        local target = GetClosestTarget()
        if target and target.Character then
            local aimPart = Config.Aim.AimHead and target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
            if aimPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
                local smoothness = math.clamp(Config.Aim.Smoothness / 10, 0.1, 1)
                
                if not Config.Aim.AimSilent then
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, smoothness)
                end

                if Config.Aim.AimFire then
                    -- Trigger Fire Action
                    mouse1press()
                    task.delay(0.05, function() mouse1release() end)
                end

                if Config.Memory.TeleportKill and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = aimPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end

    -- ESP System
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if Config.ESP.Enabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid").Health > 0 then
                if not ESPDrawings[plr] then
                    ESPDrawings[plr] = {
                        Box = Drawing.new("Square"),
                        Line = Drawing.new("Line"),
                        Text = Drawing.new("Text")
                    }
                end

                local hrp = plr.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    -- Render Line
                    if Config.ESP.Line then
                        ESPDrawings[plr].Line.Visible = true
                        ESPDrawings[plr].Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        ESPDrawings[plr].Line.To = Vector2.new(pos.X, pos.Y)
                        ESPDrawings[plr].Line.Color = Color3.fromRGB(255, 255, 255)
                    else
                        ESPDrawings[plr].Line.Visible = false
                    end

                    -- Render Box
                    if Config.ESP.Box then
                        local sizeY = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y)
                        local sizeX = sizeY / 1.5
                        
                        ESPDrawings[plr].Box.Visible = true
                        ESPDrawings[plr].Box.Size = Vector2.new(math.abs(sizeX), math.abs(sizeY))
                        ESPDrawings[plr].Box.Position = Vector2.new(pos.X - math.abs(sizeX)/2, pos.Y - math.abs(sizeY)/2)
                        ESPDrawings[plr].Box.Color = Color3.fromRGB(0, 255, 127)
                    else
                        ESPDrawings[plr].Box.Visible = false
                    end

                    -- Render Text Info (Name, Dist, Health)
                    if Config.ESP.Name or Config.ESP.Distance or Config.ESP.Health then
                        local labelText = ""
                        if Config.ESP.Name then labelText = labelText .. plr.Name .. " " end
                        if Config.ESP.Distance then 
                            local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                            labelText = labelText .. "[" .. dist .. "m] " 
                        end
                        if Config.ESP.Health then 
                            labelText = labelText .. "(" .. math.floor(plr.Character.Humanoid.Health) .. "HP)" 
                        end

                        ESPDrawings[plr].Text.Visible = true
                        ESPDrawings[plr].Text.String = labelText
                        ESPDrawings[plr].Text.Position = Vector2.new(pos.X, pos.Y - 20)
                        ESPDrawings[plr].Text.Center = true
                        ESPDrawings[plr].Text.Size = 14
                        ESPDrawings[plr].Text.Color = Color3.fromRGB(255, 255, 255)
                    else
                        ESPDrawings[plr].Text.Visible = false
                    end
                else
                    ESPDrawings[plr].Box.Visible = false
                    ESPDrawings[plr].Line.Visible = false
                    ESPDrawings[plr].Text.Visible = false
                end
            else
                ClearESP(plr)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(ClearESP)
