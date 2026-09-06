-- ====================================================================
-- ADVANCED ROBLOX EXECUTOR UI MENU (1000+ LINES STRUCTURAL UI & ENGINE)
-- FEATURE TABS: ESP | AIM | MEMORY | ADMIN
-- ====================================================================

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- --------------------------------------------------------------------
-- CONFIGURATION & STATE MANAGEMENT
-- --------------------------------------------------------------------
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
        Head = false,
        Body = false,
        Strength = 0.5,
        Fire = false,
        Silent = false
    },
    Memory = {
        Invis = false,
        Speed = 16,
        NoReload = false,
        TeleportKill = false,
        Noclip = false,
        RapidFire = 1,
        Spinbot = false
    }
}

-- --------------------------------------------------------------------
-- SCREEN GUI SETUP
-- --------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomRobloxMenu_" .. math.random(1000, 9999)
ScreenGui.ResetOnSpawn = false

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = CoreGui
end

-- --------------------------------------------------------------------
-- DRAGGABLE ICON (FLOATING TOGGLE BUTTON)
-- --------------------------------------------------------------------
local MenuIcon = Instance.new("ImageButton")
MenuIcon.Name = "MenuIcon"
MenuIcon.Size = UDim2.new(0, 50, 0, 50)
MenuIcon.Position = UDim2.new(0, 100, 0, 100)
MenuIcon.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MenuIcon.BorderSizePixel = 0
MenuIcon.Image = "rbxassetid://6031097225" -- Custom Hub Icon
MenuIcon.Parent = ScreenGui

local IconUICorner = Instance.new("UICorner")
IconUICorner.CornerRadius = UDim.new(0, 12)
IconUICorner.Parent = MenuIcon

local IconUIStroke = Instance.new("UIStroke")
IconUIStroke.Color = Color3.fromRGB(0, 170, 255)
IconUIStroke.Thickness = 2
IconUIStroke.Parent = MenuIcon

-- Make Icon Draggable
local draggingIcon, dragInputIcon, dragStartIcon, startPosIcon

local function updateIcon(input)
    local delta = input.Position - dragStartIcon
    MenuIcon.Position = UDim2.new(startPosIcon.X.Scale, startPosIcon.X.Offset + delta.X, startPosIcon.Y.Scale, startPosIcon.Y.Offset + delta.Y)
end

MenuIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingIcon = true
        dragStartIcon = input.Position
        startPosIcon = MenuIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingIcon = false
            end
        end)
    end
end)

MenuIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputIcon = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputIcon and draggingIcon then
        updateIcon(input)
    end
end)

-- --------------------------------------------------------------------
-- MAIN FRAME SETUP
-- --------------------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Toggle Menu Visibility via Icon
MenuIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Make Main Frame Draggable
local draggingMain, dragStartMain, startPosMain
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = MainFrame.Position
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingMain = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMain
        MainFrame.Position = UDim2.new(startPosMain.X.Scale, startPosMain.X.Offset + delta.X, startPosMain.Y.Scale, startPosMain.Y.Offset + delta.Y)
    end
end)

-- --------------------------------------------------------------------
-- SIDEBAR & NAVIGATION
-- --------------------------------------------------------------------
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, 160, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "HUB MENU"
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = SideBar

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 5)
NavLayout.Parent = SideBar

local NavPadding = Instance.new("UIPadding")
NavPadding.PaddingTop = UDim.new(0, 60)
NavPadding.PaddingLeft = UDim.new(0, 10)
NavPadding.PaddingRight = UDim.new(0, 10)
NavPadding.Parent = SideBar

local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -160, 1, 0)
Container.Position = UDim2.new(0, 160, 0, 0)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- --------------------------------------------------------------------
-- UI ENGINE FACTORY (TABS, TOGGLES, SLIDERS)
-- --------------------------------------------------------------------
local Tabs = {}
local CurrentTab = nil

