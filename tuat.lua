--[[
    💀 DEVILS WILL RISE v2.0 — ULTRA PREMIUM EDITION 💀
    Owner: @dongkaa | Channel: @dongkaa
    Tạo bởi: Người Đẹp Trai (Subscriber)
    Đồ họa: ULTRA HD + Animation + Glow + Blur + Particle
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Lighting = game:GetService("Lighting")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

-- Config
local MenuConfig = {
    Dragging = false,
    DragInput = nil,
    DragStart = nil,
    StartPos = nil,
    Minimized = false,
    
    ESP = {
        Enabled = false,
        Line = false,
        Box = false,
        Distance = false,
        Name = false,
        Health = false,
        Skeleton = false,
        FOVSize = 150
    },
    AIM = {
        HeadLock = false,
        AimSmoothness = 3,
        BodyLock = false,
        AutoAttack = false
    },
    MEMORY = {
        Invisible = false,
        Speed = 16,
        NoReload = false,
        TeleportKill = false,
        WallHack = false,
        RapidFire = false,
        FireRate = 8,
        SpinBot = false,
        LagEnemies = false,
        Dodge = false,
        Fly = false
    },
    ADMIN = {
        RainbowText = true
    }
}

-- Utility
local function CreateInstance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local function Tween(instance, props, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, props)
    tween:Play()
    return tween
end

local function ApplyGradient(frame, color1, color2, rotation)
    local gradient = CreateInstance("UIGradient", {
        Parent = frame,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }),
        Rotation = rotation or 0
    })
    return gradient
end

local function ApplyStroke(instance, color, thickness, transparency)
    return CreateInstance("UIStroke", {
        Parent = instance,
        Color = color or Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 2,
        Transparency = transparency or 0
    })
end

local function ApplyCorner(instance, radius)
    return CreateInstance("UICorner", {
        Parent = instance,
        CornerRadius = UDim.new(0, radius or 8)
    })
end

local function ApplyShadow(instance, transparency, size)
    return CreateInstance("ImageLabel", {
        Parent = instance,
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageTransparency = transparency or 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 50, 50),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        Position = UDim2.new(0, -(size or 30)/2, 0, -(size or 30)/2),
        ZIndex = instance.ZIndex - 1
    })
end

-- Main Container
local MainContainer = CreateInstance("Frame", {
    Name = "MainContainer",
    Parent = ScreenGui,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 550, 0, 650),
    Position = UDim2.new(0.3, 0, 0.15, 0),
    ZIndex = 50
})

ApplyShadow(MainContainer, 0.7, 40)

-- Blur Background
local BlurFrame = CreateInstance("Frame", {
    Name = "BlurFrame",
    Parent = MainContainer,
    BackgroundColor3 = Color3.fromRGB(15, 15, 20),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 51
})
ApplyCorner(BlurFrame, 16)
ApplyGradient(BlurFrame, Color3.fromRGB(15, 15, 25), Color3.fromRGB(25, 10, 35), 45)

-- Main Border Glow
local BorderGlow = CreateInstance("Frame", {
    Name = "BorderGlow",
    Parent = MainContainer,
    BackgroundTransparency = 1,
    BorderSizePixel = 3,
    BorderColor3 = Color3.fromRGB(255, 80, 0),
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 52
})
ApplyCorner(BorderGlow, 16)

-- Fire Particle Effect
local ParticleContainer = CreateInstance("Frame", {
    Name = "ParticleContainer",
    Parent = MainContainer,
    BackgroundTransparency = 1,
    ClipsDescendants = false,
    Size = UDim2.new(1, 0, 1, 0),
    ZIndex = 53
})

