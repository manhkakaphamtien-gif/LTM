-- LIONEL TIẾN MẠNH • trình cài duy nhất, không dùng HTTP/loadstring.
-- Chạy toàn bộ trong Command Bar của Roblox Studio, khi KHÔNG ở chế độ Play.
local StudioRun = game:GetService("RunService")
assert(StudioRun:IsStudio() and not StudioRun:IsRunning(), "Dừng Play, rồi chạy trong Command Bar của Roblox Studio.")
local Rep = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")
local SPS = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local backup = Instance.new("Folder")
backup.Name = "LTM_Backup_" .. os.date("%Y%m%d_%H%M%S")
local n = 0
for _, pair in ipairs({{Rep,"LTM"},{SSS,"LTMServer"},{SPS,"LTMClient"}}) do
    local existing=pair[1]:FindFirstChild(pair[2])
    if existing then existing.Parent=backup; n=n+1 end
end
if n>0 then backup.Parent=game:GetService("ServerStorage") else backup:Destroy() end
local folder=Instance.new("Folder"); folder.Name="LTM"; folder.Parent=Rep
local function install(class,name,parent,source)
    local object=Instance.new(class); object.Name=name; object.Source=source; object.Parent=parent
    return object
end
install("ModuleScript","Config",folder,[========[
-- ReplicatedStorage/LTM/Config (ModuleScript)
return {
    Title = "LIONEL TIẾN MẠNH",
    Footer = "Tik Tok:@lioneltienmanh",
    IconImageId = 0, -- ID ảnh 1000017419.png đã tải lên Roblox.
    IntroVideoId = 0, -- ID video 1000017515.mp4, được cấp quyền cho experience.
    IntroEveryOpen = true,
    IntroTimeout = 10,
    IntroVolume = 0.45,
    IntroAspectRatio = 1920 / 864,
    MaxRenderedTargets = 32,
    TargetRefreshSeconds = 0.65,
    NPCtag = "LTMTarget",
    GlassTag = "LTMGlass",
    SafeGlassAttribute = "LTMSafe", -- true/false; nếu thiếu sẽ hiện CHƯA BIẾT.
    StudsPerMeter = 1 / 0.28, -- Quy ước hiển thị; có thể đổi theo game.
    TeamColor = Color3.fromRGB(99, 232, 180),
    EnemyColor = Color3.fromRGB(255, 110, 153),
    NeutralColor = Color3.fromRGB(193, 157, 255),
}
]========])
install("ModuleScript","Catalog",folder,[========[
-- Các giới hạn và danh sách điều khiển dùng chung client/server.
local C = {}
C.Groups = {"ĐỊNH VỊ", "AIM", "NGƯỜI CHƠI"}
C.Items = {
    {"line",1,"ESP line","Đường nối từ cuối màn hình",false},
    {"box",1,"ESP box","Khung bao quanh nhân vật",false},
    {"distance",1,"ESP khoảng cách","Đơn vị mét theo cấu hình game",false},
    {"health",1,"ESP máu","Thanh máu và HP hiện tại",false},
    {"name",1,"ESP tên","Tên hiển thị của người chơi",false},
    {"skeleton",1,"Vẽ khung xương","Hỗ trợ bộ khớp R6 và R15",false},
    {"fade",1,"Làm mờ màu ESP","0% rõ nhất • 90% mờ nhất",0.15,0,0.9,0.01},
    {"glass",1,"Soi kính đứng được","Đọc LTMSafe trên kính đã đánh dấu",false},
    {"thirdPerson",1,"Đổi góc nhìn","Bật: góc nhìn thứ ba • tắt: trở về",false},
    {"pillar",1,"Cột màu trên trời","Cột chỉ vị trí cao 180 studs",false},
    {"allEsp",1,"Bật hết ESP","Bật/tắt đồng loạt 9 lớp định vị",false},
    {"highlight",1,"ESP viền sáng","Viền nhân vật xuyên vật cản",false},
    {"arrows",1,"Mũi tên ngoài màn hình","Hướng đến người ở ngoài góc nhìn",false},
    {"teamColor",1,"Màu đồng đội / đối thủ","Xanh: đồng đội • hồng: đối thủ",true},
    {"espRange",1,"Khoảng cách hiển thị","Giới hạn ESP để giảm tải",1500,100,5000,50},
    {"showFov",2,"Hiện vòng tròn FOV","Vùng chọn mục tiêu quanh tâm",true},
    {"fov",2,"Bán kính vòng FOV","Đơn vị pixel trên màn hình",140,40,450,5},
    {"aimHead",2,"Aim đầu","Giữ RMB / nút NGẮM để khóa",false},
    {"aimBody",2,"Aim body","Giữ RMB / nút NGẮM để khóa",false},
    {"aimVip",2,"Aim VIP","Đánh trượt vẫn trúng với vũ khí LTM",false,nil,nil,nil,"server"},
    {"noclip",3,"Đi xuyên tường","Tắt va chạm nhân vật trên server",false,nil,nil,nil,"server"},
    {"invisible",3,"Tàng hình","Ẩn hình thể và bảng tên với mọi người",false,nil,nil,nil,"server"},
    {"jump",3,"Nhảy cao","Chiều cao nhảy • đơn vị studs",7.2,0,120,0.2,"server"},
    {"speed",3,"Tốc độ","Tốc độ đi • đơn vị studs/giây",16,0,150,1,"server"},
    {"follow",3,"Cách đối thủ 2 m","Theo mục tiêu gần tâm màn hình",false,nil,nil,nil,"server"},
    {"fly",3,"Bay","WASD/joystick • lên/xuống: E/Q",false,nil,nil,nil,"server"},
    {"spin",3,"Xoay người siêu nhanh","Xoay 3 vòng mỗi giây",false,nil,nil,nil,"server"},
    {"freeze",3,"Đứng im giữa không trung","Khóa vị trí • không rơi / nhảy",false,nil,nil,nil,"server"},
    {"maxHealth",3,"Tăng máu","Đặt máu tối đa và hồi đầy",100,100,2000,25,"server"},
    {"lie",3,"Nằm","Đổi tư thế bằng khớp gốc R6/R15",false,nil,nil,nil,"server"},
    {"overhead",3,"Lên đầu đối thủ","Bám phía trên mục tiêu",false,nil,nil,nil,"server"},
    {"wallShot",3,"Bắn xuyên tường","Áp dụng vũ khí LTM đi kèm",false,nil,nil,nil,"server"},
    {"attackRate",3,"Tăng tốc độ đánh","Số lần đánh mỗi giây • vũ khí LTM",3,1,15,1,"server"},
    {"noReload",3,"Bắn không nạp đạn","Đạn vô hạn • vũ khí LTM",false,nil,nil,nil,"server"},
}
C.ById = {}
C.EspKeys = {"line","box","distance","health","name","skeleton","pillar","highlight","arrows"}
C.MotionKeys = {"fly","freeze","lie","follow","overhead"}
for _, item in ipairs(C.Items) do C.ById[item[1]] = item end
function C.defaults()
    local result = {}
    for _, item in ipairs(C.Items) do result[item[1]] = item[5] end
    return result
end
function C.validate(id, value, serverOnly)
    local item = C.ById[id]
    if not item or (serverOnly and item[9] ~= "server") then return nil end
    if type(item[5]) == "boolean" then
        if type(value) ~= "boolean" then return nil end
        return value
    end
    if type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then return nil end
    value = math.max(item[6], math.min(item[7], value))
    return math.max(item[6], math.min(item[7], math.floor(value / item[8] + 0.5) * item[8]))
end
function C.apply(values, id, value)
    values[id] = value
    if value and (id == "aimHead" or id == "aimBody") then
        values[id == "aimHead" and "aimBody" or "aimHead"] = false
    end
    if id == "allEsp" then
        for _, key in ipairs(C.EspKeys) do values[key] = value end
    else
        local all = true
        for _, key in ipairs(C.EspKeys) do if not values[key] then all = false end end
        values.allEsp = all
    end
    if value == true then
        for _, key in ipairs(C.MotionKeys) do
            if key == id then
                for _, other in ipairs(C.MotionKeys) do if other ~= id then values[other] = false end end
                if id == "freeze" or id == "lie" then values.spin = false end
            end
        end
        if id == "spin" then values.freeze = false; values.lie = false end
    end
end
return C
]========])
install("ModuleScript","Decor",folder,[========[
-- Đồ trang trí được dựng bằng UI/Part, không cần tải ảnh ngoài.
local D={}
local pink=Color3.fromRGB(255,168,203)
local ink=Color3.fromRGB(41,28,55)
local function make(class,props,parent)
    local obj=Instance.new(class)
    for k,v in pairs(props) do obj[k]=v end
    obj.Parent=parent; return obj
end
local function part(parent,position,size,color,shape)
    local p=make("Part",{Size=size,CFrame=CFrame.new(position),Color=color,
        Anchored=true,CanCollide=false,Material=Enum.Material.SmoothPlastic},parent)
    if shape then p.Shape=shape end
    return p
end
local function rod(parent,a,b,width,color)
    local p=part(parent,(a+b)/2,Vector3.new(width,width,(b-a).Magnitude),color)
    p.CFrame=CFrame.lookAt((a+b)/2,b)
    return p
end
local function blossom(parent,pos,scale)
    for i=1,5 do
        local angle=i*math.pi*2/5
        part(parent,pos+Vector3.new(math.cos(angle),math.sin(angle),0)*scale,
            Vector3.new(scale*1.55,scale*1.8,scale*0.65),pink,Enum.PartType.Ball)
    end
    part(parent,pos+Vector3.new(0,0,scale*0.5),Vector3.new(scale,scale,scale),Color3.fromRGB(255,227,161),Enum.PartType.Ball)
end
local function figure(parent,pose,offset,scale)
    local function at(x,y,z) return offset+Vector3.new(x,y,z)*scale end
    local function limb(a,b,w,color) return rod(parent,at(table.unpack(a)),at(table.unpack(b)),w*scale,color or ink) end
    part(parent,at(0,1.4,0),Vector3.new(0.43,0.49,0.4)*scale,Color3.fromRGB(221,188,177),Enum.PartType.Ball)
    part(parent,at(0,0.82,0),Vector3.new(0.64,0.85,0.42)*scale,ink)
    part(parent,at(0,0.56,0.24),Vector3.new(0.69,0.13,0.06)*scale,pink)
    part(parent,at(0,1.65,0),Vector3.new(0.55,0.15,0.5)*scale,ink)
    if pose=="ninja" then
        part(parent,at(0,1.37,0.22),Vector3.new(0.44,0.22,0.03)*scale,ink)
        part(parent,at(0,1.51,0.22),Vector3.new(0.45,0.08,0.03)*scale,pink)
        limb({-.18,.48,0},{-.28,-.55,0},.22)
        limb({.18,.48,0},{.45,-.5,0},.22)
        limb({-.4,1.1,0},{-.12,.78,.3},.16)
        limb({.4,1.1,0},{.08,.78,.32},.16)
        limb({-.55,-.4,-.2},{.5,1.8,-.2},.07,Color3.fromRGB(178,168,195))
        limb({.17,1.7,0},{.9,1.6,0},.12,pink)
    else
        local hat=part(parent,at(0,1.69,0),Vector3.new(.1,1.1,1.1)*scale,Color3.fromRGB(127,87,107),Enum.PartType.Cylinder)
        hat.CFrame=CFrame.new(at(0,1.69,0))*CFrame.Angles(0,0,math.pi/2)
        limb({-.2,.5,0},{-.55,.18,.25},.23)
        limb({-.55,.18,.25},{-.25,-.32,.4},.2)
        limb({.2,.5,0},{.5,.18,.3},.23)
        limb({.5,.18,.3},{.8,.08,.35},.2)
        if pose=="flute" then
            limb({-.35,1.1,0},{.02,1.27,.35},.14)
            limb({.35,1.1,0},{.56,1.22,.35},.14)
            limb({-.04,1.31,.39},{1,1.23,.39},.07,Color3.fromRGB(237,210,157))
        else
            limb({-.4,1.1,0},{-.55,.28,.35},.17)
            limb({.4,1.1,0},{.53,.26,.32},.17)
            limb({-.85,-.2,.45},{1,.18,.45},.065,Color3.fromRGB(218,207,230))
            limb({-.6,-.2,.45},{-.58,.11,.45},.07,pink)
        end
    end
end
function D.new(panel)
    local result={views={},petals={}}
    local function view(name,size,pos,anchor)
        local v=make("ViewportFrame",{Name=name,Size=size,Position=pos,AnchorPoint=anchor or Vector2.zero,
            BackgroundTransparency=1,ZIndex=5,Ambient=Color3.fromRGB(215,190,230),
            LightColor=Color3.fromRGB(255,225,238),LightDirection=Vector3.new(-1,-1,-2)},panel)
        local world=make("WorldModel",{},v)
        local model=make("Model",{},world)
        local camera=make("Camera",{FieldOfView=35},v)
        v.CurrentCamera=camera
        return v,model,camera
    end
    local _,tree,cam=view("SakuraFlutist",UDim2.fromOffset(158,104),UDim2.fromOffset(-15,-12))
    cam.CFrame=CFrame.lookAt(Vector3.new(0,1.4,10),Vector3.new(0,1.4,0))
    local wood=Color3.fromRGB(132,79,105)
    rod(tree,Vector3.new(-3,-.1,0),Vector3.new(1.7,1.2,0),.19,wood)
    rod(tree,Vector3.new(-.6,.6,0),Vector3.new(-.1,2.8,0),.12,wood)
    rod(tree,Vector3.new(.6,1,0),Vector3.new(2.2,2.3,0),.09,wood)
    rod(tree,Vector3.new(-1.9,.2,0),Vector3.new(-2.7,2.4,0),.11,wood)
    local points={{-2.6,2.2},{-2.3,1.6},{-1.4,.7},{-.2,2.5},{-.7,2.1},{.2,1.9},{1.5,1.7},{2.2,2.2},{1.8,1.1}}
    for _,p in ipairs(points) do blossom(tree,Vector3.new(p[1],p[2],.18),.17) end
    figure(tree,"flute",Vector3.new(.7,1.05,.4),.57)
    table.insert(result.views,{model=tree,pivot=tree:GetPivot(),phase=0})
    local _,samurai,cam2=view("Samurai",UDim2.fromOffset(85,87),UDim2.new(0,-6,1,7),Vector2.new(0,1))
    figure(samurai,"samurai",Vector3.zero,1)
    rod(samurai,Vector3.new(-.65,-.4,-.3),Vector3.new(-.8,1.6,-.3),.32,wood)
    cam2.CFrame=CFrame.lookAt(Vector3.new(.1,.85,5.3),Vector3.new(.1,.85,0))
    table.insert(result.views,{model=samurai,pivot=samurai:GetPivot(),phase=2})
    local _,ninja,cam3=view("Ninja",UDim2.fromOffset(76,96),UDim2.new(1,-9,1,1),Vector2.new(1,1))
    figure(ninja,"ninja",Vector3.zero,1)
    rod(ninja,Vector3.new(.69,-.6,-.25),Vector3.new(.69,1.55,-.25),.22,wood)
    cam3.CFrame=CFrame.lookAt(Vector3.new(.1,.65,5.6),Vector3.new(.1,.65,0))
    table.insert(result.views,{model=ninja,pivot=ninja:GetPivot(),phase=4})
    local layer=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1,ClipsDescendants=true,ZIndex=7},panel)
    make("UICorner",{CornerRadius=UDim.new(0,18)},layer)
    local rng=Random.new(321)
    for i=1,19 do
        local p=make("Frame",{Size=UDim2.fromOffset(rng:NextNumber(4,8),rng:NextNumber(8,13)),
            BackgroundColor3=pink,BackgroundTransparency=.25,BorderSizePixel=0,ZIndex=7},layer)
        make("UICorner",{CornerRadius=UDim.new(1,0)},p)
        table.insert(result.petals,{object=p,seed=rng:NextNumber(0,10),speed=rng:NextNumber(.055,.12),phase=i/19})
    end
    function result:update(t)
        for _,p in ipairs(self.petals) do
            local progress=(t*p.speed+p.phase)%1
            p.object.Position=UDim2.new(.04+progress*.77+math.sin(t*.9+p.seed)*.045,0,progress,0)
            p.object.Rotation=t*40+p.seed*30
            p.object.BackgroundTransparency=.18+progress*.55
        end
        for _,v in ipairs(self.views) do
            v.model:PivotTo(v.pivot*CFrame.Angles(0,math.sin(t*.9+v.phase)*.04,math.sin(t*.7+v.phase)*.015))
        end
    end
    return result
end
return D
]========])
install("ModuleScript","ESP",folder,[========[
local Players=game:GetService("Players")
local Tags=game:GetService("CollectionService")
local E={}
local function make(class,props,parent)
    local obj=Instance.new(class)
    for k,v in pairs(props) do obj[k]=v end
    obj.Parent=parent; return obj
end
local function line(parent,width)
    return make("Frame",{AnchorPoint=Vector2.new(.5,.5),BorderSizePixel=0,
        Size=UDim2.fromOffset(0,width or 1.5),ZIndex=2,Visible=false},parent)
end
local function draw(object,a,b,color,fade,width)
    local delta=b-a
    object.Position=UDim2.fromOffset((a.X+b.X)/2,(a.Y+b.Y)/2)
    object.Size=UDim2.fromOffset(delta.Magnitude,width or 1.5)
    object.Rotation=math.deg(math.atan2(delta.Y,delta.X))
    object.BackgroundColor3=color; object.BackgroundTransparency=fade; object.Visible=true
end
local function label(parent)
    return make("TextLabel",{BackgroundTransparency=1,TextSize=12,Font=Enum.Font.GothamMedium,
        TextStrokeTransparency=.35,TextStrokeColor3=Color3.new(0,0,0),ZIndex=3,Visible=false},parent)
end
local bodyNames={Head=true,HumanoidRootPart=true,Torso=true,UpperTorso=true,LowerTorso=true,
    ["Left Arm"]=true,["Right Arm"]=true,["Left Leg"]=true,["Right Leg"]=true,
    LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,RightLowerArm=true,RightHand=true,
    LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=true}
function E.new(screen,config,values)
    local self={targets={},records={},glass={},elapsed=99,config=config,values=values,player=Players.LocalPlayer}
    self.layer=make("Frame",{Name="ESP",Size=UDim2.fromScale(1,1),BackgroundTransparency=1},screen)
    self.world=make("Folder",{Name="LTM_LocalEffects"},workspace)
    local function remove(record)
        record.ui:Destroy(); record.highlight:Destroy(); record.column:Destroy()
    end
    function self:isEnemy(model)
        local p=Players:GetPlayerFromCharacter(model)
        return model:GetAttribute("LTMFriendly")~=true
            and (not p or p.Neutral or self.player.Neutral or p.Team~=self.player.Team)
    end
    function self:refresh()
        local own=self.player.Character
        local root=own and own:FindFirstChild("HumanoidRootPart")
        local all,seen={},{}
        local function add(model,p)
            if not model or seen[model] or model==own or not model:IsA("Model") then return end
            seen[model]=true
            local h=model:FindFirstChildOfClass("Humanoid")
            local r=model:FindFirstChild("HumanoidRootPart")
            if not h or not r or h.Health<=0 or not model:IsDescendantOf(workspace) then return end
            local distance=root and (root.Position-r.Position).Magnitude or 0
            if distance<=values.espRange then
                table.insert(all,{model=model,hum=h,root=r,name=p and p.DisplayName or model.Name,distance=distance})
            end
        end
        for _,p in ipairs(Players:GetPlayers()) do add(p.Character,p) end
        for _,npc in ipairs(Tags:GetTagged(config.NPCtag)) do add(npc,nil) end
        table.sort(all,function(a,b) return a.distance<b.distance end)
        while #all>config.MaxRenderedTargets do table.remove(all) end
        local keep={}
        for _,target in ipairs(all) do
            local model=target.model; keep[model]=true
            if not self.records[model] then
                local ui=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundTransparency=1},self.layer)
                local rec={ui=ui,bones={},edges={}}
                rec.tracer=line(ui); rec.caption=label(ui); rec.arrow=label(ui)
                rec.arrow.Text="▲"; rec.arrow.TextSize=24; rec.arrow.Size=UDim2.fromOffset(30,30)
                rec.arrow.AnchorPoint=Vector2.new(.5,.5)
                for i=1,4 do rec.edges[i]=line(ui) end
                rec.hpBack=line(ui,4); rec.hpFill=line(ui,3)
                for _,joint in ipairs(model:GetDescendants()) do
                    if joint:IsA("Motor6D") and joint.Part0 and joint.Part1
                        and bodyNames[joint.Part0.Name] and bodyNames[joint.Part1.Name] then
                        table.insert(rec.bones,{a=joint.Part0,b=joint.Part1,ui=line(ui,1.4)})
                    end
                end
                rec.highlight=make("Highlight",{Adornee=model,Enabled=false,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop},self.world)
                rec.column=make("Part",{Name="Column",Anchored=true,CanCollide=false,CanTouch=false,CanQuery=false,
                    Transparency=1,Size=Vector3.one},self.world)
                local a=make("Attachment",{Position=Vector3.zero},rec.column)
                local b=make("Attachment",{Position=Vector3.new(0,180,0)},rec.column)
                rec.beam=make("Beam",{Attachment0=a,Attachment1=b,Enabled=false,Width0=2.4,Width1=5,
                    FaceCamera=true,LightEmission=1,Segments=1},rec.column)
                self.records[model]=rec
            end
            target.rec=self.records[model]
        end
        for model,rec in pairs(self.records) do if not keep[model] then remove(rec); self.records[model]=nil end end
        self.targets=all
        local glassKeep={}
        if values.glass then
            local count=0
            for _,part in ipairs(Tags:GetTagged(config.GlassTag)) do
                if part:IsA("BasePart") and part:IsDescendantOf(workspace) and count<64 then
                    count=count+1; glassKeep[part]=true
                    if not self.glass[part] then
                        self.glass[part]={highlight=make("Highlight",{Adornee=part,
                            DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,FillTransparency=.65},self.world),label=label(self.layer)}
                    end
                end
            end
        end
        for part,g in pairs(self.glass) do
            if not glassKeep[part] then g.highlight:Destroy(); g.label:Destroy(); self.glass[part]=nil end
        end
    end
    function self:pick(camera,radius,partName,requireSight)
        local best,bestPart,bestScore=nil,nil,radius
        local center=camera.ViewportSize/2
        local own=self.player.Character
        local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances=own and {own,self.world} or {self.world}
        for _,target in ipairs(self.targets) do
            if target.model.Parent and target.hum.Health>0 and self:isEnemy(target.model) then
                local part=target.model:FindFirstChild(partName) or target.root
                local screenPos,onScreen=camera:WorldToViewportPoint(part.Position)
                local score=(Vector2.new(screenPos.X,screenPos.Y)-center).Magnitude
                if onScreen and screenPos.Z>0 and score<bestScore then
                    local hit=requireSight and workspace:Raycast(camera.CFrame.Position,part.Position-camera.CFrame.Position,params)
                    if not hit or hit.Instance:IsDescendantOf(target.model) then
                        best=target.model; bestPart=part; bestScore=score
                    end
                end
            end
        end
        return best,bestPart
    end
    function self:update(dt,camera,enabled)
        self.elapsed=self.elapsed+dt
        if self.elapsed>=config.TargetRefreshSeconds then self.elapsed=0; self:refresh() end
        local size=camera.ViewportSize
        local own=self.player.Character
        local ownRoot=own and own:FindFirstChild("HumanoidRootPart")
        for _,target in ipairs(self.targets) do
            local rec=target.rec
            rec.ui.Visible=enabled; rec.highlight.Enabled=false; rec.beam.Enabled=false
            for _,obj in ipairs(rec.ui:GetChildren()) do if obj:IsA("GuiObject") then obj.Visible=false end end
            if enabled and target.model.Parent and target.hum.Health>0 and target.root.Parent then
                local pos,visible=camera:WorldToViewportPoint(target.root.Position)
                local color=values.teamColor and (self:isEnemy(target.model) and config.EnemyColor or config.TeamColor) or config.NeutralColor
                local fade=values.fade
                rec.highlight.Enabled=values.highlight
                rec.highlight.FillColor=color; rec.highlight.OutlineColor=color
                rec.highlight.FillTransparency=math.min(.95,.65+fade*.3); rec.highlight.OutlineTransparency=fade
                rec.beam.Enabled=values.pillar
                if values.pillar then
                    rec.column.CFrame=CFrame.new(target.root.Position)
                    rec.beam.Color=ColorSequence.new(color); rec.beam.Transparency=NumberSequence.new(math.min(.94,.35+fade*.6))
                end
                if visible and pos.Z>0 then
                    local center=target.root.CFrame*CFrame.new(0,.2,0)
                    local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
                    local allFront=true
                    for x=-1,1,2 do for y=-1,1,2 do for z=-1,1,2 do
                        local p=camera:WorldToViewportPoint((center*CFrame.new(x*2,y*3,z*1.2)).Position)
                        if p.Z<=.05 then allFront=false end
                        minX=math.min(minX,p.X); minY=math.min(minY,p.Y); maxX=math.max(maxX,p.X); maxY=math.max(maxY,p.Y)
                    end end end
                    local point=Vector2.new(pos.X,pos.Y)
                    if values.line then draw(rec.tracer,Vector2.new(size.X/2,size.Y-12),point,color,fade) end
                    if allFront then
                        local corners={Vector2.new(minX,minY),Vector2.new(maxX,minY),Vector2.new(maxX,maxY),Vector2.new(minX,maxY)}
                        if values.box then for i=1,4 do draw(rec.edges[i],corners[i],corners[i%4+1],color,fade) end end
                        local text={}
                        if values.name then table.insert(text,target.name) end
                        if values.distance and ownRoot then
                            table.insert(text,string.format("%.1f m",(ownRoot.Position-target.root.Position).Magnitude/config.StudsPerMeter))
                        end
                        if values.health then
                            table.insert(text,string.format("%d/%d HP",math.ceil(target.hum.Health),math.ceil(target.hum.MaxHealth)))
                            local ratio=math.clamp(target.hum.Health/math.max(1,target.hum.MaxHealth),0,1)
                            draw(rec.hpBack,Vector2.new(minX-5,minY),Vector2.new(minX-5,maxY),Color3.fromRGB(24,20,29),fade,4)
                            draw(rec.hpFill,Vector2.new(minX-5,maxY),Vector2.new(minX-5,maxY-(maxY-minY)*ratio),Color3.fromHSV(ratio*.33,.75,1),fade,3)
                        end
                        if #text>0 then
                            rec.caption.Text=table.concat(text," · "); rec.caption.TextColor3=color; rec.caption.TextTransparency=fade
                            rec.caption.Size=UDim2.fromOffset(280,30); rec.caption.Position=UDim2.fromOffset((minX+maxX)/2-140,minY-30)
                            rec.caption.Visible=true
                        end
                    end
                    if values.skeleton then
                        for _,bone in ipairs(rec.bones) do
                            if bone.a.Parent and bone.b.Parent then
                                local a=camera:WorldToViewportPoint(bone.a.Position)
                                local b=camera:WorldToViewportPoint(bone.b.Position)
                                if a.Z>0 and b.Z>0 then draw(bone.ui,Vector2.new(a.X,a.Y),Vector2.new(b.X,b.Y),color,fade) end
                            end
                        end
                    end
                elseif values.arrows then
                    local relative=camera.CFrame:PointToObjectSpace(target.root.Position)
                    local direction=Vector2.new(relative.X,-relative.Y)
                    if direction.Magnitude<.01 then direction=Vector2.new(0,1) end
                    direction=direction.Unit
                    local radius=math.min((size.X/2-30)/math.max(.001,math.abs(direction.X)),(size.Y/2-55)/math.max(.001,math.abs(direction.Y)))
                    local p=size/2+direction*radius
                    rec.arrow.Position=UDim2.fromOffset(p.X,p.Y); rec.arrow.Rotation=math.deg(math.atan2(direction.Y,direction.X))+90
                    rec.arrow.TextColor3=color; rec.arrow.TextTransparency=fade; rec.arrow.Visible=true
                end
            end
        end
        for part,g in pairs(self.glass) do
            g.highlight.Enabled=enabled and values.glass; g.label.Visible=false
            if part.Parent and enabled and values.glass then
                local safe=part:GetAttribute(config.SafeGlassAttribute)
                local color=safe==true and config.TeamColor or (safe==false and config.EnemyColor or Color3.fromRGB(255,211,130))
                g.highlight.FillColor=color; g.highlight.OutlineColor=color
                local p,onScreen=camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    g.label.Visible=true; g.label.Text=safe==true and "ĐỨNG ĐƯỢC" or (safe==false and "KÍNH VỠ" or "CHƯA BIẾT")
                    g.label.TextColor3=color; g.label.Size=UDim2.fromOffset(130,24); g.label.Position=UDim2.fromOffset(p.X-65,p.Y-12)
                end
            end
        end
    end
    function self:destroy()
        self.layer:Destroy(); self.world:Destroy()
    end
    return self
end
return E
]========])
install("Script","LTMServer",SSS,[========[
-- ServerScriptService/LTMServer. Dành cho experience bạn sở hữu/quản lý.
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Tags = game:GetService("CollectionService")
local Debris = game:GetService("Debris")
local Root = RS:WaitForChild("LTM")
local Config = require(Root.Config)
local Catalog = require(Root.Catalog)

local KEY = "Messi is the Goat"
local ALLOWED_USER_IDS = {
    -- [123456789] = true, -- Thêm UserId của bạn ở đây, nhất là game thuộc group.
}
local ALLOW_ALL_STUDIO_TESTERS = true
local sessions = {}
local function permitted(p)
    return (RunService:IsStudio() and ALLOW_ALL_STUDIO_TESTERS)
        or ALLOWED_USER_IDS[p.UserId] == true
        or (game.CreatorType == Enum.CreatorType.User and game.CreatorId == p.UserId)
end
local function remote(name)
    local old = Root:FindFirstChild(name)
    if old then old:Destroy() end
    local r = Instance.new("RemoteEvent")
    r.Name = name; r.Parent = Root
    return r
end
local Request = remote("Request")
local Reply = remote("Reply")
local function push(p, s, message)
    Reply:FireClient(p, "state", s.values, s.ammo, s.reloading, message)
end
local function finite(n)
    return type(n) == "number" and n == n and math.abs(n) < 1e7
end
local function vector(v)
    return typeof(v) == "Vector3" and finite(v.X) and finite(v.Y) and finite(v.Z)
end
local function character(p)
    local c = p.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    local r = c and c:FindFirstChild("HumanoidRootPart")
    if c and h and r and h.Health > 0 then return c, h, r end
end
local function targetValid(p, model, maxDistance)
    local _, _, root = character(p)
    if not root or typeof(model) ~= "Instance" or not model:IsA("Model")
        or not model:IsDescendantOf(workspace) or model == p.Character then return false end
    local other = Players:GetPlayerFromCharacter(model)
    if not other and not Tags:HasTag(model, Config.NPCtag) then return false end
    if other and not p.Neutral and not other.Neutral and p.Team == other.Team then return false end
    if model:GetAttribute("LTMFriendly") == true then return false end
    local h = model:FindFirstChildOfClass("Humanoid")
    local r = model:FindFirstChild("HumanoidRootPart")
    return h ~= nil and h.Health > 0 and r ~= nil
        and (root.Position - r.Position).Magnitude <= maxDistance
end
local function capture(s, object)
    if s.saved[object] then return end
    local props = {}
    if object:IsA("BasePart") then
        props.Transparency = object.Transparency; props.CanCollide = object.CanCollide
    elseif object:IsA("Decal") or object:IsA("Texture") then props.Transparency = object.Transparency
    elseif object:IsA("BillboardGui") or object:IsA("SurfaceGui") or object:IsA("ParticleEmitter")
        or object:IsA("Trail") or object:IsA("Beam") or object:IsA("Light") then
        props.Enabled = object.Enabled
    end
    if next(props) then s.saved[object] = props end
end
local function visuals(s)
    for object, props in pairs(s.saved) do
        if object.Parent then
            if props.Transparency ~= nil then object.Transparency = s.values.invisible and 1 or props.Transparency end
            if props.Enabled ~= nil then object.Enabled = props.Enabled and not s.values.invisible end
        end
    end
    if s.hum and s.base then
        s.hum.DisplayDistanceType = s.values.invisible and Enum.HumanoidDisplayDistanceType.None or s.base.display
    end
end
local function clearConstraints(s)
    for _, object in ipairs(s.constraints or {}) do object:Destroy() end
    s.constraints = {}; s.velocity = nil; s.orientation = nil
    if s.root and s.root.Parent and not s.root.Anchored then
        pcall(function() s.root:SetNetworkOwnershipAuto() end)
    end
end
local function addConstraint(s, class, props)
    local instance = Instance.new(class)
    instance.Name = "LTM_" .. class
    for key, value in pairs(props) do instance[key] = value end
    instance.Parent = s.root
    table.insert(s.constraints, instance)
    return instance
end
local function apply(s, fillHealth)
    if not s.root or not s.root.Parent or not s.hum or not s.base then return end
    local v, h, r, b = s.values, s.hum, s.root, s.base
    clearConstraints(s)
    r.Anchored = v.freeze or b.anchored
    h.WalkSpeed = (v.freeze or v.fly) and 0 or (v.lie and math.min(v.speed, 4) or v.speed)
    h.UseJumpPower = false
    h.JumpHeight = (v.freeze or v.fly or v.lie) and 0 or v.jump
    h.MaxHealth = v.maxHealth
    if fillHealth and h.Health > 0 then h.Health = h.MaxHealth end
    h.AutoRotate = not (v.fly or v.spin or v.freeze or v.lie) and b.autoRotate
    h.PlatformStand = v.fly or b.platformStand
    h.HipHeight = v.lie and 0.2 or b.hipHeight
    if s.joint and s.joint.Parent then
        s.joint.C0 = v.lie and (CFrame.new(0,-1.6,0) * b.joint * CFrame.Angles(math.pi/2,0,0)) or b.joint
    end
    for part, props in pairs(s.saved) do
        if part.Parent and props.CanCollide ~= nil then part.CanCollide = v.noclip and false or props.CanCollide end
    end
    if v.freeze then
        r.AssemblyLinearVelocity = Vector3.zero; r.AssemblyAngularVelocity = Vector3.zero
    end
    if v.fly or v.spin then
        local attachment = addConstraint(s,"Attachment",{})
        if v.fly then
            pcall(function() r:SetNetworkOwner(nil) end)
            s.velocity = addConstraint(s,"LinearVelocity",{
                Attachment0=attachment, RelativeTo=Enum.ActuatorRelativeTo.World,
                ForceLimitsEnabled=false, VectorVelocity=Vector3.zero,
            })
            if not v.spin then
                s.orientation = addConstraint(s,"AlignOrientation",{
                    Attachment0=attachment, Mode=Enum.OrientationAlignmentMode.OneAttachment,
                    MaxTorque=1e8, Responsiveness=25, CFrame=r.CFrame.Rotation,
                })
            end
        end
        if v.spin then
            addConstraint(s,"AngularVelocity",{
                Attachment0=attachment, RelativeTo=Enum.ActuatorRelativeTo.World,
                AngularVelocity=Vector3.new(0, math.pi*6, 0), MaxTorque=1e8,
            })
        end
    elseif not v.freeze then r.AssemblyAngularVelocity = Vector3.zero end
    visuals(s)
end
local function detach(s, restore)
    if s.descConnection then s.descConnection:Disconnect(); s.descConnection=nil end
    clearConstraints(s)
    if restore and s.base and s.hum and s.hum.Parent then
        local h, b = s.hum, s.base
        h.WalkSpeed=b.walkSpeed; h.UseJumpPower=b.useJumpPower; h.JumpHeight=b.jumpHeight
        h.JumpPower=b.jumpPower; h.AutoRotate=b.autoRotate; h.PlatformStand=b.platformStand
        h.HipHeight=b.hipHeight; h.DisplayDistanceType=b.display; h.MaxHealth=b.maxHealth
        h.Health=math.min(h.Health,h.MaxHealth)
        if s.root and s.root.Parent then s.root.Anchored=b.anchored end
        if s.joint and s.joint.Parent then s.joint.C0=b.joint end
        for object, props in pairs(s.saved or {}) do
            if object.Parent then for key, value in pairs(props) do object[key]=value end end
        end
    end
    s.saved={}; s.root=nil; s.hum=nil; s.base=nil; s.joint=nil
end
local function grantWeapon(p, s)
    if s.tool then s.tool:Destroy() end
    local bag = p:FindFirstChildOfClass("Backpack")
    if not bag then return end
    local tool = Instance.new("Tool")
    tool.Name="LTM • tập luyện"; tool.RequiresHandle=false; tool.CanBeDropped=false
    tool.ToolTip="Chọn súng / kiếm / đấm / đá bằng nút CHẾ ĐỘ. Giữ ĐÁNH để liên tục."
    tool:SetAttribute("LTMWeapon",true); tool.Parent=bag; s.tool=tool
end
local function attach(p, s, c)
    s.generation=(s.generation or 0)+1
    local generation=s.generation
    detach(s,true)
    local h=c:WaitForChild("Humanoid",10)
    local r=c:WaitForChild("HumanoidRootPart",10)
    if not h or not r or p.Character~=c or s.generation~=generation or not s.authorized then return end
    s.hum=h; s.root=r; s.saved={}
    for _, obj in ipairs(c:GetDescendants()) do
        capture(s,obj)
        if obj:IsA("Motor6D") and obj.Part0==r then s.joint=obj end
    end
    s.base={walkSpeed=h.WalkSpeed,useJumpPower=h.UseJumpPower,jumpHeight=h.JumpHeight,jumpPower=h.JumpPower,
        maxHealth=h.MaxHealth,autoRotate=h.AutoRotate,platformStand=h.PlatformStand,hipHeight=h.HipHeight,
        display=h.DisplayDistanceType,anchored=r.Anchored,joint=s.joint and s.joint.C0 or CFrame.identity}
    s.descConnection=c.DescendantAdded:Connect(function(obj)
        capture(s,obj)
        if obj:IsA("BasePart") and s.values.noclip then obj.CanCollide=false end
        if s.values.invisible then visuals(s) end
    end)
    s.ammo=12; s.reloading=false; s.reloadToken=(s.reloadToken or 0)+1
    apply(s,true); grantWeapon(p,s); push(p,s)
end
local function rayParams(c, targetsOnly)
    local params=RaycastParams.new()
    params.FilterType=targetsOnly and Enum.RaycastFilterType.Include or Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances=targetsOnly or {c}
    return params
end
local function clearSight(c, origin, model, point)
    local hit=workspace:Raycast(origin,point-origin,rayParams(c))
    return hit==nil or hit.Instance:IsDescendantOf(model)
end
local MODES={GUN={range=450,damage=18},SWORD={range=12,damage=28},PUNCH={range=8,damage=12},KICK={range=10,damage=20}}
local function reload(p,s)
    if s.reloading or s.values.noReload or s.ammo>=12 then return end
    s.reloading=true; s.reloadToken=s.reloadToken+1
    local token=s.reloadToken
    push(p,s,"Đang nạp đạn…")
    task.delay(1.6,function()
        if sessions[p]~=s or not s.authorized or s.reloadToken~=token then return end
        s.reloading=false; s.ammo=12; push(p,s)
    end)
end
local function attack(p,s,direction,target,mode)
    local c,_,r=character(p)
    local weapon=MODES[mode]
    if not c or not weapon or not vector(direction) or direction.Magnitude<0.01
        or not s.tool or s.tool.Parent~=c then return end
    local now=os.clock()
    if now-(s.lastAttack or 0)<1/s.values.attackRate then return end
    if mode=="GUN" and not s.values.noReload then
        if s.reloading then return end
        if s.ammo<=0 then reload(p,s); return end
        s.ammo=s.ammo-1
    end
    s.lastAttack=now
    local origin=(c:FindFirstChild("Head") or r).Position
    local endpoint=origin+direction.Unit*weapon.range
    local victim=nil
    if s.values.aimVip and targetValid(p,target,weapon.range) then
        local targetRoot=target.HumanoidRootPart
        if s.values.wallShot or clearSight(c,origin,target,targetRoot.Position) then
            victim=target; endpoint=targetRoot.Position
        end
    end
    if not victim then
        local candidates=nil
        if s.values.wallShot then
            candidates={}
            for _, other in ipairs(Players:GetPlayers()) do
                if targetValid(p,other.Character,weapon.range+10) then table.insert(candidates,other.Character) end
            end
            for _, npc in ipairs(Tags:GetTagged(Config.NPCtag)) do
                if targetValid(p,npc,weapon.range+10) then table.insert(candidates,npc) end
            end
        end
        local result=workspace:Raycast(origin,direction.Unit*weapon.range,rayParams(c,candidates))
        if result then
            endpoint=result.Position
            local ancestor=result.Instance
            while ancestor and ancestor~=workspace do
                if ancestor:IsA("Model") and targetValid(p,ancestor,weapon.range+5) then victim=ancestor; break end
                ancestor=ancestor.Parent
            end
        end
    end
    if victim then victim:FindFirstChildOfClass("Humanoid"):TakeDamage(weapon.damage) end
    -- Hiệu ứng sáng ngắn, không có máu hay hình ảnh bạo lực.
    local length=(endpoint-origin).Magnitude
    if length>0.05 then
        local beam=Instance.new("Part")
        beam.Name="LTMShot"; beam.Anchored=true; beam.CanCollide=false; beam.CanTouch=false; beam.CanQuery=false
        beam.Material=Enum.Material.Neon; beam.Color=Color3.fromRGB(255,175,209)
        beam.Size=Vector3.new(0.055,0.055,length)
        beam.CFrame=CFrame.lookAt(origin,endpoint)*CFrame.new(0,0,-length/2)
        beam.Parent=workspace; Debris:AddItem(beam,0.08)
    end
    push(p,s)
end
local function setup(p)
    if sessions[p] then return end
    local s={values=Catalog.defaults(),authorized=false,saved={},constraints={},ammo=12,reloading=false,
        reloadToken=0,tokens=90,tokenTime=os.clock(),lastUnlock=-10,lastDirection=0,move=Vector3.zero}
    sessions[p]=s
    s.spawnConnection=p.CharacterAdded:Connect(function(c)
        if s.authorized then task.spawn(attach,p,s,c) end
    end)
end
Players.PlayerAdded:Connect(setup)
for _, p in ipairs(Players:GetPlayers()) do setup(p) end
Players.PlayerRemoving:Connect(function(p)
    local s=sessions[p]
    if s then
        detach(s,false)
        if s.spawnConnection then s.spawnConnection:Disconnect() end
        sessions[p]=nil
    end
end)
Request.OnServerEvent:Connect(function(p,action,a,b,c)
    local s=sessions[p]
    if not s or type(action)~="string" or #action>24 then return end
    local now=os.clock()
    s.tokens=math.min(90,s.tokens+(now-s.tokenTime)*60); s.tokenTime=now
    if s.tokens<1 then return end
    s.tokens=s.tokens-1
    if action=="unlock" then
        if now-s.lastUnlock<1 then return end
        s.lastUnlock=now
        if not permitted(p) then Reply:FireClient(p,"error","UserId chưa được chủ game cấp quyền."); return end
        if type(a)~="string" or #a>80 or a:match("^%s*(.-)%s*$")~=KEY then
            Reply:FireClient(p,"error","Key chưa đúng. Kiểm tra chữ hoa và khoảng trắng."); return
        end
        s.authorized=true; Reply:FireClient(p,"unlocked")
        if not s.root and p.Character then task.spawn(attach,p,s,p.Character) else push(p,s) end
        return
    end
    if not s.authorized or not permitted(p) then return end
    if action=="set" and type(a)=="string" then
        local value=Catalog.validate(a,b,true)
        if value==nil then return end
        Catalog.apply(s.values,a,value)
        if a=="noReload" and value then s.reloading=false; s.reloadToken=s.reloadToken+1 end
        apply(s,a=="maxHealth"); push(p,s)
    elseif action=="move" and vector(a) then
        s.move=a.Magnitude>1 and a.Unit or a; s.lastDirection=now
    elseif action=="target" then
        s.target=targetValid(p,a,500) and a or nil
    elseif action=="attack" then attack(p,s,a,b,c)
    elseif action=="reload" then reload(p,s)
    elseif action=="reset" then
        s.values=Catalog.defaults(); s.move=Vector3.zero; s.target=nil
        apply(s,true); push(p,s,"Đã trả các chức năng về mặc định.")
    end
end)
RunService.PreSimulation:Connect(function()
    for p,s in pairs(sessions) do
        if s.authorized and s.root and s.root.Parent and s.hum.Health>0 then
            local v=s.values
            if v.noclip then
                for part, props in pairs(s.saved) do
                    if props.CanCollide~=nil and part.Parent then part.CanCollide=false end
                end
            end
            if s.velocity then
                s.velocity.VectorVelocity=(os.clock()-s.lastDirection<0.4 and s.move or Vector3.zero)*math.max(v.speed,16)
                if s.orientation and s.move.Magnitude>0.1 then
                    local horizontal=Vector3.new(s.move.X,0,s.move.Z)
                    if horizontal.Magnitude>0.01 then s.orientation.CFrame=CFrame.lookAt(Vector3.zero,horizontal) end
                end
            end
            if (v.follow or v.overhead) and targetValid(p,s.target,500) then
                local other=s.target.HumanoidRootPart
                local offset=v.overhead and Vector3.new(0,5,0) or other.CFrame.LookVector*(-2*Config.StudsPerMeter)
                local position=other.Position+offset
                if (position-other.Position).Magnitude>0.01 then
                    s.root.CFrame=CFrame.lookAt(position,other.Position)
                    s.root.AssemblyLinearVelocity=Vector3.zero
                end
            end
        end
    end
end)
script.Destroying:Connect(function()
    for _,s in pairs(sessions) do
        detach(s,true)
        if s.tool then s.tool:Destroy() end
        if s.spawnConnection then s.spawnConnection:Disconnect() end
    end
end)
]========])
install("LocalScript","LTMClient",SPS,[========[
-- StarterPlayer/StarterPlayerScripts/LTMClient (LocalScript)
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local Run=game:GetService("RunService")
local player=Players.LocalPlayer
local root=RS:WaitForChild("LTM",15)
if not root then warn("LTM: cần cài bộ script bằng INSTALL_STUDIO.lua trước."); return end
local Config=require(root.Config)
local Catalog=require(root.Catalog)
local Decor=require(root.Decor)
local ESP=require(root.ESP)
local request=root:WaitForChild("Request",15)
local reply=root:WaitForChild("Reply",15)
if not request or not reply then warn("LTM: chưa có LTMServer trong ServerScriptService."); return end
local playerGui=player:WaitForChild("PlayerGui")
local old=playerGui:FindFirstChild("LTMMenu")
if old then old:Destroy() end
local connections={}
local dead=false
local function connect(signal,callback)
    local connection=signal:Connect(callback); table.insert(connections,connection); return connection
end
local function make(class,props,parent)
    local object=Instance.new(class)
    for k,v in pairs(props) do object[k]=v end
    object.Parent=parent; return object
end
local function round(obj,radius)
    make("UICorner",{CornerRadius=UDim.new(0,radius or 12)},obj)
end
local function stroke(obj,color,transparency,width)
    return make("UIStroke",{Color=color,Transparency=transparency or 0,Thickness=width or 1,
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border},obj)
end
local C={bg=Color3.fromRGB(22,17,32),card=Color3.fromRGB(39,29,50),pink=Color3.fromRGB(255,164,203),
    muted=Color3.fromRGB(181,160,194),text=Color3.fromRGB(252,236,246),purple=Color3.fromRGB(175,144,245)}
local function text(parent,value,size,pos,fontSize,color)
    return make("TextLabel",{Text=value,Size=size,Position=pos,Font=Enum.Font.GothamMedium,TextSize=fontSize or 13,
        TextColor3=color or C.text,BackgroundTransparency=1,BorderSizePixel=0,ZIndex=12},parent)
end
local function button(parent,value,size,pos)
    local b=make("TextButton",{Text=value,Size=size,Position=pos,Font=Enum.Font.GothamBold,TextSize=13,
        TextColor3=C.text,BackgroundColor3=C.card,BorderSizePixel=0,AutoButtonColor=true,ZIndex=15},parent)
    round(b,11); return b
end
local gui=make("ScreenGui",{Name="LTMMenu",ResetOnSpawn=false,IgnoreGuiInset=true,
    ScreenInsets=Enum.ScreenInsets.None,ClipToDeviceSafeArea=false,DisplayOrder=40,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},playerGui)
local values=Catalog.defaults()
local unlocked=false
local panels,controls,icons={},{},{}
local activeTab=1
local esp=ESP.new(gui,Config,values)
local panel=make("Frame",{Name="Menu",BackgroundColor3=C.bg,BorderSizePixel=0,Size=UDim2.fromOffset(650,620),
    Position=UDim2.fromOffset(80,65),ZIndex=10,Active=true},gui)
round(panel,18); stroke(panel,C.pink,.35,1.4)
make("UIGradient",{Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(46,29,57)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(17,16,30))}),Rotation=70},panel)
local decor=Decor.new(panel)
local header=make("Frame",{Name="DragHeader",Size=UDim2.new(1,-48,0,80),BackgroundTransparency=1,ZIndex=10,Active=true},panel)
local title=text(panel,"<i>"..Config.Title.."</i>",UDim2.new(1,-180,0,35),UDim2.fromOffset(126,18),23)
title.RichText=true; title.Font=Enum.Font.GothamBold; title.TextScaled=true
make("UITextSizeConstraint",{MinTextSize=12,MaxTextSize=24},title)
local titleGradient=make("UIGradient",{Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(255,134,182)),ColorSequenceKeypoint.new(.25,Color3.fromRGB(255,217,137)),
    ColorSequenceKeypoint.new(.5,Color3.fromRGB(118,255,203)),ColorSequenceKeypoint.new(.75,Color3.fromRGB(137,184,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(231,141,255))})},title)
