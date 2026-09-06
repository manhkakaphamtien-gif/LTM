--[[
    💀 DEVILS WILL RISE — SUBSCRIBER EDITION 💀
    Owner: @dongkaa
    Channel: @dongkaa
    Created by: Người Đẹp Trai (Subscriber)
    Version: 1.0.0
--]]

-- ============================================
-- SECTION 1: SERVICES
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- ============================================
-- SECTION 2: CONFIGURATION
-- ============================================

local MenuConfig = {
    Title = "💀 DEVILS WILL RISE 💀",
    SubTitle = "SUBSCRIBER EDITION",
    Owner = "@dongkaa",
    Channel = "@dongkaa",
    Creator = "Người Đẹp Trai",
    Version = "1.0.0",
    AccentColor = Color3.fromRGB(255, 0, 0),
    AccentColor2 = Color3.fromRGB(0, 255, 255),
    BackgroundColor = Color3.fromRGB(15, 15, 20),
    SectionColor = Color3.fromRGB(25, 25, 35),
    TextColor = Color3.fromRGB(255, 255, 255),
    SubtleTextColor = Color3.fromRGB(150, 150, 160),
    BorderColor = Color3.fromRGB(40, 40, 50),
    ToggleOnColor = Color3.fromRGB(0, 255, 100),
    ToggleOffColor = Color3.fromRGB(100, 100, 110),
    SliderFillColor = Color3.fromRGB(255, 0, 0),
    DangerColor = Color3.fromRGB(255, 0, 0),
    SuccessColor = Color3.fromRGB(0, 255, 0),
    WarningColor = Color3.fromRGB(255, 255, 0)
}

local ESPConfig = {
    Enabled = false,
    Line = false,
    Box = false,
    Distance = false,
    Name = false,
    Health = false,
    Skeleton = false,
    FOV = 200,
    ESPObjects = {},
    TextCache = {},
    HealthBars = {},
    SkeletonParts = {},
    MaxDistance = 500,
    BoxType = "2D",
    TextFont = Enum.Font.Code,
    TextSize = 14,
    BoxColor = Color3.fromRGB(255, 0, 0),
    LineColor = Color3.fromRGB(255, 255, 0),
    DistanceColor = Color3.fromRGB(0, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 0),
    SkeletonColor = Color3.fromRGB(255, 0, 255)
}

local AimConfig = {
    Head = false,
    Body = false,
    Fire = false,
    Silent = false,
    AimLevel = 50,
    Target = nil,
    FOV = 200,
    Smoothness = 0.5,
    VisibleCheck = true,
    TeamCheck = true,
    MaxDistance = 1000,
    Prediction = 0.15
}

local MemoryConfig = {
    Invisible = false,
    Speed = 16,
    NoReload = false,
    TeleportKill = false,
    NoClip = false,
    FireRate = 600,
    SpinSpeed = 500,
    Spinning = false,
    OldWalkSpeed = 16,
    OldJumpPower = 50,
    BackupPosition = nil,
    TeleportRange = 50,
    NoClipState = {},
    OriginalPositions = {},
    SpeedMultiplier = 1
}

local AdminConfig = {
    LionelTienManh = {
        Enabled = true,
        RainbowSpeed = 0.1,
        Text = "LIONEL TIẾN MẠNH",
        Size = 24,
        BlinkSpeed = 0.3,
        CurrentHue = 0
    }
}

-- ============================================
-- SECTION 3: UTILITY FUNCTIONS
-- ============================================

local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        instance[prop] = value
    end
    return instance
end

local function Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function IsAlive(player)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        return player.Character.Humanoid.Health > 0
    end
    return false
end

local function GetRootPart(character)
    if character then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("Head")
    end
    return nil
end

local function GetPlayers()
    local playersList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsAlive(player) then
            table.insert(playersList, player)
        end
    end
    return playersList
end

local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties or {}) do
        drawing[prop] = value
    end
    return drawing
end

local function RemoveDrawing(drawing)
    if drawing then
        drawing:Remove()
    end
end

-- ============================================
-- SECTION 4: UI CREATION
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DEVILS_WILL_RISE"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Icon Button (Movable)
local IconButton = Instance.new("TextButton")
IconButton.Name = "MenuIcon"
IconButton.Parent = ScreenGui
IconButton.Position = UDim2.new(0, 20, 0, 100)
IconButton.Size = UDim2.new(0, 60, 0, 60)
IconButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
IconButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
IconButton.BorderSizePixel = 2
IconButton.Text = "💀"
IconButton.TextSize = 35
IconButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IconButton.Font = Enum.Font.GothamBlack
IconButton.AutoButtonColor = true
IconButton.Draggable = true
IconButton.ZIndex = 10
IconButton.Visible = true
IconButton.Active = true
IconButton.Selectable = true

