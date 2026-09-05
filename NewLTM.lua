-- [[ DEVILS WILL RISE - FULL SCRIPT SIÊU DÀI - ESP + AIM + MAGIC BULLET + TELEPORT + INVISIBLE ]]
-- Version: 2.0 Ultimate
-- Owner: @dongkaa
-- Channel: @dongkaa

-- ============ SERVICES ============
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

-- ============ SETTINGS ============
local SETTINGS = {
    ESP = {
        Enabled = true,
        BoxColor = Color3.fromRGB(255, 0, 255),
        LineColor = Color3.fromRGB(255, 0, 0),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistanceColor = Color3.fromRGB(200, 200, 200),
        BoxThickness = 2,
        LineThickness = 1,
        TextSize = 14,
        MaxDistance = 2000,
        TeamCheck = false,
        ShowBox = true,
        ShowLine = true,
        ShowName = true,
        ShowHealth = true,
        ShowDistance = true,
        ShowHealthBar = true,
    },
    
    Aimbot = {
        Enabled = false,
        FOV_Radius = 400,
        FOV_Color = Color3.fromRGB(255, 255, 255),
        FOV_Thickness = 3,
        FOV_Transparency = 0.7,
        AimSmoothness = 0.35,
        AimAtHead = true,
        VisibilityCheck = true,
        TeamCheck = false,
    },
    
    MagicBullet = {
        Enabled = false,
        Damage = 50,
        BulletSpeed = 1000,
        AutoTarget = true,
        TargetDistance = 400,
    },
    
    Teleport = {
        Enabled = false,
        Height = 500,
        LockPosition = true,
        UseBodyVelocity = true,
        UseBodyGyro = true,
        PlatformStand = true,
    },
    
    Invisible = {
        Enabled = false,
        HideBody = true,
        HideAccessories = true,
        HideClothing = true,
        HideTools = true,
        HideShadow = true,
        HideNameTag = true,
    },
}

-- ============ VARIABLES ============
local ESP_List = {}
local BodyVelocity = nil
local BodyGyro = nil
local SavedPosition = nil
local IsTeleported = false

-- ============ GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DWR_ULTIMATE_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Hàm tạo nút
local function createButton(name, y, default)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 60, 0, 30)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = name
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.BorderSizePixel = 0
    button.BackgroundTransparency = 0.1
    button.Parent = ScreenGui
    button.ZIndex = 999
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    return button
end

-- Tạo 5 nút
local espButton = createButton("ESP", 10, true)
local aimButton = createButton("AIM", 45, false)
local magicButton = createButton("MAGIC", 80, false)
local teleButton = createButton("TELE", 115, false)
local invisButton = createButton("INVIS", 150, false)

-- ============ DRAG SYSTEM ============
local function makeDraggable(button)
    local dragging = false
    local startPos = nil
    local dragStart = nil
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = button.Position
            dragStart = input.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

makeDraggable(espButton)
makeDraggable(aimButton)
makeDraggable(magicButton)
makeDraggable(teleButton)
makeDraggable(invisButton)

