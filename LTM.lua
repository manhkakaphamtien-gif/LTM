-- [[ DEVILS WILL RISE - ESP + AIM + MAGIC BULLET + TELEPORT ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- ============ SETTINGS ============
local ESP_ON = true
local AIM_ON = false
local MAGIC_ON = false
local TELE_ON = false

-- ============ GUI ============
local gui = Instance.new("ScreenGui")
gui.Name = "DWR_GUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Tạo nút
local function makeButton(name, y, default)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 0.1
    btn.Parent = gui
    btn.ZIndex = 999
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    return btn
end

-- Tạo 4 nút
local espBtn = makeButton("ESP", 10, true)
local aimBtn = makeButton("AIM", 45, false)
local magicBtn = makeButton("MAGIC", 80, false)
local teleBtn = makeButton("TELE", 115, false)

-- Kéo thả nút
local function makeDraggable(btn)
    local dragging = false
    local startPos = nil
    local dragStart = nil
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = btn.Position
            dragStart = input.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(espBtn)
makeDraggable(aimBtn)
makeDraggable(magicBtn)
makeDraggable(teleBtn)

-- ============ TOGGLE ============
espBtn.MouseButton1Click:Connect(function()
    ESP_ON = not ESP_ON
    espBtn.BackgroundColor3 = ESP_ON and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

aimBtn.MouseButton1Click:Connect(function()
    AIM_ON = not AIM_ON
    aimBtn.BackgroundColor3 = AIM_ON and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

magicBtn.MouseButton1Click:Connect(function()
    MAGIC_ON = not MAGIC_ON
    magicBtn.BackgroundColor3 = MAGIC_ON and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

teleBtn.MouseButton1Click:Connect(function()
    TELE_ON = not TELE_ON
    teleBtn.BackgroundColor3 = TELE_ON and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    -- Khi bật TELE, teleport ngay lập tức
    if TELE_ON and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.CFrame = root.CFrame + Vector3.new(0, 100, 0) -- Tele lên cao 100 studs
    end
end)

-- ============ ESP ============
local espList = {}

local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 255)
    box.Filled = false
    box.Visible = false
    
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = Color3.fromRGB(255, 0, 0)
    line.Visible = false
    
    local nameLabel = Drawing.new("Text")
    nameLabel.Color = Color3.new(1,1,1)
    nameLabel.Size = 14
    nameLabel.Center = true
    nameLabel.Outline = true
    nameLabel.Visible = false
    
    local distLabel = Drawing.new("Text")
    distLabel.Color = Color3.fromRGB(200,200,200)
    distLabel.Size = 12
    distLabel.Center = true
    distLabel.Outline = true
    distLabel.Visible = false
    
    local hpBg = Drawing.new("Square")
    hpBg.Color = Color3.new(0,0,0)
    hpBg.Filled = true
    hpBg.Visible = false
    
    local hpBar = Drawing.new("Square")
    hpBar.Color = Color3.new(0,1,0)
    hpBar.Filled = true
    hpBar.Visible = false
    
    espList[player] = {
        Box = box,
        Line = line,
        Name = nameLabel,
        Dist = distLabel,
        HPBg = hpBg,
        HPBar = hpBar
    }
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if espList[player] then
        for _, d in pairs(espList[player]) do
            d:Remove()
        end
        espList[player] = nil
    end
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        createESP(p)
    end
end

-- ============ FOV ============
local fov = Drawing.new("Circle")
fov.Color = Color3.new(1,1,1)
fov.Thickness = 3
fov.Radius = 400
fov.Transparency = 0.7
fov.Visible = false

-- ============ GET PLAYER TRONG FOV ============
local function getPlayerInFOV()
    local closest = nil
    local closestDist = 400
    local screenCenter = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
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
    
    return closest
end

-- ============ MAGIC BULLET ============
local function magicBullet()
    if not MAGIC_ON then return end
    if not LocalPlayer.Character then return end
    
    -- Tìm tool đang cầm
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- Tìm target gần crosshair nhất
    local target = getPlayerInFOV()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    
    -- Tìm đạn/bullet trong tool
    local bullet = tool:FindFirstChild("Bullet") or tool:FindFirstChild("Ammo") or tool:FindFirstChild("Projectile")
    
    if bullet then
        -- Set vị trí đạn trúng đầu mục tiêu
        if bullet:IsA("BasePart") then
            bullet.CFrame = target.Character.Head.CFrame
        elseif bullet:IsA("NumberValue") or bullet:IsA("IntValue") then
            bullet.Value = 999999
        end
    end
    
    -- Tìm script bắn và chỉnh hướng
    for _, descendant in pairs(tool:GetDescendants()) do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            -- Tìm các biến mục tiêu
            local targetValue = descendant:FindFirstChild("Target") or descendant:FindFirstChild("TargetPlayer")
            if targetValue and (targetValue:IsA("ObjectValue") or targetValue:IsA("StringValue")) then
                if targetValue:IsA("ObjectValue") then
                    targetValue.Value = target.Character.Head
                else
                    targetValue.Value = target.Name
                end
            end
        end
    end
end

-- ============ TELEPORT TRÊN CAO ============
local function teleportUp()
    if not TELE_ON then return end
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = LocalPlayer.Character.HumanoidRootPart
    -- Giữ người chơi ở độ cao 100 studs
    if root.Position.Y < 90 then
        root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
    end
end

-- ============ MAIN LOOP ============
RunService.RenderStepped:Connect(function()
    -- ESP Update
    for player, esp in pairs(espList) do
        if ESP_ON and player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            local pos = root.Position
            local headPos = head and head.Position or pos + Vector3.new(0, 2, 0)
            local legPos = pos - Vector3.new(0, 3, 0)
            
            local headScreen, headOnScreen = Camera:WorldToViewportPoint(headPos)
            local legScreen, legOnScreen = Camera:WorldToViewportPoint(legPos)
            
            if headOnScreen or legOnScreen then
                local height = math.abs(legScreen.Y - headScreen.Y)
                local width = height * 0.6
                
                esp.Box.Visible = true
                esp.Box.Position = Vector2.new(headScreen.X - width/2, headScreen.Y)
                esp.Box.Size = Vector2.new(width, height)
                
                esp.Line.Visible = true
                esp.Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                esp.Line.To = Vector2.new(headScreen.X, legScreen.Y)
                
                esp.Name.Visible = true
                esp.Name.Position = Vector2.new(headScreen.X, headScreen.Y - 20)
                esp.Name.Text = player.Name
                
                local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude) or 0
                esp.Dist.Visible = true
                esp.Dist.Position = Vector2.new(headScreen.X, headScreen.Y - 35)
                esp.Dist.Text = string.format("%.0f m", dist)
                
                if humanoid and humanoid.MaxHealth > 0 then
                    local hpPercent = humanoid.Health / humanoid.MaxHealth
                    esp.HPBg.Visible = true
                    esp.HPBg.Position = Vector2.new(headScreen.X - width/2 - 6, headScreen.Y)
                    esp.HPBg.Size = Vector2.new(4, height)
                    
                    esp.HPBar.Visible = true
                    esp.HPBar.Position = Vector2.new(headScreen.X - width/2 - 6, headScreen.Y + height * (1 - hpPercent))
                    esp.HPBar.Size = Vector2.new(4, height * hpPercent)
                    
                    if hpPercent > 0.5 then
                        esp.HPBar.Color = Color3.new(0,1,0)
                    elseif hpPercent > 0.25 then
                        esp.HPBar.Color = Color3.new(1,1,0)
                    else
                        esp.HPBar.Color = Color3.new(1,0,0)
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
    fov.Visible = AIM_ON
    fov.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    -- Aimbot (gần crosshair nhất trong FOV)
    if AIM_ON then
        local target = getPlayerInFOV()
        
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, head.Position), 0.35)
        end
    end
    
    -- Magic Bullet
    if MAGIC_ON then
        magicBullet()
    end
    
    -- Teleport giữ trên cao
    if TELE_ON then
        teleportUp()
    end
end)

print("✅ Script loaded! ESP | AIM | MAGIC | TELE - Kéo thả nút được!")