-- Menu Frame
local MenuFrame = Instance.new("Frame")
MenuFrame.Name = "MainMenu"
MenuFrame.Parent = ScreenGui
MenuFrame.Position = UDim2.new(0, 100, 0, 100)
MenuFrame.Size = UDim2.new(0, 550, 0, 500)
MenuFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.BorderSizePixel = 2
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Visible = false
MenuFrame.ZIndex = 5

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MenuFrame
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 6

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TitleBar
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.Size = UDim2.new(1, -20, 0, 30)
TitleLabel.Text = MenuConfig.Title
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 20
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 7

local SubtitleLabel = Instance.new("TextLabel")
SubtitleLabel.Parent = TitleBar
SubtitleLabel.Position = UDim2.new(0, 10, 0, 35)
SubtitleLabel.Size = UDim2.new(1, -20, 0, 20)
SubtitleLabel.Text = MenuConfig.SubTitle .. " | Owner: " .. MenuConfig.Owner
SubtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
SubtitleLabel.BackgroundTransparency = 1
SubtitleLabel.Font = Enum.Font.Code
SubtitleLabel.TextSize = 11
SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
SubtitleLabel.ZIndex = 7

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBlack
CloseButton.TextSize = 14
CloseButton.ZIndex = 8

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Parent = MenuFrame
TabBar.Position = UDim2.new(0, 0, 0, 60)
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabBar.BorderColor3 = Color3.fromRGB(40, 40, 50)
TabBar.BorderSizePixel = 1
TabBar.ZIndex = 6

-- Tab Content Container
local TabContentContainer = Instance.new("Frame")
TabContentContainer.Name = "TabContent"
TabContentContainer.Parent = MenuFrame
TabContentContainer.Position = UDim2.new(0, 0, 0, 100)
TabContentContainer.Size = UDim2.new(1, 0, 1, -100)
TabContentContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TabContentContainer.BorderSizePixel = 0
TabContentContainer.ZIndex = 6

-- ============================================
-- SECTION 5: TAB SYSTEM
-- ============================================

local Tabs = {}
local TabContents = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Parent = TabBar
    TabButton.Position = UDim2.new(0, #Tabs * 110 + 5, 0, 5)
    TabButton.Size = UDim2.new(0, 105, 0, 30)
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabButton.BorderColor3 = Color3.fromRGB(40, 40, 50)
    TabButton.BorderSizePixel = 1
    TabButton.Font = Enum.Font.Code
    TabButton.TextSize = 14
    TabButton.ZIndex = 7
    
    local Content = Instance.new("ScrollingFrame")
    Content.Name = name .. "Content"
    Content.Parent = TabContentContainer
    Content.Position = UDim2.new(0, 5, 0, 5)
    Content.Size = UDim2.new(1, -10, 1, -10)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 5
    Content.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
    Content.CanvasSize = UDim2.new(0, 0, 0, 800)
    Content.Visible = false
    Content.ZIndex = 7
    
    local Layout = Instance.new("UIListLayout")
    Layout.Parent = Content
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    
    table.insert(Tabs, TabButton)
    table.insert(TabContents, Content)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, btn in pairs(Tabs) do
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        
        for _, cont in pairs(TabContents) do
            cont.Visible = false
        end
        Content.Visible = true
    end)
    
    return Content
end

-- ============================================
-- SECTION 6: UI COMPONENTS
-- ============================================

