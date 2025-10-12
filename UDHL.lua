local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- UDHL settings
local udhl_settings = {
    -- Combat
    HeadSize = 20,
    Disabled = false,
    Transparency = 0.7,
    Protection = true,
    
    -- Movement
    CFrameSpeed = false,
    SpeedValue = 50,
    
    -- Visuals
    TracersESP = false,
    Box2DESP = false
}

-- ESP variables
local tracers = {}
local boxes2d = {}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UDHL_GUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
title.BorderSizePixel = 0
title.Text = "UDHL 1.1.3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Category buttons
local categoriesFrame = Instance.new("Frame")
categoriesFrame.Size = UDim2.new(1, -20, 0, 30)
categoriesFrame.Position = UDim2.new(0, 10, 0, 45)
categoriesFrame.BackgroundTransparency = 1
categoriesFrame.Parent = mainFrame

local categories = {"Combat", "Movement", "Visuals", "Info"}
local categoryButtons = {}
local currentCategory = "Combat"

for i, category in pairs(categories) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.23, -2, 1, 0)
    btn.Position = UDim2.new(0.23 * (i-1), 0, 0, 0)
    btn.BackgroundColor3 = category == currentCategory and Color3.fromRGB(65, 65, 85) or Color3.fromRGB(45, 45, 55)
    btn.Text = category
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = categoriesFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    -- Add underline for active category
    if category == currentCategory then
        local underline = Instance.new("Frame")
        underline.Size = UDim2.new(1, 0, 0, 2)
        underline.Position = UDim2.new(0, 0, 1, -2)
        underline.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        underline.BorderSizePixel = 0
        underline.Parent = btn
        
        local underlineCorner = Instance.new("UICorner")
        underlineCorner.CornerRadius = UDim.new(0, 1)
        underlineCorner.Parent = underline
    end
    
    categoryButtons[category] = btn
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = category
        for cat, button in pairs(categoryButtons) do
            button.BackgroundColor3 = cat == category and Color3.fromRGB(65, 65, 85) or Color3.fromRGB(45, 45, 55)
            -- Update underline
            local existingUnderline = button:FindFirstChildOfClass("Frame")
            if existingUnderline then
                existingUnderline:Destroy()
            end
            if cat == category then
                local underline = Instance.new("Frame")
                underline.Size = UDim2.new(1, 0, 0, 2)
                underline.Position = UDim2.new(0, 0, 1, -2)
                underline.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                underline.BorderSizePixel = 0
                underline.Parent = button
                
                local underlineCorner = Instance.new("UICorner")
                underlineCorner.CornerRadius = UDim.new(0, 1)
                underlineCorner.Parent = underline
            end
        end
        updateCategoryDisplay()
    end)