-- Spawn fire particles
spawn(function()
    local particles = {}
    for i = 1, 15 do
        local particle = CreateInstance("Frame", {
            Parent = ParticleContainer,
            BackgroundColor3 = Color3.fromHSV(math.random() * 0.1, 1, 1),
            BackgroundTransparency = 0.3,
            BorderSizePixel = 0,
            Size = UDim2.new(0, math.random(5, 15), 0, math.random(5, 15)),
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            ZIndex = 53
        })
        ApplyCorner(particle, 10)
        particles[i] = {
            obj = particle,
            xSpeed = math.random(-2, 2) / 10,
            ySpeed = math.random(-3, -1) / 10,
            life = math.random(50, 100)
        }
    end
    
    game:GetService("RunService").RenderStepped:Connect(function()
        for i, particle in pairs(particles) do
            particle.life = particle.life - 1
            if particle.life <= 0 then
                particle.obj.Position = UDim2.new(math.random(), 0, 1, 0)
                particle.life = math.random(50, 100)
                particle.xSpeed = math.random(-2, 2) / 10
                particle.ySpeed = math.random(-3, -1) / 10
            end
            particle.obj.Position = UDim2.new(
                particle.obj.Position.X.Scale + particle.xSpeed / 100,
                0,
                particle.obj.Position.Y.Scale + particle.ySpeed / 100,
                0
            )
            particle.obj.BackgroundTransparency = 0.3 + (1 - particle.life / 100) * 0.5
        end
    end)
end)

-- Animated Fire Border
spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.008) % 0.15
        local fireColor = Color3.fromHSV(hue, 1, 1)
        BorderGlow.BorderColor3 = fireColor
        
        -- Thay đổi gradient
        local gradient = BlurFrame:FindFirstChildOfClass("UIGradient")
        if gradient then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(15 + hue * 100, 15, 25)),
                ColorSequenceKeypoint.new(1, fireColor:Lerp(Color3.fromRGB(25, 10, 35), 0.7))
            })
        end
        
        RunService.RenderStepped:Wait()
    end
end)

-- Title Bar
local TitleBar = CreateInstance("Frame", {
    Name = "TitleBar",
    Parent = MainContainer,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 0),
    ZIndex = 54
})
ApplyCorner(TitleBar, 16)
ApplyGradient(TitleBar, Color3.fromRGB(30, 30, 40), Color3.fromRGB(10, 10, 20), 90)

-- Animated Skull Icon
local SkullIcon = CreateInstance("ImageLabel", {
    Name = "SkullIcon",
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Image = "rbxassetid://6031060921",
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(0, 10, 0, 7),
    ZIndex = 55
})

-- Skull Animation
spawn(function()
    local time = 0
    while true do
        time = time + 0.05
        SkullIcon.Rotation = math.sin(time) * 20
        SkullIcon.Size = UDim2.new(0, 35 + math.sin(time * 2) * 5, 0, 35 + math.sin(time * 2) * 5)
        RunService.RenderStepped:Wait()
    end
end)

-- Title Text
local TitleText = CreateInstance("TextLabel", {
    Name = "TitleText",
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 50, 0, 0),
    Text = "💀 DEVILS WILL RISE 💀",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextTransparency = 0,
    ZIndex = 55
})

-- Title Glow Effect
spawn(function()
    local glow = 0
    while true do
        glow = (glow + 0.05) % (math.pi * 2)
        TitleText.TextStrokeTransparency = 0.5 + math.sin(glow) * 0.3
        RunService.RenderStepped:Wait()
    end
end)

-- Minimize Button
local MinimizeButton = CreateInstance("TextButton", {
    Name = "MinimizeButton",
    Parent = TitleBar,
    BackgroundColor3 = Color3.fromRGB(255, 150, 0),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -70, 0, 10),
    Text = "—",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    ZIndex = 55
})
ApplyCorner(MinimizeButton, 8)

-- Close Button
local CloseButton = CreateInstance("TextButton", {
    Name = "CloseButton",
    Parent = TitleBar,
    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
    BackgroundTransparency = 0.2,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -35, 0, 10),
    Text = "✕",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    ZIndex = 55
})
ApplyCorner(CloseButton, 8)

MinimizeButton.MouseButton1Click:Connect(function()
    MenuConfig.Minimized = not MenuConfig.Minimized
    if MenuConfig.Minimized then
        Tween(MainContainer, {Size = UDim2.new(0, 550, 0, 50)}, 0.3)
    else
        Tween(MainContainer, {Size = UDim2.new(0, 550, 0, 650)}, 0.3)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    Tween(MainContainer, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    wait(0.3)
    ScreenGui:Destroy()
end)

-- Tab Container
local TabContainer = CreateInstance("Frame", {
    Name = "TabContainer",
    Parent = MainContainer,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 50),
    ZIndex = 54
})
ApplyGradient(TabContainer, Color3.fromRGB(25, 25, 35), Color3.fromRGB(15, 10, 25), 0)