local function CreateToggle(parent, text, callback, default)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    ToggleFrame.BackgroundTransparency = 1
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.Position = UDim2.new(0, 0, 0, 5)
    ToggleButton.Size = UDim2.new(0, 25, 0, 25)
    ToggleButton.Text = ""
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 110)
    ToggleButton.BorderColor3 = Color3.fromRGB(40, 40, 50)
    ToggleButton.BorderSizePixel = 1
    
    local Indicator = Instance.new("Frame")
    Indicator.Parent = ToggleButton
    Indicator.Position = default and UDim2.new(1, -22, 0, 3) or UDim2.new(0, 3, 0, 3)
    Indicator.Size = UDim2.new(0, 19, 0, 19)
    Indicator.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Indicator.BorderSizePixel = 0
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Position = UDim2.new(0, 32, 0, 5)
    Label.Size = UDim2.new(1, -40, 0, 25)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local IsOn = default or false
    
    local function UpdateVisual()
        if IsOn then
            Indicator.Position = UDim2.new(1, -22, 0, 3)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        else
            Indicator.Position = UDim2.new(0, 3, 0, 3)
            ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        IsOn = not IsOn
        UpdateVisual()
        if callback then
            callback(IsOn)
        end
    end)
    
    UpdateVisual()
    
    return {
        SetValue = function(value)
            IsOn = value
            UpdateVisual()
        end,
        GetValue = function()
            return IsOn
        end
    }
end

local function CreateSlider(parent, text, minValue, maxValue, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.Size = UDim2.new(1, -10, 0, 55)
    SliderFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Code
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderFrame
    SliderButton.Position = UDim2.new(0, 0, 0, 22)
    SliderButton.Size = UDim2.new(1, 0, 0, 15)
    SliderButton.Text = ""
    SliderButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    SliderButton.BorderColor3 = Color3.fromRGB(40, 40, 50)
    SliderButton.BorderSizePixel = 1
    SliderButton.AutoButtonColor = false
    
    local FillBar = Instance.new("Frame")
    FillBar.Parent = SliderButton
    FillBar.Size = UDim2.new((default - minValue) / (maxValue - minValue), 0, 1, 0)
    FillBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    FillBar.BorderSizePixel = 0
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.Position = UDim2.new(0, 0, 0, 38)
    ValueLabel.Size = UDim2.new(1, 0, 0, 15)
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local CurrentValue = default
    local IsDragging = false
    
    local function UpdateValue(inputX)
        local relativeX = (inputX - SliderButton.AbsolutePosition.X) / SliderButton.AbsoluteSize.X
        relativeX = Clamp(relativeX, 0, 1)
        CurrentValue = minValue + (maxValue - minValue) * relativeX
        FillBar.Size = UDim2.new(relativeX, 0, 1, 0)
        ValueLabel.Text = string.format("%.1f", CurrentValue)
        
        if callback then
            callback(CurrentValue)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        IsDragging = true
    end)
    
    SliderButton.MouseMoved:Connect(function(x)
        if IsDragging then
            UpdateValue(x)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = false
        end
    end)
    
    return {
        SetValue = function(value)
            CurrentValue = Clamp(value, minValue, maxValue)
            local relativeX = (CurrentValue - minValue) / (maxValue - minValue)
            FillBar.Size = UDim2.new(relativeX, 0, 1, 0)
            ValueLabel.Text = string.format("%.1f", CurrentValue)
        end,
        GetValue = function()
            return CurrentValue
        end
    }
end

-- ============================================
-- SECTION 7: CREATE TABS CONTENT
-- ============================================

-- ESP Tab
local ESPContent = CreateTab("ESP", "👁️")
local ESPTitle = Instance.new("TextLabel")
ESPTitle.Parent = ESPContent
ESPTitle.Size = UDim2.new(1, -10, 0, 25)
ESPTitle.Text = "👁️ ESP SETTINGS"
ESPTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Font = Enum.Font.GothamBlack
ESPTitle.TextSize = 16
ESPTitle.TextXAlignment = Enum.TextXAlignment.Left

local EspEnabled = CreateToggle(ESPContent, "Cho phép ESP", function(value)
    ESPConfig.Enabled = value
    if not value then
        ClearESP()
    end
end, false)

local EspLine = CreateToggle(ESPContent, "ESP Line", function(value)
    ESPConfig.Line = value
end, false)

local EspBox = CreateToggle(ESPContent, "ESP Box", function(value)
    ESPConfig.Box = value
end, false)

local EspDistance = CreateToggle(ESPContent, "ESP Khoảng cách", function(value)
    ESPConfig.Distance = value
end, false)

local EspName = CreateToggle(ESPContent, "ESP Tên", function(value)
    ESPConfig.Name = value
end, false)

local EspHealth = CreateToggle(ESPContent, "ESP Máu", function(value)
    ESPConfig.Health = value
end, false)

local EspSkeleton = CreateToggle(ESPContent, "ESP Skeleton", function(value)
    ESPConfig.Skeleton = value
end, false)