end

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -85)
contentFrame.Position = UDim2.new(0, 10, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Category content functions
local categoryContents = {}

-- Combat category
categoryContents.Combat = function(parent)
    local combatFrame = Instance.new("Frame")
    combatFrame.Size = UDim2.new(1, 0, 1, 0)
    combatFrame.BackgroundTransparency = 1
    combatFrame.Parent = parent
    
    -- HeadSize slider
    local sizeFrame = Instance.new("Frame")
    sizeFrame.Size = UDim2.new(1, 0, 0, 35)
    sizeFrame.BackgroundTransparency = 1
    sizeFrame.Parent = combatFrame

    local sizeLabel = Instance.new("TextLabel")
    sizeLabel.Size = UDim2.new(0.6, 0, 1, 0)
    sizeLabel.BackgroundTransparency = 1
    sizeLabel.Text = "Head Size: " .. udhl_settings.HeadSize
    sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
    sizeLabel.TextSize = 14
    sizeLabel.Font = Enum.Font.Gotham
    sizeLabel.Parent = sizeFrame

    local sizeBox = Instance.new("TextBox")
    sizeBox.Size = UDim2.new(0.35, 0, 0.7, 0)
    sizeBox.Position = UDim2.new(0.65, 0, 0.15, 0)
    sizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    sizeBox.Text = tostring(udhl_settings.HeadSize)
    sizeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    sizeBox.PlaceholderText = "Size"
    sizeBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    sizeBox.TextSize = 14
    sizeBox.Font = Enum.Font.Gotham
    sizeBox.Parent = sizeFrame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent = sizeBox

    -- Transparency slider
    local transFrame = Instance.new("Frame")
    transFrame.Size = UDim2.new(1, 0, 0, 35)
    transFrame.Position = UDim2.new(0, 0, 0, 40)
    transFrame.BackgroundTransparency = 1
    transFrame.Parent = combatFrame

    local transLabel = Instance.new("TextLabel")
    transLabel.Size = UDim2.new(0.6, 0, 1, 0)
    transLabel.BackgroundTransparency = 1
    transLabel.Text = "Transparency: " .. udhl_settings.Transparency
    transLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    transLabel.TextXAlignment = Enum.TextXAlignment.Left
    transLabel.TextSize = 14
    transLabel.Font = Enum.Font.Gotham
    transLabel.Parent = transFrame

    local transBox = Instance.new("TextBox")
    transBox.Size = UDim2.new(0.35, 0, 0.7, 0)
    transBox.Position = UDim2.new(0.65, 0, 0.15, 0)
    transBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    transBox.Text = tostring(udhl_settings.Transparency)
    transBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    transBox.PlaceholderText = "0-1"
    transBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    transBox.TextSize = 14
    transBox.Font = Enum.Font.Gotham
    transBox.Parent = transFrame

    local transCorner = Instance.new("UICorner")
    transCorner.CornerRadius = UDim.new(0, 4)
    transCorner.Parent = transBox

    -- Toggle buttons
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 90)
    toggleFrame.Position = UDim2.new(0, 0, 0, 80)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = combatFrame

    -- Enable/Disable button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, 0, 0, 35)
    toggleBtn.BackgroundColor3 = udhl_settings.Disabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
    toggleBtn.Text = udhl_settings.Disabled and "HITBOX: DISABLED" or "HITBOX: ENABLED"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 14
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = toggleFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn

    -- Protection button
    local protectBtn = Instance.new("TextButton")
    protectBtn.Size = UDim2.new(1, 0, 0, 35)
    protectBtn.Position = UDim2.new(0, 0, 0, 45)
    protectBtn.BackgroundColor3 = udhl_settings.Protection and Color3.fromRGB(50, 120, 220) or Color3.fromRGB(80, 80, 80)
    protectBtn.Text = udhl_settings.Protection and "PROTECTION: ON" or "PROTECTION: OFF"
    protectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    protectBtn.TextSize = 14
    protectBtn.Font = Enum.Font.GothamBold
    protectBtn.Parent = toggleFrame

    local protectCorner = Instance.new("UICorner")
    protectCorner.CornerRadius = UDim.new(0, 6)
    protectCorner.Parent = protectBtn

    -- Connections
    sizeBox.FocusLost:Connect(function()
        local newSize = tonumber(sizeBox.Text)
        if newSize and newSize > 0 and newSize <= 100 then
            udhl_settings.HeadSize = newSize
            sizeLabel.Text = "Head Size: " .. udhl_settings.HeadSize
        else
            sizeBox.Text = tostring(udhl_settings.HeadSize)
        end
    end)

    transBox.FocusLost:Connect(function()
        local newTrans = tonumber(transBox.Text)
        if newTrans and newTrans >= 0 and newTrans <= 1 then
            udhl_settings.Transparency = newTrans
            transLabel.Text = "Transparency: " .. udhl_settings.Transparency
        else
            transBox.Text = tostring(udhl_settings.Transparency)
        end
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        udhl_settings.Disabled = not udhl_settings.Disabled
        toggleBtn.BackgroundColor3 = udhl_settings.Disabled and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
        toggleBtn.Text = udhl_settings.Disabled and "HITBOX: DISABLED" or "HITBOX: ENABLED"
    end)

    protectBtn.MouseButton1Click:Connect(function()
        udhl_settings.Protection = not udhl_settings.Protection
        protectBtn.BackgroundColor3 = udhl_settings.Protection and Color3.fromRGB(50, 120, 220) or Color3.fromRGB(80, 80, 80)
        protectBtn.Text = udhl_settings.Protection and "PROTECTION: ON" or "PROTECTION: OFF"
    end)
    
    return combatFrame
