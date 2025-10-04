local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- UDHL settings
local udhl_settings = {
    HeadSize = 20,
    Disabled = false,
    Transparency = 0.7,
    Protection = true
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UDHL_GUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
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
title.Text = "UDHL 1.1.2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Settings container
local settingsFrame = Instance.new("Frame")
settingsFrame.Size = UDim2.new(1, -20, 1, -40)
settingsFrame.Position = UDim2.new(0, 10, 0, 35)
settingsFrame.BackgroundTransparency = 1
settingsFrame.Parent = mainFrame

-- HeadSize slider
local sizeFrame = Instance.new("Frame")
sizeFrame.Size = UDim2.new(1, 0, 0, 30)
sizeFrame.BackgroundTransparency = 1
sizeFrame.Parent = settingsFrame

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(0.6, 0, 1, 0)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Head Size: " .. udhl_settings.HeadSize
sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
sizeLabel.Parent = sizeFrame

local sizeBox = Instance.new("TextBox")
sizeBox.Size = UDim2.new(0.35, 0, 0.7, 0)
sizeBox.Position = UDim2.new(0.65, 0, 0.15, 0)
sizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
sizeBox.Text = tostring(udhl_settings.HeadSize)
sizeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeBox.PlaceholderText = "Size"
sizeBox.Parent = sizeFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 4)
boxCorner.Parent = sizeBox

-- Transparency slider
local transFrame = Instance.new("Frame")
transFrame.Size = UDim2.new(1, 0, 0, 30)
transFrame.Position = UDim2.new(0, 0, 0, 35)
transFrame.BackgroundTransparency = 1
transFrame.Parent = settingsFrame

local transLabel = Instance.new("TextLabel")
transLabel.Size = UDim2.new(0.6, 0, 1, 0)
transLabel.BackgroundTransparency = 1
transLabel.Text = "Transparency: " .. udhl_settings.Transparency
transLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
transLabel.TextXAlignment = Enum.TextXAlignment.Left
transLabel.Parent = transFrame

local transBox = Instance.new("TextBox")
transBox.Size = UDim2.new(0.35, 0, 0.7, 0)
transBox.Position = UDim2.new(0.65, 0, 0.15, 0)
transBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
transBox.Text = tostring(udhl_settings.Transparency)
transBox.TextColor3 = Color3.fromRGB(255, 255, 255)
transBox.PlaceholderText = "0-1"
transBox.Parent = transFrame

local transCorner = Instance.new("UICorner")
transCorner.CornerRadius = UDim.new(0, 4)
transCorner.Parent = transBox

-- Toggle buttons
local toggleFrame = Instance.new("Frame")
toggleFrame.Size = UDim2.new(1, 0, 0, 60)
toggleFrame.Position = UDim2.new(0, 0, 0, 70)
toggleFrame.BackgroundTransparency = 1
toggleFrame.Parent = settingsFrame

-- Enable/Disable button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
toggleBtn.BackgroundColor3 = udhl_settings.Disabled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
toggleBtn.Text = udhl_settings.Disabled and "DISABLED" or "ENABLED"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = toggleFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = toggleBtn

-- Protection button
local protectBtn = Instance.new("TextButton")
protectBtn.Size = UDim2.new(0.48, 0, 0.4, 0)
protectBtn.Position = UDim2.new(0.52, 0, 0, 0)
protectBtn.BackgroundColor3 = udhl_settings.Protection and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(100, 100, 100)
protectBtn.Text = udhl_settings.Protection and "PROTECTION ON" or "PROTECTION OFF"
protectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
protectBtn.Font = Enum.Font.GothamBold
protectBtn.Parent = toggleFrame

local protectCorner = Instance.new("UICorner")
protectCorner.CornerRadius = UDim.new(0, 4)
protectCorner.Parent = protectBtn

-- Mobile toggle button
local mobileBtn = Instance.new("TextButton")
mobileBtn.Size = UDim2.new(0, 40, 0, 40)
mobileBtn.Position = UDim2.new(1, 10, 0, 0)
mobileBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
mobileBtn.Text = "≡"
mobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileBtn.TextSize = 20
mobileBtn.Visible = UserInputService.TouchEnabled
mobileBtn.Parent = mainFrame

local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 20)
mobileCorner.Parent = mobileBtn

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

-- Make mobile button draggable too
local mobileDragging
local mobileDragInput
local mobileDragStart
local mobileStartPos

mobileBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        mobileDragging = true
        mobileDragStart = input.Position
        mobileStartPos = mobileBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                mobileDragging = false
            end
        end)
    end
end)

mobileBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        mobileDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == mobileDragInput and mobileDragging then
        local delta = input.Position - mobileDragStart
        mobileBtn.Position = UDim2.new(mobileStartPos.X.Scale, mobileStartPos.X.Offset + delta.X, mobileStartPos.Y.Scale, mobileStartPos.Y.Offset + delta.Y)
    end
end)

-- GUI functionality
local guiVisible = true

mobileBtn.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    settingsFrame.Visible = guiVisible
    title.Visible = guiVisible
end)

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
    toggleBtn.BackgroundColor3 = udhl_settings.Disabled and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(50, 255, 50)
    toggleBtn.Text = udhl_settings.Disabled and "DISABLED" or "ENABLED"
end)

protectBtn.MouseButton1Click:Connect(function()
    udhl_settings.Protection = not udhl_settings.Protection
    protectBtn.BackgroundColor3 = udhl_settings.Protection and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(100, 100, 100)
    protectBtn.Text = udhl_settings.Protection and "PROTECTION ON" or "PROTECTION OFF"
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
