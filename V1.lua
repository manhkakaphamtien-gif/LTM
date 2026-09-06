-- [[ DEVILS WILL RISE - ULTIMATE HUB EDITION ]]
-- Phím tắt ẩn/hiện Menu: RightControl | Nút [MENU] có thể kéo thả tự do

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- ================== CẤU HÌNH HỆ THỐNG & TRẠNG THÁI ==================
local SETTINGS = {
    -- ESP CONFIG
    ESP_Master = false,
    ESP_Line = false,
    ESP_Box = false,
    ESP_Distance = false,
    ESP_Name = false,
    ESP_Health = false,
    ESP_Skeleton = false,
    FOV_Radius = 200,
    
    -- AIM CONFIG
    Aim_Head = true,
    Aim_Body = false,
    Aim_Fire = false,
    Aim_Silent = false,
    
    -- MEMORY CONFIG
    Invisible = false,
    WalkSpeed = 16,
    NoReload = false,
    TeleportKill = false,
    Noclip = false,
    RapidFire = 1,
    SpinBot = false,
}

local ESP_Storage = {}

-- ================== HELPER: HÀM TẠO TÍNH NĂNG KÉO THẢ (DRAGGABLE) ==================
local function MakeDraggable(guiObject)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ================== ESP CORE ENGINE ==================
local function CreateESPComponents(player)
    if ESP_Storage[player] then return end
    
    local drawings = {
        Box = Drawing.new("Square"),
        Line = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
        HealthBg = Drawing.new("Square"),
        HealthBar = Drawing.new("Square"),
        SkeletonLines = {}
    }
    
    drawings.Box.Thickness = 1.5
    drawings.Box.Color = Color3.fromRGB(255, 0, 100)
    drawings.Box.Filled = false
    drawings.Box.Visible = false
    
    drawings.Line.Thickness = 1
    drawings.Line.Color = Color3.fromRGB(0, 255, 255)
    drawings.Line.Visible = false
    
    drawings.Name.Size = 13
    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Color = Color3.fromRGB(255, 255, 255)
    drawings.Name.Visible = false
    
    drawings.Distance.Size = 11
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    drawings.Distance.Color = Color3.fromRGB(200, 200, 200)
    drawings.Distance.Visible = false
    
    drawings.HealthBg.Thickness = 1
    drawings.HealthBg.Color = Color3.fromRGB(0, 0, 0)
    drawings.HealthBg.Filled = true
    drawings.HealthBg.Visible = false
    
    drawings.HealthBar.Thickness = 1
    drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    drawings.HealthBar.Filled = true
    drawings.HealthBar.Visible = false
    
    for i = 1, 6 do
        local l = Drawing.new("Line")
        l.Thickness = 1
        l.Color = Color3.fromRGB(255, 255, 255)
        l.Visible = false
        table.insert(drawings.SkeletonLines, l)
    end
    
    ESP_Storage[player] = drawings
end