end

-- Movement category
categoryContents.Movement = function(parent)
    local movementFrame = Instance.new("Frame")
    movementFrame.Size = UDim2.new(1, 0, 1, 0)
    movementFrame.BackgroundTransparency = 1
    movementFrame.Parent = parent
    
    -- Speed value
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(1, 0, 0, 35)
    speedFrame.BackgroundTransparency = 1
    speedFrame.Parent = movementFrame

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.6, 0, 1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed Value: " .. udhl_settings.SpeedValue
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.TextSize = 14
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = speedFrame

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.35, 0, 0.7, 0)
    speedBox.Position = UDim2.new(0.65, 0, 0.15, 0)
    speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    speedBox.Text = tostring(udhl_settings.SpeedValue)
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.PlaceholderText = "Speed"
    speedBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    speedBox.TextSize = 14
    speedBox.Font = Enum.Font.Gotham
    speedBox.Parent = speedFrame

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 4)
    speedCorner.Parent = speedBox

    -- CFrame Speed toggle
    local speedToggleFrame = Instance.new("Frame")
    speedToggleFrame.Size = UDim2.new(1, 0, 0, 40)
    speedToggleFrame.Position = UDim2.new(0, 0, 0, 40)
    speedToggleFrame.BackgroundTransparency = 1
    speedToggleFrame.Parent = movementFrame

    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(1, 0, 0, 35)
    speedBtn.BackgroundColor3 = udhl_settings.CFrameSpeed and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    speedBtn.Text = udhl_settings.CFrameSpeed and "CFRAME SPEED: ON" or "CFRAME SPEED: OFF"
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.TextSize = 14
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.Parent = speedToggleFrame

    local speedBtnCorner = Instance.new("UICorner")
    speedBtnCorner.CornerRadius = UDim.new(0, 6)
    speedBtnCorner.Parent = speedBtn

    -- Connections
    speedBox.FocusLost:Connect(function()
        local newSpeed = tonumber(speedBox.Text)
        if newSpeed and newSpeed > 0 and newSpeed <= 500 then
            udhl_settings.SpeedValue = newSpeed
            speedLabel.Text = "Speed Value: " .. udhl_settings.SpeedValue
        else
            speedBox.Text = tostring(udhl_settings.SpeedValue)
        end
    end)

    speedBtn.MouseButton1Click:Connect(function()
        udhl_settings.CFrameSpeed = not udhl_settings.CFrameSpeed
        speedBtn.BackgroundColor3 = udhl_settings.CFrameSpeed and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        speedBtn.Text = udhl_settings.CFrameSpeed and "CFRAME SPEED: ON" or "CFRAME SPEED: OFF"
    end)
    
    return movementFrame
end

