return function(GUI, verifyCallback, copyCallback)
    local function buildUI(url)
        local Main = Instance.new("Frame", GUI)
        Main.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        Main.Position = UDim2.new(0.413, 0, 0.44, 0)
        Main.Size = UDim2.new(0.172, 0, 0.12, 0)
        Instance.new("UICorner", Main)

        local Text = Instance.new("TextLabel", Main)
        Text.Text = "Key Required"
        Text.Size = UDim2.new(1, 0, 1, 0)
        Text.BackgroundTransparency = 1
        Text.Font = Enum.Font.SourceSansSemibold
        Text.TextColor3 = Color3.fromRGB(255, 255, 255)
        Text.TextSize = 20

        local Frame = Instance.new("Frame", GUI)
        Frame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        Frame.Position = UDim2.new(0.388, 0, 0.57, 0)
        Frame.Size = UDim2.new(0.22, 0, 0.15, 0)
        Instance.new("UICorner", Frame)

        local Box = Instance.new("TextBox", Frame)
        Box.PlaceholderText = "Enter Key"
        Box.Size = UDim2.new(0.55, 0, 0.3, 0)
        Box.Position = UDim2.new(0.22, 0, 0.1, 0)
        Box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Box.TextColor3 = Color3.fromRGB(255, 255, 255)
        Box.TextScaled = true
        Instance.new("UICorner", Box)

        local Button = Instance.new("TextButton", Frame)
        Button.Text = "Verify Key"
        Button.Size = UDim2.new(0.72, 0, 0.37, 0)
        Button.Position = UDim2.new(0.14, 0, 0.49, 0)
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 20
        Instance.new("UICorner", Button)

        local Copy = Instance.new("TextButton", Frame)
        Copy.Text = "Get Key"
        Copy.Size = UDim2.new(0.5, 0, 0.45, 0)
        Copy.Position = UDim2.new(0.24, 0, -1.3, 0)
        Copy.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        Copy.TextColor3 = Color3.fromRGB(255, 255, 255)
        Copy.TextSize = 25
        Instance.new("UICorner", Copy)

        Copy.MouseButton1Click:Connect(copyCallback)

        Button.MouseButton1Click:Connect(function()
            verifyCallback(Box.Text)
        end)
    end

    return buildUI
end