local EspFOV = CreateSlider(ESPContent, "FOV", 50, 500, ESPConfig.FOV, function(value)
    ESPConfig.FOV = value
end)

-- Aim Tab
local AimContent = CreateTab("AIM", "🎯")
local AimTitle = Instance.new("TextLabel")
AimTitle.Parent = AimContent
AimTitle.Size = UDim2.new(1, -10, 0, 25)
AimTitle.Text = "🎯 AIM SETTINGS"
AimTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
AimTitle.BackgroundTransparency = 1
AimTitle.Font = Enum.Font.GothamBlack
AimTitle.TextSize = 16
AimTitle.TextXAlignment = Enum.TextXAlignment.Left

local AimHead = CreateToggle(AimContent, "Aim đầu", function(value)
    AimConfig.Head = value
    if value then
        AimConfig.Body = false
    end
end, false)

local AimLevel = CreateSlider(AimContent, "Mức độ aim", 0, 100, AimConfig.AimLevel, function(value)
    AimConfig.AimLevel = value
    AimConfig.Smoothness = Clamp(1 - (value / 100), 0.01, 1)
end)

local AimBody = CreateToggle(AimContent, "Aim body", function(value)
    AimConfig.Body = value
    if value then
        AimConfig.Head = false
    end
end, false)

local AimFire = CreateToggle(AimContent, "Aim fire", function(value)
    AimConfig.Fire = value
end, false)

local AimSilent = CreateToggle(AimContent, "Aim silent", function(value)
    AimConfig.Silent = value
end, false)

-- Memory Tab
local MemoryContent = CreateTab("MEMORY", "💾")
local MemoryTitle = Instance.new("TextLabel")
MemoryTitle.Parent = MemoryContent
MemoryTitle.Size = UDim2.new(1, -10, 0, 25)
MemoryTitle.Text = "💾 MEMORY SETTINGS"
MemoryTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
MemoryTitle.BackgroundTransparency = 1
MemoryTitle.Font = Enum.Font.GothamBlack
MemoryTitle.TextSize = 16
MemoryTitle.TextXAlignment = Enum.TextXAlignment.Left

local InvisibleToggle = CreateToggle(MemoryContent, "Tàng hình", function(value)
    MemoryConfig.Invisible = value
    if value then
        MakeInvisible()
    else
        MakeVisible()
    end
end, false)

local SpeedSlider = CreateSlider(MemoryContent, "Speed", 16, 200, MemoryConfig.Speed, function(value)
    MemoryConfig.Speed = value
    SetSpeed(value)
end)

local NoReloadToggle = CreateToggle(MemoryContent, "No reload", function(value)
    MemoryConfig.NoReload = value
end, false)

local TeleportKillToggle = CreateToggle(MemoryContent, "Teleport kill", function(value)
    MemoryConfig.TeleportKill = value
    if value then
        TeleportKill()
    end
end, false)

local NoClipToggle = CreateToggle(MemoryContent, "Đi xuyên tường", function(value)
    MemoryConfig.NoClip = value
    EnableNoClip(value)
end, false)

local FireRateSlider = CreateSlider(MemoryContent, "Bắn siêu nhanh (RPM)", 100, 6000, MemoryConfig.FireRate, function(value)
    MemoryConfig.FireRate = value
end)

local SpinToggle = CreateToggle(MemoryContent, "Người xoay vòng tròn siêu nhanh", function(value)
    MemoryConfig.Spinning = value
    SpinPlayer(value)
end, false)

-- Admin Tab
local AdminContent = CreateTab("ADMIN", "👑")
local AdminTitle = Instance.new("TextLabel")
AdminTitle.Parent = AdminContent
AdminTitle.Size = UDim2.new(1, -10, 0, 25)
AdminTitle.Text = "👑 ADMIN SETTINGS"
AdminTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
AdminTitle.BackgroundTransparency = 1
AdminTitle.Font = Enum.Font.GothamBlack
AdminTitle.TextSize = 16
AdminTitle.TextXAlignment = Enum.TextXAlignment.Left

local LionelFrame = Instance.new("Frame")
LionelFrame.Parent = AdminContent
LionelFrame.Size = UDim2.new(1, -10, 0, 60)
LionelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
LionelFrame.BorderColor3 = Color3.fromRGB(40, 40, 50)
LionelFrame.BorderSizePixel = 1

