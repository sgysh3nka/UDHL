local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local SETTINGS = {
    Keys = {
        Lock = "q",
        Switch = "e",
        AimMode = "r",
        Menu = "t"
    },
    FOV = 60,
    MaxDistance = 1000,
    Smoothness = 0.2,
    Prediction = 0.2,
    Notifications = true,
    Sounds = true,
    ShowFOV = true,
    AutoFire = false,
    TeamCheck = false,
    WallCheck = false,
    TriggerBot = false
}

local STATE = {
    Active = false,
    Target = nil,
    AimMode = "Head",
    MenuOpen = false,
    Connections = {},
    Highlight = nil,
    FOVCircle = nil,
    Sound = nil,
    NotificationGui = nil
}

local function createSound()
    if not STATE.Sound then
        STATE.Sound = Instance.new("Sound")
        STATE.Sound.SoundId = "rbxassetid://9046895032"
        STATE.Sound.Volume = 0.5
        STATE.Sound.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    end
    return STATE.Sound
end

local function playSound(id)
    if not SETTINGS.Sounds then return end
    local sound = createSound()
    sound.SoundId = "rbxassetid://"..tostring(id)
    sound:Play()
end

local function showNotification(message, soundId)
    if not SETTINGS.Notifications then return end
    
    if STATE.NotificationGui then
        STATE.NotificationGui:Destroy()
    end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "LockNotification_"..HttpService:GenerateGUID(false)
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.25, 0, 0.06, 0)
    frame.Position = UDim2.new(0.75, 0, 0.9, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0.8, 0)
    label.Position = UDim2.new(0.05, 0, 0.1, 0)
    label.Text = "🔫 "..message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    corner.Parent = frame
    label.Parent = frame
    frame.Parent = gui
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    STATE.NotificationGui = gui
    
    if soundId then
        playSound(soundId)
    end
    
    delay(3, function()
        if gui and gui.Parent then
            local tween = TweenService:Create(
                frame,
                TweenInfo.new(0.5),
                {BackgroundTransparency = 1}
            )
            tween:Play()
            tween.Completed:Wait()
            gui:Destroy()
        end
    end)
end

local function createFOVCircle()
    if STATE.FOVCircle then STATE.FOVCircle:Destroy() end
    
    local circle = Instance.new("ScreenGui")
    circle.Name = "FOVCircle"
    circle.ResetOnSpawn = false
    circle.IgnoreGuiInset = true
    circle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local drawing = Instance.new("ImageLabel")
    drawing.Size = UDim2.new(0, SETTINGS.FOV*2, 0, SETTINGS.FOV*2)
    drawing.Position = UDim2.new(0.5, -SETTINGS.FOV, 0.5, -SETTINGS.FOV)
    drawing.BackgroundTransparency = 1
    drawing.Image = "rbxassetid://9442073981"
    drawing.ImageColor3 = Color3.fromRGB(255, 60, 60)
    drawing.ImageTransparency = 0.7
    
    drawing.Parent = frame
    frame.Parent = circle
    circle.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    STATE.FOVCircle = circle
end

local function isVisible(position)
    if not SETTINGS.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (position - origin).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(origin, direction * (position - origin).Magnitude, raycastParams)
    return not result or result.Instance:IsDescendantOf(STATE.Target.Character)
end

local function isEnemy(player)
    if not SETTINGS.TeamCheck then return true end
    
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    
    return true
end

local function getTargetPart(character)
    local partName = STATE.AimMode == "Head" and "Head" or "HumanoidRootPart"
    local part = character:FindFirstChild(partName) or character:FindFirstChild("UpperTorso")
    
    if part and part:IsA("BasePart") then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local velocity = part.Velocity * SETTINGS.Prediction
            return part, velocity
        end
        return part, Vector3.new()
    end
    
    return nil, Vector3.new()
end

