-- [[ CƯỜNG MÚP - FIX MENU HIỂN THỊ ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ============ SETTINGS ============
local SETTINGS = {
    ESP = true,
    Aimbot = false,
    FOV_Size = 200,
    MagicBullet = false,
    TeleKill = false,
    UnderKill = false,
    NoReload = false,
    Invisible = false,
}

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CUONG_MUP_MENU"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- ============ ICON ============
local MenuIcon = Instance.new("TextButton")
MenuIcon.Name = "MenuIcon"
MenuIcon.Size = UDim2.new(0, 55, 0, 55)
MenuIcon.Position = UDim2.new(0, 10, 0, 10)
MenuIcon.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
MenuIcon.Text = "👑"
MenuIcon.TextColor3 = Color3.new(1, 1, 1)
MenuIcon.Font = Enum.Font.GothamBold
MenuIcon.TextSize = 28
MenuIcon.BorderSizePixel = 0
MenuIcon.Parent = ScreenGui
MenuIcon.ZIndex = 2000

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 27)
IconCorner.Parent = MenuIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.new(255, 255, 0)
IconStroke.Thickness = 2
IconStroke.Parent = MenuIcon

-- ============ MENU CHÍNH ============
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 480)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.ZIndex = 1000

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 150, 0)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👑 CƯỜNG MÚP 👑"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = TitleBar

-- ============ TOGGLE MENU (FIX: Tách riêng click và drag) ============
local menuOpen = false
local isDragging = false
local dragStartPos = nil
local dragStartInput = nil
local dragThreshold = 5 -- Pixel threshold để phân biệt click và drag

-- Click để mở/đóng menu
MenuIcon.MouseButton1Click:Connect(function()
    if not isDragging then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
        
        if menuOpen then
            MenuIcon.Text = "✕"
            MenuIcon.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            MenuIcon.Text = "👑"
            MenuIcon.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
        end
    end
    isDragging = false -- Reset
end)

-- Drag icon
MenuIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
        dragStartPos = MenuIcon.Position
        dragStartInput = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragStartInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartInput
        if delta.Magnitude > dragThreshold then
            isDragging = true
            MenuIcon.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStartInput = nil
    end
end)

-- ============ TOGGLE BUTTONS ============
local function createToggle(name, y, default, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(1, -20, 0, 35)
    ToggleButton.Position = UDim2.new(0, 10, 0, y)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    ToggleButton.Text = name .. ": " .. (default and "ON" or "OFF")
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 13
    ToggleButton.BorderSizePixel = 0
    ToggleButton.BackgroundTransparency = 0.2
    ToggleButton.Parent = MainFrame
    ToggleButton.ZIndex = 1001
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = ToggleButton
    
    local state = default
    
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        ToggleButton.Text = name .. ": " .. (state and "ON" or "OFF")
        if callback then
            callback(state)
        end
    end)
    
    return function()
        return state
    end
end

-- ============ FOV SLIDER ============
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Size = UDim2.new(1, -20, 0, 20)
FOVLabel.Position = UDim2.new(0, 10, 0, 370)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "🎯 FOV Size: " .. SETTINGS.FOV_Size
FOVLabel.TextColor3 = Color3.new(1, 1, 1)
FOVLabel.Font = Enum.Font.GothamBold
FOVLabel.TextSize = 12
FOVLabel.Parent = MainFrame

local FOVSlider = Instance.new("TextBox")
FOVSlider.Size = UDim2.new(1, -20, 0, 30)
FOVSlider.Position = UDim2.new(0, 10, 0, 390)
FOVSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
FOVSlider.Text = tostring(SETTINGS.FOV_Size)
FOVSlider.TextColor3 = Color3.new(1, 1, 1)
FOVSlider.Font = Enum.Font.Gotham
FOVSlider.TextSize = 12
FOVSlider.BorderSizePixel = 0
FOVSlider.Parent = MainFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(0, 5)
FOVCorner.Parent = FOVSlider

