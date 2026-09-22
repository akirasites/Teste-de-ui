--[[
    TomUI v1
    CoiledTom UI Library
    Single-file Luau UI Library
]]

local TomUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

TomUI.Themes = {
    Violet = {
        Background = Color3.fromRGB(8, 8, 11),
        Secondary = Color3.fromRGB(14, 14, 19),
        Tertiary = Color3.fromRGB(20, 20, 27),
        Border = Color3.fromRGB(55, 35, 80),
        Accent = Color3.fromRGB(155, 75, 255),
        AccentDark = Color3.fromRGB(100, 45, 170),
        Text = Color3.fromRGB(245, 245, 250),
        SubText = Color3.fromRGB(145, 145, 160),
        Danger = Color3.fromRGB(235, 55, 65),
        Success = Color3.fromRGB(65, 210, 120),
        Orange = Color3.fromRGB(255, 125, 35)
    },

    Orange = {
        Background = Color3.fromRGB(8, 8, 8),
        Secondary = Color3.fromRGB(15, 14, 13),
        Tertiary = Color3.fromRGB(24, 21, 18),
        Border = Color3.fromRGB(80, 45, 20),
        Accent = Color3.fromRGB(255, 125, 35),
        AccentDark = Color3.fromRGB(175, 75, 15),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(150, 145, 140),
        Danger = Color3.fromRGB(235, 55, 65),
        Success = Color3.fromRGB(65, 210, 120),
        Orange = Color3.fromRGB(255, 125, 35)
    },

    Red = {
        Background = Color3.fromRGB(9, 7, 8),
        Secondary = Color3.fromRGB(17, 12, 14),
        Tertiary = Color3.fromRGB(25, 16, 19),
        Border = Color3.fromRGB(80, 25, 32),
        Accent = Color3.fromRGB(235, 45, 60),
        AccentDark = Color3.fromRGB(160, 25, 38),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(150, 140, 145),
        Danger = Color3.fromRGB(255, 55, 65),
        Success = Color3.fromRGB(65, 210, 120),
        Orange = Color3.fromRGB(255, 125, 35)
    }
}

TomUI.CurrentTheme = TomUI.Themes.Violet

local function New(class, properties)
    local object = Instance.new(class)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    return object
end

local function Corner(parent, radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent
    })
end

local function Stroke(parent, color, thickness, transparency)
    return New("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = parent
    })
end