local function RemoveESPComponents(player)
    if ESP_Storage[player] then
        for _, obj in pairs(ESP_Storage[player]) do
            if type(obj) == "table" then
                for _, line in pairs(obj) do line:Remove() end
            else
                obj:Remove()
            end
        end
        ESP_Storage[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for player, esp in pairs(ESP_Storage) do
        local character = player.Character
        if SETTINGS.ESP_Master and character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid") then
            local rootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if head and humanoid.Health > 0 then
                local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
                
                if onScreen then
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height * 0.55
                    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) 
                        and math.floor((LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude) or 0
                    
                    if SETTINGS.ESP_Box then
                        esp.Box.Size = Vector2.new(width, height)
                        esp.Box.Position = Vector2.new(rootPos.X - width/2, headPos.Y)
                        esp.Box.Visible = true
                    else esp.Box.Visible = false end
                    
                    if SETTINGS.ESP_Line then
                        esp.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        esp.Line.To = Vector2.new(rootPos.X, legPos.Y)
                        esp.Line.Visible = true
                    else esp.Line.Visible = false end
                    
                    if SETTINGS.ESP_Name then
                        esp.Name.Text = player.Name
                        esp.Name.Position = Vector2.new(rootPos.X, headPos.Y - 16)
                        esp.Name.Visible = true
                    else esp.Name.Visible = false end
                    
                    if SETTINGS.ESP_Distance then
                        esp.Distance.Text = tostring(distance) .. "m"
                        esp.Distance.Position = Vector2.new(rootPos.X, legPos.Y + 2)
                        esp.Distance.Visible = true
                    else esp.Distance.Visible = false end
                    
                    if SETTINGS.ESP_Health then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.HealthBg.Size = Vector2.new(3, height)
                        esp.HealthBg.Position = Vector2.new(rootPos.X - width/2 - 6, headPos.Y)
                        esp.HealthBg.Visible = true
                        
                        esp.HealthBar.Size = Vector2.new(3, height * healthPercent)
                        esp.HealthBar.Position = Vector2.new(rootPos.X - width/2 - 6, headPos.Y + (height * (1 - healthPercent)))
                        esp.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                        esp.HealthBar.Visible = true
                    else 
                        esp.HealthBg.Visible = false 
                        esp.HealthBar.Visible = false 
                    end
                    
                    if SETTINGS.ESP_Skeleton then
                        local joints = {
                            {"Head", "UpperTorso"},
                            {"UpperTorso", "LowerTorso"},
                            {"UpperTorso", "LeftUpperArm"},
                            {"UpperTorso", "RightUpperArm"},
                            {"LowerTorso", "LeftUpperLeg"},
                            {"LowerTorso", "RightUpperLeg"}
                        }
                        for idx, pair in ipairs(joints) do
                            local partA = character:FindFirstChild(pair[1]) or character:FindFirstChild("Torso")
                            local partB = character:FindFirstChild(pair[2])
                            if partA and partB then
                                local pA, visA = Camera:WorldToViewportPoint(partA.Position)
                                local pB, visB = Camera:WorldToViewportPoint(partB.Position)
                                if visA and visB then
                                    esp.SkeletonLines[idx].From = Vector2.new(pA.X, pA.Y)
                                    esp.SkeletonLines[idx].To = Vector2.new(pB.X, pB.Y)
                                    esp.SkeletonLines[idx].Visible = true
                                else
                                    esp.SkeletonLines[idx].Visible = false
                                end
                            else
                                esp.SkeletonLines[idx].Visible = false
                            end
                        end
                    else
                        for _, line in pairs(esp.SkeletonLines) do line.Visible = false end
                    end
                    
                else
                    esp.Box.Visible = false
                    esp.Line.Visible = false
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    esp.HealthBg.Visible = false
                    esp.HealthBar.Visible = false
                    for _, line in pairs(esp.SkeletonLines) do line.Visible = false end
                end
            end
        else
            esp.Box.Visible = false
            esp.Line.Visible = false
            esp.Name.Visible = false
            esp.Distance.Visible = false
            esp.HealthBg.Visible = false
            esp.HealthBar.Visible = false
            for _, line in pairs(esp.SkeletonLines) do line.Visible = false end
        end
    end
end)

for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESPComponents(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESPComponents(p) end end)
Players.PlayerRemoving:Connect(function(p) RemoveESPComponents(p) end)

-- ================== AIMBOT ENGINE (CÓ KIỂM TRA TƯỜNG / VISIBILITY CHECK) ==================
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Thickness = 1.5
FOV_Circle.Color = Color3.fromRGB(0, 255, 150)
FOV_Circle.Transparency = 0.8
FOV_Circle.Filled = false
FOV_Circle.Visible = true

-- Hàm Raycast kiểm tra đường nhìn thấy kẻ địch hay bị che khuất
local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = RaycastFilterType.Exclude
    
    local ignoreList = {Camera}
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    raycastParams.FilterDescendantsInstances = ignoreList

    local result = Workspace:Raycast(origin, direction, raycastParams)
    
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
        return false
    end
    return true
end

local function GetClosestTarget()
    local closestPlayer = nil
    local shortestDist = SETTINGS.FOV_Radius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPartName = SETTINGS.Aim_Head and "Head" or "HumanoidRootPart"
            local targetPart = player.Character:FindFirstChild(targetPartName)
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if targetPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < shortestDist then
                        -- CHỈ AIM KHI NHÌN THẤY MỤC TIÊU (VISIBILITY CHECK)
                        if IsVisible(targetPart) then
                            shortestDist = dist
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    FOV_Circle.Radius = SETTINGS.FOV_Radius
    FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local target = GetClosestTarget()
    if target and target.Character then
        local targetPartName = SETTINGS.Aim_Head and "Head" or "HumanoidRootPart"
        local targetPart = target.Character:FindFirstChild(targetPartName)
        
        if targetPart then
            if not SETTINGS.Aim_Silent then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
            end
            
            if SETTINGS.Aim_Fire then
                mouse1press()
                task.wait(0.05)
                mouse1release()
            end
        end
    end
end)

-- ================== MEMORY ENGINE ==================
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = SETTINGS.WalkSpeed
    end
end)

RunService.Stepped:Connect(function()
    if SETTINGS.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if SETTINGS.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0)
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if SETTINGS.TeleportKill then
            local target = GetClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                end
            end
        end
    end