local sub=text(panel,"SAKURA  /  SAMURAI",UDim2.new(1,-190,0,18),UDim2.fromOffset(126,54),10,C.muted)
sub.TextScaled=true; make("UITextSizeConstraint",{MinTextSize=8,MaxTextSize=10},sub)
local collapse=button(panel,"−",UDim2.fromOffset(34,34),UDim2.new(1,-45,0,16))
collapse.TextSize=27
local footer=text(panel,Config.Footer,UDim2.new(1,-168,0,20),UDim2.new(0,84,1,-29),12,C.pink)
footer.TextScaled=true; make("UITextSizeConstraint",{MinTextSize=9,MaxTextSize=12},footer)
local resize=button(panel,"◢",UDim2.fromOffset(32,32),UDim2.new(1,-34,1,-34))
resize.TextColor3=C.pink; resize.BackgroundTransparency=1; resize.ZIndex=22

local icon=make("ImageButton",{Name="FloatingIcon",Size=UDim2.fromOffset(66,66),Position=UDim2.fromOffset(18,150),
    Image=Config.IconImageId>0 and ("rbxassetid://"..Config.IconImageId) or "",ScaleType=Enum.ScaleType.Crop,
    BackgroundColor3=C.card,BorderSizePixel=0,Visible=false,ZIndex=20,AutoButtonColor=false},gui)