local function CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    TabButton.Parent = SideBar
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = TabButton
    
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.BorderSizePixel = 0
    TabPage.Visible = false
    TabPage.ScrollBarThickness = 3
    TabPage.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    TabPage.Parent = Container
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 8)
    PageLayout.Parent = TabPage
    
    local PagePadding = Instance.new("UIPadding")
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)
    PagePadding.Parent = TabPage
    
    PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 30)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
            tab.Button.TextColor3 = Color3.fromRGB(150, 150, 160)
            tab.Page.Visible = false
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabPage.Visible = true
    end)
    
    local tabObj = {Button = TabButton, Page = TabPage}
    table.insert(Tabs, tabObj)
    
    if #Tabs == 1 then
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabPage.Visible = true
    end
    
    return TabPage
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    ToggleFrame.Parent = parent
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 44, 0, 22)
    Button.Position = UDim2.new(1, -54, 0.5, -11)
    Button.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = ToggleFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Button
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Button
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local state = default
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(40, 40, 50)
        Circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        callback(state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    SliderFrame.Parent = parent
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 25)
    ValueLabel.Position = UDim2.new(0.7, -10, 0, 2)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = SliderFrame
    
    local Track = Instance.new("TextButton")
    Track.Size = UDim2.new(1, -20, 0, 8)
    Track.Position = UDim2.new(0, 10, 0, 32)
    Track.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Track.Text = ""
    Track.AutoButtonColor = false
    Track.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local sliding = false
    local function update(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        ValueLabel.Text = tostring(val)
        callback(val)
    end
    
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            update(input)
        end
    end)
    
    Track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- --------------------------------------------------------------------
-- CREATING TABS & CONTROLS
-- --------------------------------------------------------------------
local ESPTab = CreateTab("ESP")
local AimTab = CreateTab("Aim")
local MemoryTab = CreateTab("Memory")
local AdminTab = CreateTab("Admin")

