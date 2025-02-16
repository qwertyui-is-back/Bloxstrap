if shared.loaded then
    shared.loaded:destruct()
end
local httpservice = cloneref(game:GetService('HttpService')) :: HttpService
local tweenservice = cloneref(game:GetService('TweenService')) :: TweenService
local inputservice = cloneref(game:GetService('UserInputService')) :: UserInputService
local lib = {
    windows = {},
    sections = {},
    assets = {
        intergrations = 'rbxassetid://94186399020089',
        ['engine settings'] = 'rbxassetid://94903440484497',
        mods = 'rbxassetid://126821269590599',
        appearence = 'rbxassetid://98935832640924',
        behaviour = 'rbxassetid://137701271745658',
        exit = 'rbxassetid://98193757882443'
    },
    configs = isfile('bloxstrap/logs/profile.json') and httpservice:JSONDecode(readfile('bloxstrap/logs/profile.json')) or {},
    fonts = {
        regular = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        medium = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        bold = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    },
    tweenspeed = 0.2,
    saving = false,
    drags = {},
    scale = workspace.CurrentCamera.ViewportSize.Y / 900,
    enabled = false,
    modules = {}
} :: table

function lib:clean(cons)
    for _, v in cons do
        if typeof(v) == 'Instance' then
            pcall(function()
                v:Destroy()
            end)
        elseif type(v) == 'thread' then
            pcall(task.cancel, v)
        else
            v:Disconnect() 
        end
    end
    table.clear(cons)
end

function lib:setdraggable(gui, bool)
    if not self.drags[gui] then
        local dragging
        local dragInput
        local dragStart
        local startPos
        
        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        inputservice.InputChanged:Connect(function(input)
            if self.drags[gui] and input == dragInput and dragging then
                local delta = input.Position - dragStart
                tweenservice:Create(gui, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end)
    end
    self.drags[gui] = bool
end

local configtable = table.clone(lib.configs)

local screengui = Instance.new('ScreenGui')
screengui.ResetOnSpawn = false
screengui.IgnoreGuiInset = true
screengui.Parent = gethui and gethui() or game:GetService('CoreGui')

lib.gui = screengui

local mainframe = Instance.new('Frame')
mainframe.Parent = screengui
mainframe.Name = 'MainFrame'
mainframe.AnchorPoint = Vector2.new(0.5, 0.5)
mainframe.Position = UDim2.fromScale(0.5, 0.5)
mainframe.BackgroundTransparency = 0.03
mainframe.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainframe.Size = UDim2.fromOffset(1013, 577)

local uiscale = Instance.new('UIScale')
uiscale.Parent = mainframe
uiscale.Scale = 0

workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(function()
    lib.scale = workspace.CurrentCamera.ViewportSize.Y / 900
    if lib.enabled then
        uiscale.Scale = lib.scale
    end
end)

lib:setdraggable(mainframe, true)

local tabBholders = Instance.new('Frame')
tabBholders.Parent = mainframe
tabBholders.Position = UDim2.fromScale(0.025, 0.127)
tabBholders.BackgroundTransparency = 1
tabBholders.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabBholders.Size = UDim2.fromOffset(155, 444)

local labelname = Instance.new('TextLabel')
labelname.Parent = mainframe
labelname.BackgroundTransparency = 1
labelname.Position = UDim2.fromScale(0.005, 0.032)
labelname.Size = UDim2.fromOffset(177, 30)
labelname.FontFace = lib.fonts.medium
labelname.TextScaled = true
labelname.TextColor3 = Color3.new(1,1,1)
labelname.Text = 'Bloxstrap'
Instance.new('UICorner', mainframe).CornerRadius = UDim.new(0, 18)

local exitbutton = Instance.new('TextButton')
exitbutton.BackgroundTransparency = 1
exitbutton.AutoButtonColor = false
exitbutton.Text = ''
exitbutton.Parent = mainframe
exitbutton.Position = UDim2.fromScale(0.025, 0.915)
exitbutton.Size = UDim2.fromOffset(166, 30)

local imagelabel = Instance.new('ImageLabel')
imagelabel.Parent = exitbutton
imagelabel.Size = UDim2.fromOffset(20, 20)
imagelabel.AnchorPoint = Vector2.new(0, 0.5)
imagelabel.Position = UDim2.fromScale(0, 0.5)
imagelabel.Image = lib.assets.exit
imagelabel.BackgroundTransparency = 1

local textlabel = Instance.new('TextLabel')
textlabel.Position = UDim2.fromScale(0.181, 0.3)
textlabel.Size = UDim2.fromOffset(200, 13)
textlabel.TextScaled = true
textlabel.TextWrapped = true
textlabel.BackgroundTransparency = 1
textlabel.Text = 'Close'
textlabel.Parent = exitbutton
textlabel.TextXAlignment = Enum.TextXAlignment.Left
textlabel.TextColor3 = Color3.new(1, 1, 1)
textlabel.FontFace = lib.fonts.medium

exitbutton.MouseButton1Click:Connect(function()
    lib:toggle(false)
end)

local tabholder = Instance.new('Frame', mainframe)
tabholder.Name = 'Main'
tabholder.Position = UDim2.fromScale(0.185, 0)
tabholder.Size = UDim2.fromOffset(826, 577)
tabholder.ClipsDescendants = true
tabholder.BorderSizePixel = 0
tabholder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)


Instance.new('UICorner', tabholder).CornerRadius = UDim.new(0, 18)

local cornerer = Instance.new('Frame', tabholder)
cornerer.Name = 'Cornerer'
cornerer.Size = UDim2.fromOffset(84, 577)
cornerer.BorderSizePixel = 0
cornerer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

function lib:addsection(args)
    local sectionframe = Instance.new('Frame', tabBholders)
    sectionframe.BackgroundTransparency = 1
    sectionframe.Name = 'sectionframe'
    sectionframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
    sectionframe.Size = UDim2.new(0, 161, 0, 60)
    sectionframe.BorderSizePixel = 0
    sectionframe.Position = args.pos
    sectionframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    
    local label = Instance.new('TextLabel', sectionframe)
    label.TextColor3 = Color3.fromRGB(179, 179, 179)
    label.Text = args.name
    label.Name = 'label'
    label.Size = UDim2.fromOffset(100, 15)
    label.Position = UDim2.fromScale(-0.08, 0)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.FontFace = lib.fonts.medium
    label.TextScaled = true
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local modholder = Instance.new('Frame')
    modholder.Parent = sectionframe
    modholder.Name = 'modholder'
    modholder.BackgroundTransparency = 1
    modholder.Position = UDim2.fromScale(-0.081, 0.4)
    modholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    modholder.Size = UDim2.fromOffset(168, 33)


    local layout = Instance.new('UIListLayout', modholder)
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    lib.sections[args.name:lower()] = sectionframe
end

lib:addsection({
    name = 'Main',
    pos = UDim2.fromScale()
})
lib:addsection({
    name = 'Interface',
    pos = UDim2.fromScale(0, 0.3)
})

function lib:setTab(tabname, vis)
    for i,v in self.windows do
        v:setvis(i == tabname:lower() and vis or false)
    end
end