-- Visuals category
categoryContents.Visuals = function(parent)
    local visualsFrame = Instance.new("Frame")
    visualsFrame.Size = UDim2.new(1, 0, 1, 0)
    visualsFrame.BackgroundTransparency = 1
    visualsFrame.Parent = parent
    
    -- Tracers ESP
    local tracersFrame = Instance.new("Frame")
    tracersFrame.Size = UDim2.new(1, 0, 0, 35)
    tracersFrame.BackgroundTransparency = 1
    tracersFrame.Parent = visualsFrame

    local tracersBtn = Instance.new("TextButton")
    tracersBtn.Size = UDim2.new(1, 0, 1, 0)
    tracersBtn.BackgroundColor3 = udhl_settings.TracersESP and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    tracersBtn.Text = udhl_settings.TracersESP and "TRACERS ESP: ON" or "TRACERS ESP: OFF"
    tracersBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tracersBtn.TextSize = 14
    tracersBtn.Font = Enum.Font.GothamBold
    tracersBtn.Parent = tracersFrame

    local tracersCorner = Instance.new("UICorner")
    tracersCorner.CornerRadius = UDim.new(0, 6)
    tracersCorner.Parent = tracersBtn

    -- 2D Box ESP
    local box2dFrame = Instance.new("Frame")
    box2dFrame.Size = UDim2.new(1, 0, 0, 35)
    box2dFrame.Position = UDim2.new(0, 0, 0, 40)
    box2dFrame.BackgroundTransparency = 1
    box2dFrame.Parent = visualsFrame

    local box2dBtn = Instance.new("TextButton")
    box2dBtn.Size = UDim2.new(1, 0, 1, 0)
    box2dBtn.BackgroundColor3 = udhl_settings.Box2DESP and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    box2dBtn.Text = udhl_settings.Box2DESP and "2D BOX ESP: ON" or "2D BOX ESP: OFF"
    box2dBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    box2dBtn.TextSize = 14
    box2dBtn.Font = Enum.Font.GothamBold
    box2dBtn.Parent = box2dFrame

    local box2dCorner = Instance.new("UICorner")
    box2dCorner.CornerRadius = UDim.new(0, 6)
    box2dCorner.Parent = box2dBtn

    -- Connections
    tracersBtn.MouseButton1Click:Connect(function()
        udhl_settings.TracersESP = not udhl_settings.TracersESP
        tracersBtn.BackgroundColor3 = udhl_settings.TracersESP and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        tracersBtn.Text = udhl_settings.TracersESP and "TRACERS ESP: ON" or "TRACERS ESP: OFF"
        updateESP()
    end)

    box2dBtn.MouseButton1Click:Connect(function()
        udhl_settings.Box2DESP = not udhl_settings.Box2DESP
        box2dBtn.BackgroundColor3 = udhl_settings.Box2DESP and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        box2dBtn.Text = udhl_settings.Box2DESP and "2D BOX ESP: ON" or "2D BOX ESP: OFF"
        updateESP()
    end)
    
    return visualsFrame
end

-- Info category
categoryContents.Info = function(parent)
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, 0, 1, 0)
    infoFrame.BackgroundTransparency = 1
    infoFrame.Parent = parent
    
    -- Discord button
    local discordFrame = Instance.new("Frame")
    discordFrame.Size = UDim2.new(1, 0, 0, 40)
    discordFrame.BackgroundTransparency = 1
    discordFrame.Parent = infoFrame

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 1, 0)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "COPY DISCORD LINK"
    discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordBtn.TextSize = 14
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.Parent = discordFrame

    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 6)
    discordCorner.Parent = discordBtn

    -- Info text
    local infoText = Instance.new("TextLabel")
    infoText.Size = UDim2.new(1, 0, 0, 120)
    infoText.Position = UDim2.new(0, 0, 0, 50)
    infoText.BackgroundTransparency = 1
    infoText.Text = "UDHL Version 1.1.3\n\nEnhanced gameplay experience\n\nJoin our Discord for updates and support!"
    infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoText.TextSize = 14
    infoText.Font = Enum.Font.Gotham
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true
    infoText.Parent = infoFrame

    -- Connection
    discordBtn.MouseButton1Click:Connect(function()
        local discordLink = "discord.gg/sFRbAWrCCb"
        pcall(function()
            setclipboard(discordLink)
        end)
        discordBtn.Text = "COPIED!"
        wait(1)
        discordBtn.Text = "COPY DISCORD LINK"
    end)
    
    return infoFrame
end

