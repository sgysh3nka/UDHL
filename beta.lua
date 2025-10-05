local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

-- UDHL settings
local udhl_settings = {
    HeadSize = 20,
    Disabled = true,
    Transparency = 0.7,
    Protection = true,
    CFrameSpeed = false,
    CFrameSpeedValue = 50,
    Noclip = false,
    NoSlow = false,
    NoJumpCooldown = false
}

-- Sound IDs to block from being played in Da Hood
local blockedSoundIds = {
    "330595293",    -- Blood Splatter Hit
    "287062939",    -- Hitmarker Sound Effect
    "541909913",    -- Heavy Hard Punch Hit
    "8595980577",   -- hit_punch_l
    "120763034620275", -- pulling(2)
    "1386772138"    -- Stab
}

-- Store GUI elements for updates
local guiElements = {}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UDHL_GUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.BorderSizePixel = 0
title.Text = "UDHL 1.1.3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Category buttons
local categories = {"Combat", "Movement", "Visuals", "Other", "Info"}
local currentCategory = "Combat"

local categoryFrame = Instance.new("Frame")
categoryFrame.Size = UDim2.new(1, 0, 0, 30)
categoryFrame.Position = UDim2.new(0, 0, 0, 30)
categoryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
categoryFrame.BorderSizePixel = 0
categoryFrame.Parent = mainFrame

local categoryLayout = Instance.new("UIListLayout")
categoryLayout.FillDirection = Enum.FillDirection.Horizontal
categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
categoryLayout.Parent = categoryFrame

-- Settings container
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -20, 1, -70)
settingsFrame.Position = UDim2.new(0, 10, 0, 65)
settingsFrame.BackgroundTransparency = 1
settingsFrame.Parent = mainFrame

-- Function to update GUI buttons
local function updateGUI()
    if guiElements.toggleButtons then
        for settingName, toggleButton in pairs(guiElements.toggleButtons) do
            if udhl_settings[settingName] ~= nil then
                toggleButton.BackgroundColor3 = udhl_settings[settingName] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
                toggleButton.Text = udhl_settings[settingName] and "ON" or "OFF"
            end
        end
    end
end

local function createToggleSetting(name, yPosition, settingKey, parent)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 25)
    frame.Position = UDim2.new(0, 0, 0, yPosition)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggle.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggle.BackgroundColor3 = udhl_settings[settingKey] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    toggle.Text = udhl_settings[settingKey] and "ON" or "OFF"
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextSize = 12
    toggle.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 4)
    toggleCorner.Parent = toggle

    -- Store toggle button for updates
    if not guiElements.toggleButtons then
        guiElements.toggleButtons = {}
    end
    guiElements.toggleButtons[settingKey] = toggle

    toggle.MouseButton1Click:Connect(function()
        udhl_settings[settingKey] = not udhl_settings[settingKey]
        toggle.BackgroundColor3 = udhl_settings[settingKey] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        toggle.Text = udhl_settings[settingKey] and "ON" or "OFF"
    end)

    return frame
end

-- Create category buttons
local categoryButtons = {}
for i, categoryName in ipairs(categories) do
    local categoryBtn = Instance.new("TextButton")
    categoryBtn.Size = UDim2.new(0.2, 0, 1, 0)
    categoryBtn.BackgroundColor3 = categoryName == currentCategory and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(50, 50, 60)
    categoryBtn.Text = categoryName
    categoryBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    categoryBtn.TextSize = 12
    categoryBtn.Font = Enum.Font.GothamBold
    categoryBtn.Parent = categoryFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = categoryBtn
    
    categoryButtons[categoryName] = categoryBtn
    
    categoryBtn.MouseButton1Click:Connect(function()
        currentCategory = categoryName
        -- Update all button colors
        for name, btn in pairs(categoryButtons) do
            btn.BackgroundColor3 = name == currentCategory and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(50, 50, 60)
        end
        showCategory(categoryName)
    end)