for i,v in {'Intergrations', 'Mods', 'Engine Settings'} do
    local tabapi = {
        on = false,
        name = v
    }
    local tab = Instance.new('TextButton', lib.sections.main.modholder)
    tab.Name = 'mainframe'
    tab.Position = UDim2.fromScale(-0.08, 0.4)
    tab.Size = UDim2.fromOffset(168, 33)
    tab.BorderSizePixel = 0
    tab.Text = ''
    tab.AutoButtonColor = false
    tab.BackgroundColor3 = Color3.fromRGB(0, 88, 203)


    local imglabel = Instance.new('ImageLabel', tab)
    imglabel.Interactable = false
    imglabel.AnchorPoint = Vector2.new(0, 0.5)
    imglabel.Image = lib.assets[v:lower()]
    imglabel.BackgroundTransparency = 1
    imglabel.Position = UDim2.new(0.08, 0, 0.5, 0)
    imglabel.Size = UDim2.new(0, 20, 0, 20)
    imglabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    imglabel.BorderSizePixel = 0
    imglabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


    local label = Instance.new('TextLabel', tab)
    label.FontFace = lib.fonts.bold
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = v
    label.Position = UDim2.fromScale(0.26, 0.28)
    label.Size = UDim2.fromOffset(200, 13)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14

    Instance.new('UICorner', tab)

    local tabframe = Instance.new('Frame', tabholder)
    tabframe.Size = UDim2.new(0, 826, 0, 512)
    tabframe.Name = 'Tab'
    tabframe.Position = UDim2.new(0, 0, 0.113, 0)
    tabframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tabframe.ZIndex = 50
    tabframe.BorderSizePixel = 0
    tabframe.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    
    local seperator2 = Instance.new('Frame', tabframe)
    seperator2.Name = 'seperator2'
    seperator2.Position = UDim2.new(0, 0, -0.002, 0)
    seperator2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    seperator2.Size = UDim2.new(0, 91, 0, 513)
    seperator2.ZIndex = 0
    seperator2.BorderSizePixel = 0
    seperator2.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    
    local seperator1 = Instance.new('Frame', tabframe)
    seperator1.Name = 'seperator1'
    seperator1.Position = UDim2.new(0, 0, -0.002, 0)
    seperator1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    seperator1.Size = UDim2.new(0, 826, 0, 42)
    seperator1.ZIndex = 0
    seperator1.BorderSizePixel = 0
    seperator1.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    Instance.new('UICorner', tabframe).CornerRadius = UDim.new(0, 18)
    
    local divider = Instance.new('Frame', tabframe)
    divider.Name = 'divider'
    divider.Position = UDim2.new(0, 0, 0, -2)
    divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    divider.Size = UDim2.new(0, 826, 0, 2)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    
    local a4 = Instance.new('TextLabel', tabframe)
    a4.TextColor3 = Color3.new(1,1,1)
    a4.Text = v
    a4.Size = UDim2.fromOffset(200, 25)
    a4.Position = UDim2.fromScale(0.062, -0.082)
    a4.BackgroundTransparency = 1
    a4.TextXAlignment = Enum.TextXAlignment.Left
    a4.FontFace = lib.fonts.medium
    a4.TextScaled = true
    
    
    local a5 = Instance.new('ImageLabel', a4)
    a5.AnchorPoint = Vector2.new(0, 0.5)
    a5.Image = lib.assets[v:lower()]
    a5.BackgroundTransparency = 1
    a5.Position = UDim2.fromScale(-0.21, 0.5)
    a5.Size = UDim2.new(0, 35, 0, 35)

    
    local moduleholder = Instance.new('Frame', tabframe)
    moduleholder.Name = 'ModuleHolder'
    moduleholder.BackgroundTransparency = 1
    moduleholder.Position = UDim2.new(0.015738498, 0, 0.021, 0)
    moduleholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    moduleholder.Size = UDim2.new(0, 797, 0, 484)
    moduleholder.BorderSizePixel = 0
    moduleholder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local UIListLayout = Instance.new('UIListLayout', moduleholder)
    UIListLayout.Wraps = true
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    
    function tabapi:setvis(bool)
        tabapi.on = bool
        tabframe.Position = tabapi.on and UDim2.new(-0.3, 0, 0.113, 0) or tabframe.Position
        tweenservice:Create(tabframe, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(tabapi.on and 0 or 1, 0, 0.113, 0)}):Play()
        tweenservice:Create(tab, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {BackgroundTransparency = bool and 0 or 1}):Play()
        tweenservice:Create(label, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {TextColor3 = bool and Color3.new(1, 1, 1) or Color3.fromRGB(135, 135, 135)}):Play()
        tweenservice:Create(imglabel, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {ImageColor3 = bool and Color3.new(1, 1, 1) or Color3.fromRGB(135, 135, 135)}):Play()
        task.delay(lib.tweenspeed / 1.5, function()
            label.FontFace = tabapi.on and lib.fonts.bold or lib.fonts.medium
        end)
    end
    lib.configs[v] = {}
    function tabapi:addmodule(moduleargs)
        local moduleapi = {
            vis = false,
            currentsection = nil,
            currentmodholder = nil,
            cons = {}
        }
        lib.configs[v][moduleargs.name] = {}
        local moduleframe = Instance.new('Frame', moduleholder)
        moduleframe.Size = UDim2.new(0, 187, 0, 97)
        moduleframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
        moduleframe.ZIndex = 5
        moduleframe.BorderSizePixel = 0
        moduleframe.ZIndex = 300
        moduleframe.BackgroundColor3 = Color3.fromRGB(45, 45, 45)


        Instance.new('UICorner', moduleframe).CornerRadius = UDim.new(0, 15)


        local b1 = Instance.new('Frame', moduleframe)
        b1.Position = UDim2.new(0, 0, 0.74, 0)
        b1.BorderColor3 = Color3.fromRGB(0, 0, 0)
        b1.Size = UDim2.new(0, 187, 0, 26)
        b1.BorderSizePixel = 0
        b1.ZIndex = 300
        b1.BackgroundTransparency = 1
        b1.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


        Instance.new('UICorner', b1).CornerRadius = UDim.new(0, 15)


        local b2 = Instance.new('Frame', b1)
        b2.Position = UDim2.new(0, 0, -0.01, 0)
        b2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        b2.Size = UDim2.new(0, 187, 0, 15)
        b2.ZIndex = 300
        b2.BorderSizePixel = 0
        b2.BackgroundTransparency = 1
        b2.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


        local TextLabel = Instance.new('TextLabel', b2)
        TextLabel.FontFace = lib.fonts.bold
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.Text = moduleargs.name
        TextLabel.Size = UDim2.new(0, 173, 0, 19)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Position = UDim2.new(0.065420561, 0, 0.115, 0)
        TextLabel.ZIndex = 300
        TextLabel.TextSize = 14


        local TextButton = Instance.new('TextButton', b2)
        TextButton.Font = Enum.Font.Arial
        TextButton.Text = ''
        TextButton.ZIndex = 600
        TextButton.BackgroundTransparency = 1
        TextButton.Size = UDim2.new(0, 187, 0, 26)


        local ImageButton = Instance.new('ImageButton', moduleframe)
        ImageButton.Image = moduleargs.icon or 'rbxassetid://127219437591544'
        ImageButton.BackgroundTransparency = 1
        ImageButton.Position = UDim2.new(0.364485949, 0, 0.124, 0)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.ZIndex = 600

        local b3 = Instance.new('Frame', moduleframe)
        b3.Position = UDim2.new(0, 0, 0.717, 0)
        b3.Size = UDim2.new(0, 187, 0, 2)
        b3.BorderSizePixel = 0
        b3.ZIndex = 300
        b3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

        local optionframe = Instance.new('Frame', tabframe)
        optionframe.Visible = false
        optionframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
        optionframe.Name = 'Option'
        optionframe.Position = UDim2.new(0, 0, 0, 0)
        optionframe.Size = UDim2.new(0, 826, 0, 488)
        optionframe.ZIndex = 700
        optionframe.BorderSizePixel = 0
        optionframe.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
        optionframe.Visible = false


        local optionlabel = Instance.new('TextLabel', optionframe)
        optionlabel.TextWrapped = true
        optionlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        optionlabel.Text = `{moduleargs.name} Settings`
        optionlabel.Size = UDim2.new(0, 685, 0, 21)
        optionlabel.Position = UDim2.new(0.030266345, 0, 0.004, 0)
        optionlabel.BorderSizePixel = 0
        optionlabel.ZIndex = 700
        optionlabel.TextScaled = true
        optionlabel.BackgroundTransparency = 1
        optionlabel.TextXAlignment = Enum.TextXAlignment.Left
        optionlabel.FontFace = lib.fonts.medium
        optionlabel.TextYAlignment = Enum.TextYAlignment.Top
        optionlabel.TextSize = 14
        optionlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local closebutton = Instance.new('ImageButton', optionframe)
        closebutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        closebutton.AnchorPoint = Vector2.new(0.980000019, 0.99000001)
        closebutton.Image = 'rbxassetid://76258290491964'
        closebutton.BackgroundTransparency = 1
        closebutton.ZIndex = 1000
        closebutton.Position = UDim2.new(0.980000019, 0, 0.99, 0)
        closebutton.Size = UDim2.new(0, 25, 0, 25)
        
        local bgholder = Instance.new('Frame', optionframe)
        bgholder.Name = 'bgholder'
        bgholder.BackgroundTransparency = 1
        bgholder.Position = UDim2.new(0.015738498, 0, 0.076, 0)
        bgholder.Size = UDim2.new(0, 801, 0, 27)
        bgholder.ZIndex = 900

        local UIListLayout = Instance.new('UIListLayout', bgholder)
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local minimodholder = Instance.new('Frame', optionframe)
        minimodholder.Name = 'moduleholder'
        minimodholder.BackgroundTransparency = 1
        minimodholder.Position = UDim2.new(0.030266345, 0, 0.095, 0)
        minimodholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        minimodholder.Size = UDim2.new(0, 266, 0, 116)
        minimodholder.BorderSizePixel = 0
        minimodholder.ZIndex = 900
        minimodholder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local qweqweqe = Instance.new('UIListLayout', minimodholder)
        qweqweqe.Padding = UDim.new(0, 26)
        qweqweqe.SortOrder = Enum.SortOrder.LayoutOrder

        xpcall(function()
            local reset = {
                toggles = 0
            }
            function moduleapi:addsection()
                local bg = Instance.new('Frame', bgholder)
                bg.Name = 'bg'
                bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
                bg.Size = UDim2.new(0, 801, 0, 16)
                bg.BorderSizePixel = 0
                bg.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
                bg.ZIndex = 900
            
                reset.toggles = 0

                Instance.new('UICorner', bg).CornerRadius = UDim.new(0, 18)
                moduleapi.currentsection = bg

                local ModuleHolder = Instance.new('Frame', minimodholder)
                ModuleHolder.Active = true
                ModuleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ModuleHolder.BackgroundTransparency = 1
                ModuleHolder.Name = 'ModuleHolder'
                ModuleHolder.SizeConstraint = Enum.SizeConstraint.RelativeYY
                ModuleHolder.Size = UDim2.new(0, 788, 0, 0)
                ModuleHolder.BorderSizePixel = 0
                ModuleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ModuleHolder.ZIndex = 900

                local qweqwe = Instance.new('UIListLayout', ModuleHolder)
                qweqwe.Wraps = true
                qweqwe.Padding = UDim.new(0, 5)
                qweqwe.SortOrder = Enum.SortOrder.LayoutOrder
                qweqwe.FillDirection = Enum.FillDirection.Horizontal

                moduleapi.currentmodholder = ModuleHolder
            end

            function moduleapi:addtoggle(modargs)
                local api = {
                    toggled = false,
                    cons = {}
                }
                lib.configs[tabapi.name][moduleargs.name][modargs.name] = api
                local Toggle = Instance.new('Frame', moduleapi.currentmodholder)
                Toggle.BackgroundTransparency = 1
                Toggle.Name = 'Toggle'
                Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle.Size = UDim2.new(0, 383, 0, 30)
                Toggle.BorderSizePixel = 0
                Toggle.ZIndex = 900
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, reset.toggles == 1 and 0 or 32)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, reset.toggles == 1 and 0 or 32)

                if reset.toggles >= 2 then
                    reset.toggles = 0
                end

                reset.toggles += 1

                local Frame = Instance.new('Frame', Toggle)
                Frame.ZIndex = 900
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.Position = UDim2.new(0.02, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 45, 0, 25)
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


                local circle = Instance.new('Frame', Frame)
                circle.AnchorPoint = Vector2.new(0, 0.5)
                circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                circle.ZIndex = 900
                circle.Size = UDim2.new(0, 17, 0, 17)
                circle.BorderSizePixel = 0
                circle.Position = UDim2.fromScale(0.06, 0.5)
                circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                Instance.new('UICorner', circle).CornerRadius = UDim.new(1, 0)

                Instance.new('UICorner', Frame).CornerRadius = UDim.new(1, 0)


                local TextButton = Instance.new('TextButton', Frame)
                TextButton.Text = ''
                TextButton.ZIndex = 900
                TextButton.BackgroundTransparency = 1
                TextButton.Position = UDim2.new(0.044444446, 0, 0, 0)
                TextButton.Size = UDim2.new(0, 43, 0, 27)

                local modname = Instance.new('TextLabel', Toggle)
                modname.TextColor3 = Color3.fromRGB(255, 255, 255)
                modname.Text = modargs.name or 'toggle'
                modname.Size = UDim2.new(0, 200, 0, 16)
                modname.Position = UDim2.new(0.200000003, 0, 0.5, 0)
                modname.AnchorPoint = Vector2.new(0.02, 0.5)
                modname.ZIndex = 900
                modname.BackgroundTransparency = 1
                modname.TextXAlignment = Enum.TextXAlignment.Left
                modname.TextScaled = true
                modname.FontFace = lib.fonts.medium

                function api:call(bool, insta, aaa)
                    self.toggled = (bool ~= nil and bool) or not self.toggled
                    tweenservice:Create(circle, TweenInfo.new(insta and 0 or lib.tweenspeed, Enum.EasingStyle.Quint), {Position = UDim2.new(self.toggled and 0.53 or 0.06, 0, 0.5, 0)}):Play()
                    tweenservice:Create(Frame, TweenInfo.new(insta and 0 or lib.tweenspeed, Enum.EasingStyle.Quint), {BackgroundColor3 = self.toggled and Color3.fromRGB(0, 102, 255) or Color3.fromRGB(50, 50, 50)}):Play()
                    if not self.toggled then
                        for _, v in api.cons do
                            if typeof(v) == 'Instance' then
                                pcall(function()
                                    v:Destroy()
                                end)
                            elseif type(v) == 'thread' then
                                pcall(task.cancel, v)
                            else
                                v:Disconnect() 
                            end
                        end
                        table.clear(api.cons)
                    end
                    if modargs.callback then
                        if aaa then
                            pcall(modargs.callback, self.toggled)
                        else
                            task.spawn(modargs.callback, self.toggled)
                        end
                    end
                end

                function api:retoggle()
                    if self.toggled then
                        api:call(false, true, true)
                        api:call(true, true)
                    end
                end
                
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modargs.name]
                if type(configtab) == 'table' and configtab.toggled then
                    if modargs.name ~= 'Enabled' then
                        api:call(configtab.toggled, true)
                    else
                        table.insert(lib.modules, api)
                    end
                elseif modargs.default then
                    api:call(modargs.default, true)
                end

                TextButton.MouseButton1Click:Connect(function()
                    api:call()
                    if lib.saving then
                        writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                    end
                end)

                return api
            end
            function moduleapi:addtextbox(modargs)
                local api = {value = ''}
                lib.configs[tabapi.name][moduleargs.name][modargs.name] = api
                reset.toggles = 0
                local frme = Instance.new('Frame', moduleapi.currentmodholder)
                frme.Name = 'TextBox'
                frme.BackgroundTransparency = 1
                frme.Position = UDim2.new(0, 0, 0.169, 0)
                frme.BorderColor3 = Color3.fromRGB(0, 0, 0)
                frme.Size = UDim2.new(0, 774, 0, 35)
                frme.BorderSizePixel = 0
                frme.ZIndex = 900
                frme.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                
                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, 39)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, 39)
                
                local Frame = Instance.new('Frame', frme)
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.Position = UDim2.new(0.738785625, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 193, 0, 29)
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 900
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                
                
                local TextBox = Instance.new('TextBox', Frame)
                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.Text = ''
                TextBox.TextScaled = true
                TextBox.AnchorPoint = Vector2.new(1, 0.5)
                TextBox.ZIndex = 900
                TextBox.PlaceholderColor3 = Color3.fromRGB(190, 190, 190)
                TextBox.PlaceholderText = 'Input'
                TextBox.Size = UDim2.new(0, 162, 0, 13)
                TextBox.BackgroundTransparency = 1
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.Position = UDim2.new(0.926999986, 0, 0.5, 0)
                TextBox.FontFace = lib.fonts.medium
                TextBox.ZIndex = 900
                
                local UICorner = Instance.new('UICorner', Frame)
                UICorner.CornerRadius = UDim.new(1, 0)
                
                
                local eqewqe = Instance.new('TextLabel', frme)
                eqewqe.TextWrapped = true
                eqewqe.TextColor3 = Color3.fromRGB(255, 255, 255)
                eqewqe.Text = modargs.name
                eqewqe.Size = UDim2.new(0, 200, 0, 18)
                eqewqe.Position = UDim2.new(0.02, 0, 0.3, 0)
                eqewqe.AnchorPoint = Vector2.new(0.02, 0.300000012)
                eqewqe.BackgroundTransparency = 1
                eqewqe.TextXAlignment = Enum.TextXAlignment.Left
                eqewqe.TextScaled = true
                eqewqe.ZIndex = 900
                eqewqe.FontFace = lib.fonts.medium

                function api:call(text, usenum, bool)
                    TextBox.Text = tostring(text)
                    api.value = usenum and tonumber(text) or tostring(text)
                    if modargs.callback then
                        modargs.callback(api.value, bool)
                    end
                end
                      
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modargs.name]
                if type(configtab) == 'table' and configtab.value then
                    api:call(configtab.value, modargs.number, true)
                elseif modargs.default then
                    api:call(modargs.default, modargs.number, true)
                end

                TextBox:GetPropertyChangedSignal('Text'):Connect(function()
                    api:call(TextBox.Text, modargs.number, false)
                end)

                TextBox.FocusLost:Connect(function()
                    api:call(TextBox.Text, modargs.number, true)
                    if lib.saving then
                        writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                    end
                end)
                                
                return api
            end
            function moduleapi:adddropdown(modapi)
                local api = {
                    value = modapi.default or modapi.list[1],
                    array = modapi.list or {},
                    opened = false,
                    size = 0
                }

                reset.toggles = 0
                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, 39)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, 39)

                local Dropdown = Instance.new('Frame', moduleapi.currentmodholder)
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.Name = 'Dropdown'
                Dropdown.BackgroundTransparency = 1
                Dropdown.Position = UDim2.new(0, 0, 0.169, 0)
                Dropdown.Size = UDim2.new(0, 774, 0, 35)
                Dropdown.ZIndex = 4
                Dropdown.BorderSizePixel = 0
                Dropdown.ZIndex = 1000
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local name = Instance.new('TextLabel', Dropdown)
                name.TextWrapped = true
                name.Name = 'name'
                name.ZIndex = 1000
                name.TextColor3 = Color3.fromRGB(255, 255, 255)
                name.BorderColor3 = Color3.fromRGB(0, 0, 0)
                name.Text = modapi.name
                name.Size = UDim2.new(0, 200, 0, 18)
                name.Position = UDim2.new(0.02, 0, 0.3, 0)
                name.AnchorPoint = Vector2.new(0.02, 0.300000012)
                name.BorderSizePixel = 0
                name.BackgroundTransparency = 1
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.TextScaled = true
                name.FontFace = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                name.TextSize = 14
                name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local Frame = Instance.new('Frame', Dropdown)
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.ZIndex = 1000
                Frame.Position = UDim2.new(0.738785625, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 193, 0, 29)
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


                local updownframe = Instance.new('Frame', Frame)
                updownframe.AnchorPoint = Vector2.new(0, 0.5)
                updownframe.Name = 'updownframe'
                updownframe.ZIndex = 1000
                updownframe.Visible = true
                updownframe.Position = UDim2.new(0.828999996, 0, 0.5, 0)
                updownframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
                updownframe.Size = UDim2.new(0, 20, 0, 20)
                updownframe.BorderSizePixel = 0
                updownframe.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


                local ImageLabel = Instance.new('ImageLabel', updownframe)
                ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ImageLabel.AnchorPoint = Vector2.new(0.536000013, 0.5)
                ImageLabel.Image = 'rbxassetid://109817625590728'
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.ZIndex = 1000
                ImageLabel.Position = UDim2.new(0.536000013, 0, 0.5, 0)
                ImageLabel.Size = UDim2.new(0, 15, 0, 15)
                ImageLabel.BorderSizePixel = 0
                ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                Instance.new('UICorner', updownframe)

                local actualoptions = Instance.new('Frame', Frame)
                actualoptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
                actualoptions.Name = 'actualoptions'
                actualoptions.BackgroundTransparency = 1
                actualoptions.Position = UDim2.new(0.134715021, 0, 1.589, 0)
                actualoptions.Size = UDim2.new(0, 151, 0, 13)
                actualoptions.ZIndex = 1100
                actualoptions.BorderSizePixel = 0
                actualoptions.Visible = false
                actualoptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local UIListLayout = Instance.new('UIListLayout', actualoptions)
                UIListLayout.Padding = UDim.new(0, 12)
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder


                local backgrond = Instance.new('Frame', Frame)
                backgrond.Size = UDim2.new(0, 189, 0, 0)
                backgrond.Name = 'backgrond'
                backgrond.Position = UDim2.new(0.008, 0, 1.4, 0)
                backgrond.BorderColor3 = Color3.fromRGB(0, 0, 0)
                backgrond.ZIndex = 1050
                backgrond.BorderSizePixel = 0
                backgrond.BackgroundColor3 = Color3.fromRGB(39, 39, 39)


                local bgcorner = Instance.new('UICorner', backgrond)
                bgcorner.Name = 'bgcorner'
                bgcorner.CornerRadius = UDim.new(0, 12)


                local bgstroke = Instance.new('UIStroke', backgrond)
                bgstroke.Color = Color3.fromRGB(68, 68, 68)
                bgstroke.Name = 'bgstroke'
                bgstroke.Enabled = false
                bgstroke.Thickness = 2


                local value = Instance.new('TextLabel', Frame)
                value.TextWrapped = true
                value.Name = 'value'
                value.TextColor3 = Color3.fromRGB(255, 255, 255)
                value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                value.Text = 'Dropdown'
                value.Size = UDim2.new(0, 200, 0, 13)
                value.ZIndex = 1000
                value.Position = UDim2.new(1.124352336, 0, 0.5, 0)
                value.AnchorPoint = Vector2.new(1, 0.5)
                value.BorderSizePixel = 0
                value.BackgroundTransparency = 1
                value.TextXAlignment = Enum.TextXAlignment.Left
                value.TextScaled = true
                value.FontFace = lib.fonts.medium
                value.TextSize = 14
                value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local opener = Instance.new('TextButton', Frame)
                opener.TextColor3 = Color3.fromRGB(0, 0, 0)
                opener.BorderColor3 = Color3.fromRGB(0, 0, 0)
                opener.Text = ''
                opener.Name = 'opener'
                opener.ZIndex = 1000
                opener.BackgroundTransparency = 1
                opener.Position = UDim2.new(0.044442449, 0, 0, 0)
                opener.Size = UDim2.new(0, 184, 0, 27)
                opener.BorderSizePixel = 0
                opener.TextSize = 14
                opener.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local UICorner = Instance.new('UICorner', Frame)
                UICorner.CornerRadius = UDim.new(1, 0)

                function api:refresh(array, default)
                    self.size = 0
                    for _, v in array do
                        local op2 = Instance.new('TextButton', actualoptions)
                        op2.FontFace = lib.fonts.medium
                        op2.TextColor3 = Color3.fromRGB(255, 255, 255)
                        op2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        op2.Text = tostring(v)
                        op2.Name = tostring(v)
                        op2.Size = UDim2.new(0, 169, 0, 18)
                        op2.BackgroundTransparency = 1
                        op2.ZIndex = 1100
                        op2.TextXAlignment = Enum.TextXAlignment.Left
                        op2.Position = UDim2.new(-0.006060606, 0, -0.8, 0)
                        op2.BorderSizePixel = 0
                        op2.TextSize = 14
                        op2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        op2.MouseButton1Click:Connect(function()
                            self:call(v)
                            self:open(false)
                        end)
                        
                        self.size += 30
                    end
                    if default then
                        self:call(default)
                        if lib.saving then
                            writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                        end
                    end
                end
                function api:open(bool, anim)
                    anim = anim or true
                    self.opened = (bool ~= nil and bool) or not self.opened
                    task.spawn(function()
                        local tween = tweenservice:Create(backgrond, TweenInfo.new(anim and 0.2 or 0, Enum.EasingStyle.Quart), {Size = UDim2.fromOffset(189, self.opened and self.size or 0)})
                        tween:Play()
                        if self.opened then
                            bgstroke.Enabled = false
                        else
                            actualoptions.Visible = false
                        end
                        updownframe.Visible = not self.opened
                        tween.Completed:Wait()
                        bgstroke.Enabled = self.opened
                        actualoptions.Visible = self.opened
                    end)
                end
                function api:call(val)
                    value.Text = tostring(val)
                    self.value = val
                    if modapi.callback then
                        task.spawn(modapi.callback, self.value)
                    end
                end

                lib.configs[tabapi.name][moduleargs.name][modapi.name] = api
                      
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modapi.name]
                if type(configtab) == 'table' and configtab.value then
                    api:call(configtab.value)
                elseif modapi.default then
                    api:call(modapi.default)
                end

                opener.MouseButton1Click:Connect(function()
                    api:open()
                end)

                api:refresh(api.array, modapi.default)

                return api
            end
        end, function(err)
            warn(err)
        end)

        moduleapi:addsection()

        local qweiwqie = moduleapi:addtoggle({
            name = 'Enabled',
            callback = function(call)
                if not call then
                    for _, v in moduleapi.cons do
                        if typeof(v) == 'Instance' then
                            pcall(function()
                                v:Destroy()
                            end)
                        elseif type(v) == 'thread' then
                            pcall(task.cancel, v)
                        else
                            v:Disconnect() 
                        end
                    end
                    table.clear(moduleapi.cons)
                end
                moduleapi.enabled = call
                b1.BackgroundTransparency = call and 0 or 1
                b2.BackgroundTransparency = call and 0 or 1
                if moduleargs.callback then
                    task.spawn(moduleargs.callback, moduleapi.enabled)
                end
            end
        })

        function moduleapi:retoggle()
            qweiwqie:retoggle()
        end

        moduleapi:addsection()

        function moduleapi:setvis(bool)
            optionframe.Visible = bool
        end

        TextButton.MouseButton1Click:Connect(function()
            moduleapi:setvis(true)
        end)

        ImageButton.MouseButton1Click:Connect(function()
            moduleapi:setvis(true)
        end)

        closebutton.MouseButton1Click:Connect(function()
            moduleapi:setvis(false)
        end)

        return moduleapi
    end
    tabapi.object = tab
    
    tab.MouseButton1Click:Connect(function()
        lib:setTab(v:gsub(' ', ''), true)
    end)
    
    lib.windows[v:lower():gsub(' ', '')] = tabapi
