--[[
    ROBLOX MENU SYSTEM - LIONEL TIEN MANH
    Script hoàn chỉnh với UI di động, hiệu ứng lửa, và toàn bộ chức năng yêu cầu.
    Sử dụng: Đưa vào Executor (Synapse, Krnl, Fluxus, v.v.)
]]

-- Khởi tạo môi trường
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

-- Tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LionelMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Biến toàn cục
local MenuFrame = nil
local Dragging = false
local DragInput = nil
local DragStart = nil
local StartPos = nil
local IconButton = nil
local MenuOpen = false

-- Cấu hình
local Settings = {
    ESP = {
        Enabled = false,
        Line = false,
        Box = false,
        Distance = false,
        Name = false,
        Health = false,
        Skeleton = false,
        FOV = 100
    },
    Aim = {
        HeadAim = false,
        AimStrength = 50,
        BodyAim = false,
        AutoAttack = false
    },
    Memory = {
        Invisible = false,
        Speed = 16,
        NoReload = false,
        TeleportKill = false,
        WallHack = false,
        RapidFire = false,
        FireRate = 10,
        SpinBot = false,
        LagEnemy = false,
        AutoDodge = false,
        Fly = false
    }
}

-- Tạo hiệu ứng lửa
local function CreateFireEffect(parent)
    local Fire = Instance.new("ParticleEmitter")
    Fire.Parent = parent
    Fire.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
    })
    Fire.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 3),
        NumberSequenceKeypoint.new(1, 0)
    })
    Fire.Lifetime = NumberRange.new(0.5, 1)
    Fire.Rate = 50
    Fire.Speed = NumberRange.new(2, 5)
    Fire.SpreadAngle = Vector2.new(360, 360)
    Fire.Rotation = NumberRange.new(0, 360)
    Fire.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    Fire.LightEmission = 1
    Fire.Texture = "rbxassetid://244221440"
    Fire.VelocitySpread = 30
    Fire.Acceleration = Vector3.new(0, 10, 0)
    Fire.Drag = 3
    Fire.Enabled = true
    return Fire
end

-- Tạo nút icon
local function CreateIcon()
    IconButton = Instance.new("ImageButton")
    IconButton.Parent = ScreenGui
    IconButton.Size = UDim2.new(0, 60, 0, 60)
    IconButton.Position = UDim2.new(0.5, -30, 0.5, -30)
    IconButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    IconButton.BorderSizePixel = 0
    IconButton.Image = "rbxassetid://6026568198"
    IconButton.ImageColor3 = Color3.fromRGB(255, 200, 0)
    IconButton.AnchorPoint = Vector2.new(0.5, 0.5)
    IconButton.ZIndex = 10
    IconButton.Visible = true
    IconButton.Active = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = IconButton
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 0))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = IconButton
    
    -- Icon di chuyển
    local iconDragging = false
    local iconDragInput = nil
    local iconDragStart = nil
    local iconStartPos = nil
    
    IconButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            iconDragging = true
            iconDragStart = input.Position
            iconStartPos = IconButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    iconDragging = false
                end
            end)
        end
    end)
    
    IconButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            iconDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == iconDragInput and iconDragging then
            local delta = input.Position - iconDragStart
            IconButton.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
        end
    end)
    
    IconButton.MouseButton1Click:Connect(function()
        if not iconDragging then
            MenuOpen = not MenuOpen
            if MenuFrame then
                MenuFrame.Visible = MenuOpen
            end
        end
    end)
end

-- Tạo toggle button
local function CreateToggle(parent, txt, callback, default)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
    ToggleFrame.BackgroundTransparency = 1
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.Size = UDim2.new(0, 50, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = ToggleButton
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Parent = ToggleButton
    ToggleDot.Size = UDim2.new(0, 18, 0, 18)
    ToggleDot.Position = UDim2.new(0, 1, 0.5, -9)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleDot.BorderSizePixel = 0
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = ToggleDot
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = txt
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local isOn = default or false
    
    local function UpdateVisual()
        if isOn then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 0)}):Play()
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -9)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 1, 0.5, -9)}):Play()
        end
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        UpdateVisual()
        if callback then
            callback(isOn)
        end
    end)
    
    UpdateVisual()
    
    return {
        SetValue = function(val)
            isOn = val
            UpdateVisual()
        end,
        GetValue = function()
            return isOn
        end
    }