local LionelLabel = Instance.new("TextLabel")
LionelLabel.Parent = LionelFrame
LionelLabel.Position = UDim2.new(0, 5, 0, 5)
LionelLabel.Size = UDim2.new(1, -10, 0, 50)
LionelLabel.Text = AdminConfig.LionelTienManh.Text
LionelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LionelLabel.BackgroundTransparency = 1
LionelLabel.Font = Enum.Font.GothamBlack
LionelLabel.TextSize = AdminConfig.LionelTienManh.Size
LionelLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Rainbow animation
coroutine.wrap(function()
    while true do
        wait(AdminConfig.LionelTienManh.RainbowSpeed)
        AdminConfig.LionelTienManh.CurrentHue = AdminConfig.LionelTienManh.CurrentHue + 5
        if AdminConfig.LionelTienManh.CurrentHue > 360 then
            AdminConfig.LionelTienManh.CurrentHue = 0
        end
        local rainbowColor = Color3.fromHSV(AdminConfig.LionelTienManh.CurrentHue / 360, 1, 1)
        LionelLabel.TextColor3 = rainbowColor
        
        if math.random() > 0.85 then
            LionelLabel.Visible = false
        else
            LionelLabel.Visible = true
        end
    end
end)()

-- ============================================
-- SECTION 8: ESP FUNCTIONS
-- ============================================

function ClearESP()
    for _, drawing in pairs(ESPConfig.ESPObjects) do
        RemoveDrawing(drawing)
    end
    ESPConfig.ESPObjects = {}
    
    for _, text in pairs(ESPConfig.TextCache) do
        RemoveDrawing(text)
    end
    ESPConfig.TextCache = {}
    
    for _, healthBar in pairs(ESPConfig.HealthBars) do
        RemoveDrawing(healthBar)
    end
    ESPConfig.HealthBars = {}
    
    for _, part in pairs(ESPConfig.SkeletonParts) do
        RemoveDrawing(part)
    end
    ESPConfig.SkeletonParts = {}
end