FOVSlider.FocusLost:Connect(function()
    local value = tonumber(FOVSlider.Text)
    if value then
        SETTINGS.FOV_Size = math.clamp(value, 50, 1000)
        FOVLabel.Text = "🎯 FOV Size: " .. SETTINGS.FOV_Size
        fovCircle.Radius = SETTINGS.FOV_Size
    end
end)

-- ============ TẠO TOGGLES ============
local espToggle = createToggle("👁 ESP", 55, SETTINGS.ESP, function(state)
    SETTINGS.ESP = state
end)

local aimbotToggle = createToggle("🎯 Aimbot", 95, SETTINGS.Aimbot, function(state)
    SETTINGS.Aimbot = state
end)

local magicToggle = createToggle("✨ Magic Bullet", 135, SETTINGS.MagicBullet, function(state)
    SETTINGS.MagicBullet = state
end)

local teleKillToggle = createToggle("🔪 Tele Kill", 175, SETTINGS.TeleKill, function(state)
    SETTINGS.TeleKill = state
end)

local underKillToggle = createToggle("💀 Under Kill", 215, SETTINGS.UnderKill, function(state)
    SETTINGS.UnderKill = state
end)

local noReloadToggle = createToggle("🔄 No Reload", 255, SETTINGS.NoReload, function(state)
    SETTINGS.NoReload = state
end)

local invisToggle = createToggle("👻 Invisible", 295, SETTINGS.Invisible, function(state)
    SETTINGS.Invisible = state
    applyInvisible(state)
end)

-- ============ FOV CIRCLE ============
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.new(1, 1, 1)
fovCircle.Thickness = 2
fovCircle.Radius = SETTINGS.FOV_Size
fovCircle.Transparency = 0.7
fovCircle.Visible = false

-- ============ ESP SYSTEM ============
local ESP_List = {}

local function createESP(player)
    local esp = {}
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 255)
    box.Filled = false
    box.Visible = false
    esp.Box = box
    
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Visible = false
    esp.Line = line
    
    local nameLabel = Drawing.new("Text")
    nameLabel.Color = Color3.new(1, 1, 1)
    nameLabel.Size = 14
    nameLabel.Center = true
    nameLabel.Outline = true
    nameLabel.Visible = false
    esp.Name = nameLabel
    
    local distLabel = Drawing.new("Text")
    distLabel.Color = Color3.fromRGB(200, 200, 200)
    distLabel.Size = 12
    distLabel.Center = true
    distLabel.Outline = true
    distLabel.Visible = false
    esp.Dist = distLabel
    
    local hpBg = Drawing.new("Square")
    hpBg.Color = Color3.new(0, 0, 0)
    hpBg.Filled = true
    hpBg.Visible = false
    esp.HPBg = hpBg
    
    local hpBar = Drawing.new("Square")
    hpBar.Color = Color3.new(0, 1, 0)
    hpBar.Filled = true
    hpBar.Visible = false
    esp.HPBar = hpBar
    
    ESP_List[player] = esp
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if ESP_List[player] then
        for _, d in pairs(ESP_List[player]) do
            d:Remove()
        end
        ESP_List[player] = nil
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESP(p)
    end
end

-- ============ GET TARGET ============
local function getClosestPlayer()
    local closest = nil
    local closestDist = SETTINGS.FOV_Size
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") then
            local humanoid = p.Character.Humanoid
            if humanoid.Health > 0 then
                local head = p.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = p
                    end
                end
            end
        end
    end
    
    return closest
end

-- ============ SYSTEMS ============
local function magicBulletSystem()
    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    
    local targetHead = target.Character.Head
    local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("bullet") or name:find("projectile") or name:find("bolt") then
                obj.CFrame = targetHead.CFrame
                obj.Velocity = Vector3.new(0, 0, 0)
                if targetHumanoid then
                    targetHumanoid:TakeDamage(50)
                end
            end
        end
    end
end

local function teleKillSystem()
    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if targetHumanoid then
        targetHumanoid:TakeDamage(999999)
    end
end

local function underKillSystem()
    local target = getClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local targetRoot = target.Character.HumanoidRootPart
    targetRoot.CFrame = targetRoot.CFrame - Vector3.new(0, 100, 0)
end