end

-- Tạo thanh kéo
local function CreateSlider(parent, txt, minVal, maxVal, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.Position = UDim2.new(0, 10, 0, 0)
    SliderFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = txt .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBG = Instance.new("Frame")
    SliderBG.Parent = SliderFrame
    SliderBG.Size = UDim2.new(1, 0, 0, 10)
    SliderBG.Position = UDim2.new(0, 0, 0, 25)
    SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SliderBG.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = SliderBG
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBG
    SliderFill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBG
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new((default - minVal) / (maxVal - minVal), -10, 0.5, -10)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.BorderSizePixel = 0
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = SliderButton
    
    local sliderValue = default
    local dragging = false
    
    local function UpdateValue(input)
        local relativeX = input.Position.X - SliderBG.AbsolutePosition.X
        local percent = math.clamp(relativeX / SliderBG.AbsoluteSize.X, 0, 1)
        sliderValue = minVal + (maxVal - minVal) * percent
        sliderValue = math.round(sliderValue)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
        Label.Text = txt .. ": " .. tostring(sliderValue)
        if callback then
            callback(sliderValue)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement) then
            UpdateValue(input)
        end
    end)
    
    SliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateValue(input)
        end
    end)
    
    return {
        SetValue = function(val)
            sliderValue = val
            local percent = (val - minVal) / (maxVal - minVal)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderButton.Position = UDim2.new(percent, -10, 0.5, -10)
            Label.Text = txt .. ": " .. tostring(val)
        end,
        GetValue = function()
            return sliderValue
        end
    }
end

-- Tạo section
local function CreateSection(parent, title)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Parent = parent
    SectionFrame.Size = UDim2.new(1, -20, 0, 30)
    SectionFrame.Position = UDim2.new(0, 10, 0, 0)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SectionFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 5)
    UICorner.Parent = SectionFrame
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = SectionFrame
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = title
    SectionLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    SectionLabel.Font = Enum.Font.SourceSansBold
    SectionLabel.TextSize = 16
    
    return SectionFrame
end