-- Content Container
local ContentContainer = CreateInstance("Frame", {
    Name = "ContentContainer",
    Parent = MainContainer,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 1, -100),
    Position = UDim2.new(0, 0, 0, 100),
    ZIndex = 54
})
ApplyCorner(ContentContainer, 16)

-- Tab Buttons
local Tabs = {"🎯 ESP", "⚡ AIM", "💾 MEMORY", "👑 ADMIN"}
local TabButtons = {}
local CurrentTab = "🎯 ESP"

local function SwitchTab(tabName)
    CurrentTab = tabName
    
    for _, child in pairs(ContentContainer:GetChildren()) do
        if child:IsA("Frame") and child:IsA("ScrollingFrame") == false and child.Name ~= "ScrollingFrame_" .. tabName then
            if child:IsA("Frame") and child.Name:sub(1, 8) == "Scrolling" then
                child.Visible = false
            end
        end
    end
    
    for name, btn in pairs(TabButtons) do
        if name == tabName then
            Tween(btn, {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(255, 100, 0)}, 0.2)
            ApplyGradient(btn, Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 60, 0), 90)
        else
            Tween(btn, {BackgroundTransparency = 0.5, BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
        end
    end
    
    -- Show/hide scroll frames
    for _, child in pairs(ContentContainer:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = (child.Name == "Scroll_" .. tabName)
        end
    end
end

for i, tabName in ipairs(Tabs) do
    local TabButton = CreateInstance("TextButton", {
        Name = tabName,
        Parent = TabContainer,
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Size = UDim2.new(0.25, -4, 1, -10),
        Position = UDim2.new(0, (i-1) * 0.25 * 550 + (i-1) * 2, 0, 5),
        Text = tabName,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ZIndex = 55,
        AutoButtonColor = false
    })
    ApplyCorner(TabButton, 10)
    
    TabButtons[tabName] = TabButton
    
    TabButton.MouseButton1Click:Connect(function()
        SwitchTab(tabName)
    end)
    
    TabButton.MouseEnter:Connect(function()
        if CurrentTab ~= tabName then
            Tween(TabButton, {BackgroundTransparency = 0.3}, 0.2)
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if CurrentTab ~= tabName then
            Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
        end
    end)
end

-- Create Premium Toggle
local function CreatePremiumToggle(parent, name, config, configKey, position, icon)
    local Frame = CreateInstance("Frame", {
        Name = name,
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 45),
        Position = position,
        ZIndex = 55
    })
    ApplyCorner(Frame, 12)
    ApplyGradient(Frame, Color3.fromRGB(35, 35, 45), Color3.fromRGB(20, 15, 30), 0)
    
    -- Hover effect
    Frame.MouseEnter:Connect(function()
        Tween(Frame, {BackgroundTransparency = 0.15}, 0.2)
    end)
    
    Frame.MouseLeave:Connect(function()
        Tween(Frame, {BackgroundTransparency = 0.3}, 0.2)
    end)
    
    local IconLabel = CreateInstance("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 10, 0, 10),
        Text = icon or "🔹",
        TextSize = 15,
        ZIndex = 56
    })
    
    local Label = CreateInstance("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.1,
        ZIndex = 56
    })
    
    local ToggleButton = CreateInstance("TextButton", {
        Parent = Frame,
        BackgroundColor3 = Color3.fromRGB(60, 60, 70),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -70, 0, 7),
        Text = "OFF",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 56,
        AutoButtonColor = false
    })
    ApplyCorner(ToggleButton, 15)
    
    ToggleButton.MouseButton1Click:Connect(function()
        config[configKey] = not config[configKey]
        if config[configKey] then
            Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(0, 200, 0), BackgroundTransparency = 0.1}, 0.2)
            ToggleButton.Text = "ON"
        else
            Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 70), BackgroundTransparency = 0.3}, 0.2)
            ToggleButton.Text = "OFF"
        end
    end)
    
    return Frame
end