end)

-- ================== GIAO DIỆN CHÍNH (GUI MENU ENGINE) ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DevilsWillRise_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Nút Thu Nhỏ / Mở Menu (KÈM KHẢ NĂNG KÉO THẢ TỰ DO)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 90, 0, 32)
toggleBtn.Position = UDim2.new(0, 15, 0, 15)
toggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
toggleBtn.TextColor3 = Color3.fromRGB(0, 255, 180)
toggleBtn.Text = "MENU [ON]"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Active = true
toggleBtn.Parent = ScreenGui

local tbCorner = Instance.new("UICorner") tbCorner.CornerRadius = UDim.new(0, 6) tbCorner.Parent = toggleBtn
local tbStroke = Instance.new("UIStroke") tbStroke.Color = Color3.fromRGB(0, 255, 180) tbStroke.Thickness = 1.5 tbStroke.Parent = toggleBtn

-- Cho phép kéo thả Icon Menu
MakeDraggable(toggleBtn)

-- Khung Main Menu (Cũng hỗ trợ kéo thả)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 350)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

MakeDraggable(MainFrame)

local mfCorner = Instance.new("UICorner") mfCorner.CornerRadius = UDim.new(0, 8) mfCorner.Parent = MainFrame
local mfStroke = Instance.new("UIStroke") mfStroke.Color = Color3.fromRGB(120, 0, 255) mfStroke.Thickness = 2 mfStroke.Parent = MainFrame