-- Tạo menu chính
local function CreateMenu()
    MenuFrame = Instance.new("Frame")
    MenuFrame.Parent = ScreenGui
    MenuFrame.Size = UDim2.new(0, 400, 0, 600)
    MenuFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MenuFrame.BorderSizePixel = 0
    MenuFrame.Visible = false
    MenuFrame.ZIndex = 5
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MenuFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Parent = MenuFrame
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.Position = UDim2.new(0, 0, 0, 0)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Header.BorderSizePixel = 0
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 10)
    UICorner2.Parent = Header
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Parent = Header
    HeaderLabel.Size = UDim2.new(1, -40, 1, 0)
    HeaderLabel.Position = UDim2.new(0, 20, 0, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = "LIONEL TIEN MANH"
    HeaderLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    HeaderLabel.Font = Enum.Font.SourceSansBold
    HeaderLabel.TextSize = 20
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Parent = Header
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 16
    CloseButton.AutoButtonColor = false
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(1, 0)
    UICorner3.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        MenuOpen = false
        MenuFrame.Visible = false
    end)
    
    -- Menu di chuyển
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MenuFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local delta = input.Position - DragStart
            MenuFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Tab system
    local TabFrame = Instance.new("Frame")
    TabFrame.Parent = MenuFrame
    TabFrame.Size = UDim2.new(1, 0, 0, 40)
    TabFrame.Position = UDim2.new(0, 0, 0, 50)
    TabFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabFrame.BorderSizePixel = 0
    
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MenuFrame
    ContentFrame.Size = UDim2.new(1, 0, 1, -90)
    ContentFrame.Position = UDim2.new(0, 0, 0, 90)
    ContentFrame.BackgroundTransparency = 1
    
    local TabContents = {}
    local TabButtons = {}
    local CurrentTab = nil
    
    local function CreateTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabFrame
        TabButton.Size = UDim2.new(0.25, 0, 1, 0)
        TabButton.Position = UDim2.new(#TabButtons * 0.25, 0, 0, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Parent = ContentFrame
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 5
        TabContent.Visible = false
        TabContent.ZIndex = 6
        
        local UIListLayout = Instance.new("UIListLayout")
        UIListLayout.Parent = TabContent
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)
        
        local UIPadding = Instance.new("UIPadding")
        UIPadding.Parent = TabContent
        UIPadding.PaddingTop = UDim.new(0, 10)
        UIPadding.PaddingBottom = UDim.new(0, 10)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, btn in pairs(TabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            for _, content in pairs(TabContents) do
                content.Visible = false
            end
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            CurrentTab = TabContent
        end)
        
        table.insert(TabContents, TabContent)
        table.insert(TabButtons, TabButton)
        
        return TabContent
    end
    
    -- Tạo các tab
    local ESPTab = CreateTab("ESP")
    local AimTab = CreateTab("AIM")
    local MemoryTab = CreateTab("MEMORY")
    local AdminTab = CreateTab("ADMIN")
    
    -- ESP TAB
    CreateSection(ESPTab, "ESP SETTINGS")
    CreateToggle(ESPTab, "Cho phép ESP", function(val)
        Settings.ESP.Enabled = val
    end, false)
    CreateToggle(ESPTab, "ESP Line", function(val)
        Settings.ESP.Line = val
    end, false)
    CreateToggle(ESPTab, "ESP Box", function(val)
        Settings.ESP.Box = val
    end, false)
    CreateToggle(ESPTab, "ESP Khoảng cách", function(val)
        Settings.ESP.Distance = val
    end, false)
    CreateToggle(ESPTab, "ESP Tên", function(val)
        Settings.ESP.Name = val
    end, false)
    CreateToggle(ESPTab, "ESP Máu", function(val)
        Settings.ESP.Health = val
    end, false)
    CreateToggle(ESPTab, "ESP Skeleton (Khung xương)", function(val)
        Settings.ESP.Skeleton = val
    end, false)
    CreateSlider(ESPTab, "Kích cỡ FOV", 50, 200, 100, function(val)
        Settings.ESP.FOV = val
        Camera.FieldOfView = val
    end)
    
    -- AIM TAB
    CreateSection(AimTab, "AIM SETTINGS")
    CreateToggle(AimTab, "Aim đầu (Head)", function(val)
        Settings.Aim.HeadAim = val
    end, false)
    CreateSlider(AimTab, "Mức độ aim", 1, 100, 50, function(val)
        Settings.Aim.AimStrength = val
    end)
    CreateToggle(AimTab, "Aim body", function(val)
        Settings.Aim.BodyAim = val
    end, false)
    CreateToggle(AimTab, "Tự động tấn công", function(val)
        Settings.Aim.AutoAttack = val
    end, false)
    
    -- MEMORY TAB
    CreateSection(MemoryTab, "MEMORY SETTINGS")
    CreateToggle(MemoryTab, "Tàng hình", function(val)
        Settings.Memory.Invisible = val
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Transparency = val and 1 or 0
                end
            end
        end
    end, false)
    CreateSlider(MemoryTab, "Speed", 16, 200, 16, function(val)
        Settings.Memory.Speed = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end)
    CreateToggle(MemoryTab, "No Reload", function(val)
        Settings.Memory.NoReload = val
    end, false)
    CreateToggle(MemoryTab, "Teleport Kill", function(val)
        Settings.Memory.TeleportKill = val
    end, false)
    CreateToggle(MemoryTab, "Đi xuyên tường", function(val)
        Settings.Memory.WallHack = val
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not val
                end
            end
        end
    end, false)
    CreateToggle(MemoryTab, "Bắn siêu nhanh", function(val)
        Settings.Memory.RapidFire = val
    end, false)
    CreateSlider(MemoryTab, "Tốc độ bắn", 1, 100, 10, function(val)
        Settings.Memory.FireRate = val
    end)
    CreateToggle(MemoryTab, "Xoay vòng tròn", function(val)
        Settings.Memory.SpinBot = val
    end, false)
    CreateToggle(MemoryTab, "Làm lag đối thủ", function(val)
        Settings.Memory.LagEnemy = val
    end, false)
    CreateToggle(MemoryTab, "Né khi bị tấn công", function(val)
        Settings.Memory.AutoDodge = val
    end, false)
    CreateToggle(MemoryTab, "Bay", function(val)
        Settings.Memory.Fly = val
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = val
        end
    end, false)
    
    -- ADMIN TAB
    CreateSection(AdminTab, "ADMIN INFO")
    
    local AdminLabel = Instance.new("TextLabel")
    AdminLabel.Parent = AdminTab
    AdminLabel.Size = UDim2.new(1, -20, 0, 60)
    AdminLabel.Position = UDim2.new(0, 10, 0, 10)
    AdminLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AdminLabel.BorderSizePixel = 0
    AdminLabel.Text = "LIONEL TIẾN MẠNH"
    AdminLabel.Font = Enum.Font.SourceSansBold
    AdminLabel.TextSize = 30
    AdminLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 8)
    UICorner4.Parent = AdminLabel
    
    -- Hiệu ứng cầu vồng nhấp nháy
    RunService.RenderStepped:Connect(function()
        if AdminLabel and AdminLabel.Parent then
            local hue = (tick() * 2) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            AdminLabel.TextColor3 = color
            AdminLabel.TextTransparency = (math.sin(tick() * 5) + 1) / 4
        end
    end)
    
    local TikTokLabel = Instance.new("TextLabel")
    TikTokLabel.Parent = AdminTab
    TikTokLabel.Size = UDim2.new(1, -20, 0, 40)
    TikTokLabel.Position = UDim2.new(0, 10, 0, 80)
    TikTokLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TikTokLabel.BorderSizePixel = 0
    TikTokLabel.Text = "TikTok: lioneltienmanh 😎😎"
    TikTokLabel.Font = Enum.Font.SourceSansBold
    TikTokLabel.TextSize = 18
    TikTokLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local UICorner5 = Instance.new("UICorner")
    UICorner5.CornerRadius = UDim.new(0, 8)
    UICorner5.Parent = TikTokLabel
    
    -- Chọn tab đầu tiên
    if TabButtons[1] then
        TabButtons[1].BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContents[1].Visible = true
        CurrentTab = TabContents[1]
    end
    
    -- Cập nhật CanvasSize
    task.wait(1)
    for _, tab in pairs(TabContents) do
        local totalHeight = 0
        for _, child in pairs(tab:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                totalHeight = totalHeight + child.AbsoluteSize.Y + 5
            end
        end
        tab.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
    end
end

-- ESP Logic
local function DrawESP()
    local function CreateESPForPlayer(player)
        if player == LocalPlayer then return end
        
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        
        if not humanoid or not rootPart or not head then return end
        
        -- ESP Line
        local espLine = Drawing.new("Line")
        espLine.Color = Color3.fromRGB(255, 0, 0)
        espLine.Thickness = 1
        espLine.Transparency = 1
        
        -- ESP Box
        local boxFill = Drawing.new("Square")
        boxFill.Color = Color3.fromRGB(255, 0, 0)
        boxFill.Thickness = 1
        boxFill.Filled = true
        boxFill.Transparency = 0.3
        
        -- ESP Text
        local nameText = Drawing.new("Text")
        nameText.Color = Color3.fromRGB(255, 255, 255)
        nameText.Size = 14
        nameText.Center = true
        nameText.Outline = true
        
        local distanceText = Drawing.new("Text")
        distanceText.Color = Color3.fromRGB(200, 200, 200)
        distanceText.Size = 12
        distanceText.Center = true
        distanceText.Outline = true
        
        local healthText = Drawing.new("Text")
        healthText.Color = Color3.fromRGB(0, 255, 0)
        healthText.Size = 12
        healthText.Center = true
        healthText.Outline = true
        
        -- Skeleton lines
        local skeletonLines = {}
        for i = 1, 14 do
            local skLine = Drawing.new("Line")
            skLine.Color = Color3.fromRGB(255, 255, 0)
            skLine.Thickness = 1
            skLine.Transparency = 1
            table.insert(skeletonLines, skLine)
        end
        
        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character or not character.Parent or not rootPart or not rootPart.Parent then
                connection:Disconnect()
                espLine:Remove()
                boxFill:Remove()
                nameText:Remove()
                distanceText:Remove()
                healthText:Remove()
                for _, skLine in pairs(skeletonLines) do
                    skLine:Remove()
                end
                return
            end
            
            if not Settings.ESP.Enabled then
                espLine.Transparency = 0
                boxFill.Transparency = 0
                nameText.Transparency = 0
                distanceText.Transparency = 0
                healthText.Transparency = 0
                for _, skLine in pairs(skeletonLines) do
                    skLine.Transparency = 0                end
                return
            end
            
            local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if not onScreen then
                espLine.Transparency = 0
                boxFill.Transparency = 0
                nameText.Transparency = 0
                distanceText.Transparency = 0
                healthText.Transparency = 0
                for _, skLine in pairs(skeletonLines) do
                    skLine.Transparency = 0
                end
                return
            end
            
            -- ESP Line
            if Settings.ESP.Line then
                espLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                espLine.To = Vector2.new(screenPos.X, screenPos.Y)
                espLine.Transparency = 1
            else
                espLine.Transparency = 0
            end
            
            -- ESP Box
            if Settings.ESP.Box then
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local rootPos = Camera:WorldToViewportPoint(rootPart.Position)
                local height = math.abs(headPos.Y - rootPos.Y)
                local width = height * 0.6
                boxFill.Size = Vector2.new(width, height)
                boxFill.Position = Vector2.new(screenPos.X - width/2, headPos.Y - height/2)
                boxFill.Transparency = 0.3
            else
                boxFill.Transparency = 0
            end
            
            -- ESP Name
            if Settings.ESP.Name then
                nameText.Text = player.Name
                nameText.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                nameText.Transparency = 1
            else
                nameText.Transparency = 0
            end
            
            -- ESP Distance
            if Settings.ESP.Distance then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                distanceText.Text = string.format("%.1f m", distance)
                distanceText.Position = Vector2.new(screenPos.X, screenPos.Y + 15)
                distanceText.Transparency = 1
            else
                distanceText.Transparency = 0
            end
            
            -- ESP Health
            if Settings.ESP.Health then
                healthText.Text = "HP: " .. math.floor(humanoid.Health)
                healthText.Position = Vector2.new(screenPos.X, screenPos.Y + 30)
                healthText.Transparency = 1
            else
                healthText.Transparency = 0
            end
            
            -- ESP Skeleton
            if Settings.ESP.Skeleton then
                local joints = {
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
                
                for i, joint in pairs(joints) do
                    local part1 = character:FindFirstChild(joint[1])
                    local part2 = character:FindFirstChild(joint[2])
                    
                    if part1 and part2 then
                        local pos1 = Camera:WorldToViewportPoint(part1.Position)
                        local pos2 = Camera:WorldToViewportPoint(part2.Position)
                        
                        if pos1.Z > 0 and pos2.Z > 0 then
                            if skeletonLines[i] then
                                skeletonLines[i].From = Vector2.new(pos1.X, pos1.Y)
                                skeletonLines[i].To = Vector2.new(pos2.X, pos2.Y)
                                skeletonLines[i].Transparency = 1
                            end
                        else
                            if skeletonLines[i] then
                                skeletonLines[i].Transparency = 0
                            end
                        end
                    end
                end
            else
                for _, skLine in pairs(skeletonLines) do
                    skLine.Transparency = 0
                end
            end
        end)
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            task.wait(1)
            CreateESPForPlayer(player)
        end)
    end)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                CreateESPForPlayer(player)
            end
            player.CharacterAdded:Connect(function()
                task.wait(1)
                CreateESPForPlayer(player)
            end)
        end
    end