round(icon,33); local iconStroke=stroke(icon,C.pink,0,2)
local fallback=text(icon,"LTM",UDim2.fromScale(1,1),UDim2.fromScale(0,0),17,C.pink)
fallback.Visible=Config.IconImageId==0
text(icon,"✦",UDim2.fromOffset(21,21),UDim2.fromOffset(48,-2),19,C.pink)

local toast=text(gui,"",UDim2.new(.8,0,0,46),UDim2.new(.1,0,0,54),13,C.text)
toast.BackgroundColor3=C.card; toast.BackgroundTransparency=.06; toast.Visible=false; toast.ZIndex=80
toast.TextWrapped=true; round(toast,12)
local toastSerial=0
local function notify(message)
    toastSerial=toastSerial+1; local serial=toastSerial
    toast.Text=message; toast.Visible=true
    task.delay(4,function() if not dead and toastSerial==serial then toast.Visible=false end end)
end
local tabBar=make("Frame",{Size=UDim2.new(1,-30,0,42),Position=UDim2.fromOffset(15,86),BackgroundTransparency=1,Visible=false},panel)
local tabButtons={}
local function chooseTab(index)
    activeTab=index
    for i,scroller in ipairs(panels) do scroller.Visible=unlocked and i==index end
    for i,b in ipairs(tabButtons) do b.BackgroundColor3=i==index and Color3.fromRGB(93,52,94) or C.card end