-- Create Premium Slider
local function CreatePremiumSlider(parent, name, minValue, maxValue, default, position, icon, callback)
    local Frame = CreateInstance("Frame", {
        Name = name,
        Parent = parent,
        BackgroundColor3 = Color3.fromRGB(25, 25, 35),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 60),
        Position = position,
        ZIndex = 55
    })
    ApplyCorner(Frame, 12)
    ApplyGradient(Frame, Color3.fromRGB(35, 35, 45), Color3.fromRGB(20, 15, 30), 0)
    
    local IconLabel = CreateInstance("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        Text = icon or "🎚️",
        TextSize = 15,
        ZIndex = 56
    })
    
    local Label = CreateInstance("TextLabel", {
        Parent = Frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 0, 20),
        Position = UDim2.new(0, 40, 0, 5),
        Text = name .. ": " .. default,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 56
    })
    
    local SliderBar = CreateInstance("Frame", {
        Parent = Frame,
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 250, 0, 8),
        Position = UDim2.new(0, 40, 0, 35),
        ZIndex = 56
    })
    ApplyCorner(SliderBar, 4)
    
    local SliderFill = CreateInstance("Frame", {
        Parent = SliderBar,
        BackgroundColor3 = Color3.fromRGB(255, 100, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new((default - minValue) / (maxValue - minValue), 0, 1, 0),
        ZIndex = 57
    })
    ApplyCorner(SliderFill, 4)
    ApplyGradient(SliderFill, Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 50, 0), 0)
    
    local SliderButton = CreateInstance("TextButton", {
        Parent = Frame,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 40 + (default - minValue) / (maxValue - minValue) * 250 - 10, 0, 29),
        Text = "",
        ZIndex = 58,
        AutoButtonColor = false
    })
    ApplyCorner(SliderButton, 10)
    ApplyShadow(SliderButton, 0.5, 10)
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        Tween(SliderButton, {Size = UDim2.new(0, 25, 0, 25)}, 0.1)
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            Tween(SliderButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = SliderBar.AbsolutePosition.X
            local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, 250)
            local value = minValue + (relativeX / 250) * (maxValue - minValue)
            value = math.floor(value * 100) / 100
            
            SliderButton.Position = UDim2.new(0, 40 + relativeX - 10, 0, 29)
            SliderFill.Size = UDim2.new(relativeX / 250, 0, 1, 0)
            Label.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    return Frame
end

-- ESP Tab
local ESPScroll = CreateInstance("ScrollingFrame", {
    Name = "Scroll_🎯 ESP",
    Parent = ContentContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    CanvasSize = UDim2.new(0, 0, 0, 600),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0),
    Visible = true,
    ZIndex = 55
})

CreatePremiumToggle(ESPScroll, "ESP Master", MenuConfig.ESP, "Enabled", UDim2.new(0, 10, 0, 10), "👁️")
CreatePremiumToggle(ESPScroll, "ESP Lines", MenuConfig.ESP, "Line", UDim2.new(0, 10, 0, 60), "📏")
CreatePremiumToggle(ESPScroll, "ESP Box", MenuConfig.ESP, "Box", UDim2.new(0, 10, 0, 110), "📦")
CreatePremiumToggle(ESPScroll, "ESP Distance", MenuConfig.ESP, "Distance", UDim2.new(0, 10, 0, 160), "📍")
CreatePremiumToggle(ESPScroll, "ESP Name", MenuConfig.ESP, "Name", UDim2.new(0, 10, 0, 210), "📛")
CreatePremiumToggle(ESPScroll, "ESP Health", MenuConfig.ESP, "Health", UDim2.new(0, 10, 0, 260), "💚")
CreatePremiumToggle(ESPScroll, "ESP Skeleton", MenuConfig.ESP, "Skeleton", UDim2.new(0, 10, 0, 310), "🦴")
CreatePremiumSlider(ESPScroll, "FOV Size", 50, 300, 150, UDim2.new(0, 10, 0, 360), "🎯", function(val)
    MenuConfig.ESP.FOVSize = val
end)

-- AIM Tab
local AIMScroll = CreateInstance("ScrollingFrame", {
    Name = "Scroll_⚡ AIM",
    Parent = ContentContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    CanvasSize = UDim2.new(0, 0, 0, 500),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0),
    Visible = false,
    ZIndex = 55
})

CreatePremiumToggle(AIMScroll, "Aim Head", MenuConfig.AIM, "HeadLock", UDim2.new(0, 10, 0, 10), "🎯")
CreatePremiumSlider(AIMScroll, "Aim Smoothness", 1, 15, 3, UDim2.new(0, 10, 0, 60), "🔄", function(val)
    MenuConfig.AIM.AimSmoothness = val
end)
CreatePremiumToggle(AIMScroll, "Aim Body", MenuConfig.AIM, "BodyLock", UDim2.new(0, 10, 0, 130), "⚡")
CreatePremiumToggle(AIMScroll, "Auto Attack", MenuConfig.AIM, "AutoAttack", UDim2.new(0, 10, 0, 180), "💥")