end

-- Create category containers
local categoryContainers = {}

-- Combat category
local combatContainer = Instance.new("Frame")
combatContainer.Size = UDim2.new(1, 0, 1, 0)
combatContainer.BackgroundTransparency = 1
combatContainer.Visible = true
combatContainer.Parent = settingsFrame
categoryContainers.Combat = combatContainer

-- Movement category
local movementContainer = Instance.new("Frame")
movementContainer.Size = UDim2.new(1, 0, 1, 0)
movementContainer.BackgroundTransparency = 1
movementContainer.Visible = false
movementContainer.Parent = settingsFrame
categoryContainers.Movement = movementContainer

-- Visuals category
local visualsContainer = Instance.new("Frame")
visualsContainer.Size = UDim2.new(1, 0, 1, 0)
visualsContainer.BackgroundTransparency = 1
visualsContainer.Visible = false
visualsContainer.Parent = settingsFrame
categoryContainers.Visuals = visualsContainer

-- Other category
local otherContainer = Instance.new("Frame")
otherContainer.Size = UDim2.new(1, 0, 1, 0)
otherContainer.BackgroundTransparency = 1
otherContainer.Visible = false
otherContainer.Parent = settingsFrame
categoryContainers.Other = otherContainer

-- Info category
local infoContainer = Instance.new("Frame")
infoContainer.Size = UDim2.new(1, 0, 1, 0)
infoContainer.BackgroundTransparency = 1
infoContainer.Visible = false
infoContainer.Parent = settingsFrame
categoryContainers.Info = infoContainer

-- Function to show specific category
local function showCategory(categoryName)
    for name, container in pairs(categoryContainers) do
        container.Visible = (name == categoryName)
    end
end