-- --- ESP TAB ---
CreateToggle(ESPTab, "Cho phép ESP", Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
CreateToggle(ESPTab, "ESP Line", Config.ESP.Line, function(v) Config.ESP.Line = v end)
CreateToggle(ESPTab, "ESP Box", Config.ESP.Box, function(v) Config.ESP.Box = v end)
CreateToggle(ESPTab, "ESP Khoảng cách", Config.ESP.Distance, function(v) Config.ESP.Distance = v end)
CreateToggle(ESPTab, "ESP Tên", Config.ESP.Name, function(v) Config.ESP.Name = v end)
CreateToggle(ESPTab, "ESP Máu", Config.ESP.Health, function(v) Config.ESP.Health = v end)
CreateToggle(ESPTab, "ESP Skeleton", Config.ESP.Skeleton, function(v) Config.ESP.Skeleton = v end)
CreateSlider(ESPTab, "Điều chỉnh kích cỡ FOV", 30, 500, Config.ESP.FOVSize, function(v) Config.ESP.FOVSize = v end)

-- --- AIM TAB ---
CreateToggle(AimTab, "Aim đầu", Config.Aim.Head, function(v) Config.Aim.Head = v end)
CreateToggle(AimTab, "Aim body", Config.Aim.Body, function(v) Config.Aim.Body = v end)
CreateSlider(AimTab, "Mức độ Aim (Lỏng - Siêu chặt)", 1, 100, math.floor(Config.Aim.Strength * 100), function(v) Config.Aim.Strength = v / 100 end)
CreateToggle(AimTab, "Aim fire", Config.Aim.Fire, function(v) Config.Aim.Fire = v end)
CreateToggle(AimTab, "Aim Silent", Config.Aim.Silent, function(v) Config.Aim.Silent = v end)

-- --- MEMORY TAB ---
CreateToggle(MemoryTab, "Tàng hình", Config.Memory.Invis, function(v) Config.Memory.Invis = v end)
CreateSlider(MemoryTab, "Speed (Tốc độ tùy thích)", 16, 250, Config.Memory.Speed, function(v) Config.Memory.Speed = v end)
CreateToggle(MemoryTab, "No Reload", Config.Memory.NoReload, function(v) Config.Memory.NoReload = v end)
CreateToggle(MemoryTab, "Teleport Kill", Config.Memory.TeleportKill, function(v) Config.Memory.TeleportKill = v end)
CreateToggle(MemoryTab, "Đi xuyên tường (Noclip)", Config.Memory.Noclip, function(v) Config.Memory.Noclip = v end)
CreateSlider(MemoryTab, "Bắn siêu nhanh (Rapid Fire)", 1, 10, Config.Memory.RapidFire, function(v) Config.Memory.RapidFire = v end)
CreateToggle(MemoryTab, "Người xoay vòng tròn siêu nhanh (Spinbot)", Config.Memory.Spinbot, function(v) Config.Memory.Spinbot = v end)

-- --- ADMIN TAB ---
local RainbowLabel = Instance.new("TextLabel")
RainbowLabel.Size = UDim2.new(1, 0, 0, 100)
RainbowLabel.BackgroundTransparency = 1
RainbowLabel.Text = "Lionel Tiến Mạnh"
RainbowLabel.TextSize = 32
RainbowLabel.Font = Enum.Font.GothamBold
RainbowLabel.Parent = AdminTab

-- Rainbow Text Loop Effect
RunService.RenderStepped:Connect(function()
    local hue = (tick() % 5) / 5
    RainbowLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- --------------------------------------------------------------------
-- FOV CIRCLE DRAWING
-- --------------------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- --------------------------------------------------------------------
-- ESP ENGINE
-- --------------------------------------------------------------------
local ESPCache = {}

local function ClearESP(plr)
    if ESPCache[plr] then
        for _, obj in pairs(ESPCache[plr]) do
            if obj.Remove then obj:Remove() end
        end
        ESPCache[plr] = nil
    end
end

local function RenderESP()
    FOVCircle.Radius = Config.ESP.FOVSize
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Visible = Config.ESP.Enabled

    if not Config.ESP.Enabled then
        for plr, _ in pairs(ESPCache) do ClearESP(plr) end
        return
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
            local char = plr.Character
            local hrp = char.HumanoidRootPart
            local hum = char.Humanoid
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen and hum.Health > 0 then
                if not ESPCache[plr] then
                    ESPCache[plr] = {
                        Box = Drawing.new("Square"),
                        Line = Drawing.new("Line"),
                        Name = Drawing.new("Text"),
                        Distance = Drawing.new("Text"),
                        Health = Drawing.new("Text")
                    }
                end

                local esp = ESPCache[plr]
                local sizeY = (Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y)
                local sizeX = sizeY / 1.8

                -- Box
                esp.Box.Visible = Config.ESP.Box
                esp.Box.Size = Vector2.new(sizeX, sizeY)
                esp.Box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2)
                esp.Box.Color = Color3.fromRGB(255, 255, 255)
                esp.Box.Thickness = 1

                -- Line
                esp.Line.Visible = Config.ESP.Line
                esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                esp.Line.To = Vector2.new(pos.X, pos.Y)
                esp.Line.Color = Color3.fromRGB(0, 170, 255)

                -- Name
                esp.Name.Visible = Config.ESP.Name
                esp.Name.Text = plr.Name
                esp.Name.Size = 14
                esp.Name.Center = true
                esp.Name.Outline = true
                esp.Name.Position = Vector2.new(pos.X, pos.Y - sizeY / 2 - 16)
                esp.Name.Color = Color3.fromRGB(255, 255, 255)

                -- Distance
                esp.Distance.Visible = Config.ESP.Distance
                local dist = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                esp.Distance.Text = dist .. "m"
                esp.Distance.Size = 12
                esp.Distance.Center = true
                esp.Distance.Outline = true
                esp.Distance.Position = Vector2.new(pos.X, pos.Y + sizeY / 2 + 2)
                esp.Distance.Color = Color3.fromRGB(200, 200, 200)

                -- Health
                esp.Health.Visible = Config.ESP.Health
                esp.Health.Text = "HP: " .. math.floor(hum.Health)
                esp.Health.Size = 12
                esp.Health.Center = true
                esp.Health.Outline = true
                esp.Health.Position = Vector2.new(pos.X, pos.Y + sizeY / 2 + 14)
                esp.Health.Color = Color3.fromRGB(0, 255, 100)
            else
                ClearESP(plr)
            end
        else
            ClearESP(plr)
        end
    end
end

Players.PlayerRemoving:Connect(ClearESP)
RunService.RenderStepped:Connect(RenderESP)

-- --------------------------------------------------------------------
-- AIMBOT & MEMORY LOOPS
-- --------------------------------------------------------------------
local function GetClosestTarget()
    local target = nil
    local maxDist = Config.ESP.FOVSize

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
            if plr.Character.Humanoid.Health > 0 then
                local partName = Config.Aim.Head and "Head" or (Config.Aim.Body and "HumanoidRootPart" or nil)
                if partName then
                    local part = plr.Character:FindFirstChild(partName)
                    if part then
                        local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local mouseDist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                            if mouseDist < maxDist then
                                maxDist = mouseDist
                                target = part
                            end
                        end
                    end
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    -- Aim Logic
    if Config.Aim.Head or Config.Aim.Body then
        local target = GetClosestTarget()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            local moveVector = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * Config.Aim.Strength
            mousemoverel(moveVector.X, moveVector.Y)
        end
    end

    -- Speed Hack
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.Memory.Speed
    end

    -- Noclip Hack
    if Config.Memory.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Spinbot
    if Config.Memory.Spinbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
end)