end
local symbols={"◎","✧","◇"}
for i,name in ipairs(Catalog.Groups) do
    local tab=button(tabBar,"",UDim2.new(1/3,-5,1,0),UDim2.new((i-1)/3,2,0,0))
    local glyph=text(tab,symbols[i],UDim2.fromOffset(25,30),UDim2.fromOffset(8,6),22,C.pink)
    table.insert(icons,{object=glyph,phase=i})
    local nameText=text(tab,name,UDim2.new(1,-42,1,0),UDim2.fromOffset(35,0),11)
    nameText.TextScaled=true; make("UITextSizeConstraint",{MinTextSize=8,MaxTextSize=12},nameText)
    tabButtons[i]=tab; connect(tab.Activated,function() chooseTab(i) end)
    local scroller=make("ScrollingFrame",{Name=name,Size=UDim2.new(1,-30,1,-223),Position=UDim2.fromOffset(15,139),
        BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=C.pink,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.fromOffset(0,0),ScrollingDirection=Enum.ScrollingDirection.Y,
        Visible=false,ZIndex=11},panel)
    make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},scroller)
    make("UIPadding",{PaddingRight=UDim.new(0,7),PaddingBottom=UDim.new(0,8)},scroller)
    panels[i]=scroller
end
local locked=make("Frame",{Name="KeyGate",Size=UDim2.new(1,-42,1,-156),Position=UDim2.fromOffset(21,102),
    BackgroundColor3=C.card,BorderSizePixel=0,ZIndex=11},panel)