end

-- Aim Logic
local function AimSystem()
    local function GetClosestEnemy()
        local closest = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closest = player
                        end
                    end
                end
            end
        end
        
        return closest
    end
    
    RunService.RenderStepped:Connect(function()
        if not Settings.Aim.HeadAim and not Settings.Aim.BodyAim then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local target = GetClosestEnemy()
        if not target then return end
        
        local targetPart = nil
        if Settings.Aim.HeadAim and target.Character:FindFirstChild("Head") then
            targetPart = target.Character.Head
        elseif Settings.Aim.BodyAim and target.Character:FindFirstChild("UpperTorso") then
            targetPart = target.Character.UpperTorso
        end
        
        if not targetPart then return end
        
        local targetPos = targetPart.Position
        local aimStrength = Settings.Aim.AimStrength / 100
        
        local currentMousePos = UserInputService:GetMouseLocation()
        local targetScreenPos = Camera:WorldToViewportPoint(targetPos)
        
        local newX = currentMousePos.X + (targetScreenPos.X - currentMousePos.X) * aimStrength
        local newY = currentMousePos.Y + (targetScreenPos.Y - currentMousePos.Y) * aimStrength
        
        VirtualInputManager:SendMouseMoveEvent(newX, newY, game)
    end)
end

-- Auto Attack Logic
local function AutoAttackSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Aim.AutoAttack then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if onScreen then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance < 100 then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    end
                end
            end
        end
    end)