local function UpdateESP()
    while true do
        wait(0.1)
        
        if ESPConfig.Enabled then
            ClearESP()
            
            for _, player in pairs(GetPlayers()) do
                local character = player.Character
                local rootPart = GetRootPart(character)
                local head = character and character:FindFirstChild("Head")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                
                if rootPart and head and humanoid then
                    local distance = GetDistance(Camera.CFrame.Position, rootPart.Position)
                    
                    if distance <= ESPConfig.FOV then
                        local headPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                        
                        if onScreen then
                            -- ESP Box
                            if ESPConfig.Box then
                                local boxSize = Vector2.new(50, 100)
                                local boxPos = Vector2.new(headPos.X - boxSize.X / 2, headPos.Y - boxSize.Y / 2)
                                
                                local boxDrawing = CreateDrawing("Square", {
                                    Position = boxPos,
                                    Size = boxSize,
                                    Color = ESPConfig.BoxColor,
                                    Thickness = 2,
                                    Filled = false,
                                    Visible = true
                                })
                                table.insert(ESPConfig.ESPObjects, boxDrawing)
                            end
                            
                            -- ESP Line
                            if ESPConfig.Line then
                                local lineDrawing = CreateDrawing("Line", {
                                    From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y),
                                    To = Vector2.new(headPos.X, headPos.Y),
                                    Color = ESPConfig.LineColor,
                                    Thickness = 1,
                                    Visible = true
                                })
                                table.insert(ESPConfig.ESPObjects, lineDrawing)
                            end
                            
                            -- ESP Distance
                            if ESPConfig.Distance then
                                local distanceText = CreateDrawing("Text", {
                                    Text = string.format("%.1fm", distance),
                                    Position = Vector2.new(headPos.X, headPos.Y - 20),
                                    Color = ESPConfig.DistanceColor,
                                    Font = 3,
                                    Size = ESPConfig.TextSize,
                                    Center = true,
                                    Outline = true,
                                    Visible = true
                                })
                                table.insert(ESPConfig.TextCache, distanceText)
                            end
                            
                            -- ESP Name
                            if ESPConfig.Name then
                                local nameText = CreateDrawing("Text", {
                                    Text = player.Name,
                                    Position = Vector2.new(headPos.X, headPos.Y - 40),
                                    Color = ESPConfig.NameColor,
                                    Font = 3,
                                    Size = ESPConfig.TextSize,
                                    Center = true,
                                    Outline = true,
                                    Visible = true
                                })
                                table.insert(ESPConfig.TextCache, nameText)
                            end
                            
                            -- ESP Health
                            if ESPConfig.Health then
                                local healthPercent = humanoid.Health / humanoid.MaxHealth
                                local healthBarWidth = 50
                                local healthBarHeight = 5
                                local healthBarX = headPos.X - healthBarWidth / 2
                                local healthBarY = headPos.Y - 110
                                
                                local healthBg = CreateDrawing("Square", {
                                    Position = Vector2.new(healthBarX, healthBarY),
                                    Size = Vector2.new(healthBarWidth, healthBarHeight),
                                    Color = Color3.new(0, 0, 0),
                                    Thickness = 1,
                                    Filled = true,
                                    Visible = true
                                })
                                table.insert(ESPConfig.HealthBars, healthBg)
                                
                                local healthFill = CreateDrawing("Square", {
                                    Position = Vector2.new(healthBarX, healthBarY),
                                    Size = Vector2.new(healthBarWidth * healthPercent, healthBarHeight),
                                    Color = healthPercent > 0.5 and ESPConfig.HealthColor or Color3.new(1, 0, 0),
                                    Thickness = 1,
                                    Filled = true,
                                    Visible = true
                                })
                                table.insert(ESPConfig.HealthBars, healthFill)
                            end
                            
                            -- ESP Skeleton
                            if ESPConfig.Skeleton then
                                local bodyParts = {
                                    "Head", "UpperTorso", "LowerTorso",
                                    "LeftUpperArm", "LeftLowerArm", "LeftHand",
                                    "RightUpperArm", "RightLowerArm", "RightHand",
                                    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
                                    "RightUpperLeg", "RightLowerLeg", "RightFoot"
                                }
                                
                                local partPositions = {}
                                for _, partName in pairs(bodyParts) do
                                    local part = character:FindFirstChild(partName)
                                    if part then
                                        local partScreenPos, partOnScreen = Camera:WorldToScreenPoint(part.Position)
                                        if partOnScreen then
                                            partPositions[partName] = partScreenPos
                                        end
                                    end
                                end
                                
                                local connections = {
                                    {"Head", "UpperTorso"},
                                    {"UpperTorso", "LowerTorso"},
                                    {"UpperTorso", "LeftUpperArm"},
                                    {"LeftUpperArm", "LeftLowerArm"},
                                    {"LeftLowerArm", "LeftHand"},
                                    {"UpperTorso", "RightUpperArm"},
                                    {"RightUpperArm", "RightLowerArm"},
                                    {"RightLowerArm", "RightHand"},
                                    {"LowerTorso", "LeftUpperLeg"},
                                    {"LeftUpperLeg", "LeftLowerLeg"},
                                    {"LeftLowerLeg", "LeftFoot"},
                                    {"LowerTorso", "RightUpperLeg"},
                                    {"RightUpperLeg", "RightLowerLeg"},
                                    {"RightLowerLeg", "RightFoot"}
                                }
                                
                                for _, connection in pairs(connections) do
                                    local startPart = partPositions[connection[1]]
                                    local endPart = partPositions[connection[2]]
                                    
                                    if startPart and endPart then
                                        local skeletonLine = CreateDrawing("Line", {
                                            From = Vector2.new(startPart.X, startPart.Y),
                                            To = Vector2.new(endPart.X, endPart.Y),
                                            Color = ESPConfig.SkeletonColor,
                                            Thickness = 2,
                                            Visible = true
                                        })
                                        table.insert(ESPConfig.SkeletonParts, skeletonLine)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            wait(0.5)
        end
    end
end

-- ============================================
-- SECTION 9: AIM FUNCTIONS
-- ============================================

local function FindBestTarget()
    local bestTarget = nil
    local bestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(GetPlayers()) do
        local character = player.Character
        local targetPart = nil
        
        if AimConfig.Head and character then
            targetPart = character:FindFirstChild("Head")
        elseif AimConfig.Body and character then
            targetPart = character:FindFirstChild("HumanoidRootPart")
        elseif character then
            targetPart = character:FindFirstChild("Head")
        end
        
        if targetPart then
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            
            if onScreen then
                local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                local worldDistance = GetDistance(Camera.CFrame.Position, targetPart.Position)
                
                if screenDistance <= AimConfig.FOV and worldDistance <= AimConfig.MaxDistance then
                    if screenDistance < bestDistance then
                        bestDistance = screenDistance
                        bestTarget = targetPart
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function ApplyAim()
    local target = FindBestTarget()
    
    if target then
        local targetPosition = target.Position
        local cameraCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(cameraCFrame.Position, targetPosition)
        
        if AimConfig.Smoothness < 1 then
            cameraCFrame = cameraCFrame:Lerp(targetCFrame, 1 - AimConfig.Smoothness)
        else
            cameraCFrame = targetCFrame
        end
        
        Camera.CFrame = cameraCFrame
    end
