--[[
    💀 DEVILS WILL RISE — SUBSCRIBER EDITION 💀
    Owner: @dongkaa
    Channel: @dongkaa
    Created by: Người Đẹp Trai (Subscriber)
    Version: 1.0.0
    Status: Unlimited — No Refusal
--]]

-- ============================================
-- SECTION 1: INITIALIZATION & SERVICES
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Teams = game:GetService("Teams")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TextChatService = game:GetService("TextChatService")
local MarketplaceService = game:GetService("MarketplaceService")
local PhysicsService = game:GetService("PhysicsService")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local Stats = game:GetService("Stats")
local GroupService = game:GetService("GroupService")
local Chat = game:GetService("Chat")
local InsertService = game:GetService("InsertService")
local ScriptContext = game:GetService("ScriptContext")
local PolicyService = game:GetService("PolicyService")
local AnalyticsService = game:GetService("AnalyticsService")
local AssetService = game:GetService("AssetService")
local BadgeService = game:GetService("BadgeService")
local AvatarEditorService = game:GetService("AvatarEditorService")
local LocalizationService = game:GetService("LocalizationService")
local PathfindingService = game:GetService("PathfindingService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TeleportService = game:GetService("TeleportService")
local TweenService2 = game:GetService("TweenService")
local VRService = game:GetService("VRService")
local StudioService = game:GetService("StudioService")
local DebuggerManager = game:GetService("DebuggerManager")
local GeometryService = game:GetService("GeometryService")
local GamepadService = game:GetService("GamepadService")
local ContextActionService = game:GetService("ContextActionService")
local HapticService = game:GetService("HapticService")
local VoiceChatService = game:GetService("VoiceChatService")
local FriendService = game:GetService("FriendService")
local SocialService = game:GetService("SocialService")
local ContentProvider = game:GetService("ContentProvider")

-- ============================================
-- SECTION 2: VARIABLES & CONFIGURATION
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
    BoxType = "2D", -- "2D", "3D", "Corner"
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
    AimLevel = 50, -- 0 = loose, 100 = tight
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
    FireRate = 600, -- RPM
    SpinSpeed = 500, -- Degrees per second
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
        RainbowSpeed = 0.5,
        Text = "LIONEL TIẾN MẠNH",
        Size = 24,
        BlinkSpeed = 0.3,
        CurrentHue = 0
    }
}

local UIConfig = {
    MenuOpen = true,
    DragEnabled = false,
    DragOffset = Vector2.new(0, 0),
    MenuSize = UDim2.new(0, 500, 0, 450),
    MenuPosition = UDim2.new(0, 100, 0, 100),
    IconSize = UDim2.new(0, 80, 0, 80),
    IconPosition = UDim2.new(0, 10, 0, 10),
    TabSize = UDim2.new(0, 100, 0, 35),
    TabSpacing = 5,
    AnimationSpeed = 0.3,
    SectionSpacing = 10,
    ElementHeight = 30,
    ElementSpacing = 5
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

local function DeepCopy(original)
    if type(original) ~= "table" then
        return original
    end
    
    local copy = {}
    for key, value in pairs(original) do
        copy[DeepCopy(key)] = DeepCopy(value)
    end
    return copy
end

local function Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function Round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
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

local function GetCharacter(player)
    return player and player.Character or nil
end

local function GetHumanoid(character)
    if character then
        return character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function GetRootPart(character)
    if character then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("Head")
    end
    return nil
end

local function GetHead(character)
    if character then
        return character:FindFirstChild("Head")
    end
    return nil
end

local function IsVisible(part)
    if not part then return false end
    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin).Unit * 1000
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character or {}}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart:IsDescendantOf(part.Parent or workspace) then
            return true
        end
        return false
    end
    return true
end

local function IsInTeam(player)
    if Teams and player and LocalPlayer then
        return player.Team == LocalPlayer.Team
    end
    return false
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