end

for i,v in {'Appearence', 'Behaviour'} do
    local tabapi = {
        on = false,
        name = v
    }
    local tab = Instance.new('TextButton', lib.sections.interface.modholder)
    tab.Name = 'mainframe'
    tab.Position = UDim2.fromScale(-0.08, 0.4)
    tab.Size = UDim2.fromOffset(168, 33)
    tab.BorderSizePixel = 0
    tab.Text = ''
    tab.AutoButtonColor = false
    tab.BackgroundColor3 = Color3.fromRGB(0, 88, 203)


    local imglabel = Instance.new('ImageLabel', tab)
    imglabel.Interactable = false
    imglabel.AnchorPoint = Vector2.new(0, 0.5)
    imglabel.Image = lib.assets[v:lower()]
    imglabel.BackgroundTransparency = 1
    imglabel.Position = UDim2.new(0.08, 0, 0.5, 0)
    imglabel.Size = UDim2.new(0, 20, 0, 20)
    imglabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    imglabel.BorderSizePixel = 0
    imglabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


    local label = Instance.new('TextLabel', tab)
    label.FontFace = lib.fonts.bold
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = v
    label.Position = UDim2.fromScale(0.26, 0.28)
    label.Size = UDim2.fromOffset(200, 13)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14

    Instance.new('UICorner', tab)

    local tabframe = Instance.new('Frame', tabholder)
    tabframe.Size = UDim2.new(0, 826, 0, 512)
    tabframe.Name = 'Tab'
    tabframe.Position = UDim2.new(0, 0, 0.113, 0)
    tabframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tabframe.ZIndex = 50
    tabframe.BorderSizePixel = 0
    tabframe.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    
    local seperator2 = Instance.new('Frame', tabframe)
    seperator2.Name = 'seperator2'
    seperator2.Position = UDim2.new(0, 0, -0.002, 0)
    seperator2.BorderColor3 = Color3.fromRGB(0, 0, 0)
    seperator2.Size = UDim2.new(0, 91, 0, 513)
    seperator2.ZIndex = 0
    seperator2.BorderSizePixel = 0
    seperator2.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    
    local seperator1 = Instance.new('Frame', tabframe)
    seperator1.Name = 'seperator1'
    seperator1.Position = UDim2.new(0, 0, -0.002, 0)
    seperator1.BorderColor3 = Color3.fromRGB(0, 0, 0)
    seperator1.Size = UDim2.new(0, 826, 0, 42)
    seperator1.ZIndex = 0
    seperator1.BorderSizePixel = 0
    seperator1.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
    
    Instance.new('UICorner', tabframe).CornerRadius = UDim.new(0, 18)
    
    local divider = Instance.new('Frame', tabframe)
    divider.Name = 'divider'
    divider.Position = UDim2.new(0, 0, 0, -2)
    divider.BorderColor3 = Color3.fromRGB(0, 0, 0)
    divider.Size = UDim2.new(0, 826, 0, 2)
    divider.BorderSizePixel = 0
    divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    
    local a4 = Instance.new('TextLabel', tabframe)
    a4.TextColor3 = Color3.new(1,1,1)
    a4.Text = v
    a4.Size = UDim2.fromOffset(200, 25)
    a4.Position = UDim2.fromScale(0.062, -0.082)
    a4.BackgroundTransparency = 1
    a4.TextXAlignment = Enum.TextXAlignment.Left
    a4.FontFace = lib.fonts.medium
    a4.TextScaled = true
    
    
    local a5 = Instance.new('ImageLabel', a4)
    a5.AnchorPoint = Vector2.new(0, 0.5)
    a5.Image = lib.assets[v:lower()]
    a5.BackgroundTransparency = 1
    a5.Position = UDim2.fromScale(-0.21, 0.5)
    a5.Size = UDim2.new(0, 35, 0, 35)

    
    local moduleholder = Instance.new('Frame', tabframe)
    moduleholder.Name = 'ModuleHolder'
    moduleholder.BackgroundTransparency = 1
    moduleholder.Position = UDim2.new(0.015738498, 0, 0.021, 0)
    moduleholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    moduleholder.Size = UDim2.new(0, 797, 0, 484)
    moduleholder.BorderSizePixel = 0
    moduleholder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

    local UIListLayout = Instance.new('UIListLayout', moduleholder)
    UIListLayout.Wraps = true
    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    
    function tabapi:setvis(bool)
        tabapi.on = bool
        tabframe.Position = tabapi.on and UDim2.new(-0.3, 0, 0.113, 0) or tabframe.Position
        tweenservice:Create(tabframe, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Position = UDim2.new(tabapi.on and 0 or 1, 0, 0.113, 0)}):Play()
        tweenservice:Create(tab, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {BackgroundTransparency = bool and 0 or 1}):Play()
        tweenservice:Create(label, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {TextColor3 = bool and Color3.new(1, 1, 1) or Color3.fromRGB(135, 135, 135)}):Play()
        tweenservice:Create(imglabel, TweenInfo.new(lib.tweenspeed, Enum.EasingStyle.Quad), {ImageColor3 = bool and Color3.new(1, 1, 1) or Color3.fromRGB(135, 135, 135)}):Play()
        task.delay(lib.tweenspeed / 1.5, function()
            label.FontFace = tabapi.on and lib.fonts.bold or lib.fonts.medium
        end)
    end
    lib.configs[v] = {}
    function tabapi:addmodule(moduleargs)
        local moduleapi = {
            vis = false,
            currentsection = nil,
            currentmodholder = nil,
            cons = {},
            enabled = false
        }
        lib.configs[v][moduleargs.name] = {}
        local moduleframe = Instance.new('Frame', moduleholder)
        moduleframe.Size = UDim2.new(0, 187, 0, 97)
        moduleframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
        moduleframe.ZIndex = 5
        moduleframe.BorderSizePixel = 0
        moduleframe.ZIndex = 300
        moduleframe.BackgroundColor3 = Color3.fromRGB(45, 45, 45)


        Instance.new('UICorner', moduleframe).CornerRadius = UDim.new(0, 15)


        local b1 = Instance.new('Frame', moduleframe)
        b1.Position = UDim2.new(0, 0, 0.74, 0)
        b1.BorderColor3 = Color3.fromRGB(0, 0, 0)
        b1.Size = UDim2.new(0, 187, 0, 26)
        b1.BorderSizePixel = 0
        b1.ZIndex = 300
        b1.BackgroundTransparency = 1
        b1.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


        Instance.new('UICorner', b1).CornerRadius = UDim.new(0, 15)


        local b2 = Instance.new('Frame', b1)
        b2.Position = UDim2.new(0, 0, -0.01, 0)
        b2.BorderColor3 = Color3.fromRGB(0, 0, 0)
        b2.Size = UDim2.new(0, 187, 0, 15)
        b2.ZIndex = 300
        b2.BorderSizePixel = 0
        b2.BackgroundTransparency = 1
        b2.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


        local TextLabel = Instance.new('TextLabel', b2)
        TextLabel.FontFace = lib.fonts.bold
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.Text = moduleargs.name
        TextLabel.Size = UDim2.new(0, 173, 0, 19)
        TextLabel.BackgroundTransparency = 1
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Position = UDim2.new(0.065420561, 0, 0.115, 0)
        TextLabel.ZIndex = 300
        TextLabel.TextSize = 14


        local TextButton = Instance.new('TextButton', b2)
        TextButton.Font = Enum.Font.Arial
        TextButton.Text = ''
        TextButton.ZIndex = 600
        TextButton.BackgroundTransparency = 1
        TextButton.Size = UDim2.new(0, 187, 0, 26)


        local ImageButton = Instance.new('ImageButton', moduleframe)
        ImageButton.Image = moduleargs.icon or 'rbxassetid://127219437591544'
        ImageButton.BackgroundTransparency = 1
        ImageButton.Position = UDim2.new(0.364485949, 0, 0.124, 0)
        ImageButton.Size = UDim2.new(0, 50, 0, 50)
        ImageButton.ZIndex = 600

        local b3 = Instance.new('Frame', moduleframe)
        b3.Position = UDim2.new(0, 0, 0.717, 0)
        b3.Size = UDim2.new(0, 187, 0, 2)
        b3.BorderSizePixel = 0
        b3.ZIndex = 300
        b3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

        local optionframe = Instance.new('Frame', moduleframe)
        optionframe.Visible = false
        optionframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
        optionframe.Name = 'Option'
        optionframe.Position = UDim2.new(-0.069518715, 0, -0.028, 0)
        optionframe.Size = UDim2.new(0, 826, 0, 488)
        optionframe.ZIndex = 700
        optionframe.BorderSizePixel = 0
        optionframe.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
        optionframe.Visible = false


        local optionlabel = Instance.new('TextLabel', optionframe)
        optionlabel.TextWrapped = true
        optionlabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        optionlabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        optionlabel.Text = `{moduleargs.name} Settings`
        optionlabel.Size = UDim2.new(0, 685, 0, 21)
        optionlabel.Position = UDim2.new(0.030266345, 0, 0.004, 0)
        optionlabel.BorderSizePixel = 0
        optionlabel.ZIndex = 700
        optionlabel.TextScaled = true
        optionlabel.BackgroundTransparency = 1
        optionlabel.TextXAlignment = Enum.TextXAlignment.Left
        optionlabel.FontFace = lib.fonts.medium
        optionlabel.TextYAlignment = Enum.TextYAlignment.Top
        optionlabel.TextSize = 14
        optionlabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local closebutton = Instance.new('ImageButton', optionframe)
        closebutton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        closebutton.AnchorPoint = Vector2.new(0.980000019, 0.99000001)
        closebutton.Image = 'rbxassetid://76258290491964'
        closebutton.BackgroundTransparency = 1
        closebutton.ZIndex = 1000
        closebutton.Position = UDim2.new(0.980000019, 0, 0.99, 0)
        closebutton.Size = UDim2.new(0, 25, 0, 25)
        
        local bgholder = Instance.new('Frame', optionframe)
        bgholder.Name = 'bgholder'
        bgholder.BackgroundTransparency = 1
        bgholder.Position = UDim2.new(0.015738498, 0, 0.076, 0)
        bgholder.Size = UDim2.new(0, 801, 0, 27)
        bgholder.ZIndex = 900

        local UIListLayout = Instance.new('UIListLayout', bgholder)
        UIListLayout.Padding = UDim.new(0, 10)
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local minimodholder = Instance.new('Frame', optionframe)
        minimodholder.Name = 'moduleholder'
        minimodholder.BackgroundTransparency = 1
        minimodholder.Position = UDim2.new(0.030266345, 0, 0.095, 0)
        minimodholder.BorderColor3 = Color3.fromRGB(0, 0, 0)
        minimodholder.Size = UDim2.new(0, 266, 0, 116)
        minimodholder.BorderSizePixel = 0
        minimodholder.ZIndex = 900
        minimodholder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local qweqweqe = Instance.new('UIListLayout', minimodholder)
        qweqweqe.Padding = UDim.new(0, 26)
        qweqweqe.SortOrder = Enum.SortOrder.LayoutOrder

        xpcall(function()
            local reset = {
                toggles = 0
            }
            function moduleapi:addsection()
                local bg = Instance.new('Frame', bgholder)
                bg.Name = 'bg'
                bg.BorderColor3 = Color3.fromRGB(0, 0, 0)
                bg.Size = UDim2.new(0, 801, 0, 16)
                bg.BorderSizePixel = 0
                bg.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
                bg.ZIndex = 900
            
                reset.toggles = 0

                Instance.new('UICorner', bg).CornerRadius = UDim.new(0, 18)
                moduleapi.currentsection = bg

                local ModuleHolder = Instance.new('Frame', minimodholder)
                ModuleHolder.Active = true
                ModuleHolder.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ModuleHolder.BackgroundTransparency = 1
                ModuleHolder.Name = 'ModuleHolder'
                ModuleHolder.SizeConstraint = Enum.SizeConstraint.RelativeYY
                ModuleHolder.Size = UDim2.new(0, 788, 0, 0)
                ModuleHolder.BorderSizePixel = 0
                ModuleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ModuleHolder.ZIndex = 900

                local qweqwe = Instance.new('UIListLayout', ModuleHolder)
                qweqwe.Wraps = true
                qweqwe.Padding = UDim.new(0, 5)
                qweqwe.SortOrder = Enum.SortOrder.LayoutOrder
                qweqwe.FillDirection = Enum.FillDirection.Horizontal

                moduleapi.currentmodholder = ModuleHolder
            end

            function moduleapi:addtoggle(modargs)
                local api = {
                    toggled = false,
                    cons = {}
                }
                lib.configs[tabapi.name][moduleargs.name][modargs.name] = api
                local Toggle = Instance.new('Frame', moduleapi.currentmodholder)
                Toggle.BackgroundTransparency = 1
                Toggle.Name = 'Toggle'
                Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Toggle.Size = UDim2.new(0, 383, 0, 30)
                Toggle.BorderSizePixel = 0
                Toggle.ZIndex = 900
                Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, reset.toggles == 1 and 0 or 32)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, reset.toggles == 1 and 0 or 32)

                if reset.toggles >= 2 then
                    reset.toggles = 0
                end

                reset.toggles += 1

                local Frame = Instance.new('Frame', Toggle)
                Frame.ZIndex = 900
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.Position = UDim2.new(0.02, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 45, 0, 25)
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


                local circle = Instance.new('Frame', Frame)
                circle.AnchorPoint = Vector2.new(0, 0.5)
                circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
                circle.ZIndex = 900
                circle.Size = UDim2.new(0, 17, 0, 17)
                circle.BorderSizePixel = 0
                circle.Position = UDim2.fromScale(0.06, 0.5)
                circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                Instance.new('UICorner', circle).CornerRadius = UDim.new(1, 0)

                Instance.new('UICorner', Frame).CornerRadius = UDim.new(1, 0)


                local TextButton = Instance.new('TextButton', Frame)
                TextButton.Text = ''
                TextButton.ZIndex = 900
                TextButton.BackgroundTransparency = 1
                TextButton.Position = UDim2.new(0.044444446, 0, 0, 0)
                TextButton.Size = UDim2.new(0, 43, 0, 27)

                local modname = Instance.new('TextLabel', Toggle)
                modname.TextColor3 = Color3.fromRGB(255, 255, 255)
                modname.Text = modargs.name or 'toggle'
                modname.Size = UDim2.new(0, 200, 0, 16)
                modname.Position = UDim2.new(0.200000003, 0, 0.5, 0)
                modname.AnchorPoint = Vector2.new(0.02, 0.5)
                modname.ZIndex = 900
                modname.BackgroundTransparency = 1
                modname.TextXAlignment = Enum.TextXAlignment.Left
                modname.TextScaled = true
                modname.FontFace = lib.fonts.medium

                function api:call(bool, insta, aaa)
                    self.toggled = (bool ~= nil and bool) or not self.toggled
                    tweenservice:Create(circle, TweenInfo.new(insta and 0 or lib.tweenspeed, Enum.EasingStyle.Quint), {Position = UDim2.new(self.toggled and 0.53 or 0.06, 0, 0.5, 0)}):Play()
                    tweenservice:Create(Frame, TweenInfo.new(insta and 0 or lib.tweenspeed, Enum.EasingStyle.Quint), {BackgroundColor3 = self.toggled and Color3.fromRGB(0, 102, 255) or Color3.fromRGB(50, 50, 50)}):Play()
                    if not self.toggled then
                        for _, v in api.cons do
                            if typeof(v) == 'Instance' then
                                pcall(function()
                                    v:Destroy()
                                end)
                            elseif type(v) == 'thread' then
                                pcall(task.cancel, v)
                            else
                                v:Disconnect() 
                            end
                        end
                        table.clear(api.cons)
                    end
                    if modargs.callback then
                        if aaa then
                            pcall(modargs.callback, self.toggled)
                        else
                            task.spawn(modargs.callback, self.toggled)
                        end
                    end
                end

                function api:retoggle()
                    if self.toggled then
                        api:call(false, true, true)
                        api:call(true, true)
                    end
                end
                
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modargs.name]
                if type(configtab) == 'table' and configtab.toggled then
                    if modargs.name ~= 'Enabled' then
                        api:call(configtab.toggled, true)
                    else
                        table.insert(lib.modules, api)
                    end
                elseif modargs.default then
                    api:call(modargs.default)
                end

                TextButton.MouseButton1Click:Connect(function()
                    api:call()
                    if lib.saving then
                        writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                    end
                end)

                return api
            end
            function moduleapi:addtextbox(modargs)
                local api = {value = ''}
                lib.configs[tabapi.name][moduleargs.name][modargs.name] = api
                reset.toggles = 0
                local frme = Instance.new('Frame', moduleapi.currentmodholder)
                frme.Name = 'TextBox'
                frme.BackgroundTransparency = 1
                frme.Position = UDim2.new(0, 0, 0.169, 0)
                frme.BorderColor3 = Color3.fromRGB(0, 0, 0)
                frme.Size = UDim2.new(0, 774, 0, 35)
                frme.BorderSizePixel = 0
                frme.ZIndex = 900
                frme.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                
                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, 39)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, 39)
                
                local Frame = Instance.new('Frame', frme)
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.Position = UDim2.new(0.738785625, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 193, 0, 29)
                Frame.BorderSizePixel = 0
                Frame.ZIndex = 900
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                
                
                local TextBox = Instance.new('TextBox', Frame)
                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.Text = ''
                TextBox.TextScaled = true
                TextBox.AnchorPoint = Vector2.new(1, 0.5)
                TextBox.ZIndex = 900
                TextBox.PlaceholderColor3 = Color3.fromRGB(190, 190, 190)
                TextBox.PlaceholderText = 'Input'
                TextBox.Size = UDim2.new(0, 162, 0, 13)
                TextBox.BackgroundTransparency = 1
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.Position = UDim2.new(0.926999986, 0, 0.5, 0)
                TextBox.FontFace = lib.fonts.medium
                TextBox.ZIndex = 900
                
                local UICorner = Instance.new('UICorner', Frame)
                UICorner.CornerRadius = UDim.new(1, 0)
                
                
                local eqewqe = Instance.new('TextLabel', frme)
                eqewqe.TextWrapped = true
                eqewqe.TextColor3 = Color3.fromRGB(255, 255, 255)
                eqewqe.Text = modargs.name
                eqewqe.Size = UDim2.new(0, 200, 0, 18)
                eqewqe.Position = UDim2.new(0.02, 0, 0.3, 0)
                eqewqe.AnchorPoint = Vector2.new(0.02, 0.300000012)
                eqewqe.BackgroundTransparency = 1
                eqewqe.TextXAlignment = Enum.TextXAlignment.Left
                eqewqe.TextScaled = true
                eqewqe.ZIndex = 900
                eqewqe.FontFace = lib.fonts.medium

                function api:call(text, usenum, bool)
                    TextBox.Text = tostring(text)
                    api.value = usenum and tonumber(text) or tostring(text)
                    if modargs.callback then
                        modargs.callback(api.value, bool)
                    end
                end
                      
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modargs.name]
                if type(configtab) == 'table' and configtab.value then
                    api:call(configtab.value, modargs.number, true)
                elseif modargs.default then
                    api:call(modargs.default, modargs.number, true)
                end

                TextBox:GetPropertyChangedSignal('Text'):Connect(function()
                    api:call(TextBox.Text, modargs.number, false)
                end)

                TextBox.FocusLost:Connect(function()
                    api:call(TextBox.Text, modargs.number, true)
                    if lib.saving then
                        writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                    end
                end)
                                
                return api
            end
            function moduleapi:adddropdown(modapi)
                local api = {
                    value = modapi.default or modapi.list[1],
                    array = modapi.list or {},
                    opened = false,
                    size = 0
                }

                reset.toggles = 0
                moduleapi.currentmodholder.Size += UDim2.fromOffset(0, 39)
                moduleapi.currentsection.Size += UDim2.fromOffset(0, 39)

                local Dropdown = Instance.new('Frame', moduleapi.currentmodholder)
                Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Dropdown.Name = 'Dropdown'
                Dropdown.BackgroundTransparency = 1
                Dropdown.Position = UDim2.new(0, 0, 0.169, 0)
                Dropdown.Size = UDim2.new(0, 774, 0, 35)
                Dropdown.ZIndex = 4
                Dropdown.BorderSizePixel = 0
                Dropdown.ZIndex = 1000
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local name = Instance.new('TextLabel', Dropdown)
                name.TextWrapped = true
                name.Name = 'name'
                name.ZIndex = 1000
                name.TextColor3 = Color3.fromRGB(255, 255, 255)
                name.BorderColor3 = Color3.fromRGB(0, 0, 0)
                name.Text = modapi.name
                name.Size = UDim2.new(0, 200, 0, 18)
                name.Position = UDim2.new(0.02, 0, 0.3, 0)
                name.AnchorPoint = Vector2.new(0.02, 0.300000012)
                name.BorderSizePixel = 0
                name.BackgroundTransparency = 1
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.TextScaled = true
                name.FontFace = Font.new('rbxasset://fonts/families/Roboto.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                name.TextSize = 14
                name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local Frame = Instance.new('Frame', Dropdown)
                Frame.AnchorPoint = Vector2.new(0, 0.5)
                Frame.ZIndex = 1000
                Frame.Position = UDim2.new(0.738785625, 0, 0.5, 0)
                Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
                Frame.Size = UDim2.new(0, 193, 0, 29)
                Frame.BorderSizePixel = 0
                Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)


                local updownframe = Instance.new('Frame', Frame)
                updownframe.AnchorPoint = Vector2.new(0, 0.5)
                updownframe.Name = 'updownframe'
                updownframe.ZIndex = 1000
                updownframe.Visible = true
                updownframe.Position = UDim2.new(0.828999996, 0, 0.5, 0)
                updownframe.BorderColor3 = Color3.fromRGB(0, 0, 0)
                updownframe.Size = UDim2.new(0, 20, 0, 20)
                updownframe.BorderSizePixel = 0
                updownframe.BackgroundColor3 = Color3.fromRGB(0, 102, 255)


                local ImageLabel = Instance.new('ImageLabel', updownframe)
                ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                ImageLabel.AnchorPoint = Vector2.new(0.536000013, 0.5)
                ImageLabel.Image = 'rbxassetid://109817625590728'
                ImageLabel.BackgroundTransparency = 1
                ImageLabel.ZIndex = 1000
                ImageLabel.Position = UDim2.new(0.536000013, 0, 0.5, 0)
                ImageLabel.Size = UDim2.new(0, 15, 0, 15)
                ImageLabel.BorderSizePixel = 0
                ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                Instance.new('UICorner', updownframe)

                local actualoptions = Instance.new('Frame', Frame)
                actualoptions.BorderColor3 = Color3.fromRGB(0, 0, 0)
                actualoptions.Name = 'actualoptions'
                actualoptions.BackgroundTransparency = 1
                actualoptions.Position = UDim2.new(0.134715021, 0, 1.589, 0)
                actualoptions.Size = UDim2.new(0, 151, 0, 13)
                actualoptions.ZIndex = 1100
                actualoptions.BorderSizePixel = 0
                actualoptions.Visible = false
                actualoptions.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                local UIListLayout = Instance.new('UIListLayout', actualoptions)
                UIListLayout.Padding = UDim.new(0, 12)
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder


                local backgrond = Instance.new('Frame', Frame)
                backgrond.Size = UDim2.new(0, 189, 0, 0)
                backgrond.Name = 'backgrond'
                backgrond.Position = UDim2.new(0.008, 0, 1.4, 0)
                backgrond.BorderColor3 = Color3.fromRGB(0, 0, 0)
                backgrond.ZIndex = 1050
                backgrond.BorderSizePixel = 0
                backgrond.BackgroundColor3 = Color3.fromRGB(39, 39, 39)


                local bgcorner = Instance.new('UICorner', backgrond)
                bgcorner.Name = 'bgcorner'
                bgcorner.CornerRadius = UDim.new(0, 12)


                local bgstroke = Instance.new('UIStroke', backgrond)
                bgstroke.Color = Color3.fromRGB(68, 68, 68)
                bgstroke.Name = 'bgstroke'
                bgstroke.Enabled = false
                bgstroke.Thickness = 2


                local value = Instance.new('TextLabel', Frame)
                value.TextWrapped = true
                value.Name = 'value'
                value.TextColor3 = Color3.fromRGB(255, 255, 255)
                value.BorderColor3 = Color3.fromRGB(0, 0, 0)
                value.Text = 'Dropdown'
                value.Size = UDim2.new(0, 200, 0, 13)
                value.ZIndex = 1000
                value.Position = UDim2.new(1.124352336, 0, 0.5, 0)
                value.AnchorPoint = Vector2.new(1, 0.5)
                value.BorderSizePixel = 0
                value.BackgroundTransparency = 1
                value.TextXAlignment = Enum.TextXAlignment.Left
                value.TextScaled = true
                value.FontFace = lib.fonts.medium
                value.TextSize = 14
                value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local opener = Instance.new('TextButton', Frame)
                opener.TextColor3 = Color3.fromRGB(0, 0, 0)
                opener.BorderColor3 = Color3.fromRGB(0, 0, 0)
                opener.Text = ''
                opener.Name = 'opener'
                opener.ZIndex = 1000
                opener.BackgroundTransparency = 1
                opener.Position = UDim2.new(0.044442449, 0, 0, 0)
                opener.Size = UDim2.new(0, 184, 0, 27)
                opener.BorderSizePixel = 0
                opener.TextSize = 14
                opener.BackgroundColor3 = Color3.fromRGB(255, 255, 255)


                local UICorner = Instance.new('UICorner', Frame)
                UICorner.CornerRadius = UDim.new(1, 0)

                function api:refresh(array, default)
                    self.size = 0
                    for _, v in array do
                        local op2 = Instance.new('TextButton', actualoptions)
                        op2.FontFace = lib.fonts.medium
                        op2.TextColor3 = Color3.fromRGB(255, 255, 255)
                        op2.BorderColor3 = Color3.fromRGB(0, 0, 0)
                        op2.Text = tostring(v)
                        op2.Name = tostring(v)
                        op2.Size = UDim2.new(0, 169, 0, 18)
                        op2.BackgroundTransparency = 1
                        op2.ZIndex = 1100
                        op2.TextXAlignment = Enum.TextXAlignment.Left
                        op2.Position = UDim2.new(-0.006060606, 0, -0.8, 0)
                        op2.BorderSizePixel = 0
                        op2.TextSize = 14
                        op2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        op2.MouseButton1Click:Connect(function()
                            self:call(v)
                            self:open(false)
                        end)
                        
                        self.size += 30
                    end
                    if default then
                        self:call(default)
                        if lib.saving then
                            writefile('bloxstrap/logs/profile.json', httpservice:JSONEncode(lib.configs))
                        end
                    end
                end
                function api:open(bool, anim)
                    anim = anim or true
                    self.opened = (bool ~= nil and bool) or not self.opened
                    task.spawn(function()
                        local tween = tweenservice:Create(backgrond, TweenInfo.new(anim and 0.2 or 0, Enum.EasingStyle.Quart), {Size = UDim2.fromOffset(189, self.opened and self.size or 0)})
                        tween:Play()
                        if self.opened then
                            bgstroke.Enabled = false
                        else
                            actualoptions.Visible = false
                        end
                        updownframe.Visible = not self.opened
                        tween.Completed:Wait()
                        bgstroke.Enabled = self.opened
                        actualoptions.Visible = self.opened
                    end)
                end
                function api:call(val)
                    value.Text = tostring(val)
                    self.value = val
                    if modapi.callback then
                        task.spawn(modapi.callback, self.value)
                    end
                end

                lib.configs[tabapi.name][moduleargs.name][modapi.name] = api
                      
                local configtab = configtable[tabapi.name] and configtable[tabapi.name][moduleargs.name] and configtable[tabapi.name][moduleargs.name][modapi.name]
                if type(configtab) == 'table' and configtab.value then
                    api:call(configtab.value)
                elseif modapi.default then
                    api:call(modapi.value)
                end

                opener.MouseButton1Click:Connect(function()
                    api:open()
                end)

                api:refresh(api.array, modapi.default)

                return api
            end
        end, function(err)
            warn(err)
        end)

        moduleapi:addsection()

        local qweiwqie = moduleapi:addtoggle({
            name = 'Enabled',
            callback = function(call)
                if not call then
                    for _, v in moduleapi.cons do
                        if typeof(v) == 'Instance' then
                            pcall(function()
                                v:Destroy()
                            end)
                        elseif type(v) == 'thread' then
                            pcall(task.cancel, v)
                        else
                            v:Disconnect() 
                        end
                    end
                    table.clear(moduleapi.cons)
                end
                moduleapi.enabled = call
                b1.BackgroundTransparency = call and 0 or 1
                b2.BackgroundTransparency = call and 0 or 1
                if moduleargs.callback then
                    task.spawn(moduleargs.callback, moduleapi.enabled)
                end
            end
        })

        moduleapi:addsection()

        function moduleapi:setvis(bool)
            optionframe.Visible = bool
        end

        function moduleapi:retoggle()
            qweiwqie:retoggle()
        end

        TextButton.MouseButton1Click:Connect(function()
            moduleapi:setvis(true)
        end)

        ImageButton.MouseButton1Click:Connect(function()
            moduleapi:setvis(true)
        end)

        closebutton.MouseButton1Click:Connect(function()
            moduleapi:setvis(false)
        end)

        return moduleapi
    end
    tabapi.object = tab
    
    tab.MouseButton1Click:Connect(function()
        lib:setTab(v, true)
    end)
    
    lib.windows[v:lower():gsub(' ', '')] = tabapi