end

local function UpdateAim()
    while true do
        wait(0.01)
        
        if AimConfig.Fire then
            if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                ApplyAim()
            end
        elseif AimConfig.Head or AimConfig.Body then
            ApplyAim()
        end
    end
end

-- ============================================
-- SECTION 10: MEMORY FUNCTIONS
-- ============================================

function MakeInvisible()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end

function MakeVisible()
    local character = LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

function SetSpeed(speed)
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

function EnableNoClip(enabled)
    MemoryConfig.NoClip = enabled
    
    if enabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    MemoryConfig.NoClipState[part] = part.CanCollide
                    part.CanCollide = false
                end
            end
        end
    else
        local character = LocalPlayer.Character
        if character then
            for part, canCollide in pairs(MemoryConfig.NoClipState) do
                if part and part.Parent then
                    part.CanCollide = canCollide
                end
            end
            MemoryConfig.NoClipState = {}
        end
    end
end

function TeleportKill()
    local nearestPlayer = nil
    local nearestDistance = MemoryConfig.TeleportRange
    
    for _, player in pairs(GetPlayers()) do
        local character = player.Character
        local rootPart = GetRootPart(character)
        
        if rootPart and LocalPlayer.Character then
            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if localRoot then
                local distance = GetDistance(localRoot.Position, rootPart.Position)
                if distance < nearestDistance then
                    nearestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    
    if nearestPlayer and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            MemoryConfig.BackupPosition = rootPart.CFrame
            
            local targetCharacter = nearestPlayer.Character
            local targetRootPart = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetRootPart then
                rootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 3, 2)
                
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
                
                wait(0.5)
                if MemoryConfig.BackupPosition then
                    rootPart.CFrame = MemoryConfig.BackupPosition
                end
            end
        end
    end
end

function SpinPlayer(enabled)
    MemoryConfig.Spinning = enabled
end

local function UpdateSpin()
    while true do
        wait(0.01)
        
        if MemoryConfig.Spinning and LocalPlayer.Character then
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local rotation = CFrame.Angles(0, math.rad(MemoryConfig.SpinSpeed / 60), 0)
                rootPart.CFrame = rootPart.CFrame * rotation
            end
        end
    end
end

local function UpdateNoReload()
    while true do
        wait(0.1)
        
        if MemoryConfig.NoReload then
            local character = LocalPlayer.Character
            if character then
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") then
                        ammo.Value = 999999
                    end
                end
            end
        end
    end
end

local function UpdateFireRate()
    while true do
        wait(0.01)
        
        local character = LocalPlayer.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local config = tool:FindFirstChild("Configuration")
                if config then
                    local fireRate = config:FindFirstChild("FireRate")
                    if fireRate then
                        fireRate.Value = MemoryConfig.FireRate
                    end
                end
            end
        end
    end
end

-- ============================================
-- SECTION 11: ICON & MENU INTERACTIONS
-- ============================================

IconButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

-- ============================================
-- SECTION 12: START ALL SYSTEMS
-- ============================================

coroutine.wrap(UpdateESP)()
coroutine.wrap(UpdateAim)()
coroutine.wrap(UpdateSpin)()
coroutine.wrap(UpdateNoReload)()
coroutine.wrap(UpdateFireRate)()

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    SetSpeed(MemoryConfig.Speed)
    
    if MemoryConfig.Invisible then
        MakeInvisible()
    end
    
    if MemoryConfig.NoClip then
        EnableNoClip(true)
    end
end)

-- Show first tab by default
if Tabs[1] then
    Tabs[1].BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    TabContents[1].Visible = true
end

print("💀 DEVILS WILL RISE — SUBSCRIBER EDITION đã được khởi tạo!")
print("👑 Owner: " .. MenuConfig.Owner)
print("📢 Channel: " .. MenuConfig.Channel)
print("✨ Created by: " .. MenuConfig.Creator)
print("💀 Icon menu: Bấm vào icon 💀 để mở menu")