-- MEMORY Tab
local MEMORYScroll = CreateInstance("ScrollingFrame", {
    Name = "Scroll_💾 MEMORY",
    Parent = ContentContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    CanvasSize = UDim2.new(0, 0, 0, 800),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0),
    Visible = false,
    ZIndex = 55
})

CreatePremiumToggle(MEMORYScroll, "Invisible", MenuConfig.MEMORY, "Invisible", UDim2.new(0, 10, 0, 10), "👻")
CreatePremiumSlider(MEMORYScroll, "Speed", 16, 200, 16, UDim2.new(0, 10, 0, 60), "💨", function(val)
    MenuConfig.MEMORY.Speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)
CreatePremiumToggle(MEMORYScroll, "No Reload", MenuConfig.MEMORY, "NoReload", UDim2.new(0, 10, 0, 130), "🔄")
CreatePremiumToggle(MEMORYScroll, "Teleport Kill", MenuConfig.MEMORY, "TeleportKill", UDim2.new(0, 10, 0, 180), "⚔️")
CreatePremiumToggle(MEMORYScroll, "Walk Through Walls", MenuConfig.MEMORY, "WallHack", UDim2.new(0, 10, 0, 230), "🧱")
CreatePremiumSlider(MEMORYScroll, "Fire Rate", 1, 30, 8, UDim2.new(0, 10, 0, 280), "🔥", function(val)
    MenuConfig.MEMORY.FireRate = val
end)
CreatePremiumToggle(MEMORYScroll, "Spin Bot", MenuConfig.MEMORY, "SpinBot", UDim2.new(0, 10, 0, 350), "🌀")
CreatePremiumToggle(MEMORYScroll, "Lag Enemies", MenuConfig.MEMORY, "LagEnemies", UDim2.new(0, 10, 0, 400), "🐌")
CreatePremiumToggle(MEMORYScroll, "Auto Dodge", MenuConfig.MEMORY, "Dodge", UDim2.new(0, 10, 0, 450), "🏃")
CreatePremiumToggle(MEMORYScroll, "Fly", MenuConfig.MEMORY, "Fly", UDim2.new(0, 10, 0, 500), "🦅")

-- ADMIN Tab
local ADMINScroll = CreateInstance("ScrollingFrame", {
    Name = "Scroll_👑 ADMIN",
    Parent = ContentContainer,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    CanvasSize = UDim2.new(0, 0, 0, 500),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = Color3.fromRGB(255, 100, 0),
    Visible = false,
    ZIndex = 55
})

-- Lionel Tiến Mạnh (Rainbow Animated)
local LionelText = CreateInstance("TextLabel", {
    Name = "LionelText",
    Parent = ADMINScroll,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 0, 80),
    Position = UDim2.new(0, 10, 0, 20),
    Text = "LIONEL TIẾN MẠNH",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 28,
    TextTransparency = 0,
    ZIndex = 56
})

-- TikTok Text
local TikTokText = CreateInstance("TextLabel", {
    Name = "TikTokText",
    Parent = ADMINScroll,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, -20, 0, 50),
    Position = UDim2.new(0, 10, 0, 100),
    Text = "TikTok: lioneltienmanh 😎😎",
    TextColor3 = Color3.fromRGB(255, 200, 0),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextTransparency = 0,
    ZIndex = 56
})

-- Rainbow Animation for Lionel Text
spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.01) % 1
        LionelText.TextColor3 = Color3.fromHSV(hue, 1, 1)
        TikTokText.TextColor3 = Color3.fromHSV((hue + 0.5) % 1, 1, 1)
        RunService.RenderStepped:Wait()
    end
end)

-- Drag Functionality
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MenuConfig.Dragging = true
        MenuConfig.DragStart = input.Position
        MenuConfig.StartPos = MainContainer.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                MenuConfig.Dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if MenuConfig.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - MenuConfig.DragStart
        MainContainer.Position = UDim2.new(
            MenuConfig.StartPos.X.Scale,
            MenuConfig.StartPos.X.Offset + delta.X,
            MenuConfig.StartPos.Y.Scale,
            MenuConfig.StartPos.Y.Offset + delta.Y
        )
    end
end)

-- ESP System
local ESPObjects = {}