local function noReloadSystem()
    if not LocalPlayer.Character then return end
    
    for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("AmmoValue") or tool:FindFirstChild("CurrentAmmo") or tool:FindFirstChild("Magazine")
            if ammo and (ammo:IsA("IntValue") or ammo:IsA("NumberValue")) then
                ammo.Value = 999999
            end
        end
    end
end

local function applyInvisible(enabled)
    if not LocalPlayer.Character then return end
    
    local character = LocalPlayer.Character
    
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = enabled and 1 or 0
        elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
            part.Handle.Transparency = enabled and 1 or 0
        end
    end
    
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = enabled and 1 or 0
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = enabled and 1 or 0
        end
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = enabled and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
    end
end

-- ============ MAIN LOOP ============
RunService.RenderStepped:Connect(function()
    -- ESP
    for player, esp in pairs(ESP_List) do
        if SETTINGS.ESP and player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local pos = root.Position
                local headPos = head and head.Position or pos + Vector3.new(0, 2, 0)
                local legPos = pos - Vector3.new(0, 3, 0)
                
                local headScreen, headOnScreen = Camera:WorldToViewportPoint(headPos)
                local legScreen, legOnScreen = Camera:WorldToViewportPoint(legPos)
                
                if headOnScreen or legOnScreen then
                    local height = math.abs(legScreen.Y - headScreen.Y)
                    local width = height * 0.6
                    
                    esp.Box.Visible = true
                    esp.Box.Position = Vector2.new(headScreen.X - width / 2, headScreen.Y)
                    esp.Box.Size = Vector2.new(width, height)
                    
                    esp.Line.Visible = true
                    esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    esp.Line.To = Vector2.new(headScreen.X, legScreen.Y)
                    
                    esp.Name.Visible = true
                    esp.Name.Position = Vector2.new(headScreen.X, headScreen.Y - 20)
                    esp.Name.Text = player.Name
                    
                    local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude) or 0
                    esp.Dist.Visible = true
                    esp.Dist.Position = Vector2.new(headScreen.X, headScreen.Y - 35)
                    esp.Dist.Text = string.format("%.0f m", dist)
                    
                    if humanoid.MaxHealth > 0 then
                        local hpPercent = humanoid.Health / humanoid.MaxHealth
                        esp.HPBg.Visible = true
                        esp.HPBg.Position = Vector2.new(headScreen.X - width / 2 - 6, headScreen.Y)
                        esp.HPBg.Size = Vector2.new(4, height)
                        
                        esp.HPBar.Visible = true
                        esp.HPBar.Position = Vector2.new(headScreen.X - width / 2 - 6, headScreen.Y + height * (1 - hpPercent))
                        esp.HPBar.Size = Vector2.new(4, height * hpPercent)
                        
                        if hpPercent > 0.5 then
                            esp.HPBar.Color = Color3.new(0, 1, 0)
                        elseif hpPercent > 0.25 then
                            esp.HPBar.Color = Color3.new(1, 1, 0)
                        else
                            esp.HPBar.Color = Color3.new(1, 0, 0)
                        end
                    end
                else
                    for _, d in pairs(esp) do
                        d.Visible = false
                    end
                end
            else
                for _, d in pairs(esp) do
                    d.Visible = false
                end
            end
        else
            for _, d in pairs(esp) do
                d.Visible = false
            end
        end
    end
    
    -- FOV
    fovCircle.Visible = SETTINGS.Aimbot
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fovCircle.Radius = SETTINGS.FOV_Size
    
    -- Aimbot
    if SETTINGS.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), 0.35)
        end
    end
    
    -- Systems
    if SETTINGS.MagicBullet then magicBulletSystem() end
    if SETTINGS.TeleKill then teleKillSystem() end
    if SETTINGS.UnderKill then underKillSystem() end
    if SETTINGS.NoReload then noReloadSystem() end
    if SETTINGS.Invisible and LocalPlayer.Character then applyInvisible(true) end
end)

print("👑 CƯỜNG MÚP MENU - ĐÃ LOAD!")
print("📌 Bấm icon 👑 góc trái để mở/đóng menu!")