round(locked,15); stroke(locked,C.pink,.8)
local gateLayout=make("Frame",{Size=UDim2.new(1,-34,0,258),AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),BackgroundTransparency=1},locked)
local gateScale=make("UIScale",{Scale=1},gateLayout)
text(gateLayout,"✦  SAKURA ACCESS  ✦",UDim2.new(1,0,0,29),UDim2.fromOffset(0,0),17,C.pink)
local gatePrompt=text(gateLayout,"Nhập key để mở khóa menu",UDim2.new(1,0,0,32),UDim2.fromOffset(0,39),14)
gatePrompt.TextWrapped=true
local keyBox=make("TextBox",{Size=UDim2.new(1,0,0,47),Position=UDim2.fromOffset(0,88),Text="",PlaceholderText="Nhập key…",
    ClearTextOnFocus=false,TextSize=16,Font=Enum.Font.Gotham,TextColor3=C.text,PlaceholderColor3=C.muted,
    BackgroundColor3=C.bg,BorderSizePixel=0,ZIndex=13},gateLayout)
round(keyBox,11); stroke(keyBox,C.pink,.65)
local unlock=button(gateLayout,"XÁC NHẬN",UDim2.new(1,0,0,43),UDim2.fromOffset(0,149))
unlock.BackgroundColor3=Color3.fromRGB(117,62,112)
local keyStatus=text(gateLayout,"Key được xác nhận bởi máy chủ.",UDim2.new(1,0,0,48),UDim2.fromOffset(0,204),11,C.muted)
keyStatus.TextWrapped=true
local waitingKey=false
local function tryUnlock()
    if waitingKey or unlocked then return end
    if #keyBox.Text==0 then keyStatus.Text="Bạn chưa nhập key."; return end
    waitingKey=true; unlock.Text="ĐANG XÁC NHẬN…"; request:FireServer("unlock",keyBox.Text)
    task.delay(5,function()
        if not dead and waitingKey then
            waitingKey=false; unlock.Text="XÁC NHẬN"; keyStatus.Text="Chưa nhận phản hồi máy chủ. Thử lại."
        end
    end)