local function createESP(player)
    local espFolder = CreateInstance("Folder", {
        Name = "ESP_" .. player.Name,
        Parent = ScreenGui,
        ZIndex = 40
    })
    
    local box = CreateInstance("Frame", {
        Parent = espFolder,
        BackgroundColor3 = Color3.fromRGB(255, 80, 0),
        BackgroundTransparency = 0.75,
        BorderColor3 = Color3.fromRGB(255, 80, 0),
        BorderSizePixel = 2,
        Size = UDim2.new(0, 50, 0, 100),
        Visible = false,
        ZIndex = 40
    })
    
    local nameLabel = CreateInstance("TextLabel", {
        Parent = espFolder,
        BackgroundTransparency = 1,
        Text = player.Name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextTransparency = 0,
        Visible = false,
        ZIndex = 41
    })
    
    local distanceLabel = CreateInstance("TextLabel", {
        Parent = espFolder,
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 200, 0),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        Visible = false,
        ZIndex = 41
    })
    
    local healthBar = CreateInstance("Frame", {
        Parent = espFolder,
        BackgroundColor3 = Color3.fromRGB(0, 255, 0),
        BackgroundTransparency = 0.1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 50, 0, 3),
        Visible = false,
        ZIndex = 41
    })
    ApplyCorner(healthBar, 2)
    
    ESPObjects[player] = {
        Folder = espFolder,
        Box = box,
        NameLabel = nameLabel,
        DistanceLabel = distanceLabel,
        HealthBar = healthBar,
        Lines = {}
    }
end

local function updateESP()
    for player, espData in pairs(ESPObjects) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local humanoid = player.Character.Humanoid
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and MenuConfig.ESP.Enabled then
                local screenPos, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
                
                if onScreen then
                    espData.Box.Visible = MenuConfig.ESP.Box
                    espData.NameLabel.Visible = MenuConfig.ESP.Name
                    espData.DistanceLabel.Visible = MenuConfig.ESP.Distance
                    espData.HealthBar.Visible = MenuConfig.ESP.Health
                    
                    local size = Vector3.new(4, 6, 1)
                    local topPos = Camera:WorldToScreenPoint(rootPart.Position + Vector3.new(0, size.Y/2, 0))
                    local bottomPos = Camera:WorldToScreenPoint(rootPart.Position - Vector3.new(0, size.Y/2, 0))
                    
                    local height = math.abs(topPos.Y - bottomPos.Y)
                    local width = height * 0.6
                    
                    espData.Box.Size = UDim2.new(0, width, 0, height)
                    espData.Box.Position = UDim2.new(0, screenPos.X - width/2, 0, screenPos.Y - height/2)
                    
                    espData.NameLabel.Position = UDim2.new(0, screenPos.X - 25, 0, screenPos.Y - height/2 - 20)
                    espData.DistanceLabel.Position = UDim2.new(0, screenPos.X - 25, 0, screenPos.Y + height/2 + 5)
                    
                    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 0
                    espData.DistanceLabel.Text = string.format("%.1f studs", distance)
                    
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    espData.HealthBar.Size = UDim2.new(0, width * healthPercent, 0, 3)
                    espData.HealthBar.Position = UDim2.new(0, screenPos.X - width/2, 0, screenPos.Y + height/2 + 2)
                    espData.HealthBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                    
                    -- ESP Lines
                    if MenuConfig.ESP.Line then
                        local line = espData.Lines[1]
                        if not line then
                            line = CreateInstance("Frame", {
                                Parent = espData.Folder,
                                BackgroundColor3 = Color3.fromRGB(255, 150, 0),
                                BackgroundTransparency = 0.3,
                                BorderSizePixel = 0,
                                Size = UDim2.new(0, 2, 0, 100),
                                ZIndex = 39
                            })
                            espData.Lines[1] = line
                        end
                        line.Visible = true
                        line.Size = UDim2.new(0, 2, 0, math.abs(screenPos.Y - Camera.ViewportSize.Y/2))
                        line.Position = UDim2.new(0, Camera.ViewportSize.X/2, 0, math.min(screenPos.Y, Camera.ViewportSize.Y/2))
                    else
                        if espData.Lines[1] then
                            espData.Lines[1].Visible = false
                        end
                    end
                else
                    espData.Box.Visible = false
                    espData.NameLabel.Visible = false
                    espData.DistanceLabel.Visible = false
                    espData.HealthBar.Visible = false
                    for _, line in pairs(espData.Lines) do
                        line.Visible = false
                    end
                end
            else
                espData.Box.Visible = false
                espData.NameLabel.Visible = false
                espData.DistanceLabel.Visible = false
                espData.HealthBar.Visible = false
            end
        else
            espData.Box.Visible = false
            espData.NameLabel.Visible = false
            espData.DistanceLabel.Visible = false
            espData.HealthBar.Visible = false
        end
    end