-- Function to update category display
function updateCategoryDisplay()
    for _, child in ipairs(contentFrame:GetChildren()) do
        child:Destroy()
    end
    categoryContents[currentCategory](contentFrame)
end

-- Make GUI draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Initialize first category
updateCategoryDisplay()

-- ESP Functions using Drawing library
function createTracer(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Color3.fromRGB(255, 255, 255)
    tracer.Thickness = 1
    tracer.ZIndex = 1
    
    tracers[player] = tracer
end

function createBox2D(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local box = {
        top = Drawing.new("Line"),
        bottom = Drawing.new("Line"),
        left = Drawing.new("Line"),
        right = Drawing.new("Line")
    }
    
    for _, line in pairs(box) do
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 1
        line.ZIndex = 1
    end
    
    boxes2d[player] = box
end

function updateESP()
    -- Clear existing ESP
    for player, tracer in pairs(tracers) do
        if tracer then
            tracer:Remove()
        end
    end
    tracers = {}
    
    for player, box in pairs(boxes2d) do
        for _, line in pairs(box) do
            if line then
                line:Remove()
            end
        end
    end
    boxes2d = {}
    
    -- Create new ESP based on settings
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            if udhl_settings.TracersESP then
                createTracer(player)
            end
            if udhl_settings.Box2DESP then
                createBox2D(player)
            end
        end
    end
end

-- ESP update loop
RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    
    for player, tracer in pairs(tracers) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPoint, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(screenPoint.X, screenPoint.Y)
                tracer.Visible = true
            else
                tracer.Visible = false
            end
        else
            tracer.Visible = false
        end
    end
    
    for player, box in pairs(boxes2d) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local screenPoint, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local head = player.Character:FindFirstChild("Head")
                local headPoint = head and camera:WorldToViewportPoint(head.Position)
                
                if headPoint then
                    local height = math.abs(screenPoint.Y - headPoint.Y)
                    local width = height / 2
                    
                    local topLeft = Vector2.new(screenPoint.X - width/2, headPoint.Y)
                    local topRight = Vector2.new(screenPoint.X + width/2, headPoint.Y)
                    local bottomLeft = Vector2.new(screenPoint.X - width/2, screenPoint.Y)
                    local bottomRight = Vector2.new(screenPoint.X + width/2, screenPoint.Y)
                    
                    box.top.From = topLeft
                    box.top.To = topRight
                    box.top.Visible = true
                    
                    box.bottom.From = bottomLeft
                    box.bottom.To = bottomRight
                    box.bottom.Visible = true
                    
                    box.left.From = topLeft
                    box.left.To = bottomLeft
                    box.left.Visible = true
                    
                    box.right.From = topRight
                    box.right.To = bottomRight
                    box.right.Visible = true
                end
            else
                for _, line in pairs(box) do
                    line.Visible = false
                end
            end
        else
            for _, line in pairs(box) do
                line.Visible = false
            end
        end
    end
end)

-- Improved CFrame Speed functionality based on the example
local speedControlConnection

local function SpeedControl()
    while udhl_settings.CFrameSpeed do
        RunService.RenderStepped:Wait()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local moveDirection = player.Character.Humanoid.MoveDirection
            if moveDirection.Magnitude > 0 then
                player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + moveDirection * (udhl_settings.SpeedValue / 10)
            end
        end
    end
end

-- Monitor CFrame Speed changes
spawn(function()
    while true do
        if speedControlConnection then
            speedControlConnection:Disconnect()
            speedControlConnection = nil
        end
        
        if udhl_settings.CFrameSpeed then
            speedControlConnection = RunService.RenderStepped:Connect(function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                    local moveDirection = player.Character.Humanoid.MoveDirection
                    if moveDirection.Magnitude > 0 then
                        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + moveDirection * (udhl_settings.SpeedValue / 10)
                    end
                end
            end)
        end
        wait(0.5)
    end
end)

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
            wait(1) -- Wait for character to load
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
            updateESP()
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

-- Initialize ESP
updateESP()