end
connect(unlock.Activated,tryUnlock)
connect(keyBox.FocusLost,function(enter) if enter then tryUnlock() end end)

local savedCamera=nil
local function thirdPerson(on)
    if on and not savedCamera then
        savedCamera={mode=player.CameraMode,min=player.CameraMinZoomDistance,max=player.CameraMaxZoomDistance}
        player.CameraMode=Enum.CameraMode.Classic
        player.CameraMaxZoomDistance=math.max(35,player.CameraMaxZoomDistance)
        player.CameraMinZoomDistance=8
    elseif not on and savedCamera then
        player.CameraMinZoomDistance=savedCamera.min; player.CameraMaxZoomDistance=savedCamera.max
        player.CameraMode=savedCamera.mode; savedCamera=nil
    end
end
local refreshControls
local function change(id,value,send)
    if not unlocked then return end
    value=Catalog.validate(id,value,false)
    if value==nil then return end
    Catalog.apply(values,id,value)
    if id=="thirdPerson" then thirdPerson(value) end
    if id=="glass" then esp.elapsed=99 end
    if send~=false and Catalog.ById[id][9]=="server" then request:FireServer("set",id,value) end
    if refreshControls then refreshControls() end
end
local drag=nil
local function startDrag(kind,obj,input,data)
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    drag={kind=kind,obj=obj,input=input,start=Vector2.new(input.Position.X,input.Position.Y),
        pos=obj.AbsolutePosition,size=obj.AbsoluteSize,data=data,moved=false,lastSend=0}
end
local function fmt(id,value)
    if id=="fade" then return string.format("%d%%",math.floor(value*100+.5)) end
    if id=="jump" then return string.format("%.1f",value) end
    return tostring(math.floor(value+.5))