local function findBestTarget()
    local closestPlayer = nil
    local shortestDistance = SETTINGS.MaxDistance
    local closestAngle = math.rad(SETTINGS.FOV)
    
    local cameraPos = Camera.CFrame.Position
    local cameraLook = Camera.CFrame.LookVector
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isEnemy(player) then
            local part, velocity = getTargetPart(player.Character)
            if part then
                local position = part.Position + velocity
                local distance = (position - cameraPos).Magnitude
                
                if distance <= SETTINGS.MaxDistance and isVisible(position) then
                    local direction = (position - cameraPos).Unit
                    local angle = math.acos(cameraLook:Dot(direction))
                    
                    if angle <= math.rad(SETTINGS.FOV) and angle < closestAngle then
                        closestAngle = angle
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function smoothAim(targetPos)
    if not LocalPlayer.Character then return end
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local currentPos = root.Position
    local lookAtPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
    
    local currentCF = root.CFrame
    local targetCF = CFrame.new(currentPos, lookAtPos)
    
    root.CFrame = currentCF:Lerp(targetCF, SETTINGS.Smoothness)
end

local function highlightTarget(character)
    if STATE.Highlight then 
        STATE.Highlight:Destroy()
        STATE.Highlight = nil
    end
    
    if not character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "LockHighlight"
    highlight.FillColor = Color3.fromRGB(255, 60, 60)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 80)
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.3
    highlight.Parent = character
    
    STATE.Highlight = highlight
end

local function checkTriggerbot()
    if not SETTINGS.TriggerBot or not STATE.Active or not STATE.Target then return end
    
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = Mouse.Target
        if target and target:IsDescendantOf(STATE.Target.Character) then
            mouse1click()
        end
    end
end

local function updateLock()
    if not STATE.Active then 
        highlightTarget(nil)
        return 
    end
    
    if not STATE.Target or not STATE.Target.Character then
        STATE.Target = findBestTarget()
        if not STATE.Target then 
            showNotification("Target lost", 31173820)
            STATE.Active = false
            return 
        end
        showNotification("Locked: "..STATE.Target.Name, 142376130)
    end
    
    local part, velocity = getTargetPart(STATE.Target.Character)
    if part then
        local targetPos = part.Position + velocity
        smoothAim(targetPos)
        highlightTarget(STATE.Target.Character)
        
        if SETTINGS.AutoFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            mouse1click()
        end
    end
    
    checkTriggerbot()
end

local function createSettingsMenu()
    if STATE.MenuOpen then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LockSettingsMenu"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.25, 0, 0.45, 0)
    frame.Position = UDim2.new(0.75, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Text = "LOCK SETTINGS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.BackgroundTransparency = 1
    closeButton.Font = Enum.Font.GothamBold
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        STATE.MenuOpen = false
    end)
    
    local settingsList = {
        {"FOV", "number", 30, 120, 5},
        {"MaxDistance", "number", 100, 2000, 50},
        {"Smoothness", "number", 0.05, 1, 0.05},
        {"Prediction", "number", 0, 0.5, 0.05},
        {"ShowFOV", "boolean"},
        {"Notifications", "boolean"},
        {"Sounds", "boolean"},
        {"AutoFire", "boolean"},
        {"TriggerBot", "boolean"},
        {"TeamCheck", "boolean"},
        {"WallCheck", "boolean"}
    }
    
    local yOffset = 0.12
    local function createSetting(name, settingType, min, max, step)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0.07, 0)
        container.Position = UDim2.new(0, 0, yOffset, 0)
        container.BackgroundTransparency = 1
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Position = UDim2.new(0.05, 0, 0, 0)
        
        local valueBox = Instance.new("TextButton")
        valueBox.Size = UDim2.new(0.3, 0, 0.8, 0)
        valueBox.Position = UDim2.new(0.65, 0, 0.1, 0)
        valueBox.Text = tostring(SETTINGS[name])
        valueBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        valueBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        valueBox.Font = Enum.Font.Gotham
        valueBox.TextSize = 14
        
        valueBox.MouseButton1Click:Connect(function()
            if settingType == "boolean" then
                SETTINGS[name] = not SETTINGS[name]
                valueBox.Text = tostring(SETTINGS[name])
                showNotification(name..": "..tostring(SETTINGS[name]))
                
                if name == "ShowFOV" then
                    if SETTINGS.ShowFOV then
                        createFOVCircle()
                    elseif STATE.FOVCircle then
                        STATE.FOVCircle:Destroy()
                    end
                end
            elseif settingType == "number" then
                SETTINGS[name] = SETTINGS[name] + step
                if SETTINGS[name] > max then SETTINGS[name] = min end
                local displayValue = string.format(name == "FOV" and "%d" or "%.2f", SETTINGS[name])
                valueBox.Text = displayValue
                showNotification(name..": "..displayValue)
                
                if name == "FOV" and SETTINGS.ShowFOV then
                    STATE.FOVCircle:Destroy()
                    createFOVCircle()
                end
            end
        end)
        
        label.Parent = container
        valueBox.Parent = container
        container.Parent = frame
        
        yOffset = yOffset + 0.07
    end
    
    for _, setting in ipairs(settingsList) do
        createSetting(setting[1], setting[2], setting[3], setting[4], setting[5])
    end
    
    corner.Parent = frame
    title.Parent = frame
    closeButton.Parent = frame
    frame.Parent = screenGui
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    STATE.MenuOpen = true
end