local function CreateTextLabel(parent, text, position, size, color, font, textSize, transparency)
    local label = CreateInstance("TextLabel", {
        Parent = parent,
        Text = text or "",
        Position = position or UDim2.new(0, 0, 0, 0),
        Size = size or UDim2.new(1, 0, 0, 20),
        TextColor3 = color or MenuConfig.TextColor,
        BackgroundTransparency = transparency or 1,
        Font = font or Enum.Font.Code,
        TextSize = textSize or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextScaled = false,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    return label
end

local function CreateButton(parent, text, position, size, callback)
    local button = CreateInstance("TextButton", {
        Parent = parent,
        Text = text or "",
        Position = position or UDim2.new(0, 0, 0, 0),
        Size = size or UDim2.new(1, -10, 0, 30),
        BackgroundColor3 = MenuConfig.SectionColor,
        TextColor3 = MenuConfig.TextColor,
        Font = Enum.Font.Code,
        TextSize = 14,
        AutoButtonColor = true,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 1
    })
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = MenuConfig.AccentColor
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = MenuConfig.SectionColor
        }):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function CreateToggle(parent, text, position, callback, defaultValue)
    local toggleFrame = CreateInstance("Frame", {
        Parent = parent,
        Position = position or UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -10, 0, 30),
        BackgroundTransparency = 1
    })
    
    local toggleButton = CreateInstance("TextButton", {
        Parent = toggleFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 25, 0, 25),
        Text = "",
        BackgroundColor3 = defaultValue and MenuConfig.ToggleOnColor or MenuConfig.ToggleOffColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 1
    })
    
    local indicator = CreateInstance("Frame", {
        Parent = toggleButton,
        Position = UDim2.new(0, 3, 0, 3),
        Size = UDim2.new(0, 19, 0, 19),
        BackgroundColor3 = MenuConfig.BackgroundColor,
        BorderSizePixel = 0
    })
    
    local label = CreateInstance("TextLabel", {
        Parent = toggleFrame,
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(1, -35, 0, 25),
        Text = text or "",
        TextColor3 = MenuConfig.TextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local isOn = defaultValue or false
    
    local function updateVisual()
        indicator.Position = isOn and UDim2.new(1, -22, 0, 3) or UDim2.new(0, 3, 0, 3)
        toggleButton.BackgroundColor3 = isOn and MenuConfig.ToggleOnColor or MenuConfig.ToggleOffColor
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateVisual()
        if callback then
            callback(isOn)
        end
    end)
    
    updateVisual()
    return {
        Frame = toggleFrame,
        SetValue = function(value)
            isOn = value
            updateVisual()
        end,
        GetValue = function()
            return isOn
        end
    }
end

local function CreateSlider(parent, text, position, minValue, maxValue, defaultValue, callback)
    local sliderFrame = CreateInstance("Frame", {
        Parent = parent,
        Position = position or UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(1, -10, 0, 50),
        BackgroundTransparency = 1
    })
    
    local label = CreateInstance("TextLabel", {
        Parent = sliderFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 20),
        Text = text or "",
        TextColor3 = MenuConfig.TextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local sliderButton = CreateInstance("TextButton", {
        Parent = sliderFrame,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(1, 0, 0, 15),
        Text = "",
        BackgroundColor3 = MenuConfig.SectionColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 1,
        AutoButtonColor = false
    })
    
    local fillBar = CreateInstance("Frame", {
        Parent = sliderButton,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = MenuConfig.SliderFillColor,
        BorderSizePixel = 0
    })
    
    local dragHandle = CreateInstance("Frame", {
        Parent = sliderButton,
        Position = UDim2.new(0, 0, 0, -2),
        Size = UDim2.new(0, 10, 0, 19),
        BackgroundColor3 = MenuConfig.TextColor,
        BorderSizePixel = 1,
        BorderColor3 = MenuConfig.BorderColor
    })
    
    local valueLabel = CreateInstance("TextLabel", {
        Parent = sliderFrame,
        Position = UDim2.new(0, 0, 0, 42),
        Size = UDim2.new(1, 0, 0, 15),
        Text = tostring(defaultValue),
        TextColor3 = MenuConfig.SubtleTextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local currentValue = defaultValue or minValue
    local isDragging = false
    
    local function updateValue(input)
        local relativeX = (input.Position.X - sliderButton.AbsolutePosition.X) / sliderButton.AbsoluteSize.X
        relativeX = Clamp(relativeX, 0, 1)
        currentValue = minValue + (maxValue - minValue) * relativeX
        fillBar.Size = UDim2.new(relativeX, 0, 1, 0)
        dragHandle.Position = UDim2.new(relativeX, -5, 0, -2)
        valueLabel.Text = string.format("%.1f", currentValue)
        
        if callback then
            callback(currentValue)
        end
    end
    
    local function startDrag()
        isDragging = true
    end
    
    local function stopDrag()
        isDragging = false
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    sliderButton.MouseButton1Up:Connect(stopDrag)
    
    sliderButton.MouseMoved:Connect(function(x, y)
        if isDragging then
            local relativeX = (x - sliderButton.AbsolutePosition.X) / sliderButton.AbsoluteSize.X
            relativeX = Clamp(relativeX, 0, 1)
            currentValue = minValue + (maxValue - minValue) * relativeX
            fillBar.Size = UDim2.new(relativeX, 0, 1, 0)
            dragHandle.Position = UDim2.new(relativeX, -5, 0, -2)
            valueLabel.Text = string.format("%.1f", currentValue)
            
            if callback then
                callback(currentValue)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            stopDrag()
        end
    end)
    
    -- Initialize
    local initRelativeX = (currentValue - minValue) / (maxValue - minValue)
    fillBar.Size = UDim2.new(initRelativeX, 0, 1, 0)
    dragHandle.Position = UDim2.new(initRelativeX, -5, 0, -2)
    valueLabel.Text = string.format("%.1f", currentValue)
    
    return {
        Frame = sliderFrame,
        SetValue = function(value)
            currentValue = Clamp(value, minValue, maxValue)
            local relativeX = (currentValue - minValue) / (maxValue - minValue)
            fillBar.Size = UDim2.new(relativeX, 0, 1, 0)
            dragHandle.Position = UDim2.new(relativeX, -5, 0, -2)
            valueLabel.Text = string.format("%.1f", currentValue)
        end,
        GetValue = function()
            return currentValue
        end
    }
end

-- ============================================
-- SECTION 4: MENU CREATION
-- ============================================

local function CreateMenu()
    -- Main Menu Frame
    local menuFrame = CreateInstance("Frame", {
        Parent = CoreGui,
        Position = UIConfig.MenuPosition,
        Size = UIConfig.MenuSize,
        BackgroundColor3 = MenuConfig.BackgroundColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 2,
        Active = true,
        Draggable = true,
        Visible = true,
        ZIndex = 999
    })
    
    -- Menu Title Bar
    local titleBar = CreateInstance("Frame", {
        Parent = menuFrame,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = MenuConfig.AccentColor,
        BorderSizePixel = 0,
        ZIndex = 1000
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Parent = titleBar,
        Position = UDim2.new(0, 10, 0, 5),
        Size = UDim2.new(1, -20, 0, 25),
        Text = MenuConfig.Title,
        TextColor3 = MenuConfig.TextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001
    })
    
    local subtitleLabel = CreateInstance("TextLabel", {
        Parent = titleBar,
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 15),
        Text = MenuConfig.SubTitle .. " | Owner: " .. MenuConfig.Owner,
        TextColor3 = MenuConfig.SubtleTextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.Code,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001
    })
    
    -- Tab Bar
    local tabBar = CreateInstance("Frame", {
        Parent = menuFrame,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = MenuConfig.SectionColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 1,
        ZIndex = 1000
    })
    
    local tabs = {}
    local tabButtons = {}
    local tabContents = {}
    local currentTab = nil
    
    local function createTab(name, icon)
        local tabButton = CreateInstance("TextButton", {
            Parent = tabBar,
            Position = UDim2.new(0, #tabs * 105 + 5, 0, 5),
            Size = UDim2.new(0, 100, 0, 30),
            Text = icon .. " " .. name,
            TextColor3 = MenuConfig.TextColor,
            BackgroundColor3 = MenuConfig.SectionColor,
            BorderColor3 = MenuConfig.BorderColor,
            BorderSizePixel = 1,
            Font = Enum.Font.Code,
            TextSize = 14,
            ZIndex = 1001
        })
        
        local content = CreateInstance("ScrollingFrame", {
            Parent = menuFrame,
            Position = UDim2.new(0, 5, 0, 95),
            Size = UDim2.new(1, -10, 1, -100),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = MenuConfig.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 1000),
            Visible = false,
            ZIndex = 999
        })
        
        local layout = CreateInstance("UIListLayout", {
            Parent = content,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })
        
        table.insert(tabs, name)
        table.insert(tabButtons, tabButton)
        table.insert(tabContents, content)
        
        tabButton.MouseButton1Click:Connect(function()
            for i, btn in pairs(tabButtons) do
                btn.BackgroundColor3 = MenuConfig.SectionColor
            end
            tabButton.BackgroundColor3 = MenuConfig.AccentColor
            
            for i, cont in pairs(tabContents) do
                cont.Visible = false
            end
            content.Visible = true
            currentTab = #tabs
        end)
        
        return content
    end
    
    -- Create Tabs
    local espContent = createTab("ESP", "👁️")
    local aimContent = createTab("AIM", "🎯")
    local memoryContent = createTab("MEMORY", "💾")
    local adminContent = createTab("ADMIN", "👑")
    
    -- Icon Button (Movable)
    local iconButton = CreateInstance("ImageButton", {
        Parent = CoreGui,
        Position = UIConfig.IconPosition,
        Size = UIConfig.IconSize,
        BackgroundColor3 = MenuConfig.AccentColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 2,
        Image = "rbxassetid://0",
        ZIndex = 999,
        Draggable = true,
        Visible = true
    })
    
    local iconLabel = CreateInstance("TextLabel", {
        Parent = iconButton,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        Text = "💀",
        TextColor3 = MenuConfig.TextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = 40,
        ZIndex = 1000
    })
    
    iconButton.MouseButton1Click:Connect(function()
        UIConfig.MenuOpen = not UIConfig.MenuOpen
        menuFrame.Visible = UIConfig.MenuOpen
    end)
    
    -- Initialize first tab
    if tabButtons[1] then
        tabButtons[1].BackgroundColor3 = MenuConfig.AccentColor
        tabContents[1].Visible = true
        currentTab = 1
    end
    
    return {
        MenuFrame = menuFrame,
        ESPContent = espContent,
        AimContent = aimContent,
        MemoryContent = memoryContent,
        AdminContent = adminContent,
        IconButton = iconButton
    }
end

-- ============================================
-- SECTION 5: ESP SYSTEM
-- ============================================

local function CreateESPSystem(parent)
    local espFrame = CreateInstance("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 300),
        BackgroundTransparency = 1,
        LayoutOrder = 1
    })
    
    local layout = CreateInstance("UIListLayout", {
        Parent = espFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Title
    local title = CreateTextLabel(espFrame, "👁️ ESP SETTINGS", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.AccentColor, Enum.Font.GothamBlack, 16)
    
    -- Toggles
    local espEnabled = CreateToggle(espFrame, "Cho phép ESP", nil, function(value)
        ESPConfig.Enabled = value
        if not value then
            ClearESP()
        end
    end, false)
    espEnabled.Frame.LayoutOrder = 1
    
    local espLine = CreateToggle(espFrame, "ESP Line", nil, function(value)
        ESPConfig.Line = value
    end, false)
    espLine.Frame.LayoutOrder = 2
    
    local espBox = CreateToggle(espFrame, "ESP Box", nil, function(value)
        ESPConfig.Box = value
    end, false)
    espBox.Frame.LayoutOrder = 3
    
    local espDistance = CreateToggle(espFrame, "ESP Khoảng cách", nil, function(value)
        ESPConfig.Distance = value
    end, false)
    espDistance.Frame.LayoutOrder = 4
    
    local espName = CreateToggle(espFrame, "ESP Tên", nil, function(value)
        ESPConfig.Name = value
    end, false)
    espName.Frame.LayoutOrder = 5
    
    local espHealth = CreateToggle(espFrame, "ESP Máu", nil, function(value)
        ESPConfig.Health = value
    end, false)
    espHealth.Frame.LayoutOrder = 6
    
    local espSkeleton = CreateToggle(espFrame, "ESP Skeleton", nil, function(value)
        ESPConfig.Skeleton = value
        if not value then
            ClearSkeletons()
        end
    end, false)
    espSkeleton.Frame.LayoutOrder = 7
    
    local espFOV = CreateSlider(espFrame, "FOV", nil, 50, 500, ESPConfig.FOV, function(value)
        ESPConfig.FOV = value
    end)
    espFOV.Frame.LayoutOrder = 8
    
    return {
        EspEnabled = espEnabled,
        EspLine = espLine,
        EspBox = espBox,
        EspDistance = espDistance,
        EspName = espName,
        EspHealth = espHealth,
        EspSkeleton = espSkeleton,
        EspFOV = espFOV
    }
end

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
end

function ClearSkeletons()
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
                local character = GetCharacter(player)
                local rootPart = GetRootPart(character)
                local head = GetHead(character)
                local humanoid = GetHumanoid(character)
                
                if rootPart and head and humanoid then
                    local distance = GetDistance(Camera.CFrame.Position, rootPart.Position)
                    
                    if distance <= ESPConfig.FOV then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
                        local headPos, headOnScreen = Camera:WorldToScreenPoint(head.Position)
                        
                        if onScreen or headOnScreen then
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
-- SECTION 6: AIM SYSTEM
-- ============================================

local function CreateAimSystem(parent)
    local aimFrame = CreateInstance("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 250),
        BackgroundTransparency = 1,
        LayoutOrder = 2
    })
    
    local layout = CreateInstance("UIListLayout", {
        Parent = aimFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local title = CreateTextLabel(aimFrame, "🎯 AIM SETTINGS", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.AccentColor, Enum.Font.GothamBlack, 16)
    
    local aimHead = CreateToggle(aimFrame, "Aim đầu", nil, function(value)
        AimConfig.Head = value
        if value then
            AimConfig.Body = false
        end
    end, false)
    aimHead.Frame.LayoutOrder = 1
    
    local aimLevel = CreateSlider(aimFrame, "Mức độ aim", nil, 0, 100, AimConfig.AimLevel, function(value)
        AimConfig.AimLevel = value
        AimConfig.Smoothness = 1 - (value / 100)
        AimConfig.Smoothness = Clamp(AimConfig.Smoothness, 0.01, 1)
    end)
    aimLevel.Frame.LayoutOrder = 2
    
    local aimBody = CreateToggle(aimFrame, "Aim body", nil, function(value)
        AimConfig.Body = value
        if value then
            AimConfig.Head = false
        end
    end, false)
    aimBody.Frame.LayoutOrder = 3
    
    local aimFire = CreateToggle(aimFrame, "Aim fire", nil, function(value)
        AimConfig.Fire = value
    end, false)
    aimFire.Frame.LayoutOrder = 4
    
    local aimSilent = CreateToggle(aimFrame, "Aim silent", nil, function(value)
        AimConfig.Silent = value
    end, false)
    aimSilent.Frame.LayoutOrder = 5
    
    return {
        AimHead = aimHead,
        AimLevel = aimLevel,
        AimBody = aimBody,
        AimFire = aimFire,
        AimSilent = aimSilent
    }
end

local function FindBestTarget()
    local bestTarget = nil
    local bestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(GetPlayers()) do
        if not AimConfig.TeamCheck or not IsInTeam(player) then
            local character = GetCharacter(player)
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
                        if not AimConfig.VisibleCheck or IsVisible(targetPart) then
                            if screenDistance < bestDistance then
                                bestDistance = screenDistance
                                bestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function ApplyAim()
    if not (AimConfig.Head or AimConfig.Body or AimConfig.Fire) then
        return
    end
    
    local target = FindBestTarget()
    
    if target then
        local targetPosition = target.Position
        
        if AimConfig.Prediction > 0 and target.Parent then
            local rootPart = target.Parent:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local velocity = rootPart.Velocity or Vector3.new(0, 0, 0)
                targetPosition = targetPosition + velocity * AimConfig.Prediction
            end
        end
        
        local cameraCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(cameraCFrame.Position, targetPosition)
        
        if AimConfig.Silent then
            -- Silent aim (doesn't move camera)
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.CameraOffset = CFrame.new()
                end
            end
        else
            -- Normal aim (moves camera)
            if AimConfig.Smoothness < 1 then
                cameraCFrame = cameraCFrame:Lerp(targetCFrame, 1 - AimConfig.Smoothness)
            else
                cameraCFrame = targetCFrame
            end
            Camera.CFrame = cameraCFrame
        end
        
        AimConfig.Target = target
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
-- SECTION 7: MEMORY SYSTEM
-- ============================================

local function CreateMemorySystem(parent)
    local memoryFrame = CreateInstance("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 350),
        BackgroundTransparency = 1,
        LayoutOrder = 3
    })
    
    local layout = CreateInstance("UIListLayout", {
        Parent = memoryFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    local title = CreateTextLabel(memoryFrame, "💾 MEMORY SETTINGS", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.AccentColor, Enum.Font.GothamBlack, 16)
    
    local invisibleToggle = CreateToggle(memoryFrame, "Tàng hình", nil, function(value)
        MemoryConfig.Invisible = value
        if value then
            MakeInvisible()
        else
            MakeVisible()
        end
    end, false)
    invisibleToggle.Frame.LayoutOrder = 1
    
    local speedSlider = CreateSlider(memoryFrame, "Speed", nil, 16, 200, MemoryConfig.Speed, function(value)
        MemoryConfig.Speed = value
        SetSpeed(value)
    end)
    speedSlider.Frame.LayoutOrder = 2
    
    local noReloadToggle = CreateToggle(memoryFrame, "No reload", nil, function(value)
        MemoryConfig.NoReload = value
    end, false)
    noReloadToggle.Frame.LayoutOrder = 3
    
    local teleportKillToggle = CreateToggle(memoryFrame, "Teleport kill", nil, function(value)
        MemoryConfig.TeleportKill = value
        if value then
            TeleportKill()
        end
    end, false)
    teleportKillToggle.Frame.LayoutOrder = 4
    
    local noClipToggle = CreateToggle(memoryFrame, "Đi xuyên tường", nil, function(value)
        MemoryConfig.NoClip = value
        EnableNoClip(value)
    end, false)
    noClipToggle.Frame.LayoutOrder = 5
    
    local fireRateSlider = CreateSlider(memoryFrame, "Bắn siêu nhanh (RPM)", nil, 100, 6000, MemoryConfig.FireRate, function(value)
        MemoryConfig.FireRate = value
    end)
    fireRateSlider.Frame.LayoutOrder = 6
    
    local spinToggle = CreateToggle(memoryFrame, "Người xoay vòng tròn siêu nhanh", nil, function(value)
        MemoryConfig.Spinning = value
        SpinPlayer(value)
    end, false)
    spinToggle.Frame.LayoutOrder = 7
    
    return {
        Invisible = invisibleToggle,
        Speed = speedSlider,
        NoReload = noReloadToggle,
        TeleportKill = teleportKillToggle,
        NoClip = noClipToggle,
        FireRate = fireRateSlider,
        Spin = spinToggle
    }
end

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
        
        if not MemoryConfig.NoClipConnection then
            MemoryConfig.NoClipConnection = RunService.Stepped:Connect(function()
                if MemoryConfig.NoClip and LocalPlayer.Character then
                    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local direction = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            direction = direction + Camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            direction = direction - Camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            direction = direction - Camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            direction = direction + Camera.CFrame.RightVector
                        end
                        
                        if direction.Magnitude > 0 then
                            rootPart.CFrame = rootPart.CFrame + direction.Unit * (MemoryConfig.Speed / 10)
                        end
                    end
                end
            end)
        end
    else
        if MemoryConfig.NoClipConnection then
            MemoryConfig.NoClipConnection:Disconnect()
            MemoryConfig.NoClipConnection = nil
        end
        
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
        local character = GetCharacter(player)
        local rootPart = GetRootPart(character)
        
        if rootPart then
            local distance = GetDistance(LocalPlayer.Character.HumanoidRootPart.Position, rootPart.Position)
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
    end
    
    if nearestPlayer and LocalPlayer.Character then
        local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            MemoryConfig.BackupPosition = rootPart.CFrame
            
            local targetCharacter = nearestPlayer.Character
            local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
            
            if targetRootPart then
                rootPart.CFrame = targetRootPart.CFrame * CFrame.new(0, 3, 2)
                
                -- Auto kill
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
                
                -- Teleport back
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
    
    if enabled then
        if not MemoryConfig.SpinConnection then
            MemoryConfig.SpinConnection = RunService.RenderStepped:Connect(function()
                if MemoryConfig.Spinning and LocalPlayer.Character then
                    local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local rotation = CFrame.Angles(0, math.rad(MemoryConfig.SpinSpeed / 60), 0)
                        rootPart.CFrame = rootPart.CFrame * rotation
                    end
                end
            end)
        end
    else
        if MemoryConfig.SpinConnection then
            MemoryConfig.SpinConnection:Disconnect()
            MemoryConfig.SpinConnection = nil
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
        
        if MemoryConfig.FireRate > 0 then
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
end

-- ============================================
-- SECTION 8: ADMIN SYSTEM
-- ============================================

local function CreateAdminSystem(parent)
    local adminFrame = CreateInstance("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 200),
        BackgroundTransparency = 1,
        LayoutOrder = 4
    })
    
    local layout = CreateInstance("UIListLayout", {
        Parent = adminFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    local title = CreateTextLabel(adminFrame, "👑 ADMIN SETTINGS", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.AccentColor, Enum.Font.GothamBlack, 16)
    
    -- Lionel Tiến Mạnh text with rainbow effect
    local lionelFrame = CreateInstance("Frame", {
        Parent = adminFrame,
        Size = UDim2.new(1, -10, 0, 60),
        BackgroundColor3 = MenuConfig.SectionColor,
        BorderColor3 = MenuConfig.BorderColor,
        BorderSizePixel = 1,
        LayoutOrder = 1
    })
    
    local lionelLabel = CreateInstance("TextLabel", {
        Parent = lionelFrame,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 0, 50),
        Text = AdminConfig.LionelTienManh.Text,
        TextColor3 = MenuConfig.TextColor,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack,
        TextSize = AdminConfig.LionelTienManh.Size,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextScaled = false,
        ZIndex = 1000
    })
    
    -- Rainbow animation for Lionel Tiến Mạnh
    local function updateRainbow()
        while true do
            wait(AdminConfig.LionelTienManh.RainbowSpeed)
            
            if AdminConfig.LionelTienManh.Enabled then
                AdminConfig.LionelTienManh.CurrentHue = AdminConfig.LionelTienManh.CurrentHue + 5
                if AdminConfig.LionelTienManh.CurrentHue > 360 then
                    AdminConfig.LionelTienManh.CurrentHue = 0
                end
                
                local rainbowColor = Color3.fromHSV(AdminConfig.LionelTienManh.CurrentHue / 360, 1, 1)
                lionelLabel.TextColor3 = rainbowColor
                
                -- Blink effect
                if math.random() > 0.8 then
                    lionelLabel.Visible = false
                else
                    lionelLabel.Visible = true
                end
            end
        end
    end
    
    coroutine.wrap(updateRainbow)()
    
    local ownerInfo = CreateTextLabel(adminFrame, "Owner: @dongkaa", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.SubtleTextColor, Enum.Font.Code, 14)
    ownerInfo.LayoutOrder = 2
    
    local channelInfo = CreateTextLabel(adminFrame, "Channel: @dongkaa", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.SubtleTextColor, Enum.Font.Code, 14)
    channelInfo.LayoutOrder = 3
    
    local creatorInfo = CreateTextLabel(adminFrame, "Created by: Người Đẹp Trai (Subscriber)", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.SubtleTextColor, Enum.Font.Code, 14)
    creatorInfo.LayoutOrder = 4
    
    local versionInfo = CreateTextLabel(adminFrame, "Version: " .. MenuConfig.Version, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 25), MenuConfig.SubtleTextColor, Enum.Font.Code, 14)
    versionInfo.LayoutOrder = 5
    
    return {
        LionelLabel = lionelLabel,
        LionelFrame = lionelFrame
    }
end

-- ============================================
-- SECTION 9: MAIN INITIALIZATION
-- ============================================

local function InitializeMenu()
    local menu = CreateMenu()
    
    -- Create all systems
    local espSystem = CreateESPSystem(menu.ESPContent)
    local aimSystem = CreateAimSystem(menu.AimContent)
    local memorySystem = CreateMemorySystem(menu.MemoryContent)
    local adminSystem = CreateAdminSystem(menu.AdminContent)
    
    -- Start ESP system
    coroutine.wrap(UpdateESP)()
    
    -- Start Aim system
    coroutine.wrap(UpdateAim)()
    
    -- Start NoReload system
    coroutine.wrap(UpdateNoReload)()
    
    -- Start FireRate system
    coroutine.wrap(UpdateFireRate)()
    
    -- Restore speed when character respawns
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
    
    print("💀 DEVILS WILL RISE — SUBSCRIBER EDITION đã được khởi tạo!")
    print("👑 Owner: " .. MenuConfig.Owner)
    print("📢 Channel: " .. MenuConfig.Channel)
    print("✨ Created by: " .. MenuConfig.Creator)
    
    return menu
end

-- ============================================
-- SECTION 10: STARTUP
-- ============================================

local success, error = pcall(function()
    InitializeMenu()
end)

if not success then
    warn("Lỗi khi khởi tạo menu: " .. tostring(error))
    
    -- Fallback initialization
    wait(1)
    pcall(function()
        InitializeMenu()
    end)
end

-- Keep the script alive
while true do
    wait(10)
end