end
for order,item in ipairs(Catalog.Items) do
    local id,group,name,description,default=item[1],item[2],item[3],item[4],item[5]
    local slider=type(default)=="number"
    local row=make("Frame",{Name=id,Size=UDim2.new(1,0,0,slider and 90 or 70),BackgroundColor3=C.card,
        BorderSizePixel=0,LayoutOrder=order,ZIndex=12},panels[group])
    round(row,12); stroke(row,C.purple,.87)
    local orb=make("Frame",{Size=UDim2.fromOffset(31,31),Position=UDim2.fromOffset(10,14),
        BackgroundColor3=Color3.fromRGB(61,40,72),BorderSizePixel=0,ZIndex=13},row)
    round(orb,10)
    local glyph=text(orb,({"◎","◇","✧","◈","＋","⌁"})[(order-1)%6+1],UDim2.fromScale(1,1),UDim2.fromScale(0,0),20,C.pink)
    table.insert(icons,{object=glyph,phase=order*.79})
    local nameText=text(row,name,UDim2.new(1,-133,0,23),UDim2.fromOffset(51,10),13)
    nameText.TextXAlignment=Enum.TextXAlignment.Left; nameText.TextScaled=true
    make("UITextSizeConstraint",{MinTextSize=10,MaxTextSize=13},nameText)
    local desc=text(row,description,UDim2.new(1,-130,0,30),UDim2.fromOffset(51,31),10,C.muted)
    desc.TextXAlignment=Enum.TextXAlignment.Left; desc.TextYAlignment=Enum.TextYAlignment.Top; desc.TextWrapped=true
    if slider then
        local number=text(row,fmt(id,default),UDim2.fromOffset(72,24),UDim2.new(1,-82,0,12),14,C.pink)
        local track=make("TextButton",{Text="",Size=UDim2.new(1,-33,0,20),Position=UDim2.fromOffset(16,65),
            BackgroundTransparency=1,BorderSizePixel=0,ZIndex=14,AutoButtonColor=false},row)
        local bar=make("Frame",{Size=UDim2.new(1,0,0,5),Position=UDim2.fromOffset(0,8),BackgroundColor3=Color3.fromRGB(76,58,88),BorderSizePixel=0},track)
        round(bar,3)
        local fill=make("Frame",{Size=UDim2.fromScale(0,1),BackgroundColor3=C.pink,BorderSizePixel=0},bar); round(fill,3)
        local knob=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(16,16),Position=UDim2.fromScale(0,.5),
            BackgroundColor3=C.text,BorderSizePixel=0,ZIndex=16},bar); round(knob,8)
        controls[id]={kind="slider",track=track,fill=fill,knob=knob,number=number,item=item}
        connect(track.InputBegan,function(input)
            startDrag("slider",track,input,id)
            if drag and drag.obj==track then
                local ratio=math.clamp((input.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
                change(id,item[6]+ratio*(item[7]-item[6])); drag.lastSend=os.clock()
                panels[group].ScrollingEnabled=false
            end
        end)
    else
        local switch=button(row,"",UDim2.fromOffset(50,27),UDim2.new(1,-62,0,21))
        round(switch,14)
        local dot=make("Frame",{Size=UDim2.fromOffset(19,19),Position=UDim2.fromOffset(4,4),BackgroundColor3=C.text,BorderSizePixel=0,ZIndex=16},switch)
        round(dot,10)
        controls[id]={kind="toggle",switch=switch,dot=dot}
        connect(switch.Activated,function() change(id,not values[id]) end)
    end
end
refreshControls=function()
    for id,control in pairs(controls) do
        local value=values[id]
        if control.kind=="toggle" then
            control.switch.BackgroundColor3=value and Color3.fromRGB(188,102,154) or Color3.fromRGB(76,63,89)
            control.dot.Position=UDim2.fromOffset(value and 27 or 4,4)
        else
            local item=control.item; local ratio=(value-item[6])/(item[7]-item[6])
            control.fill.Size=UDim2.fromScale(ratio,1); control.knob.Position=UDim2.fromScale(ratio,.5)
            control.number.Text=fmt(id,value)
        end
    end
end
refreshControls()
local reset=button(panel,"ĐẶT LẠI",UDim2.fromOffset(92,28),UDim2.new(.5,-98,1,-74))
local replay=button(panel,"INTRO ↺",UDim2.fromOffset(92,28),UDim2.new(.5,6,1,-74))
reset.Visible=false; replay.Visible=false
connect(reset.Activated,function()
    for key,value in pairs(Catalog.defaults()) do values[key]=value end
    thirdPerson(false); refreshControls(); esp.elapsed=99; request:FireServer("reset")
end)

-- Intro nằm trên menu, có timeout và nút bỏ qua để không kẹt màn hình.
local intro=make("Frame",{Name="Intro",Size=UDim2.fromScale(1,1),BackgroundColor3=C.bg,
    BackgroundTransparency=.04,Visible=false,ZIndex=60},panel)
round(intro,18)
local introTitle=text(intro,Config.Title,UDim2.new(1,-30,0,35),UDim2.fromOffset(15,25),20,C.pink)
introTitle.TextScaled=true
make("UITextSizeConstraint",{MinTextSize=12,MaxTextSize=20},introTitle)
local video=make("VideoFrame",{Size=UDim2.new(1,-24,1,-155),Position=UDim2.fromOffset(12,67),
    BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,Volume=Config.IntroVolume,Looped=false,
    Video=Config.IntroVideoId>0 and ("rbxassetid://"..Config.IntroVideoId) or "",ZIndex=61},intro)
local introInfo=text(intro,"",UDim2.new(1,-38,0,56),UDim2.new(0,19,.5,-28),13,C.muted)
introInfo.TextWrapped=true; introInfo.ZIndex=62
local skip=button(intro,"BỎ QUA INTRO",UDim2.fromOffset(155,37),UDim2.new(.5,-77,1,-57)); skip.ZIndex=64
local introSerial=0
local function closeIntro()
    introSerial=introSerial+1; video:Pause(); intro.Visible=false
end
local function playIntro()
    introSerial=introSerial+1; local serial=introSerial
    intro.Visible=true
    if Config.IntroVideoId==0 then
        video.Visible=false
        introInfo.Text="Chưa đặt IntroVideoId trong Config.\nThêm ID video Roblox để dùng intro bạn gửi."
        task.delay(2.2,function() if not dead and serial==introSerial then closeIntro() end end)
        return
    end
    video.Visible=true; introInfo.Text="Đang tải video…"; video.TimePosition=0
    task.spawn(function()
        local start=os.clock()
        while not dead and serial==introSerial and not video.IsLoaded and os.clock()-start<Config.IntroTimeout do task.wait(.1) end
        if dead or serial~=introSerial then return end
        if not video.IsLoaded then
            closeIntro(); notify("Video chưa tải được. Kiểm tra ID và quyền dùng asset của game."); return
        end
        introInfo.Text=""; video:Play()
        task.delay(math.max(video.TimeLength,2)+2,function() if not dead and serial==introSerial then closeIntro() end end)
    end)
end
connect(skip.Activated,closeIntro)
connect(video.Ended,closeIntro)
connect(replay.Activated,playIntro)
local openedOnce=false
local function setOpen(open)
    panel.Visible=open; icon.Visible=not open
    if open then
        if Config.IntroEveryOpen or not openedOnce then playIntro() end
        openedOnce=true
    else closeIntro() end
end
connect(collapse.Activated,function() setOpen(false) end)

-- Kéo/resize dùng chung cho chuột và một ngón tay; không nuốt joystick ngón khác.
local function viewport()
    return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
end
local function clampPanel()
    local v=viewport()
    local minW=math.min(350,v.X-16); local minH=math.min(380,v.Y-20)
    local w=math.clamp(panel.AbsoluteSize.X,minW,math.max(minW,v.X-16))
    local h=math.clamp(panel.AbsoluteSize.Y,minH,math.max(minH,v.Y-20))
    local x=math.clamp(panel.AbsolutePosition.X,8,math.max(8,v.X-w-8))
    local y=math.clamp(panel.AbsolutePosition.Y,10,math.max(10,v.Y-h-10))
    panel.Size=UDim2.fromOffset(w,h); panel.Position=UDim2.fromOffset(x,y)
    icon.Position=UDim2.fromOffset(math.clamp(icon.AbsolutePosition.X,0,math.max(0,v.X-66)),
        math.clamp(icon.AbsolutePosition.Y,0,math.max(0,v.Y-66)))
end
connect(header.InputBegan,function(input) startDrag("panel",panel,input) end)
connect(title.InputBegan,function(input) startDrag("panel",panel,input) end)
connect(sub.InputBegan,function(input) startDrag("panel",panel,input) end)
connect(resize.InputBegan,function(input) startDrag("resize",panel,input) end)
connect(icon.InputBegan,function(input) startDrag("icon",icon,input) end)
connect(UIS.InputChanged,function(input)
    if not drag then return end
    if drag.input.UserInputType==Enum.UserInputType.Touch and input~=drag.input then return end
    if drag.input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
    local point=Vector2.new(input.Position.X,input.Position.Y)
    local delta=point-drag.start
    if delta.Magnitude>6 then drag.moved=true end
    if drag.kind=="panel" then
        panel.Position=UDim2.fromOffset(drag.pos.X+delta.X,drag.pos.Y+delta.Y); clampPanel()
    elseif drag.kind=="resize" then
        local v=viewport()
        local w=math.clamp(drag.size.X+delta.X,math.min(350,v.X-16),math.max(math.min(350,v.X-16),v.X-panel.AbsolutePosition.X-8))
        local h=math.clamp(drag.size.Y+delta.Y,math.min(380,v.Y-20),math.max(math.min(380,v.Y-20),v.Y-panel.AbsolutePosition.Y-10))
        panel.Size=UDim2.fromOffset(w,h)
    elseif drag.kind=="icon" then
        local v=viewport()
        icon.Position=UDim2.fromOffset(math.clamp(drag.pos.X+delta.X,0,math.max(0,v.X-66)),math.clamp(drag.pos.Y+delta.Y,0,math.max(0,v.Y-66)))
    elseif drag.kind=="slider" then
        local item=Catalog.ById[drag.data]
        local ratio=math.clamp((point.X-drag.obj.AbsolutePosition.X)/drag.obj.AbsoluteSize.X,0,1)
        local send=os.clock()-drag.lastSend>.1
        change(drag.data,item[6]+ratio*(item[7]-item[6]),send)
        if send then drag.lastSend=os.clock() end
    end
end)

-- Điều khiển cảm ứng và vũ khí tập luyện.
local hud=make("Frame",{Name="Controls",Size=UDim2.fromOffset(222,116),Position=UDim2.new(1,-237,1,-262),
    BackgroundTransparency=1,Visible=false,ZIndex=25},gui)
local aimButton=button(hud,"NGẮM",UDim2.fromOffset(68,40),UDim2.fromOffset(0,0))
local attackButton=button(hud,"ĐÁNH",UDim2.fromOffset(68,40),UDim2.fromOffset(77,0))
local reloadButton=button(hud,"NẠP",UDim2.fromOffset(68,40),UDim2.fromOffset(154,0))
local upButton=button(hud,"↑",UDim2.fromOffset(50,34),UDim2.fromOffset(0,45))
local downButton=button(hud,"↓",UDim2.fromOffset(50,34),UDim2.fromOffset(57,45))
local modeButton=button(hud,"SÚNG",UDim2.fromOffset(107,34),UDim2.fromOffset(115,45))
local ammoText=text(hud,"Trang bị LTM • tập luyện",UDim2.fromOffset(222,28),UDim2.fromOffset(0,83),10,C.pink)
local fov=make("Frame",{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(280,280),
    BackgroundTransparency=1,Visible=false,ZIndex=4},gui); round(fov,999)
local fovStroke=stroke(fov,C.pink,.15,1.5)
local aimHeld,attackHeld,upHeld,downHeld=false,false,false,false
local heldInputs={}
local function hold(buttonObject,name,setter)
    connect(buttonObject.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
            heldInputs[name]={input=input,set=setter}; setter(true)
        end
    end)
end
hold(aimButton,"aim",function(v) aimHeld=v end)
hold(attackButton,"attack",function(v) attackHeld=v end)
hold(upButton,"up",function(v) upHeld=v end)
hold(downButton,"down",function(v) downHeld=v end)
connect(UIS.InputEnded,function(input)
    for name,entry in pairs(heldInputs) do
        if input==entry.input or (entry.input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then
            entry.set(false); heldInputs[name]=nil
        end
    end
    if input.UserInputType==Enum.UserInputType.MouseButton2 then aimHeld=false end
    if input.UserInputType==Enum.UserInputType.MouseButton1 then attackHeld=false end
    if not drag then return end
    if input~=drag.input and not (drag.input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then return end
    local ended=drag; drag=nil
    if ended.kind=="slider" then
        local id=ended.data
        if Catalog.ById[id][9]=="server" then request:FireServer("set",id,values[id]) end
        for _,scroller in ipairs(panels) do scroller.ScrollingEnabled=true end
    elseif ended.kind=="icon" and not ended.moved then setOpen(true) end
end)
local modeIndex=1
local modes={"GUN","SWORD","PUNCH","KICK"}
local modeNames={"SÚNG","KIẾM","ĐẤM","ĐÁ"}
connect(modeButton.Activated,function() modeIndex=modeIndex%4+1; modeButton.Text=modeNames[modeIndex] end)
connect(reloadButton.Activated,function() if unlocked then request:FireServer("reload") end end)
connect(UIS.InputBegan,function(input,processed)
    if UIS:GetFocusedTextBox() then return end
    if not processed and input.KeyCode==Enum.KeyCode.RightShift then setOpen(not panel.Visible) end
    if not unlocked or processed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton2 then aimHeld=true end
    if input.KeyCode==Enum.KeyCode.R then request:FireServer("reload") end
end)
connect(UIS.WindowFocusReleased,function()
    aimHeld=false; attackHeld=false; upHeld=false; downHeld=false; heldInputs={}; drag=nil
    for _,scroller in ipairs(panels) do scroller.ScrollingEnabled=true end
    if unlocked then request:FireServer("move",Vector3.zero) end
end)
local toolConnections={}
local hookedTools={}
local charConnection=nil
local function hookCharacter(character)
    for _,connection in ipairs(toolConnections) do connection:Disconnect() end
    toolConnections={}
    hookedTools={}
    if charConnection then charConnection:Disconnect() end
    local function hookTool(tool)
        if not tool:IsA("Tool") or not tool:GetAttribute("LTMWeapon") or hookedTools[tool] then return end
        hookedTools[tool]=true
        table.insert(toolConnections,tool.Activated:Connect(function() if unlocked then attackHeld=true end end))
        table.insert(toolConnections,tool.Deactivated:Connect(function() attackHeld=false end))
        table.insert(toolConnections,tool.Unequipped:Connect(function() attackHeld=false end))
    end
    charConnection=character.ChildAdded:Connect(hookTool)
    for _,obj in ipairs(character:GetChildren()) do hookTool(obj) end
end
connect(player.CharacterAdded,hookCharacter)
if player.Character then hookCharacter(player.Character) end
connect(reply.OnClientEvent,function(action,a,b,c,message)
    if action=="unlocked" then
        unlocked=true; waitingKey=false; keyBox.Text=""; locked.Visible=false; tabBar.Visible=true
        reset.Visible=true; replay.Visible=true; hud.Visible=true; chooseTab(activeTab)
        notify("Đã mở khóa. Trang bị “LTM • tập luyện” để thử các chế độ đánh.")
    elseif action=="error" then
        waitingKey=false; unlock.Text="XÁC NHẬN"; keyStatus.Text=tostring(a)
    elseif action=="state" and type(a)=="table" then
        for id,value in pairs(a) do
            local definition=Catalog.ById[id]
            if definition and definition[9]=="server" and not (drag and drag.kind=="slider" and drag.data==id) then values[id]=value end
        end
        refreshControls()
        ammoText.Text=c and "Đang nạp…" or (values.noReload and "Đạn ∞  •  LTM" or tostring(b).."/12  •  LTM")
        if message then notify(message) end
    end
end)
local elapsed,espElapsed,netElapsed,lastAttack=0,0,0,-100
local lastViewport=Vector2.zero
Run:BindToRenderStep("LTM_Render",Enum.RenderPriority.Camera.Value+1,function(dt)
    if dead then return end
    local camera=workspace.CurrentCamera
    if not camera then return end
    elapsed=elapsed+dt; espElapsed=espElapsed+dt; netElapsed=netElapsed+dt
    if camera.ViewportSize~=lastViewport then
        lastViewport=camera.ViewportSize; clampPanel()
    end
    if panel.Visible then
        gateScale.Scale=math.min(1,math.max(.5,(locked.AbsoluteSize.Y-14)/258))
        local availableW=math.max(20,panel.AbsoluteSize.X-24)
        local availableH=math.max(20,panel.AbsoluteSize.Y-155)
        local videoW=math.min(availableW,availableH*Config.IntroAspectRatio)
        local videoH=videoW/Config.IntroAspectRatio
        video.Size=UDim2.fromOffset(videoW,videoH)
        video.Position=UDim2.fromOffset((panel.AbsoluteSize.X-videoW)/2,67+(availableH-videoH)/2)
        titleGradient.Rotation=elapsed*23; title.TextTransparency=.06+.12*(.5+.5*math.sin(elapsed*3))
        decor:update(elapsed)
        for _,item in ipairs(icons) do item.object.Rotation=math.sin(elapsed*1.8+item.phase)*13 end
    else iconStroke.Color=Color3.fromHSV((elapsed*.12)%1,.42,1) end
    if espElapsed>1/30 then esp:update(espElapsed,camera,unlocked); espElapsed=0 end
    fov.Visible=unlocked and values.showFov
    local radius=math.min(values.fov,math.max(25,math.min(camera.ViewportSize.X,camera.ViewportSize.Y)/2-8))
    fov.Size=UDim2.fromOffset(radius*2,radius*2); fovStroke.Transparency=values.fade
    upButton.Visible=values.fly; downButton.Visible=values.fly
    if not unlocked then return end
    local partName=values.aimHead and "Head" or "HumanoidRootPart"
    local target,part=esp:pick(camera,radius,partName,not values.wallShot)
    if aimHeld and (values.aimHead or values.aimBody) and part and not UIS:GetFocusedTextBox() then
        local goal=CFrame.lookAt(camera.CFrame.Position,part.Position)
        camera.CFrame=camera.CFrame:Lerp(goal,1-math.exp(-18*dt))
    end
    if netElapsed>=.09 then
        netElapsed=0
        if values.follow or values.overhead then request:FireServer("target",target) end
        if values.fly then
            local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local move=hum and hum.MoveDirection or Vector3.zero
            local typing=UIS:GetFocusedTextBox()~=nil
            local up=upHeld or (not typing and (UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space)))
            local down=downHeld or (not typing and UIS:IsKeyDown(Enum.KeyCode.Q))
            move=move+Vector3.new(0,(up and 1 or 0)-(down and 1 or 0),0)
            if move.Magnitude>1 then move=move.Unit end
            request:FireServer("move",move)
        end
    end
    if attackHeld and not UIS:GetFocusedTextBox() and elapsed-lastAttack>=1/values.attackRate then
        lastAttack=elapsed
        local char=player.Character
        local tool=char and char:FindFirstChildOfClass("Tool")
        if tool and tool:GetAttribute("LTMWeapon") then
            -- Cùng tâm với vòng FOV; bắn theo tia giữa camera, có bù vị trí đầu.
            local ray=camera:ViewportPointToRay(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
            local head=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances={char,esp.world}
            local hit=workspace:Raycast(ray.Origin,ray.Direction*450,params)
            local point=hit and hit.Position or ray.Origin+ray.Direction*450
            local dir=head and (point-head.Position) or ray.Direction
            if dir.Magnitude>.01 then request:FireServer("attack",dir.Unit,target,modes[modeIndex]) end
        elseif not panel.Visible then notify("Hãy trang bị công cụ LTM • tập luyện trong ba lô."); attackHeld=false end
    end
end)
connect(gui.Destroying,function()
    if dead then return end
    dead=true; introSerial=introSerial+1
    Run:UnbindFromRenderStep("LTM_Render")
    if unlocked then request:FireServer("reset") end
    thirdPerson(false); esp:destroy()
    for _,connection in ipairs(connections) do connection:Disconnect() end
    for _,connection in ipairs(toolConnections) do connection:Disconnect() end
    if charConnection then charConnection:Disconnect() end
end)
local size=viewport()
panel.Size=UDim2.fromOffset(math.min(650,size.X-24),math.min(620,size.Y-32))
panel.Position=UDim2.fromOffset(math.max(12,(size.X-panel.Size.X.Offset)/2),math.max(16,(size.Y-panel.Size.Y.Offset)/2))
task.defer(function() if not dead then clampPanel(); setOpen(true) end end)
]========])
print("LTM đã cài. Đặt Asset ID trong ReplicatedStorage/LTM/Config. Play và nhập key: Messi is the Goat")
