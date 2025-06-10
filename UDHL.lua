local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")

local SETTINGS = {
    Keys = {Lock = "q", Switch = "e", AimMode = "r", Menu = "t", HideUI = "l"},
    FOV = 60, MaxDistance = 1000, Smoothness = 0.2, Prediction = 0.2,
    Notifications = true, Sounds = true, ShowFOV = true, UIVisible = true
}

local STATE = {Active = false, Target = nil, AimMode = "Head", Connections = {}}

-- Watermark
local function createWatermark()
    if STATE.Watermark then STATE.Watermark:Destroy() end
    
    local watermark = Instance.new("ScreenGui")
    watermark.Name = "UDHL_Watermark"
    watermark.ResetOnSpawn = false
    watermark.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Position = UDim2.new(1, -10, 0, 10)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.BackgroundTransparency = 0.3
    
    local label = Instance.new("TextLabel")
    label.Text = "UDHL v1.1.1 | discord.gg/sFRbAWrCCb"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Right
    
    local textBounds = TextService:GetTextSize(label.Text, label.TextSize, label.Font, Vector2.new(10000, 10000))
    frame.Size = UDim2.new(0, textBounds.X + 20, 0, textBounds.Y + 10)
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    
    label.Parent = frame
    frame.Parent = watermark
    watermark.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    STATE.Watermark = watermark
end

-- FOV Circle
local function createFOVCircle()
    if STATE.FOVCircle then STATE.FOVCircle:Destroy() end
    
    local circle = Instance.new("ScreenGui")
    circle.Name = "FOVCircle"
    circle.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local drawing = Instance.new("ImageLabel")
    drawing.Size = UDim2.new(0, SETTINGS.FOV*2, 0, SETTINGS.FOV*2)
    drawing.Position = UDim2.new(0.5, -SETTINGS.FOV, 0.5, -SETTINGS.FOV)
    drawing.BackgroundTransparency = 1
    drawing.Image = "rbxassetid://9442073981"
    drawing.ImageColor3 = Color3.new(1, 0.2, 0.2)
    drawing.ImageTransparency = 0.7
    
    drawing.Parent = frame
    frame.Parent = circle
    circle.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    STATE.FOVCircle = circle
end

-- Target Finding
local function findBestTarget()
    local closestPlayer, closestAngle = nil, math.rad(SETTINGS.FOV)
    local cameraPos, cameraLook = Camera.CFrame.Position, Camera.CFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(STATE.AimMode == "Head" and "Head" or "HumanoidRootPart")
            if part then
                local position = part.Position + (part.Velocity * SETTINGS.Prediction)
                local direction = (position - cameraPos).Unit
                local angle = math.acos(cameraLook:Dot(direction))
                
                if angle <= math.rad(SETTINGS.FOV) and angle < closestAngle then
                    closestAngle, closestPlayer = angle, player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aim Function
local function smoothAim(targetPos)
    if not LocalPlayer.Character then return end
    
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local cameraCF = Camera.CFrame
    local targetDirection = (targetPos - cameraCF.Position).Unit
    local rotation = CFrame.fromAxisAngle(cameraCF.LookVector:Cross(targetDirection), math.acos(math.clamp(cameraCF.LookVector:Dot(targetDirection), -1, 1))
    
    Camera.CFrame = cameraCF:Lerp(cameraCF * rotation, SETTINGS.Smoothness)
    
    local lookAtPos = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
    root.CFrame = root.CFrame:Lerp(CFrame.new(root.Position, lookAtPos), SETTINGS.Smoothness)
end

-- Main Functions
local function updateLock()
    if not STATE.Active then return end
    
    if not STATE.Target or not STATE.Target.Character then
        STATE.Target = findBestTarget()
        if not STATE.Target then 
            STATE.Active = false
            return 
        end
    end
    
    local part = STATE.Target.Character:FindFirstChild(STATE.AimMode == "Head" and "Head" or "HumanoidRootPart")
    if part then
        smoothAim(part.Position + (part.Velocity * SETTINGS.Prediction))
    end
end

local function handleInput(input, processed)
    if processed or UserInputService:GetFocusedTextBox() then return end
    local key = input.KeyCode.Name:lower()
    
    if key == SETTINGS.Keys.Lock then
        STATE.Active = not STATE.Active
        if STATE.Active then STATE.Target = findBestTarget() end
    elseif key == SETTINGS.Keys.Switch and STATE.Active then
        STATE.Target = findBestTarget()
    elseif key == SETTINGS.Keys.AimMode then
        STATE.AimMode = STATE.AimMode == "Head" and "Body" or "Head"
    elseif key == SETTINGS.Keys.HideUI then
        SETTINGS.UIVisible = not SETTINGS.UIVisible
        if STATE.Watermark then STATE.Watermark.Enabled = SETTINGS.UIVisible end
        if STATE.FOVCircle then STATE.FOVCircle.Enabled = SETTINGS.UIVisible end
    end
end

-- Initialization
local function init()
    createWatermark()
    if SETTINGS.ShowFOV then createFOVCircle() end
    
    table.insert(STATE.Connections, UserInputService.InputBegan:Connect(handleInput))
    table.insert(STATE.Connections, RunService.Heartbeat:Connect(updateLock))
end

local function cleanup()
    for _, conn in ipairs(STATE.Connections) do conn:Disconnect() end
    if STATE.Watermark then STATE.Watermark:Destroy() end
    if STATE.FOVCircle then STATE.FOVCircle:Destroy() end
    STATE.Connections = {}
end

if pcall(init) then
    LocalPlayer.CharacterRemoving:Connect(cleanup)
    LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started then cleanup() end
    end)
end