-- ============ TOGGLE FUNCTIONS ============
espButton.MouseButton1Click:Connect(function()
    SETTINGS.ESP.Enabled = not SETTINGS.ESP.Enabled
    espButton.BackgroundColor3 = SETTINGS.ESP.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

aimButton.MouseButton1Click:Connect(function()
    SETTINGS.Aimbot.Enabled = not SETTINGS.Aimbot.Enabled
    aimButton.BackgroundColor3 = SETTINGS.Aimbot.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

magicButton.MouseButton1Click:Connect(function()
    SETTINGS.MagicBullet.Enabled = not SETTINGS.MagicBullet.Enabled
    magicButton.BackgroundColor3 = SETTINGS.MagicBullet.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
end)

teleButton.MouseButton1Click:Connect(function()
    SETTINGS.Teleport.Enabled = not SETTINGS.Teleport.Enabled
    teleButton.BackgroundColor3 = SETTINGS.Teleport.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    if SETTINGS.Teleport.Enabled then
        teleportUp()
    else
        teleportDown()
    end
end)

invisButton.MouseButton1Click:Connect(function()
    SETTINGS.Invisible.Enabled = not SETTINGS.Invisible.Enabled
    invisButton.BackgroundColor3 = SETTINGS.Invisible.Enabled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    applyInvisible(SETTINGS.Invisible.Enabled)
end)

-- ============ ESP SYSTEM ============
local function createESP(player)
    local esp = {}
    
    -- Box
    local box = Drawing.new("Square")
    box.Thickness = SETTINGS.ESP.BoxThickness
    box.Color = SETTINGS.ESP.BoxColor
    box.Filled = false
    box.Transparency = 1
    box.Visible = false
    esp.Box = box
    
    -- Line
    local line = Drawing.new("Line")
    line.Thickness = SETTINGS.ESP.LineThickness
    line.Color = SETTINGS.ESP.LineColor
    line.Transparency = 1
    line.Visible = false
    esp.Line = line
    
    -- Name
    local nameLabel = Drawing.new("Text")
    nameLabel.Color = SETTINGS.ESP.NameColor
    nameLabel.Size = SETTINGS.ESP.TextSize
    nameLabel.Center = true
    nameLabel.Outline = true
    nameLabel.Visible = false
    esp.Name = nameLabel
    
    -- Distance
    local distLabel = Drawing.new("Text")
    distLabel.Color = SETTINGS.ESP.DistanceColor
    distLabel.Size = SETTINGS.ESP.TextSize - 2
    distLabel.Center = true
    distLabel.Outline = true
    distLabel.Visible = false
    esp.Dist = distLabel
    
    -- Health Background
    local hpBg = Drawing.new("Square")
    hpBg.Color = Color3.new(0, 0, 0)
    hpBg.Filled = true
    hpBg.Transparency = 1
    hpBg.Visible = false
    esp.HPBg = hpBg
    
    -- Health Bar
    local hpBar = Drawing.new("Square")
    hpBar.Color = Color3.new(0, 1, 0)
    hpBar.Filled = true
    hpBar.Transparency = 1
    hpBar.Visible = false
    esp.HPBar = hpBar
    
    ESP_List[player] = esp
    return esp
end

Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(function(player)
    if ESP_List[player] then
        for _, drawing in pairs(ESP_List[player]) do
            drawing:Remove()
        end
        ESP_List[player] = nil
    end
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- ============ FOV CIRCLE ============
local fovCircle = Drawing.new("Circle")
fovCircle.Color = SETTINGS.Aimbot.FOV_Color
fovCircle.Thickness = SETTINGS.Aimbot.FOV_Thickness
fovCircle.Radius = SETTINGS.Aimbot.FOV_Radius
fovCircle.Transparency = SETTINGS.Aimbot.FOV_Transparency
fovCircle.Visible = false

-- ============ TARGET SYSTEM ============
local function getClosestPlayerInFOV()
    local closest = nil
    local closestDist = SETTINGS.Aimbot.FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                -- Team check
                if SETTINGS.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                
                local head = player.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if distFromCenter < closestDist then
                        -- Visibility check
                        if SETTINGS.Aimbot.VisibilityCheck then
                            local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000)
                            local ignoreList = {LocalPlayer.Character}
                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
                            
                            if hit and hit:IsDescendantOf(player.Character) then
                                closestDist = distFromCenter
                                closest = player
                            end
                        else
                            closestDist = distFromCenter
                            closest = player
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- ============ MAGIC BULLET SYSTEM ============
local function magicBulletSystem()
    if not SETTINGS.MagicBullet.Enabled then return end
    if not LocalPlayer.Character then return end
    
    local target = getClosestPlayerInFOV()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    
    local targetHead = target.Character.Head
    local targetHumanoid = target.Character:FindFirstChildOfClass("Humanoid")
    
    -- Cách 1: Dịch chuyển đạn hiện có
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local objName = obj.Name:lower()
            if objName:find("bullet") or objName:find("projectile") or objName:find("bolt") or objName:find("shell") or objName:find("rocket") then
                obj.CFrame = targetHead.CFrame
                obj.Velocity = Vector3.new(0, 0, 0)
                
                -- Gây sát thương
                if targetHumanoid and targetHumanoid.Health > 0 then
                    targetHumanoid:TakeDamage(SETTINGS.MagicBullet.Damage)
                end
            end
        end
    end
    
    -- Cách 2: Tạo bullet mới từ súng
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local muzzle = tool:FindFirstChild("Muzzle") or tool:FindFirstChild("Barrel") or tool:FindFirstChild("Handle")
        if muzzle and muzzle:IsA("BasePart") then
            local fakeBullet = Instance.new("Part")
            fakeBullet.Name = "MagicBullet"
            fakeBullet.Size = Vector3.new(0.5, 0.5, 2)
            fakeBullet.Shape = Enum.PartType.Cylinder
            fakeBullet.Anchored = false
            fakeBullet.CanCollide = false
            fakeBullet.Material = Enum.Material.Neon
            fakeBullet.Color = Color3.new(1, 1, 0)
            fakeBullet.Transparency = 0.5
            fakeBullet.CFrame = CFrame.new(muzzle.Position, targetHead.Position)
            fakeBullet.Parent = workspace
            
            local direction = (targetHead.Position - muzzle.Position).Unit
            fakeBullet.Velocity = direction * SETTINGS.MagicBullet.BulletSpeed
            
            -- Tự xóa sau 2 giây
            Debris:AddItem(fakeBullet, 2)
            
            -- Gây sát thương khi trúng
            fakeBullet.Touched:Connect(function(hit)
                if hit:IsDescendantOf(target.Character) then
                    if targetHumanoid and targetHumanoid.Health > 0 then
                        targetHumanoid:TakeDamage(SETTINGS.MagicBullet.Damage)
                    end
                    fakeBullet:Destroy()
                end
            end)
        end
    end
end

-- ============ TELEPORT SYSTEM ============
local function teleportUp()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    -- Lưu vị trí ban đầu
    if not SavedPosition then
        SavedPosition = root.Position
    end
    
    -- Xóa body cũ
    for _, child in pairs(root:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyPosition") then
            child:Destroy()
        end
    end
    
    -- Tele lên cao
    root.CFrame = CFrame.new(root.Position.X, SETTINGS.Teleport.Height, root.Position.Z)
    
    -- Khóa vị trí
    if SETTINGS.Teleport.UseBodyVelocity then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Parent = root
    end
    
    -- Khóa xoay
    if SETTINGS.Teleport.UseBodyGyro then
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.CFrame = root.CFrame
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.D = 1000
        BodyGyro.P = 100000
        BodyGyro.Parent = root
    end
    
    -- PlatformStand để không rơi
    if SETTINGS.Teleport.PlatformStand and humanoid then
        humanoid.PlatformStand = true
    end
    
    IsTeleported = true
end

local function teleportDown()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = LocalPlayer.Character.HumanoidRootPart
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    
    -- Xóa body khóa
    for _, child in pairs(root:GetChildren()) do
        if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("BodyPosition") then
            child:Destroy()
        end
    end
    
    -- Cho phép rơi
    if humanoid then
        humanoid.PlatformStand = false
    end
    
    -- Rơi xuống đất
    root.Velocity = Vector3.new(0, -500, 0)
    
    IsTeleported = false
end

-- ============ INVISIBLE SYSTEM ============
local function applyInvisible(enabled)
    if not LocalPlayer.Character then return end
    
    local character = LocalPlayer.Character
    
    -- Ẩn body parts
    if SETTINGS.Invisible.HideBody then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = enabled and 1 or 0
            end
        end
    end
    
    -- Ẩn accessories
    if SETTINGS.Invisible.HideAccessories then
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") and accessory:FindFirstChild("Handle") then
                accessory.Handle.Transparency = enabled and 1 or 0
            end
        end
    end
    
    -- Ẩn quần áo
    if SETTINGS.Invisible.HideClothing then
        for _, clothing in pairs(character:GetChildren()) do
            if clothing:IsA("Shirt") or clothing:IsA("Pants") or clothing:IsA("Clothing") then
                clothing.Transparency = enabled and 1 or 0
            end
        end
    end
    
    -- Ẩn tool
    if SETTINGS.Invisible.HideTools then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                local handle = tool:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    handle.Transparency = enabled and 1 or 0
                end
            end
        end
    end
    
    -- Ẩn descendants
    for _, descendant in pairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.Transparency = enabled and 1 or 0
        elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
            descendant.Transparency = enabled and 1 or 0
        elseif descendant:IsA("SpecialMesh") then
            descendant.Transparency = enabled and 1 or 0
        end
    end
    
    -- Ẩn bóng
    if SETTINGS.Invisible.HideShadow then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = enabled and Enum.HumanoidDisplayDistanceType.None or Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end

-- ============ ESP UPDATE ============
local function updateESP()
    if not SETTINGS.ESP.Enabled then
        for _, esp in pairs(ESP_List) do
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
        return
    end
    
    for player, esp in pairs(ESP_List) do
        if player.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local root = player.Character.HumanoidRootPart
            local head = player.Character:FindFirstChild("Head")
            local humanoid = player.Character.Humanoid
            
            if humanoid.Health <= 0 then
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
                continue
            end
            
            -- Team check
            if SETTINGS.ESP.TeamCheck and player.Team == LocalPlayer.Team then
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
                continue
            end
            
            local pos = root.Position
            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (LocalPlayer.Character.HumanoidRootPart.Position - pos).Magnitude) or 0
            
            -- Max distance check
            if distance > SETTINGS.ESP.MaxDistance then
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
                continue
            end
            
            local headPos = head and head.Position or pos + Vector3.new(0, 2, 0)
            local legPos = pos - Vector3.new(0, 3, 0)
            
            local headScreen, headOnScreen = Camera:WorldToViewportPoint(headPos)
            local legScreen, legOnScreen = Camera:WorldToViewportPoint(legPos)
            
            if headOnScreen or legOnScreen then
                local height = math.abs(legScreen.Y - headScreen.Y)
                local width = height * 0.6
                
                -- Box
                if SETTINGS.ESP.ShowBox then
                    esp.Box.Visible = true
                    esp.Box.Position = Vector2.new(headScreen.X - width / 2, headScreen.Y)
                    esp.Box.Size = Vector2.new(width, height)
                else
                    esp.Box.Visible = false
   