end

-- No Reload Logic
local function NoReloadSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.NoReload then return end
        if not LocalPlayer.Character then return end
        
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local ammo = tool:FindFirstChild("Ammo")
            if ammo then
                ammo.Value = ammo.MaxValue
            end
        end
    end)
end

-- Teleport Kill Logic
local function TeleportKillSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.TeleportKill then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.Health > 0 then
                    local rootPart = player.Character.HumanoidRootPart
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    if distance < 200 then
                        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
                            tool:Activate()
                            task.wait(0.1)
                            tool:Deactivate()
                        end
                    end
                end
            end
        end
    end)
end

-- Rapid Fire Logic
local function RapidFireSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.RapidFire then return end
        if not LocalPlayer.Character then return end
        
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local fireRate = Settings.Memory.FireRate
            local delay = 1 / fireRate
            
            task.spawn(function()
                while Settings.Memory.RapidFire and tool and tool.Parent do
                    tool:Activate()
                    task.wait(delay)
                    tool:Deactivate()
                end
            end)
        end
    end)
end

-- Spin Bot Logic
local function SpinBotSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.SpinBot then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
    end)
end

-- Lag Enemy Logic
local function LagEnemySystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.LagEnemy then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.RotVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end

-- Auto Dodge Logic
local function AutoDodgeSystem()
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.AutoDodge then return end
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local enemyRoot = player.Character.HumanoidRootPart
                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                
                if distance < 10 then
                    local direction = (rootPart.Position - enemyRoot.Position).Unit
                    rootPart.CFrame = rootPart.CFrame + direction * 5
                end
            end
        end
    end)