-- Create settings for each category
local function createSettings()
    local yOffset = 0
    local elementHeight = 30
    
    -- Combat settings
    createToggleSetting("Hitboxes", yOffset, "Disabled", combatContainer)
    yOffset = yOffset + elementHeight
    
    -- HeadSize slider for Combat
    local sizeFrame = Instance.new("Frame")
    sizeFrame.Size = UDim2.new(1, 0, 0, 25)
    sizeFrame.Position = UDim2.new(0, 0, 0, yOffset)
    sizeFrame.BackgroundTransparency = 1
    sizeFrame.Parent = combatContainer
    
    local sizeLabel = Instance.new("TextLabel")
    sizeLabel.Size = UDim2.new(0.6, 0, 1, 0)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Head Size: " .. udhl_settings.HeadSize
    sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    sizeLabel.Parent = sizeFrame
    
    local sizeBox = Instance.new("TextBox")
    sizeBox.Size = UDim2.new(0.35, 0, 0.8, 0)
    sizeBox.Position = UDim2.new(0.65, 0, 0.1, 0)
    sizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sizeBox.Text = tostring(udhl_settings.HeadSize)
    sizeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeBox.PlaceholderText = "Size"
    sizeBox.TextSize = 12
    sizeBox.Parent = sizeFrame
    
    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = sizeBox
    
    yOffset = yOffset + elementHeight
    
    -- Transparency slider for Combat
    local transFrame = Instance.new("Frame")
    transFrame.Size = UDim2.new(1, 0, 0, 25)
    transFrame.Position = UDim2.new(0, 0, 0, yOffset)
    transFrame.BackgroundTransparency = 1
    transFrame.Parent = combatContainer
    
    local transLabel = Instance.new("TextLabel")
    transLabel.Size = UDim2.new(0.6, 0, 1, 0)
    transLabel.BackgroundTransparency = 1
    transLabel.Text = "Transparency: " .. udhl_settings.Transparency
    transLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    transLabel.TextXAlignment = Enum.TextXAlignment.Left
    transLabel.Parent = transFrame
    
    local transBox = Instance.new("TextBox")
    transBox.Size = UDim2.new(0.35, 0, 0.8, 0)
    transBox.Position = UDim2.new(0.65, 0, 0.1, 0)
    transBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    transBox.Text = tostring(udhl_settings.Transparency)
    transBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    transBox.PlaceholderText = "0-1"
    transBox.TextSize = 12
    transBox.Parent = transFrame
    
    local transCorner = Instance.new("UICorner")
    transCorner.CornerRadius = UDim.new(0, 4)
    transCorner.Parent = transBox
    
    -- Movement settings
    yOffset = 0
    
    createToggleSetting("No Slow", yOffset, "NoSlow", movementContainer)
    yOffset = yOffset + elementHeight
    
    createToggleSetting("CFrame Speed", yOffset, "CFrameSpeed", movementContainer)
    yOffset = yOffset + elementHeight
    
    -- CFrame Speed Value for Movement
    local cfSpeedFrame = Instance.new("Frame")
    cfSpeedFrame.Size = UDim2.new(1, 0, 0, 25)
    cfSpeedFrame.Position = UDim2.new(0, 0, 0, yOffset)
    cfSpeedFrame.BackgroundTransparency = 1
    cfSpeedFrame.Parent = movementContainer
    
    local cfSpeedLabel = Instance.new("TextLabel")
    cfSpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
    cfSpeedLabel.BackgroundTransparency = 1
    cfSpeedLabel.Text = "CFrame Speed: " .. udhl_settings.CFrameSpeedValue
    cfSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    cfSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    cfSpeedLabel.Parent = cfSpeedFrame
    
    local cfSpeedBox = Instance.new("TextBox")
    cfSpeedBox.Size = UDim2.new(0.35, 0, 0.8, 0)
    cfSpeedBox.Position = UDim2.new(0.65, 0, 0.1, 0)
    cfSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    cfSpeedBox.Text = tostring(udhl_settings.CFrameSpeedValue)
    cfSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    cfSpeedBox.PlaceholderText = "Speed"
    cfSpeedBox.TextSize = 12
    cfSpeedBox.Parent = cfSpeedFrame
    
    local cfSpeedCorner = Instance.new("UICorner")
    cfSpeedCorner.CornerRadius = UDim.new(0, 4)
    cfSpeedCorner.Parent = cfSpeedBox
    
    yOffset = yOffset + elementHeight
    
    createToggleSetting("No Jump Cooldown", yOffset, "NoJumpCooldown", movementContainer)
    
    -- Visuals settings
    local comingSoonFrame = Instance.new("Frame")
    comingSoonFrame.Size = UDim2.new(1, 0, 1, 0)
    comingSoonFrame.BackgroundTransparency = 1
    comingSoonFrame.Parent = visualsContainer
    
    local comingSoonLabel = Instance.new("TextLabel")
    comingSoonLabel.Size = UDim2.new(1, 0, 0, 50)
    comingSoonLabel.Position = UDim2.new(0, 0, 0.4, 0)
    comingSoonLabel.BackgroundTransparency = 1
    comingSoonLabel.Text = "Coming Soon.."
    comingSoonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    comingSoonLabel.TextSize = 18
    comingSoonLabel.Font = Enum.Font.GothamBold
    comingSoonLabel.Parent = comingSoonFrame
    
    -- Other settings
    yOffset = 0
    createToggleSetting("Anti-Reset Protection", yOffset, "Protection", otherContainer)
    
    -- Info settings
    local discordFrame = Instance.new("Frame")
    discordFrame.Size = UDim2.new(1, 0, 0, 40)
    discordFrame.Position = UDim2.new(0, 0, 0.3, 0)
    discordFrame.BackgroundTransparency = 1
    discordFrame.Parent = infoContainer
    
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0.8, 0, 1, 0)
    discordBtn.Position = UDim2.new(0.1, 0, 0, 0)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "discord.gg/sFRbAWrCCb"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 14
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.Parent = discordFrame
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn
    
    discordBtn.MouseButton1Click:Connect(function()
        -- Copy to clipboard
        pcall(function()
            setclipboard("discord.gg/sFRbAWrCCb")
        end)
        
        -- Visual feedback
        local originalColor = discordBtn.BackgroundColor3
        discordBtn.BackgroundColor3 = Color3.fromRGB(100, 120, 255)
        discordBtn.Text = "Copied!"
        
        task.wait(1)
        
        discordBtn.BackgroundColor3 = originalColor
        discordBtn.Text = "discord.gg/sFRbAWrCCb"
    end)
    
    -- Text box event handlers
    sizeBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSize = tonumber(sizeBox.Text)
            if newSize and newSize > 0 and newSize <= 100 then
                udhl_settings.HeadSize = newSize
                sizeLabel.Text = "Head Size: " .. udhl_settings.HeadSize
            else
                sizeBox.Text = tostring(udhl_settings.HeadSize)
            end
        end
    end)
    
    transBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newTrans = tonumber(transBox.Text)
            if newTrans and newTrans >= 0 and newTrans <= 1 then
                udhl_settings.Transparency = newTrans
                transLabel.Text = "Transparency: " .. udhl_settings.Transparency
            else
                transBox.Text = tostring(udhl_settings.Transparency)
            end
        end
    end)
    
    cfSpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(cfSpeedBox.Text)
            if newSpeed and newSpeed > 0 and newSpeed <= 200 then
                udhl_settings.CFrameSpeedValue = newSpeed
                cfSpeedLabel.Text = "CFrame Speed: " .. udhl_settings.CFrameSpeedValue
            else
                cfSpeedBox.Text = tostring(udhl_settings.CFrameSpeedValue)
            end
        end
    end)