local function handleInput(input, processed)
    if processed or not UserInputService:GetFocusedTextBox() == nil then return end
    
    local key = input.KeyCode.Name:lower()
    
    if key == SETTINGS.Keys.Lock then
        STATE.Active = not STATE.Active
        if STATE.Active then
            STATE.Target = findBestTarget()
            if STATE.Target then
                showNotification("Locked: "..STATE.Target.Name, 142376130)
            else
                showNotification("No targets found", 9046895032)
                STATE.Active = false
            end
        else
            showNotification("Lock disabled", 9046895032)
            highlightTarget(nil)
        end
    elseif key == SETTINGS.Keys.Switch and STATE.Active then
        highlightTarget(nil)
        STATE.Target = findBestTarget()
        if STATE.Target then
            showNotification("Switched to: "..STATE.Target.Name, 142376130)
        end
    elseif key == SETTINGS.Keys.AimMode then
        STATE.AimMode = STATE.AimMode == "Head" and "Body" or "Head"
        showNotification("Aim mode: "..STATE.AimMode, 142376130)
    elseif key == SETTINGS.Keys.Menu then
        createSettingsMenu()
    end
end

local function initialize()
    if SETTINGS.ShowFOV then
        createFOVCircle()
    end
    
    table.insert(STATE.Connections, UserInputService.InputBegan:Connect(handleInput))
    table.insert(STATE.Connections, RunService.Heartbeat:Connect(updateLock))
    
    showNotification("Ultimate Lock Script loaded!", 142376130)
    showNotification("Press ["..SETTINGS.Keys.Menu:upper().."] for settings", 9046895032)
end

local function cleanup()
    for _, conn in ipairs(STATE.Connections) do
        conn:Disconnect()
    end
    
    if STATE.Highlight then STATE.Highlight:Destroy() end
    if STATE.FOVCircle then STATE.FOVCircle:Destroy() end
    if STATE.Sound then STATE.Sound:Destroy() end
    if STATE.NotificationGui then STATE.NotificationGui:Destroy() end
    
    STATE.Connections = {}
    STATE.Active = false
end

local success, err = pcall(initialize)
if not success then
    warn("Lock script error: "..tostring(err))
    cleanup()
end

LocalPlayer.CharacterRemoving:Connect(cleanup)
LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        cleanup()
    end
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local function antiAFK()
    VirtualInputManager:SendKeyEvent(true, "LeftControl", false, nil)
    VirtualInputManager:SendKeyEvent(false, "LeftControl", false, nil)
end

game:GetService("Players").LocalPlayer.Idled:Connect(antiAFK)