local headerLabel = Instance.new("TextLabel")
headerLabel.Size = UDim2.new(1, 0, 0, 40)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "DEVILS WILL RISE — CHEAT SYSTEM"
headerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
headerLabel.Font = Enum.Font.GothamBlack
headerLabel.TextSize = 14
headerLabel.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 125, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = TabContainer

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -135, 1, -50)
ContentContainer.Position = UDim2.new(0, 130, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local TabBtns = {}

local function CreateTab(tabName)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 0, 255)
    scroll.Visible = false
    scroll.Parent = ContentContainer
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroll
    
    Tabs[tabName] = scroll
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 32)
    btn.Position = UDim2.new(0, 6, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = TabContainer
    
    local bCorner = Instance.new("UICorner") bCorner.CornerRadius = UDim.new(0, 6) bCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for name, page in pairs(Tabs) do page.Visible = (name == tabName) end
        for _, button in pairs(TabBtns) do
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            button.TextColor3 = Color3.fromRGB(180, 180, 180)
        end
        btn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    table.insert(TabBtns, btn)
    return scroll
end

local pageESP = CreateTab("ESP")
local pageAim = CreateTab("Aim")
local pageMemory = CreateTab("Memory")
local pageAdmin = CreateTab("Admin")

Tabs["ESP"].Visible = true
TabBtns[1].BackgroundColor3 = Color3.fromRGB(120, 0, 255)

-- ================== CÁC NÚT ĐIỀU KHIỂN (UI COMPONENTS) ==================
local function AddToggle(parent, title, default, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    row.Parent = parent
    local rCorner = Instance.new("UICorner") rCorner.CornerRadius = UDim.new(0, 4) rCorner.Parent = row
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 48, 0, 20)
    tBtn.Position = UDim2.new(1, -54, 0.5, -10)
    tBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(180, 40, 40)
    tBtn.Text = default and "ON" or "OFF"
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Font = Enum.Font.GothamBold
    tBtn.TextSize = 10
    tBtn.Parent = row
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(0, 10) btnCorner.Parent = tBtn
    
    local state = default
    tBtn.MouseButton1Click:Connect(function()
        state = not state
        tBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(180, 40, 40)
        tBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function AddSlider(parent, title, minVal, maxVal, defaultVal, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -10, 0, 42)
    row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    row.Parent = parent
    local rCorner = Instance.new("UICorner") rCorner.CornerRadius = UDim.new(0, 4) rCorner.Parent = row
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 10, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = title .. ": " .. tostring(defaultVal)
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0.9, 0, 0, 6)
    track.Position = UDim2.new(0.05, 0, 0.7, 0)
    track.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    track.BorderSizePixel = 0
    track.Parent = row
    local tCorner = Instance.new("UICorner") tCorner.CornerRadius = UDim.new(1, 0) tCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fCorner = Instance.new("UICorner") fCorner.CornerRadius = UDim.new(1, 0) fCorner.Parent = fill
    
    local dragging = false
    local function UpdateValue(input)
        local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        local calculated = math.floor(minVal + (maxVal - minVal) * pos)
        lbl.Text = title .. ": " .. tostring(calculated)
        callback(calculated)
    end
    
    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateValue(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateValue(input)
        end
    end)
end

-- ================== BỔ SUNG NÚT VÀO MỖI TAB ==================
-- [TAB ESP]
AddToggle(pageESP, "Cho phép ESP (Tổng)", SETTINGS.ESP_Master, function(v) SETTINGS.ESP_Master = v end)
AddToggle(pageESP, "ESP Line (Đường kẻ)", SETTINGS.ESP_Line, function(v) SETTINGS.ESP_Line = v end)
AddToggle(pageESP, "ESP Box (Khung hình)", SETTINGS.ESP_Box, function(v) SETTINGS.ESP_Box = v end)
AddToggle(pageESP, "ESP Khoảng cách", SETTINGS.ESP_Distance, function(v) SETTINGS.ESP_Distance = v end)
AddToggle(pageESP, "ESP Tên", SETTINGS.ESP_Name, function(v) SETTINGS.ESP_Name = v end)
AddToggle(pageESP, "ESP Máu", SETTINGS.ESP_Health, function(v) SETTINGS.ESP_Health = v end)
AddToggle(pageESP, "ESP Skeleton (Khung xương)", SETTINGS.ESP_Skeleton, function(v) SETTINGS.ESP_Skeleton = v end)
AddSlider(pageESP, "Kích cỡ vòng FOV", 50, 800, SETTINGS.FOV_Radius, function(v) SETTINGS.FOV_Radius = v end)

-- [TAB AIM]
AddToggle(pageAim, "Aim Đầu (Head)", SETTINGS.Aim_Head, function(v) 
    SETTINGS.Aim_Head = v 
    if v then SETTINGS.Aim_Body = false end 
end)
AddToggle(pageAim, "Aim Body (Thân)", SETTINGS.Aim_Body, function(v) 
    SETTINGS.Aim_Body = v 
    if v then SETTINGS.Aim_Head = false end 
end)
AddToggle(pageAim, "Aim Fire (Tự động bắn)", SETTINGS.Aim_Fire, function(v) SETTINGS.Aim_Fire = v end)
AddToggle(pageAim, "Aim Silent (Bắn ẩn tâm)", SETTINGS.Aim_Silent, function(v) SETTINGS.Aim_Silent = v end)

-- [TAB MEMORY]
AddToggle(pageMemory, "Tàng hình (Invisible)", SETTINGS.Invisible, function(v) 
    SETTINGS.Invisible = v 
    if LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") or p:IsA("Decal") then p.Transparency = v and 1 or 0 end
        end
    end
end)
AddSlider(pageMemory, "Speed (Tốc độ chạy)", 16, 300, SETTINGS.WalkSpeed, function(v) SETTINGS.WalkSpeed = v end)
AddToggle(pageMemory, "No Reload (Không nạp đạn)", SETTINGS.NoReload, function(v) SETTINGS.NoReload = v end)
AddToggle(pageMemory, "Teleport Kill (Tự áp sát)", SETTINGS.TeleportKill, function(v) SETTINGS.TeleportKill = v end)
AddToggle(pageMemory, "Đi xuyên tường (Noclip)", SETTINGS.Noclip, function(v) SETTINGS.Noclip = v end)
AddSlider(pageMemory, "Bắn siêu nhanh (Rapid Fire)", 1, 10, SETTINGS.RapidFire, function(v) SETTINGS.RapidFire = v end)
AddToggle(pageMemory, "Người xoay siêu nhanh (SpinBot)", SETTINGS.SpinBot, function(v) SETTINGS.SpinBot = v end)

-- [TAB ADMIN]
local adminNameLabel = Instance.new("TextLabel")
adminNameLabel.Size = UDim2.new(1, -10, 0, 100)
adminNameLabel.Position = UDim2.new(0, 5, 0, 20)
adminNameLabel.BackgroundTransparency = 1
adminNameLabel.Text = "Lionel Tiến Mạnh"
adminNameLabel.Font = Enum.Font.GothamBlack
adminNameLabel.TextSize = 26
adminNameLabel.Parent = pageAdmin

RunService.RenderStepped:Connect(function()
    local hue = (tick() % 2) / 2
    adminNameLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- ================== BẬT/TẮT MENU ==================
toggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    toggleBtn.Text = MainFrame.Visible and "MENU [ON]" or "MENU [OFF]"
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
        toggleBtn.Text = MainFrame.Visible and "MENU [ON]" or "MENU [OFF]"
    end
end)

print("💀 DEVILS WILL RISE - UPDATED WITH VISIBILITY CHECK & DRAGGABLE ICON!")