end

-- Fly Logic
local function FlySystem()
    local flyKeys = {}
    
    UserInputService.InputBegan:Connect(function(input)
        if Settings.Memory.Fly then
            if input.KeyCode == Enum.KeyCode.W then
                flyKeys.W = true
            elseif input.KeyCode == Enum.KeyCode.S then
                flyKeys.S = true
            elseif input.KeyCode == Enum.KeyCode.A then
                flyKeys.A = true
            elseif input.KeyCode == Enum.KeyCode.D then
                flyKeys.D = true
            elseif input.KeyCode == Enum.KeyCode.Space then
                flyKeys.Space = true
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                flyKeys.Shift = true
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            flyKeys.W = false
        elseif input.KeyCode == Enum.KeyCode.S then
            flyKeys.S = false
        elseif input.KeyCode == Enum.KeyCode.A then
            flyKeys.A = false
        elseif input.KeyCode == Enum.KeyCode.D then
            flyKeys.D = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            flyKeys.Space = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            flyKeys.Shift = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if not Settings.Memory.Fly then return end
        
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character.Humanoid
        local speed = 50
        
        humanoid.PlatformStand = true
        
        local direction = Vector3.new(0, 0, 0)
        
        if flyKeys.W then
            direction = direction + Camera.CFrame.LookVector
        end
        if flyKeys.S then
            direction = direction - Camera.CFrame.LookVector
        end
        if flyKeys.A then
            direction = direction - Camera.CFrame.RightVector
        end
        if flyKeys.D then
            direction = direction + Camera.CFrame.RightVector
        end
        if flyKeys.Space then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if flyKeys.Shift then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        if direction.Magnitude > 0 then
            rootPart.Velocity = direction.Unit * speed
        else
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- Khởi tạo tất cả
CreateIcon()
CreateMenu()
DrawESP()
AimSystem()
AutoAttackSystem()
NoReloadSystem()
TeleportKillSystem()
RapidFireSystem()
SpinBotSystem()
LagEnemySystem()
AutoDodgeSystem()
FlySystem()

-- Thông báo hoàn tất
print("Lionel Menu đã được tải thành công!")
print("TikTok: lioneltienmanh 😎😎")