end

-- Skeleton ESP (Sử dụng Drawing API)
local function drawSkeleton(player)
    local character = player.Character
    if not character then return end
    
    local joints = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"UpperTorso", "LowerTorso"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"}
    }
    
    for _, jointPair in pairs(joints) do
        local part1 = character:FindFirstChild(jointPair[1])
        local part2 = character:FindFirstChild(jointPair[2])
        
        if part1 and part2 then
            local pos1 = Camera:WorldToScreenPoint(part1.Position)
            local pos2 = Camera:WorldToScreenPoint(part2.Position)
            
            if pos1.Z > 0 and pos2.Z > 0 then
                local line = Drawing.new("Line")
                line.Visible = true
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Color = Color3.fromRGB(255, 255, 255)
                line.Thickness = 2
                line.Transparency = 0.8
                
                spawn(function()
                    RunService.RenderStepped:Wait()
                    line:Remove()
                end)
            end
        end
    end
end

-- AIM System
RunService.RenderStepped:Connect(function()
    if MenuConfig.AIM.HeadLock or MenuConfig.AIM.BodyLock then
        local target = nil
        local shortestDistance = math.huge
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
                if player.Character.Humanoid.Health > 0 then
                    local targetPart = MenuConfig.AIM.HeadLock and player.Character.Head or player.Character:FindFirstChild("UpperTorso")
                    
                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
                        
                        if onScreen then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            
                            if distance < shortestDistance and distance < MenuConfig.ESP.FOVSize then
                                shortestDistance = distance
                                target = targetPart
                            end
                        end
                    end
                end
            end
        end
        
        if target then
            local targetScreenPos = Camera:WorldToScreenPoint(target.Position)
            local targetPos2D = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
            
            local aimVector = (targetPos2D - screenCenter) / MenuConfig.AIM.AimSmoothness
            
            mousemoverel(aimVector.X, aimVector.Y)
        end
    end
end)

-- Memory Systems
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    if MenuConfig.MEMORY.Speed ~= 16 then
        humanoid.WalkSpeed = MenuConfig.MEMORY.Speed
    end
end)

-- No Reload
RunService.RenderStepped:Connect(function()
    if MenuConfig.MEMORY.NoReload then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Ammo") then
            tool.Ammo.Value = 999
        end
    end
end)

-- Fly
RunService.RenderStepped:Connect(function()
    if MenuConfig.MEMORY.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        local humanoid = LocalPlayer.Character.Humanoid
        
        humanoid.PlatformStand = true
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            rootPart.Velocity = Vector3.new(0, 50, 0)
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            rootPart.Velocity = Vector3.new(0, -50, 0)
        else
            rootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Spin Bot
RunService.RenderStepped:Connect(function()
    if MenuConfig.MEMORY.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, 0.15, 0)
    end
end)

-- Wall Hack
RunService.RenderStepped:Connect(function()
    if MenuConfig.MEMORY.WallHack then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- Teleport Kill
RunService.RenderStepped:Connect(function()
    if MenuConfig.MEMORY.TeleportKill and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = LocalPlayer.Character.HumanoidRootPart
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                if player.Character.Humanoid.Health > 0 then
                    local targetRoot = player.Character.HumanoidRootPart
                    rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 0)
                    
                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                    
                    break
                end
            end
        end
    end
end)

-- ESP Update
RunService.RenderStepped:Connect(function()
    updateESP()
    
    if MenuConfig.ESP.Skeleton then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                drawSkeleton(player)
            end
        end
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player].Folder:Destroy()
        ESPObjects[player] = nil
    end
end)

-- Init
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

SwitchTab("🎯 ESP")

print("💀 DEVILS WILL RISE v2.0 — ULTRA PREMIUM LOADED!")
print("👑 Owner: @dongkaa | Channel: @dongkaa")
print("🔥 Đồ họa: Ultra HD + Animation + Glow + Particle Fire")