local function Tween(object, properties, duration)
    local info = TweenInfo.new(
        duration or 0.2,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    TweenService:Create(object, info, properties):Play()
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

function TomUI:CreateWindow(config)
    config = config or {}

    local Theme = self.CurrentTheme
    local Title = config.Title or "TomUI"
    local Size = config.Size or UDim2.fromOffset(560, 380)

    local ScreenGui = New("ScreenGui", {
        Name = "TomUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })

    local Main = New("Frame", {
        Name = "Main",
        Size = Size,
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    Corner(Main, 12)
    Stroke(Main, Theme.Border, 1)

    local Shadow = New("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 40, 1, 40),
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.45,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        ZIndex = 0,
        Parent = Main
    })

    Main.ZIndex = 2

    local Header = New("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    })

    Corner(Header, 12)

    New("Frame", {
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Header
    })

    local Status = New("Frame", {
        Size = UDim2.fromOffset(7, 7),
        Position = UDim2.new(0, 15, 0.5, -3),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = Header
    })

    Corner(Status, 10)

    New("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(30, 0),
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Header
    })

    local Close = New("TextButton", {
        Size = UDim2.fromOffset(34, 34),
        Position = UDim2.new(1, -40, 0, 6),
        BackgroundColor3 = Color3.fromRGB(30, 20, 23),
        Text = "×",
        TextColor3 = Theme.Danger,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        AutoButtonColor = false,
        Parent = Header
    })

    Corner(Close, 8)

    local Minimize = New("TextButton", {
        Size = UDim2.fromOffset(34, 34),
        Position = UDim2.new(1, -78, 0, 6),
        BackgroundColor3 = Theme.Tertiary,
        Text = "−",
        TextColor3 = Theme.SubText,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        Parent = Header
    })

    Corner(Minimize, 8)
    MakeDraggable(Main, Header)

    Close.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.fromOffset(0, 0)}, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    local Sidebar = New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 145, 1, -56),
        Position = UDim2.fromOffset(8, 51),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = Main
    })

    Corner(Sidebar, 9)

    local TabList = New("ScrollingFrame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = Sidebar
    })

    New("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabList
    })

    local Content = New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -161, 1, -56),
        Position = UDim2.fromOffset(153, 51),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local Pages = {}
    local Tabs = {}
    local CurrentTab
    local OriginalSize = Size
    local Minimized = false

    Minimize.MouseButton1Click:Connect(function()
        Minimized = not Minimized

        if Minimized then
            Tween(Main, {Size = UDim2.fromOffset(Size.X.Offset, 46)})
            Sidebar.Visible = false
            Content.Visible = false
        else
            Tween(Main, {Size = OriginalSize})
            task.delay(0.15, function()
                Sidebar.Visible = true
                Content.Visible = true
            end)
        end
    end)

    local Window = {}

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Tab"

        local TabButton = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Theme.Tertiary,
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = TabList
        })

        Corner(TabButton, 7)

        local TabText = New("TextLabel", {
            Size = UDim2.new(1, -15, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })

        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = Content
        })

        New("UIListLayout", {
            Padding = UDim.new(0, 7),
            Parent = Page
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 4),
            Parent = Page
        })

        Pages[TabName] = Page
        Tabs[TabName] = TabButton

        TabButton.MouseButton1Click:Connect(function()
            for name, page in pairs(Pages) do
                page.Visible = false
                if Tabs[name] then
                    Tween(Tabs[name], {BackgroundTransparency = 1}, 0.15)
                    Tween(Tabs[name]:FindFirstChildOfClass("TextLabel"), {
                        TextColor3 = Theme.SubText
                    }, 0.15)
                end
            end

            Page.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0}, 0.15)
            Tween(TabText, {TextColor3 = Theme.Text}, 0.15)
            CurrentTab = TabName
        end)

        if not CurrentTab then
            TabButton:Activate()
        end

        local Tab = {}

        function Tab:CreateSection(text)
            return New("TextLabel", {
                Size = UDim2.new(1, -5, 0, 28),
                BackgroundTransparency = 1,
                Text = text or "Section",
                TextColor3 = Theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
        end

        function Tab:CreateLabel(text)
            local Label = New("TextLabel", {
                Size = UDim2.new(1, -5, 0, 35),
                BackgroundColor3 = Theme.Secondary,
                Text = "  " .. (text or ""),
                TextColor3 = Theme.SubText,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Page
            })
            Corner(Label, 7)
            Stroke(Label, Theme.Border, 1)
            return Label
        end

        function Tab:CreateButton(buttonConfig)
            buttonConfig = buttonConfig or {}

            local Button = New("TextButton", {
                Size = UDim2.new(1, -5, 0, 38),
                BackgroundColor3 = Theme.Secondary,
                Text = buttonConfig.Name or "Button",
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                AutoButtonColor = false,
                Parent = Page
            })

            Corner(Button, 7)
            Stroke(Button, Theme.Border, 1)

            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Tertiary})
            end)

            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Secondary})
            end)

            Button.MouseButton1Click:Connect(function()
                if buttonConfig.Callback then
                    task.spawn(buttonConfig.Callback)
                end
            end)

            return Button
        end

        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local Enabled = toggleConfig.Default or false

            local Holder = New("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                Parent = Page
            })

            Corner(Holder, 7)
            Stroke(Holder, Theme.Border, 1)

            New("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = toggleConfig.Name or "Toggle",
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder
            })

            local Switch = New("TextButton", {
                Size = UDim2.fromOffset(42, 22),
                Position = UDim2.new(1, -52, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(30, 30, 35),
                Text = "",
                AutoButtonColor = false,
                Parent = Holder
            })

            Corner(Switch, 20)

            local Knob = New("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(3, 3),
                BackgroundColor3 = Theme.SubText,
                Parent = Switch
            })

            Corner(Knob, 20)

            local function Update()
                if Enabled then
                    Tween(Switch, {BackgroundColor3 = Theme.Accent})
                    Tween(Knob, {
                        Position = UDim2.new(1, -19, 0, 3),
                        BackgroundColor3 = Theme.Text
                    })
                else
                    Tween(Switch, {BackgroundColor3 = Color3.fromRGB(30, 30, 35)})
                    Tween(Knob, {
                        Position = UDim2.fromOffset(3, 3),
                        BackgroundColor3 = Theme.SubText
                    })
                end

                if toggleConfig.Callback then
                    task.spawn(toggleConfig.Callback, Enabled)
                end
            end

            Switch.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Update()
            end)

            if Enabled then
                Update()
            end

            return {
                Set = function(_, value)
                    Enabled = value
                    Update()
                end,
                Get = function()
                    return Enabled
                end
            }
        end

        function Tab:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}

            local Options = dropdownConfig.Options or {}
            local Selected = dropdownConfig.Default or Options[1]

            local Holder = New("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                ClipsDescendants = true,
                Parent = Page
            })

            Corner(Holder, 7)
            Stroke(Holder, Theme.Border, 1)

            local Button = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 42),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                Parent = Holder
            })

            New("TextLabel", {
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = dropdownConfig.Name or "Dropdown",
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button
            })

            local SelectedLabel = New("TextLabel", {
                Size = UDim2.new(0.45, -15, 1, 0),
                Position = UDim2.new(0.55, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(Selected or "Select"),
                TextColor3 = Theme.Accent,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Button
            })

            local Open = false

            for _, option in ipairs(Options) do
                local OptionButton = New("TextButton", {
                    Size = UDim2.new(1, -12, 0, 30),
                    BackgroundColor3 = Theme.Tertiary,
                    Text = tostring(option),
                    TextColor3 = Theme.SubText,
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    AutoButtonColor = false,
                    Visible = false,
                    Parent = Holder
                })

                Corner(OptionButton, 6)

                OptionButton.MouseButton1Click:Connect(function()
                    Selected = option
                    SelectedLabel.Text = tostring(option)

                    if dropdownConfig.Callback then
                        task.spawn(dropdownConfig.Callback, option)
                    end

                    Open = false
                    Holder.Size = UDim2.new(1, -5, 0, 42)

                    for _, child in ipairs(Holder:GetChildren()) do
                        if child:IsA("TextButton") and child ~= Button then
                            child.Visible = false
                        end
                    end
                end)
            end

            Button.MouseButton1Click:Connect(function()
                Open = not Open

                if Open then
                    local Height = 42 + (#Options * 33)
                    Holder.Size = UDim2.new(1, -5, 0, math.min(Height, 210))

                    local Y = 45

                    for _, child in ipairs(Holder:GetChildren()) do
                        if child:IsA("TextButton") and child ~= Button then
                            child.Position = UDim2.fromOffset(6, Y)
                            child.Visible = true
                            Y += 33
                        end
                    end
                else
                    Holder.Size = UDim2.new(1, -5, 0, 42)

                    for _, child in ipairs(Holder:GetChildren()) do
                        if child:IsA("TextButton") and child ~= Button then
                            child.Visible = false
                        end
                    end
                end
            end)

            return {
                Set = function(_, value)
                    Selected = value
                    SelectedLabel.Text = tostring(value)
                end,
                Get = function()
                    return Selected
                end
            }
        end

        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}

            local Minimum = sliderConfig.Min or 0
            local Maximum = sliderConfig.Max or 100
            local Value = sliderConfig.Default or Minimum

            local Holder = New("Frame", {
                Size = UDim2.new(1, -5, 0, 55),
                BackgroundColor3 = Theme.Secondary,
                Parent = Page
            })

            Corner(Holder, 7)
            Stroke(Holder, Theme.Border, 1)

            New("TextLabel", {
                Size = UDim2.new(1, -70, 0, 25),
                Position = UDim2.fromOffset(12, 2),
                BackgroundTransparency = 1,
                Text = sliderConfig.Name or "Slider",
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder
            })

            local ValueLabel = New("TextLabel", {
                Size = UDim2.fromOffset(50, 25),
                Position = UDim2.new(1, -60, 0, 2),
                BackgroundTransparency = 1,
                Text = tostring(Value),
                TextColor3 = Theme.Accent,
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = Holder
            })

            local Bar = New("Frame", {
                Size = UDim2.new(1, -24, 0, 5),
                Position = UDim2.fromOffset(12, 37),
                BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                BorderSizePixel = 0,
                Parent = Holder
            })

            Corner(Bar, 10)

            local Fill = New("Frame", {
                Size = UDim2.fromScale(
                    (Value - Minimum) / (Maximum - Minimum),
                    1
                ),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = Bar
            })

            Corner(Fill, 10)

            local Dragging = false

            local function SetValue(value)
                Value = math.clamp(value, Minimum, Maximum)

                local Percent =
                    (Value - Minimum) /
                    (Maximum - Minimum)

                Fill.Size = UDim2.fromScale(Percent, 1)
                ValueLabel.Text = tostring(math.floor(Value))

                if sliderConfig.Callback then
                    task.spawn(sliderConfig.Callback, Value)
                end
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if not Dragging then return end

                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                local Percent =
                    math.clamp(
                        (input.Position.X - Bar.AbsolutePosition.X)
                        / Bar.AbsoluteSize.X,
                        0,
                        1
                    )

                SetValue(Minimum + ((Maximum - Minimum) * Percent))
            end)

            return {
                Set = function(_, value)
                    SetValue(value)
                end,
                Get = function()
                    return Value
                end
            }
        end

        function Tab:CreateInput(inputConfig)
            inputConfig = inputConfig or {}

            local Holder = New("Frame", {
                Size = UDim2.new(1, -5, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                Parent = Page
            })

            Corner(Holder, 7)
            Stroke(Holder, Theme.Border, 1)

            local Input = New("TextBox", {
                Size = UDim2.new(1, -20, 1, -10),
                Position = UDim2.fromOffset(10, 5),
                BackgroundColor3 = Theme.Tertiary,
                PlaceholderText = inputConfig.Placeholder or "Digite aqui...",
                PlaceholderColor3 = Theme.SubText,
                Text = inputConfig.Default or "",
                TextColor3 = Theme.Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                ClearTextOnFocus = false,
                Parent = Holder
            })

            Corner(Input, 6)

            Input.FocusLost:Connect(function()
                if inputConfig.Callback then
                    task.spawn(inputConfig.Callback, Input.Text)
                end
            end)

            return Input
        end

        return Tab
    end

    function Window:Notify(config)
        config = config or {}

        local Notification = New("Frame", {
            Size = UDim2.fromOffset(280, 70),
            Position = UDim2.new(1, 20, 1, -85),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = Theme.Secondary,
            Parent = ScreenGui
        })

        Corner(Notification, 9)
        Stroke(Notification, Theme.Border, 1)

        local AccentBar = New("Frame", {
            Size = UDim2.fromOffset(3, 50),
            Position = UDim2.fromOffset(8, 10),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0,
            Parent = Notification
        })

        Corner(AccentBar, 5)

        New("TextLabel", {
            Size = UDim2.new(1, -30, 0, 22),
            Position = UDim2.fromOffset(22, 8),
            BackgroundTransparency = 1,
            Text = config.Title or "TomUI",
            TextColor3 = Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notification
        })

        New("TextLabel", {
            Size = UDim2.new(1, -30, 0, 32),
            Position = UDim2.fromOffset(22, 30),
            BackgroundTransparency = 1,
            Text = config.Content or "",
            TextColor3 = Theme.SubText,
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Notification
        })

        Tween(Notification, {
            Position = UDim2.new(1, -15, 1, -85)
        }, 0.3)

        task.delay(config.Duration or 3, function()
            if Notification.Parent then
                Tween(Notification, {
                    Position = UDim2.new(1, 20, 1, -85)
                }, 0.3)

                task.wait(0.3)
                Notification:Destroy()
            end
        end)

        return Notification
    end

    function Window:SetTheme(themeName)
        local NewTheme = TomUI.Themes[themeName]

        if not NewTheme then
            warn("TomUI: Tema não encontrado:", themeName)
            return
        end

        TomUI.CurrentTheme = NewTheme
        warn("TomUI: Tema alterado para", themeName)
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    Window.ScreenGui = ScreenGui
    Window.Main = Main

    return Window
end

return TomUI