end

-- Mobile control button (big circle for dragging)
local mobileControl = Instance.new("Frame")
mobileControl.Size = UDim2.new(0, 80, 0, 80)
mobileControl.Position = UDim2.new(1, 10, 0, 0)
mobileControl.BackgroundTransparency = 1
mobileControl.Visible = UserInputService.TouchEnabled
mobileControl.Parent = mainFrame

-- Big outer circle for dragging
local dragCircle = Instance.new("TextButton")
dragCircle.Size = UDim2.new(1, 0, 1, 0)
dragCircle.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
dragCircle.Text = ""
dragCircle.Parent = mobileControl

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(1, 0)
dragCorner.Parent = dragCircle

-- Small inner circle for toggle
local toggleCircle = Instance.new("TextButton")
toggleCircle.Size = UDim2.new(0.6, 0, 0.6, 0)
toggleCircle.Position = UDim2.new(0.2, 0, 0.2, 0)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleCircle.TextSize = 16
toggleCircle.Font = Enum.Font.GothamBold
toggleCircle.Parent = mobileControl

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleCircle

-- Make GUI draggable via big circle
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

dragCircle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        -- Visual feedback for dragging
        dragCircle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragCircle.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
            end
        end)
    end
end

dragCircle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- GUI visibility state
local guiVisible = true

-- Function to toggle GUI visibility
local function toggleGUIVisibility()
    guiVisible = not guiVisible
    
    if guiVisible then
        -- Show GUI
        settingsFrame.Visible = true
        title.Visible = true
        categoryFrame.Visible = true
        toggleCircle.Text = "▲"
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        
        -- Smooth show animation
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 400)})
        tween:Play()
    else
        -- Hide GUI
        settingsFrame.Visible = false
        title.Visible = false
        categoryFrame.Visible = false
        toggleCircle.Text = "▼"
        toggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Smooth hide animation
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 300, 0, 40)})
        tween:Play()
    end
end