end

function lib:destruct()
    lib.saving = false
    screengui:Destroy()
    shared.loaded = nil
end

lib:setTab('Intergrations', true)

function lib:toggle(bool)
    self.enabled = bool or not self.enabled
    if self.enabled then
        tweenservice:Create(uiscale, TweenInfo.new(0.7, Enum.EasingStyle.Bounce), {Scale = self.scale}):Play()
    else
        tweenservice:Create(uiscale, TweenInfo.new(0.45, Enum.EasingStyle.Quart), {Scale = 0}):Play()
    end
end

if inputservice.KeyboardEnabled then
    inputservice.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            lib:toggle(true)
        end
    end)
else
    local button = Instance.new('TextButton', lib.gui)
    button.BorderSizePixel = 0
    button.BackgroundTransparency = 0.2
    button.Text = ''
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.BackgroundColor3 = Color3.new()
    button.Size = UDim2.new(0, 44, 0, 44)
    button.Position = UDim2.fromScale(1, 0.5)
    button.ZIndex = 2000

    local imagelabel = Instance.new('ImageLabel', button) :: ImageLabel
    imagelabel.Size = UDim2.new(0, 22, 0, 22)
    imagelabel.Position = UDim2.new(0.25, 0, 0.25, 0)
    imagelabel.BackgroundTransparency = 1
    imagelabel.Image = getcustomasset('bloxstrap/images/bloxstrap.png')
    imagelabel.ImageColor3 = Color3.new(1, 1, 1)
    imagelabel.ZIndex = 2000

    Instance.new('UICorner', button).CornerRadius = UDim.new(1, 0)

    lib.button = button

    button.MouseButton1Click:Connect(function()
        lib:toggle(true)
    end)

    local buttontransparency = nil
    local buttonvisibility = nil
    local buttondraggable = nil
    local legitmode = lib.windows.behaviour:addmodule({
        name = 'Legit Mode',
        callback = function(call)
            if buttondraggable then
                lib:setdraggable(button, buttondraggable.on)
            end
            if call then
                button.Visible = buttonvisibility.toggled
                if buttontransparency.value then
                    button.BackgroundTransparency = buttontransparency.value
                    imagelabel.ImageTransparency = buttontransparency.value
                end
            end
        end
    })
    buttonvisibility = legitmode:addtoggle({
        name = 'Visible',
        default = true,
        callback = function(val)
            if legitmode.enabled then
                button.Visible = val
            end
        end
    })
    buttondraggable = legitmode:addtoggle({
        name = 'Draggable',
        callback = function(val)
            legitmode:retoggle()
        end
    })
    buttontransparency = legitmode:addtextbox({
        name = 'Transparency',
        number = true,
        callback = function(val)
            if legitmode.enabled then
                button.BackgroundTransparency = val
                imagelabel.ImageTransparency = val
            end
        end
    })
end

function lib:loadconfig()
    for i,v in self.modules do
        v:call(true, true, true)
    end
    self.saving = true
end

shared.loaded = lib

cloneref(game:FindService('Players')).LocalPlayer.OnTeleport:Connect(function()
    local initscript = [[
        task.delay(5, function()
            getgenv().developer = true
            loadfile('bloxstrap/loader.lua')() 
        end)
    ]]
    queue_on_teleport(initscript)
end)

return lib