-- Toggle button click with debounce
local debounce = false
toggleCircle.MouseButton1Click:Connect(function()
    if not debounce then
        debounce = true
        toggleGUIVisibility()
        task.wait(0.2) -- Debounce time
        debounce = false
    end
end

-- Set initial toggle button text
toggleCircle.Text = guiVisible and "▲" or "▼"

-- Create all settings
createSettings()

-- Sound blocking system for Da Hood
local function setupSoundBlocking()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        pcall(function()
            -- Block sounds from being played globally
            for _, sound in pairs(workspace:GetDescendants()) do
                if sound:IsA("Sound") then
                    for _, blockedId in ipairs(blockedSoundIds) do
                        if string.find(sound.SoundId, blockedId) then
                            sound:Stop()
                            sound.Volume = 0
                            sound.Playing = false
                        end
                    end
                end
            end
            
            -- Also check SoundService
            for _, sound in pairs(SoundService:GetDescendants()) do
                if sound:IsA("Sound") then
                    for _, blockedId in ipairs(blockedSoundIds) do
                        if string.find(sound.SoundId, blockedId) then
                            sound:Stop()
                            sound.Volume = 0
                            sound.Playing = false
                        end
                    end
                end
            end
            
            -- Check player's character
            if player.Character then
                for _, sound in pairs(player.Character:GetDescendants()) do
                    if sound:IsA("Sound") then
                        for _, blockedId in ipairs(blockedSoundIds) do
                            if string.find(sound.SoundId, blockedId) then
                                sound:Stop()
                                sound.Volume = 0
                                sound.Playing = false
                            end
                        end
                    end
                end
            end
        end)
    end)
    
    return connection
end

-- CFrame Speed function (fast movement through CFrame manipulation)
local function setupCFrameSpeed()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if udhl_settings.CFrameSpeed and player.Character then
            pcall(function()
                local character = player.Character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                
                if humanoid and rootPart then
                    -- Get movement direction
                    local moveDirection = humanoid.MoveDirection
                    
                    -- If player is moving
                    if moveDirection.Magnitude > 0 then
                        -- Multiply direction by speed
                        local velocity = moveDirection * udhl_settings.CFrameSpeedValue
                        
                        -- Apply CFrame for fast movement
                        rootPart.CFrame = rootPart.CFrame + velocity
                        
                        -- Disable physics to prevent rubberbanding
                        rootPart.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
    end)
    return connection
end

-- Noclip function
local function setupNoclip()
    local connection
    connection = RunService.Stepped:Connect(function()
        if udhl_settings.Noclip and player.Character then
            pcall(function()
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end)
    return connection
end

-- No Slow function (remove weapon slowdown in Da Hood)
local function setupNoSlow()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if udhl_settings.NoSlow and player.Character then
            pcall(function()
                -- Find weapons/tools in character
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Remove any slowdown effects from weapons
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        -- Reset walkspeed to normal if weapon tries to slow it
                        if humanoid.WalkSpeed < 16 then
                            humanoid.WalkSpeed = 16
                        end
                    end
                end
            end)
        end
    end)
    return connection
end

-- No Jump Cooldown function (reset on 3rd jump)
local function setupNoJumpCooldown()
    local connection
    local jumpCount = 0
    local lastJumpTime = 0
    
    connection = RunService.Heartbeat:Connect(function()
        if udhl_settings.NoJumpCooldown and player.Character then
            pcall(function()
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Check if player is jumping
                    if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                        local currentTime = tick()
                        
                        -- If enough time passed since last jump, reset counter
                        if currentTime - lastJumpTime > 1 then
                            jumpCount = 0
                        end
                        
                        jumpCount = jumpCount + 1
                        lastJumpTime = currentTime
                        
                        -- Reset jump state on 3rd jump to bypass cooldown
                        if jumpCount >= 3 then
                            humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                            task.wait(0.05)
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                            jumpCount = 0 -- Reset counter after bypass
                        end
                    end
                end
            end)
        else
            -- Reset counter when disabled
            jumpCount = 0
        end
    end)
    return connection
end

-- Initialize feature connections
local cframeSpeedConnection = setupCFrameSpeed()
local noclipConnection = setupNoclip()
local noslowConnection = setupNoSlow()
local nojumpConnection = setupNoJumpCooldown()
local soundBlockingConnection = setupSoundBlocking()

-- Character respawn handler
local function onCharacterAdded(character)
    -- Wait for character to fully load
    task.wait(1)
    
    -- Update GUI to reflect current settings
    updateGUI()
    
    -- Reset hitboxes for other players based on current setting
    if not udhl_settings.Disabled then
        for i, v in next, Players:GetPlayers() do
            if v ~= player and v.Character then
                pcall(function()
                    local rootPart = v.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Size = Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize)
                        rootPart.Transparency = udhl_settings.Transparency
                        rootPart.BrickColor = BrickColor.new("Really blue")
                        rootPart.Material = "Neon"
                        rootPart.CanCollide = false
                    end
                end)
            end
        end
    else
        -- Reset hitboxes when disabled
        for i, v in next, Players:GetPlayers() do
            if v ~= player and v.Character then
                pcall(function()
                    local rootPart = v.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Size = Vector3.new(2, 2, 1)
                        rootPart.Transparency = 0
                        rootPart.CanCollide = true
                    end
                end)
            end
        end
    end
end

-- Connect character added event
player.CharacterAdded:Connect(onCharacterAdded)

-- Main hitbox expansion loop
RunService.RenderStepped:Connect(function()
    if not udhl_settings.Disabled then
        for i, v in next, Players:GetPlayers() do
            if v ~= player then
                pcall(function()
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = v.Character.HumanoidRootPart
                        
                        -- Apply hitbox expansion
                        rootPart.Size = Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize)
                        rootPart.Transparency = udhl_settings.Transparency
                        rootPart.BrickColor = BrickColor.new("Really blue")
                        rootPart.Material = "Neon"
                        rootPart.CanCollide = false
                        
                        -- Protection system - constantly reapply if game tries to reset
                        if udhl_settings.Protection then
                            if rootPart.Size ~= Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize) then
                                rootPart.Size = Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize)
                            end
                            if rootPart.Transparency ~= udhl_settings.Transparency then
                                rootPart.Transparency = udhl_settings.Transparency
                            end
                            if rootPart.CanCollide == true then
                                rootPart.CanCollide = false
                            end
                        end
                    end
                end)
            end
        end
    else
        -- Reset hitboxes when disabled
        for i, v in next, Players:GetPlayers() do
            if v ~= player then
                pcall(function()
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local rootPart = v.Character.HumanoidRootPart
                        -- Reset to default size
                        rootPart.Size = Vector3.new(2, 2, 1)
                        rootPart.Transparency = 0
                        rootPart.CanCollide = true
                    end
                end)
            end
        end
    end
end)

-- Auto-reapply when players spawn
Players.PlayerAdded:Connect(function(v)
    if v ~= player then
        v.CharacterAdded:Connect(function(char)
            task.wait(1) -- Wait for character to load
            if not udhl_settings.Disabled then
                pcall(function()
                    local rootPart = char:WaitForChild("HumanoidRootPart")
                    rootPart.Size = Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize)
                    rootPart.Transparency = udhl_settings.Transparency
                    rootPart.BrickColor = BrickColor.new("Really blue")
                    rootPart.Material = "Neon"
                    rootPart.CanCollide = false
                end)
            end
        end)
    end
end)

-- Apply to existing players
for i, v in next, Players:GetPlayers() do
    if v ~= player and v.Character then
        pcall(function()
            local rootPart = v.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and not udhl_settings.Disabled then
                rootPart.Size = Vector3.new(udhl_settings.HeadSize, udhl_settings.HeadSize, udhl_settings.HeadSize)
                rootPart.Transparency = udhl_settings.Transparency
                rootPart.BrickColor = BrickColor.new("Really blue")
                rootPart.Material = "Neon"
                rootPart.CanCollide = false
            end
        end)
    end
end

-- Initial GUI update
updateGUI()
