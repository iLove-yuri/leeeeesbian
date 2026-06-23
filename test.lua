local cloneref  = (cloneref or clonereference or function(i) return i end)
local IS        = cloneref(game:GetService("UserInputService"))
local TS        = cloneref(game:GetService("TweenService"))
local TextSvc   = cloneref(game:GetService("TextService"))
local CoreGui   = cloneref(game:GetService("CoreGui"))
local Players   = cloneref(game:GetService("Players"))
local RunSvc    = cloneref(game:GetService("RunService"))
local HttpSvc   = cloneref(game:GetService("HttpService"))
local LP      = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse   = LP:GetMouse()
local getgenv_  = (getgenv  or function() return shared end)
local ProtGui   = (protectgui or (syn and syn.protect_gui) or function() end)
local GetHUI    = (gethui   or function() return CoreGui end)
local _setclip  = (setclipboard or nil)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "UILibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.DisplayOrder   = 999
ScreenGui.ResetOnSpawn   = false
pcall(ProtGui, ScreenGui)
do
    local ok = pcall(function() ScreenGui.Parent = GetHUI() end)
    if not ok or not ScreenGui.Parent then
        ScreenGui.Parent = LP:WaitForChild("PlayerGui", 60)
    end
end
local Toggles = {}
local Options = {}
local Library = {
    Registry      = {};
    RegistryMap   = {};
    Signals       = {};
    UnloadFns     = {};
    DepBoxes      = {};
    DepGroupboxes = {};
    OpenedFrames  = {};
    BackgroundColor      = Color3.fromRGB(20,  20,  20);   
    MainColor            = Color3.fromRGB(25,  25,  25);   
    SecondaryColor       = Color3.fromRGB(32,  32,  32);   
    SecondaryHoverColor  = Color3.fromRGB(42,  42,  42);   
    OutlineColor         = Color3.fromRGB(60,  60,  60);   
    FontColor            = Color3.fromRGB(240, 240, 240);   
    AccentFontColor      = Color3.fromRGB(240, 240, 240);   
    DimColor             = Color3.fromRGB(150, 150, 150);   
    AccentColor          = Color3.fromRGB(56,  140, 70);    
    AccentColorDark      = Color3.fromRGB(37,  93,  47);    
    AccentDarkColor      = Color3.fromRGB(37,  93,  47);    
    DisabledAccentColor  = Color3.fromRGB(80,  80,  80);
    DisabledTextColor    = Color3.fromRGB(100, 100, 100);
    DisabledOutlineColor = Color3.fromRGB(35,  35,  35);
    SuccessColor         = Color3.fromRGB(60,  255, 60);
    ErrorColor           = Color3.fromRGB(255, 60,  60);
    RiskColor            = Color3.fromRGB(255, 50,  50);
    Font = Enum.Font.Code;
    Toggles  = Toggles;
    Options  = Options;
    IsMobile   = false;
    Unloaded   = false;
    CanDrag    = true;
    NotifySide = "Right";
    ScreenGui  = ScreenGui;
    Window     = nil;
    VideoLink          = "";
    InnerVideoBackground = nil;  
    LeftNotifArea  = nil;
    RightNotifArea = nil;
}
do
    local ok = pcall(function()
        local p = IS:GetPlatform()
        Library.IsMobile = (p == Enum.Platform.Android or p == Enum.Platform.IOS)
    end)
    if not ok then
        Library.IsMobile = IS.TouchEnabled and not IS.MouseEnabled
    end
end
local TW_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
local TW_MED  = TweenInfo.new(0.30, Enum.EasingStyle.Quad)
local TW_BACK = TweenInfo.new(0.30, Enum.EasingStyle.Back)
local function Tw(inst, info, props) TS:Create(inst, info, props):Play() end
function Library:Create(class, props)
    local inst = type(class) == "string" and Instance.new(class) or class
    for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
    return inst
end
local function Corner(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    if parent then c.Parent = parent end
    return c
end
local function Stroke(col, thick, parent)
    local s = Instance.new("UIStroke")
    s.Color     = col   or Library.OutlineColor
    s.Thickness = thick or 1
    if parent then s.Parent = parent end
    return s
end
local function Pad(top, btm, lft, rgt, parent)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top or 0)
    p.PaddingBottom = UDim.new(0, btm or 0)
    p.PaddingLeft   = UDim.new(0, lft or 0)
    p.PaddingRight  = UDim.new(0, rgt or 0)
    if parent then p.Parent = parent end
    return p
end
local function List(dir, halign, padding, parent)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir    or Enum.FillDirection.Vertical
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    if padding then l.Padding = UDim.new(0, padding) end
    if parent  then l.Parent  = parent end
    return l
end
local function Box(color, size, parent, cr)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = color or Library.SecondaryColor
    f.BorderSizePixel  = 0
    f.Size             = size  or UDim2.new(1, -4, 0, 22)
    if parent then f.Parent = parent end
    Corner(cr or 4, f)
    local s = Stroke(Library.OutlineColor, 1, f)
    return f, s
end
function Library:GetTextBounds(text, font, size, bounds)
    local ok, r = pcall(TextSvc.GetTextSize, TextSvc,
        tostring(text or ""), size or 14, font or Library.Font,
        bounds or Vector2.new(math.huge, math.huge))
    return ok and r.X or 0, ok and r.Y or 0
end
function Library:MapValue(v, fMin, fMax, tMin, tMax)
    return tMin + (tMax - tMin) * ((v - fMin) / math.max(fMax - fMin, 1e-6))
end
function Library:GetDarkerColor(color)
    local h, s, v = Color3.toHSV(color)
    return Color3.fromHSV(h, s, v / 1.5)
end
function Library:SafeCallback(fn, ...)
    if type(fn) ~= "function" then return end
    local ok = xpcall(fn, function(e)
        task.defer(error, debug.traceback(e, 2))
    end, ...)
    return ok
end
function Library:AttemptSave()
end
function Library:MouseOverFrame(f, input)
    local p, s = f.AbsolutePosition, f.AbsoluteSize
    local mx = input and input.Position.X or Mouse.X
    local my = input and input.Position.Y or Mouse.Y
    return mx >= p.X and mx <= p.X + s.X and my >= p.Y and my <= p.Y + s.Y
end
function Library:MouseOverOpenedFrame(input)
    for f in pairs(Library.OpenedFrames) do
        if f and f.Parent and Library:MouseOverFrame(f, input) then return true end
    end
    return false
end
function Library:CreateLabel(props)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Font       = Library.Font
    lbl.TextColor3 = Library.FontColor
    lbl.TextSize   = 14
    lbl.TextStrokeTransparency = 0.8
    Library:AddToRegistry(lbl, { TextColor3 = "FontColor" })
    return Library:Create(lbl, props or {})
end
function Library:MakeDraggable(frame, header, cutoff)
    cutoff = cutoff or 9999
    if not Library.IsMobile then
        local dragging, objPos
        frame.InputBegan:Connect(function(input)
            if Library.Unloaded then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if not Library.CanDrag then return end
            local relY = Mouse.Y - frame.AbsolutePosition.Y
            if header and relY > cutoff then return end
            dragging = true
            objPos   = Vector2.new(Mouse.X - frame.AbsolutePosition.X,
                                   Mouse.Y - frame.AbsolutePosition.Y)
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        Library:GiveSignal(IS.InputChanged:Connect(function(input)
            if Library.Unloaded or not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            frame.Position = UDim2.fromOffset(
                Mouse.X - objPos.X + frame.Size.X.Offset * frame.AnchorPoint.X,
                Mouse.Y - objPos.Y + frame.Size.Y.Offset * frame.AnchorPoint.Y)
        end))
    else
        local dragging, dragInput, dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not Library.CanDrag then return end
            dragging = true; dragInput = input
            dragStart = input.Position; startPos = frame.Position
        end)
        Library:GiveSignal(IS.TouchMoved:Connect(function(input)
            if not dragging or input ~= dragInput then return end
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end))
        Library:GiveSignal(IS.TouchEnded:Connect(function(input)
            if input == dragInput then dragging = false end
        end))
    end
end
function Library:AddToRegistry(inst, props)
    if Library.RegistryMap[inst] then
        for k, v in pairs(props or {}) do
            Library.RegistryMap[inst].Properties[k] = v
        end
        return
    end
    local d = { Instance = inst; Properties = props or {} }
    table.insert(Library.Registry, d)
    Library.RegistryMap[inst] = d
end
function Library:RemoveFromRegistry(inst)
    local d = Library.RegistryMap[inst]
    if not d then return end
    for i = #Library.Registry, 1, -1 do
        if Library.Registry[i] == d then table.remove(Library.Registry, i) end
    end
    Library.RegistryMap[inst] = nil
end
function Library:UpdateColorsUsingRegistry()
    for _, obj in next, Library.Registry do
        for prop, key in next, obj.Properties do
            if type(key) == "string" then
                pcall(function() obj.Instance[prop] = Library[key] end)
            elseif type(key) == "function" then
                pcall(function() obj.Instance[prop] = key() end)
            end
        end
    end
end
function Library:GiveSignal(conn)
    if conn then table.insert(Library.Signals, conn) end
    return conn
end
function Library:OnUnload(fn)
    table.insert(Library.UnloadFns, fn)
end
function Library:Unload()
    Library.Unloaded = true
    for _, c in ipairs(Library.Signals) do pcall(function() c:Disconnect() end) end
    for _, f in ipairs(Library.UnloadFns) do Library:SafeCallback(f) end
    pcall(function() ScreenGui:Destroy() end)
    getgenv_().UILibrary = nil
end
function Library:UpdateDepBoxes()
    for _, dep in next, Library.DepBoxes do
        local show = true
        for _, r in next, dep.Rules do
            local t = Toggles[r.Idx]
            if t and t.Value ~= r.Value then show = false; break end
        end
        if dep.Frame then dep.Frame.Visible = show end
    end
end
function Library:UpdateDepGroupboxes()
    for _, dep in next, Library.DepGroupboxes do
        local show = true
        for _, r in next, dep.Rules do
            local t = Toggles[r.Idx]
            if t and t.Value ~= r.Value then show = false; break end
        end
        if dep.Outer then dep.Outer.Visible = show end
    end
end
do
    local function MakeArea(anchor, pos, halign)
        local f = Library:Create("Frame", {
            AnchorPoint            = anchor;
            BackgroundTransparency = 1;
            Position               = pos;
            Size                   = UDim2.fromOffset(300, 0);
            AutomaticSize          = Enum.AutomaticSize.Y;
            ZIndex                 = 11000;
            Parent                 = ScreenGui;
        })
        local ll = List(nil, halign, 4, f)
        ll.VerticalAlignment = Enum.VerticalAlignment.Top
        return f
    end
    Library.LeftNotifArea  = MakeArea(
        Vector2.new(0,0), UDim2.new(0,10,0,40), Enum.HorizontalAlignment.Left)
    Library.RightNotifArea = MakeArea(
        Vector2.new(1,0), UDim2.new(1,-10,0,40), Enum.HorizontalAlignment.Right)
end
function Library:Notify(info)
    if type(info) ~= "table" then
        info = { Description = tostring(info), Time = 5 }
    end
    local title = info.Title and tostring(info.Title) or ""
    local desc  = tostring(info.Description or "")
    local dur   = (type(info.Time)     == "number" and info.Time)
               or (type(info.Duration) == "number" and info.Duration) or 5
    local side  = (Library.NotifySide or "Right"):lower()
    local area  = side == "left" and Library.LeftNotifArea or Library.RightNotifArea
    local W = 280
    local _, th = Library:GetTextBounds(
        (title ~= "" and "["..title.."] " or "")..desc,
        Library.Font, 13, Vector2.new(W - 16, math.huge))
    local H = math.max(28, th + 12)
    local outer = Library:Create("Frame", {
        BackgroundColor3 = Library.MainColor;
        BorderSizePixel  = 0;
        Size             = UDim2.fromOffset(0, H);
        ClipsDescendants = true;
        ZIndex           = 11001;
        Parent           = area;
    })
    Corner(5, outer)
    local ns = Stroke(Library.OutlineColor, 1, outer)
    Library:AddToRegistry(outer, { BackgroundColor3 = "MainColor" })
    Library:AddToRegistry(ns,    { Color = "OutlineColor" })
    local stripe = Library:Create("Frame", {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel  = 0;
        Size             = UDim2.new(0, 3, 1, 0);
        ZIndex           = 11002;
        Parent           = outer;
    })
    Library:AddToRegistry(stripe, { BackgroundColor3 = "AccentColor" })
    Library:CreateLabel({
        Position       = UDim2.fromOffset(10, 0);
        Size           = UDim2.new(1, -14, 1, 0);
        TextSize       = 13;
        Text           = (title ~= "" and "["..title.."] " or "")..desc;
        TextXAlignment = side == "left" and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right;
        TextWrapped    = true;
        RichText       = true;
        ZIndex         = 11003;
        Parent         = outer;
    })
    outer.Visible = true
    Tw(outer, TW_MED, { Size = UDim2.fromOffset(W, H) })
    local data = { Destroyed = false }
    function data:Destroy()
        if data.Destroyed then return end
        data.Destroyed = true
        Tw(outer, TW_MED, { Size = UDim2.fromOffset(0, H) })
        task.delay(0.31, function() pcall(function() outer:Destroy() end) end)
    end
    task.delay(dur, function() data:Destroy() end)
    return data
end
local BaseFuncs  = {}
BaseFuncs.__index = BaseFuncs
function BaseFuncs:AddBlank(h, visible)
    local f = Library:Create("Frame", {
        BackgroundTransparency = 1;
        Size    = UDim2.new(1, 0, 0, h or 6);
        Visible = (visible == nil) and true or visible;
        ZIndex  = 1;
        Parent  = self.Container;
    })
    return f
end
function BaseFuncs:AddDivider(config)
    local text = (type(config) == "table"  and config.Text)
              or (type(config) == "string" and config)
              or nil
    self:AddBlank(3)
    local line = Library:Create("Frame", {
        BackgroundColor3 = Library.OutlineColor;
        BorderSizePixel  = 0;
        Size             = UDim2.new(1, -4, 0, 1);
        ZIndex           = 5;
        Parent           = self.Container;
    })
    Library:AddToRegistry(line, { BackgroundColor3 = "OutlineColor" })
    if text and text ~= "" then
        local tw = Library:GetTextBounds(text, Library.Font, 12) + 8
        local tl = Library:CreateLabel({
            AnchorPoint            = Vector2.new(0.5, 0.5);
            BackgroundColor3       = Library.MainColor;
            BackgroundTransparency = 0;
            Position               = UDim2.new(0.5, 0, 0.5, 0);
            Size                   = UDim2.fromOffset(tw, 12);
            TextSize               = 12;
            Text                   = text;
            TextColor3             = Library.DimColor;
            ZIndex                 = 6;
            Parent                 = line;
        })
        Library:AddToRegistry(tl, { BackgroundColor3 = "MainColor"; TextColor3 = "DimColor" })
    end
    self:AddBlank(3)
    self:Resize()
end
function BaseFuncs:AddLabel(idx, text, wrap)
    if type(idx) ~= "string" then
        wrap = text; text = idx; idx = nil
    elseif type(text) == "boolean" then
        wrap = text; text = idx; idx = nil
    elseif text == nil then
        text = idx; idx = nil
    end
    text = text or ""; wrap = wrap or false
    local self2 = self
    local Label = { Type = "Label"; Value = text; Addons = {} }
    local _, th = Library:GetTextBounds(text, Library.Font, 14, Vector2.new(200, math.huge))
    local lbl = Library:CreateLabel({
        Size           = UDim2.new(1, -4, 0, wrap and math.max(14, th) or 14);
        TextSize       = 14;
        Text           = text;
        TextWrapped    = wrap;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex         = 5;
        Parent         = self.Container;
    })
    Library:Create("UIListLayout", {
        FillDirection       = Enum.FillDirection.Horizontal;
        HorizontalAlignment = Enum.HorizontalAlignment.Right;
        VerticalAlignment   = Enum.VerticalAlignment.Center;
        SortOrder           = Enum.SortOrder.LayoutOrder;
        Padding             = UDim.new(0, 4);
        Parent              = lbl;
    })
    Label.TextLabel = lbl
    Label.Container = self.Container
    function Label:SetText(t)
        Label.Value = t; lbl.Text = t
        if wrap then
            local _, h2 = Library:GetTextBounds(t, Library.Font, 14,
                Vector2.new(lbl.AbsoluteSize.X, math.huge))
            lbl.Size = UDim2.new(1, -4, 0, math.max(14, h2))
        end
        self2:Resize()
    end
    setmetatable(Label, BaseAddons)
    self:AddBlank(4); self:Resize()
    if idx then Options[idx] = Label end
    return Label
end
function BaseFuncs:AddParagraph(config)
    config = config or {}
    local title   = config.Title   or config.Name or ""
    local content = config.Content or config.Text or ""
    local P = {}
    local tl = Library:CreateLabel({
        Size=UDim2.new(1,-4,0,16); TextSize=14; Text=title;
        TextXAlignment=Enum.TextXAlignment.Left; RichText=true; ZIndex=5; Parent=self.Container
    })
    tl.Font = Enum.Font.GothamBold
    self:AddBlank(2)
    local _, ch = Library:GetTextBounds(content, Library.Font, 12, Vector2.new(200, math.huge))
    local cl = Library:CreateLabel({
        Size=UDim2.new(1,-4,0,math.max(12,ch)); TextSize=12; Text=content;
        TextWrapped=true; TextXAlignment=Enum.TextXAlignment.Left;
        RichText=true; ZIndex=5; Parent=self.Container
    })
    cl.TextColor3 = Library.DimColor
    Library:AddToRegistry(cl, { TextColor3 = "DimColor" })
    function P:Set(t, c)
        if t then tl.Text = t end
        if c then
            cl.Text = c
            local _, h2 = Library:GetTextBounds(c, Library.Font, 12,
                Vector2.new(cl.AbsoluteSize.X, math.huge))
            cl.Size = UDim2.new(1, -4, 0, math.max(12, h2))
        end
    end
    self:AddBlank(6); self:Resize()
    return P
end
function BaseFuncs:AddButton(config, fn2)
    if type(config) == "string" then config = { Text = config, Func = fn2 } end
    config = config or {}
    local text = config.Text or "Button"
    local fn   = config.Func or config.Callback or function() end
    local dbl  = config.DoubleClick or false
    local Btn = { Type = "Button"; Text = text; Disabled = false }
    local outer, stroke = Box(Library.SecondaryColor, UDim2.new(1,-4,0,24), self.Container)
    Library:AddToRegistry(outer,  { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(stroke, { Color = "OutlineColor" })
    local lbl = Library:CreateLabel({
        Size=UDim2.fromScale(1,1); TextSize=14; Text=text; ZIndex=6; Parent=outer
    })
    outer.MouseEnter:Connect(function()
        if Btn.Disabled then return end
        Tw(outer, TW_FAST, { BackgroundColor3 = Library.SecondaryHoverColor })
        Tw(stroke, TW_FAST, { Color = Library.AccentColor })
    end)
    outer.MouseLeave:Connect(function()
        Tw(outer, TW_FAST, { BackgroundColor3 = Library.SecondaryColor })
        Tw(stroke, TW_FAST, { Color = Library.OutlineColor })
    end)
    local locked = false
    outer.InputBegan:Connect(function(input)
        if Btn.Disabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if Library:MouseOverOpenedFrame() then return end
        if dbl then
            if locked then
                locked = false; lbl.Text = Btn.Text; lbl.TextColor3 = Library.FontColor
                Library:SafeCallback(fn)
            else
                locked = true; lbl.Text = "Are you sure?"; lbl.TextColor3 = Library.AccentColor
                task.delay(1.5, function()
                    if locked then
                        locked = false; lbl.Text = Btn.Text; lbl.TextColor3 = Library.FontColor
                    end
                end)
            end
        else
            Library:SafeCallback(fn)
        end
    end)
    function Btn:SetText(t) Btn.Text = t; lbl.Text = t end
    function Btn:SetDisabled(d)
        Btn.Disabled = d
        lbl.TextColor3 = d and Library.DimColor or Library.FontColor
    end
    function Btn:AddButton(config2, fn3)
        if type(config2) == "string" then config2 = { Text = config2, Func = fn3 } end
        outer.Size = UDim2.new(0.5, -4, 0, 24)
        local sub, subS = Box(Library.SecondaryColor, UDim2.new(0.5,-2,0,24), outer.Parent)
        sub.Position = UDim2.new(0.5, 2, outer.Position.Y.Scale, outer.Position.Y.Offset)
        Library:AddToRegistry(sub,  { BackgroundColor3 = "SecondaryColor" })
        Library:AddToRegistry(subS, { Color = "OutlineColor" })
        local sl = Library:CreateLabel({
            Size=UDim2.fromScale(1,1); TextSize=14; Text=config2.Text or ""; ZIndex=6; Parent=sub
        })
        sub.MouseEnter:Connect(function()
            Tw(sub, TW_FAST, { BackgroundColor3 = Library.SecondaryHoverColor })
            Tw(subS, TW_FAST, { Color = Library.AccentColor })
        end)
        sub.MouseLeave:Connect(function()
            Tw(sub, TW_FAST, { BackgroundColor3 = Library.SecondaryColor })
            Tw(subS, TW_FAST, { Color = Library.OutlineColor })
        end)
        sub.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                Library:SafeCallback(config2.Func or config2.Callback)
            end
        end)
        return { SetText = function(_, t) sl.Text = t end }
    end
    self:AddBlank(4); self:Resize()
    return Btn
end
function BaseFuncs:AddInput(idx, info)
    info = info or {}
    local self2 = self
    local Input = {
        Type       = "Input";
        Value      = info.Default or "";
        Numeric    = info.Numeric or false;
        Finished   = (info.Finished ~= nil) and info.Finished or false;
        AllowEmpty = info.AllowEmpty ~= false;
        Visible    = info.Visible ~= false;
        Disabled   = info.Disabled or false;
        Callback   = info.Callback or function() end;
    }
    if info.Text then
        Library:CreateLabel({
            Size=UDim2.new(1,-4,0,14); TextSize=13; Text=info.Text;
            TextXAlignment=Enum.TextXAlignment.Left; ZIndex=5; Parent=self.Container
        })
        self:AddBlank(2)
    end
    local box, bs = Box(Library.SecondaryColor, UDim2.new(1,-4,0,22), self.Container)
    Library:AddToRegistry(box, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(bs,  { Color = "OutlineColor" })
    local tb = Library:Create("TextBox", {
        BackgroundTransparency = 1;
        PlaceholderText    = info.Placeholder or info.PlaceholderText or "";
        PlaceholderColor3  = Library.DimColor;
        Text               = info.Default or "";
        TextColor3         = Library.FontColor;
        TextSize           = 13;
        Font               = Library.Font;
        TextXAlignment     = Enum.TextXAlignment.Left;
        ClearTextOnFocus   = info.ClearTextOnFocus ~= false;
        TextEditable       = not Input.Disabled;
        Size               = UDim2.new(1, -10, 1, 0);
        Position           = UDim2.fromOffset(5, 0);
        ZIndex             = 6;
        Parent             = box;
    })
    Library:AddToRegistry(tb, { TextColor3 = "FontColor"; PlaceholderColor3 = "DimColor" })
    box.MouseEnter:Connect(function()
        if not Input.Disabled then Tw(bs, TW_FAST, { Color = Library.AccentColor }) end
    end)
    box.MouseLeave:Connect(function()
        if not tb:IsFocused() then Tw(bs, TW_FAST, { Color = Library.OutlineColor }) end
    end)
    tb.Focused:Connect(function()    Tw(bs, TW_FAST, { Color = Library.AccentColor })  end)
    tb.FocusLost:Connect(function(enter)
        Tw(bs, TW_FAST, { Color = Library.OutlineColor })
        if Input.Finished and enter then Input:SetValue(tb.Text) end
    end)
    tb:GetPropertyChangedSignal("Text"):Connect(function()
        if Input.Finished then return end
        local t = tb.Text
        if Input.Numeric and t ~= "" and not tonumber(t) then tb.Text = Input.Value; return end
        Input.Value = t
        Library:SafeCallback(Input.Callback, t)
        Library:SafeCallback(Input.Changed,  t)
    end)
    function Input:SetValue(v)
        if Input.Numeric and not tonumber(v) then return end
        if not Input.AllowEmpty and v == "" then return end
        Input.Value = v; tb.Text = v
        Library:SafeCallback(Input.Callback, v)
        Library:SafeCallback(Input.Changed,  v)
        Library:AttemptSave()
    end
    function Input:OnChanged(f)    Input.Changed = f end
    function Input:SetVisible(v)   Input.Visible = v; box.Visible = v; self2:Resize() end
    function Input:SetDisabled(d)
        Input.Disabled = d; tb.TextEditable = not d
        tb.TextColor3  = d and Library.DimColor or Library.FontColor
    end
    Input.Default = Input.Value
    self:AddBlank(5); self:Resize()
    Options[idx] = Input
    return Input
end
function BaseFuncs:AddToggle(idx, info)
    info = info or {}
    local self2 = self
    local Toggle = {
        Type     = "Toggle";
        Value    = info.Default or false;
        Visible  = info.Visible ~= false;
        Disabled = info.Disabled or false;
        Risky    = info.Risky or false;
        Text     = info.Text or "";
        Callback = info.Callback or function() end;
        Addons   = {};
    }
    local row = Library:Create("Frame", {
        BackgroundTransparency = 1;
        Size    = UDim2.new(1, -4, 0, 16);
        Visible = Toggle.Visible;
        ZIndex  = 5;
        Parent  = self.Container;
    })
    local box = Library:Create("Frame", {
        BackgroundColor3 = Library.SecondaryColor;
        BorderSizePixel  = 0;
        Size             = UDim2.fromOffset(13, 13);
        ZIndex           = 6;
        Parent           = row;
    })
    Corner(3, box)
    local bs = Stroke(Library.OutlineColor, 1, box)
    Library:AddToRegistry(box, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(bs,  { Color = "OutlineColor" })
    local lbl = Library:CreateLabel({
        Position       = UDim2.fromOffset(19, 0);
        Size           = UDim2.new(1, -23, 1, 0);
        TextSize       = 14;
        Text           = info.Text or "";
        TextXAlignment = Enum.TextXAlignment.Left;
        RichText       = true;
        ZIndex         = 6;
        Parent         = row;
    })
    Library:Create("UIListLayout", {
        FillDirection       = Enum.FillDirection.Horizontal;
        HorizontalAlignment = Enum.HorizontalAlignment.Right;
        VerticalAlignment   = Enum.VerticalAlignment.Center;
        SortOrder           = Enum.SortOrder.LayoutOrder;
        Padding             = UDim.new(0, 4);
        Parent              = lbl;
    })
    Toggle.TextLabel    = lbl
    Toggle.Container    = self.Container
    Toggle.DisplayFrame = box
    function Toggle:Display()
        if Toggle.Disabled then
            box.BackgroundColor3 = Toggle.Value and Library.DisabledAccentColor or Library.SecondaryColor
            bs.Color             = Library.DisabledOutlineColor
            lbl.TextColor3       = Library.DisabledTextColor
        else
            box.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.SecondaryColor
            bs.Color             = Toggle.Value and Library.AccentDarkColor or Library.OutlineColor
            lbl.TextColor3       = Toggle.Risky and Library.RiskColor or Library.FontColor
        end
    end
    function Toggle:SetValue(v)
        Toggle.Value = not not v
        Toggle:Display()
        Library:SafeCallback(Toggle.Callback, Toggle.Value)
        Library:SafeCallback(Toggle.Changed,  Toggle.Value)
        Library:UpdateDepBoxes()
        Library:UpdateDepGroupboxes()
        Library:AttemptSave()
    end
    function Toggle:OnChanged(f)   Toggle.Changed = f end
    function Toggle:SetVisible(v)  Toggle.Visible = v; row.Visible = v; self2:Resize() end
    function Toggle:SetDisabled(d) Toggle.Disabled = d; Toggle:Display() end
    function Toggle:SetText(t)     Toggle.Text = t; lbl.Text = t end
    function Toggle:UpdateColors() Toggle:Display() end
    local hit = Library:Create("Frame", {
        BackgroundTransparency = 1;
        Size = UDim2.fromScale(1, 1); ZIndex = 8; Parent = row;
    })
    hit.InputBegan:Connect(function(input)
        if Toggle.Disabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if Library:MouseOverOpenedFrame() then return end
        for _, a in next, Toggle.Addons do
            if a.DisplayFrame and Library:MouseOverFrame(a.DisplayFrame) then return end
        end
        Toggle:SetValue(not Toggle.Value)
    end)
    hit.MouseEnter:Connect(function()
        if not Toggle.Disabled then Tw(bs, TW_FAST, { Color = Library.AccentColor }) end
    end)
    hit.MouseLeave:Connect(function()
        if not Toggle.Value and not Toggle.Disabled then
            Tw(bs, TW_FAST, { Color = Library.OutlineColor })
        end
    end)
    Toggle:Display()
    setmetatable(Toggle, BaseAddons)
    Toggle.Default = Toggle.Value
    self:AddBlank(5, Toggle.Visible); self:Resize()
    Toggles[idx] = Toggle
    Library:UpdateDepBoxes(); Library:UpdateDepGroupboxes()
    return Toggle
end
function BaseFuncs:AddSlider(idx, info)
    info = info or {}
    local self2  = self
    local extras = {}
    if type(info.Range) == "table" then
        info.Min = info.Range[1] or info.Min
        info.Max = info.Range[2] or info.Max
    end
    local Slider = {
        Type     = "Slider";
        Value    = info.Default or info.Min or 0;
        Min      = info.Min or 0;
        Max      = info.Max or 100;
        Rounding = info.Rounding or 0;
        Suffix   = info.Suffix or "";
        Prefix   = info.Prefix or "";
        Visible  = info.Visible ~= false;
        Disabled = info.Disabled or false;
        Text     = info.Text or "";
        Callback = info.Callback or function() end;
        MaxPx    = 1;
    }
    if info.Text and info.Text ~= "" and not info.Compact then
        local tl = Library:CreateLabel({
            Size=UDim2.new(1,-4,0,14); TextSize=13; Text=info.Text;
            TextXAlignment=Enum.TextXAlignment.Left;
            Visible=Slider.Visible; ZIndex=5; Parent=self.Container
        })
        table.insert(extras, self:AddBlank(2, Slider.Visible))
        table.insert(extras, tl)
    end
    local track, ts = Box(Library.SecondaryColor, UDim2.new(1,-4,0,14), self.Container)
    Library:AddToRegistry(track, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(ts,    { Color = "OutlineColor" })
    track:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        Slider.MaxPx = math.max(1, track.AbsoluteSize.X - 2)
    end)
    track.MouseEnter:Connect(function()
        if not Slider.Disabled then Tw(ts, TW_FAST, { Color = Library.AccentColor }) end
    end)
    track.MouseLeave:Connect(function()
        Tw(ts, TW_FAST, { Color = Library.OutlineColor })
    end)
    local fill = Library:Create("Frame", {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel  = 0;
        Size             = UDim2.new(0, 0, 1, 0);
        ZIndex           = 6;
        Parent           = track;
    })
    Corner(4, fill)
    Library:AddToRegistry(fill, { BackgroundColor3 = "AccentColor" })
    local valLbl = Library:CreateLabel({ Size=UDim2.fromScale(1,1); TextSize=12; ZIndex=7; Parent=track })
    local function Round(v)
        if Slider.Rounding == 0 then return math.floor(v + 0.5) end
        return tonumber(string.format("%."..Slider.Rounding.."f", v))
    end
    function Slider:Display()
        local x = Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, 1)
        fill.Size   = UDim2.new(math.clamp(x, 0, 1), 0, 1, 0)
        local vs    = Slider.Prefix..tostring(Slider.Value)..Slider.Suffix
        valLbl.Text = info.Compact   and (Slider.Text..": "..vs)
                   or info.HideMax  and vs
                   or (vs.."/"..Slider.Prefix..tostring(Slider.Max)..Slider.Suffix)
    end
    function Slider:SetValue(v)
        local n = tonumber(v); if not n then return end
        n = math.clamp(Round(n), Slider.Min, Slider.Max)
        local old = Slider.Value; Slider.Value = n; Slider:Display()
        if n ~= old then
            Library:SafeCallback(Slider.Callback, n)
            Library:SafeCallback(Slider.Changed,  n)
            Library:AttemptSave()
        end
    end
    function Slider:OnChanged(f)   Slider.Changed = f end
    function Slider:SetVisible(v)
        Slider.Visible = v; track.Visible = v
        for _, e in ipairs(extras) do e.Visible = v end
        self2:Resize()
    end
    function Slider:SetDisabled(d)
        Slider.Disabled = d
        fill.BackgroundColor3 = d and Library.DisabledAccentColor or Library.AccentColor
    end
    track.InputBegan:Connect(function(input)
        if Slider.Disabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if Library:MouseOverOpenedFrame() then return end
        Library.CanDrag = false
        while IS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            local rel = math.clamp(Mouse.X - track.AbsolutePosition.X, 0, Slider.MaxPx)
            Slider:SetValue(Library:MapValue(rel / Slider.MaxPx, 0, 1, Slider.Min, Slider.Max))
            RunSvc.RenderStepped:Wait()
        end
        Library.CanDrag = true; Library:AttemptSave()
    end)
    Slider:Display()
    table.insert(extras, self:AddBlank(5, Slider.Visible))
    self:Resize()
    Slider.Default = Slider.Value
    Options[idx]   = Slider
    return Slider
end
function BaseFuncs:AddDropdown(idx, info)
    info = info or {}
    local self2  = self
    local isOpen = false
    local Dropdown = {
        Type           = "Dropdown";
        Values         = info.Values or {};
        Value          = info.Multi and {} or nil;
        Multi          = info.Multi or false;
        AllowNull      = info.AllowNull or false;
        Visible        = info.Visible ~= false;
        Disabled       = info.Disabled or false;
        DisabledValues = info.DisabledValues or {};
        Callback       = info.Callback or function() end;
    }
    if info.Text then
        Library:CreateLabel({
            Size=UDim2.new(1,-4,0,14); TextSize=13; Text=info.Text;
            TextXAlignment=Enum.TextXAlignment.Left;
            Visible=Dropdown.Visible; ZIndex=5; Parent=self.Container
        })
        self:AddBlank(2)
    end
    local dbox, ds = Box(Library.SecondaryColor, UDim2.new(1,-4,0,22), self.Container)
    Library:AddToRegistry(dbox, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(ds,   { Color = "OutlineColor" })
    local selLbl = Library:CreateLabel({
        Position=UDim2.fromOffset(7,0); Size=UDim2.new(1,-24,1,0);
        TextSize=13; Text="
        TextXAlignment=Enum.TextXAlignment.Left;
        TextTruncate=Enum.TextTruncate.AtEnd; ZIndex=6; Parent=dbox
    })
    local arrow = Library:CreateLabel({
        AnchorPoint=Vector2.new(1,0.5); Position=UDim2.new(1,-6,0.5,0);
        Size=UDim2.fromOffset(12,12); TextSize=12; Text="▾"; ZIndex=7; Parent=dbox
    })
    local listOuter = Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Visible=false; ZIndex=200; Parent=ScreenGui
    })
    Corner(4, listOuter)
    local ls = Stroke(Library.OutlineColor, 1, listOuter)
    Library:AddToRegistry(listOuter, { BackgroundColor3 = "MainColor" })
    Library:AddToRegistry(ls,        { Color = "OutlineColor" })
    local listScroll = Library:Create("ScrollingFrame", {
        BackgroundTransparency=1; BorderSizePixel=0;
        CanvasSize=UDim2.new(0,0,0,0); Size=UDim2.fromScale(1,1);
        ScrollBarThickness=3; ScrollBarImageColor3=Library.AccentColor;
        ZIndex=201; Parent=listOuter
    })
    Library:AddToRegistry(listScroll, { ScrollBarImageColor3 = "AccentColor" })
    List(nil, nil, 0, listScroll)
    local ITEM_H   = 20
    local MAX_SHOW = info.MaxVisibleItems or 8
    local function UpdateListPos()
        listOuter.Position = UDim2.fromOffset(
            dbox.AbsolutePosition.X,
            dbox.AbsolutePosition.Y + dbox.AbsoluteSize.Y + 2)
        local h = math.clamp(#Dropdown.Values * ITEM_H, 0, MAX_SHOW * ITEM_H) + 2
        listOuter.Size = UDim2.fromOffset(dbox.AbsoluteSize.X, h)
        listScroll.CanvasSize = UDim2.fromOffset(0, #Dropdown.Values * ITEM_H)
    end
    dbox:GetPropertyChangedSignal("AbsolutePosition"):Connect(UpdateListPos)
    function Dropdown:Display()
        if Dropdown.Multi then
            local p = {}
            for v, on in pairs(Dropdown.Value) do if on then table.insert(p, tostring(v)) end end
            selLbl.Text = #p > 0 and table.concat(p, ", ") or "
        else
            selLbl.Text = Dropdown.Value and tostring(Dropdown.Value) or "
        end
    end
    function Dropdown:BuildList()
        for _, c in ipairs(listScroll:GetChildren()) do
            if not c:IsA("UIListLayout") then c:Destroy() end
        end
        for _, v in ipairs(Dropdown.Values) do
            local disabled = table.find(Dropdown.DisabledValues, v)
            local selected = Dropdown.Multi and Dropdown.Value[v]
                          or (not Dropdown.Multi and Dropdown.Value == v)
            local item = Library:Create("TextButton", {
                AutoButtonColor=false; BackgroundColor3=Library.MainColor;
                BorderSizePixel=0; Size=UDim2.new(1,0,0,ITEM_H);
                Text=""; ZIndex=202; Parent=listScroll
            })
            Library:AddToRegistry(item, { BackgroundColor3 = "MainColor" })
            local il = Library:CreateLabel({
                Position=UDim2.fromOffset(8,0); Size=UDim2.new(1,-10,1,0);
                TextSize=13; Text=tostring(v);
                TextXAlignment=Enum.TextXAlignment.Left; ZIndex=203; Parent=item
            })
            if selected and Library.RegistryMap[il] then
                il.TextColor3 = Library.AccentColor
                Library.RegistryMap[il].Properties.TextColor3 = "AccentColor"
            end
            if disabled and Library.RegistryMap[il] then
                il.TextColor3 = Library.DimColor
                Library.RegistryMap[il].Properties.TextColor3 = "DimColor"
            end
            item.MouseEnter:Connect(function() item.BackgroundColor3 = Library.SecondaryColor end)
            item.MouseLeave:Connect(function() item.BackgroundColor3 = Library.MainColor end)
            if not disabled then
                item.MouseButton1Click:Connect(function()
                    if Dropdown.Multi then
                        Dropdown.Value[v] = (not Dropdown.Value[v]) or nil
                    else
                        if Dropdown.Value == v and Dropdown.AllowNull then
                            Dropdown.Value = nil
                        else
                            Dropdown.Value = v
                        end
                        Dropdown:CloseList()
                    end
                    Dropdown:Display(); Dropdown:BuildList()
                    Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
                    Library:SafeCallback(Dropdown.Changed,  Dropdown.Value)
                    Library:AttemptSave()
                end)
            end
        end
        UpdateListPos()
    end
    function Dropdown:OpenList()
        if Dropdown.Disabled then return end
        isOpen = true; Dropdown:BuildList()
        listOuter.Visible = true; Library.OpenedFrames[listOuter] = true
        arrow.Text = "▴"
    end
    function Dropdown:CloseList()
        isOpen = false; listOuter.Visible = false
        Library.OpenedFrames[listOuter] = nil; arrow.Text = "▾"
    end
    dbox.InputBegan:Connect(function(input)
        if Dropdown.Disabled then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if isOpen then Dropdown:CloseList() else Dropdown:OpenList() end
    end)
    dbox.MouseEnter:Connect(function()
        if not Dropdown.Disabled then Tw(ds, TW_FAST, { Color = Library.AccentColor }) end
    end)
    dbox.MouseLeave:Connect(function()
        if not isOpen then Tw(ds, TW_FAST, { Color = Library.OutlineColor }) end
    end)
    Library:GiveSignal(IS.InputBegan:Connect(function(input)
        if Library.Unloaded or not isOpen then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local p, s = listOuter.AbsolutePosition, listOuter.AbsoluteSize
        if Mouse.X < p.X or Mouse.X > p.X + s.X
        or Mouse.Y < p.Y - ITEM_H or Mouse.Y > p.Y + s.Y then
            Dropdown:CloseList()
        end
    end))
    function Dropdown:SetValue(v)
        if Dropdown.Multi then
            Dropdown.Value = {}
            if type(v) == "table" then
                for k, on in pairs(v) do
                    if type(on) == "boolean" then Dropdown.Value[k] = on or nil
                    else Dropdown.Value[on] = true end
                end
            end
        else
            Dropdown.Value = table.find(Dropdown.Values, v) and v
                or (Dropdown.AllowNull and nil or Dropdown.Value)
        end
        Dropdown:Display()
        Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
        Library:SafeCallback(Dropdown.Changed,  Dropdown.Value)
    end
    function Dropdown:SetValues(vals)
        Dropdown.Values = vals or {}
        Dropdown.Value  = Dropdown.Multi and {} or nil
        Dropdown:Display()
        if isOpen then Dropdown:BuildList() end
    end
    function Dropdown:OnChanged(f)  Dropdown.Changed = f end
    function Dropdown:SetVisible(v)
        Dropdown.Visible = v; dbox.Visible = v
        if not v then Dropdown:CloseList() end; self2:Resize()
    end
    function Dropdown:SetDisabled(d)
        Dropdown.Disabled = d; if d then Dropdown:CloseList() end
        selLbl.TextColor3 = d and Library.DimColor or Library.FontColor
    end
    function Dropdown:UpdateColors() Dropdown:Display() end
    if info.Default ~= nil then
        if Dropdown.Multi then
            if type(info.Default) == "table" then
                for _, v in ipairs(info.Default) do Dropdown.Value[v] = true end
            end
        else
            if table.find(Dropdown.Values, info.Default) then
                Dropdown.Value = info.Default
            end
        end
    end
    Dropdown:Display()
    Dropdown.Default       = Dropdown.Value
    Dropdown.DefaultValues = Dropdown.Values
    self:AddBlank(5); self:Resize()
    Options[idx] = Dropdown
    return Dropdown
end
function BaseFuncs:AddSection(config)
    local name = (type(config) == "string" and config)
              or (type(config) == "table"  and (config.Name or config.Text))
              or ""
    local self2 = self
    local hdr = Library:CreateLabel({
        Size=UDim2.new(1,-4,0,14); TextSize=12; Text=name;
        TextXAlignment=Enum.TextXAlignment.Left; ZIndex=5; Parent=self.Container;
        TextColor3=Library.DimColor
    })
    Library:AddToRegistry(hdr, { TextColor3 = "DimColor" })
    self:AddBlank(1)
    local sep = Library:Create("Frame", {
        BackgroundColor3=Library.OutlineColor; BorderSizePixel=0;
        Size=UDim2.new(1,-4,0,1); ZIndex=5; Parent=self.Container
    })
    Library:AddToRegistry(sep, { BackgroundColor3 = "OutlineColor" })
    self:AddBlank(4)
    local S = setmetatable({
        Elements  = {};
        Container = self.Container;
        Resize    = function() self2:Resize() end;
    }, BaseFuncs)
    self:Resize()
    return S
end
function BaseFuncs:AddTable(config)
    config = config or {}
    local cols   = config.Columns or {}
    local height = config.Height  or 120
    local T      = { Type = "Table"; Rows = {}; Columns = cols }
    local frame, fs = Box(Library.SecondaryColor, UDim2.new(1,-4,0,height), self.Container)
    Library:AddToRegistry(frame, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(fs,    { Color = "OutlineColor" })
    local HROW = 18; local IROW = 18
    local colN = math.max(1, #cols)
    local header = Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Size=UDim2.new(1,0,0,HROW); ZIndex=6; Parent=frame
    })
    Library:AddToRegistry(header, { BackgroundColor3 = "MainColor" })
    for i, c in ipairs(cols) do
        Library:CreateLabel({
            Position=UDim2.new((i-1)/colN,3,0,0); Size=UDim2.new(1/colN,-6,1,0);
            TextSize=12; Text=c; TextXAlignment=Enum.TextXAlignment.Left;
            ZIndex=7; Parent=header
        })
    end
    local scroll = Library:Create("ScrollingFrame", {
        BackgroundTransparency=1; BorderSizePixel=0;
        Position=UDim2.fromOffset(0,HROW); Size=UDim2.new(1,0,1,-HROW);
        CanvasSize=UDim2.new(0,0,0,0);
        ScrollBarThickness=3; ScrollBarImageColor3=Library.AccentColor;
        ZIndex=6; Parent=frame
    })
    Library:AddToRegistry(scroll, { ScrollBarImageColor3 = "AccentColor" })
    List(nil, nil, 0, scroll)
    local rowFrames = {}
    local function Rebuild()
        for _, r in ipairs(rowFrames) do r:Destroy() end; rowFrames = {}
        for ri, row in ipairs(T.Rows) do
            local rf = Library:Create("Frame", {
                BackgroundColor3 = ri%2==0 and Library.SecondaryColor or Library.MainColor;
                BorderSizePixel=0; Size=UDim2.new(1,0,0,IROW); ZIndex=7; Parent=scroll
            })
            Library:AddToRegistry(rf, { BackgroundColor3 = ri%2==0 and "SecondaryColor" or "MainColor" })
            local cells = type(row)=="table" and row or {tostring(row)}
            for ci = 1, colN do
                Library:CreateLabel({
                    Position=UDim2.new((ci-1)/colN,3,0,0); Size=UDim2.new(1/colN,-6,1,0);
                    TextSize=12; Text=tostring(cells[ci] or "");
                    TextXAlignment=Enum.TextXAlignment.Left; ZIndex=8; Parent=rf
                })
            end
            table.insert(rowFrames, rf)
        end
        scroll.CanvasSize = UDim2.fromOffset(0, #T.Rows * IROW)
    end
    function T:AddRow(row)  table.insert(T.Rows, row); Rebuild() end
    function T:SetData(rows) T.Rows = rows or {};       Rebuild() end
    function T:Clear()       T.Rows = {};               Rebuild() end
    self:AddBlank(5); self:Resize()
    return T
end
function BaseFuncs:AddConsole(config)
    config = config or {}
    local height = config.Height or 120
    local C      = { Type = "Console"; Lines = {} }
    local frame, fs = Box(Library.SecondaryColor, UDim2.new(1,-4,0,height), self.Container)
    Library:AddToRegistry(frame, { BackgroundColor3 = "SecondaryColor" })
    Library:AddToRegistry(fs,    { Color = "OutlineColor" })
    local scroll = Library:Create("ScrollingFrame", {
        BackgroundTransparency=1; BorderSizePixel=0;
        Size=UDim2.fromScale(1,1); CanvasSize=UDim2.new(0,0,0,0);
        ScrollBarThickness=3; ScrollBarImageColor3=Library.AccentColor;
        ZIndex=6; Parent=frame
    })
    Pad(4,4,6,4, scroll)
    Library:AddToRegistry(scroll, { ScrollBarImageColor3 = "AccentColor" })
    List(nil, nil, 1, scroll)
    local LH = 14
    function C:AppendText(text, color)
        local lbl = Library:CreateLabel({
            Size=UDim2.new(1,0,0,LH); TextSize=12; Text=tostring(text or "");
            TextXAlignment=Enum.TextXAlignment.Left;
            TextWrapped=true; RichText=true; ZIndex=7; Parent=scroll
        })
        if color then lbl.TextColor3 = color; Library:RemoveFromRegistry(lbl) end
        table.insert(C.Lines, { Text=text; Color=color; Label=lbl })
        scroll.CanvasSize    = UDim2.fromOffset(0, #C.Lines * LH + 8)
        scroll.CanvasPosition = Vector2.new(0, math.huge)
    end
    function C:Clear()
        for _, l in ipairs(C.Lines) do pcall(function() l.Label:Destroy() end) end
        C.Lines = {}; scroll.CanvasSize = UDim2.fromOffset(0, 0)
    end
    function C:GetValue()
        local t = {}
        for _, l in ipairs(C.Lines) do table.insert(t, tostring(l.Text)) end
        return table.concat(t, "\n")
    end
    self:AddBlank(5); self:Resize()
    return C
end
function BaseFuncs:AddDependencyBox()
    local self2 = self
    local DB    = { Elements={}; Rules={} }
    local frame = Library:Create("Frame", {
        BackgroundTransparency=1; Size=UDim2.new(1,0,0,0);
        AutomaticSize=Enum.AutomaticSize.Y;
        Visible=false; ZIndex=5; Parent=self.Container
    })
    List(nil, nil, 0, frame)
    DB.Container = frame
    function DB:Resize()   self2:Resize() end
    function DB:SetDependencies(rules)
        DB.Rules = rules
        table.insert(Library.DepBoxes, { Frame=frame; Rules=rules })
        Library:UpdateDepBoxes()
    end
    setmetatable(DB, BaseFuncs)
    return DB
end
function BaseFuncs:AddDependencyGroupbox(name)
    local self2 = self
    local DGB   = { Elements={}; Rules={} }
    local gOuter = Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Size=UDim2.new(1,0,0,40); Visible=false; ZIndex=4; Parent=self.Container
    })
    Corner(5, gOuter)
    local gS = Stroke(Library.OutlineColor, 1, gOuter)
    Library:AddToRegistry(gOuter, { BackgroundColor3 = "MainColor" })
    Library:AddToRegistry(gS,     { Color = "OutlineColor" })
    local stripe = Library:Create("Frame", {
        BackgroundColor3=Library.AccentColor; BorderSizePixel=0;
        Size=UDim2.new(1,0,0,2); ZIndex=5; Parent=gOuter
    })
    Corner(5, stripe)
    Library:Create("Frame", {
        BackgroundColor3=Library.AccentColor; BorderSizePixel=0;
        Position=UDim2.new(0,0,1,-3); Size=UDim2.new(1,0,0,3); ZIndex=5; Parent=stripe
    })
    Library:AddToRegistry(stripe, { BackgroundColor3 = "AccentColor" })
    if name then
        Library:CreateLabel({
            Position=UDim2.fromOffset(8,4); Size=UDim2.new(1,-16,0,16);
            TextSize=13; Text=name;
            TextXAlignment=Enum.TextXAlignment.Left; ZIndex=5; Parent=gOuter
        })
    end
    local cont = Library:Create("Frame", {
        BackgroundTransparency=1; Position=UDim2.fromOffset(6,22);
        Size=UDim2.new(1,-8,1,-24); ZIndex=4; Parent=gOuter
    })
    List(nil, nil, 0, cont)
    DGB.Container = cont
    DGB.BoxOuter  = gOuter
    function DGB:Resize()
        local h = 0
        for _, el in ipairs(cont:GetChildren()) do
            if not el:IsA("UIListLayout") and el.Visible then
                h = h + el.Size.Y.Offset
            end
        end
        gOuter.Size = UDim2.new(1, 0, 0, h + 26)
        self2:Resize()
    end
    function DGB:SetDependencies(rules)
        DGB.Rules = rules
        table.insert(Library.DepGroupboxes, { Outer=gOuter; Rules=rules })
        Library:UpdateDepGroupboxes()
    end
    setmetatable(DGB, BaseFuncs)
    DGB:AddBlank(3)
    return DGB
end
local BaseAddons          = {}
BaseAddons.__index  = BaseAddons
function BaseAddons:AddColorPicker(idx, info)
    info = info or {}
    assert(info.Default, "AddColorPicker: info.Default (Color3) required")
    local parent = self
    local lbl    = parent.TextLabel
    local CP = {
        Type         = "ColorPicker";
        Value        = info.Default;
        Transparency = info.Transparency or 0;
        Callback     = info.Callback or function() end;
    }
    CP.H, CP.S, CP.V = CP.Value:ToHSV()
    local swatch = Library:Create("Frame", {
        BackgroundColor3 = CP.Value;
        BorderSizePixel  = 0;
        Size             = UDim2.fromOffset(24, 14);
        ZIndex           = 7;
        Parent           = lbl;
    })
    Corner(3, swatch)
    CP.DisplayFrame = swatch
    local open = false
    local pf   = nil        
    local SV_W, SV_H = 180, 150
    local function BuildPicker()
        local f = Library:Create("Frame", {
            BackgroundColor3 = Library.MainColor;
            BorderSizePixel  = 0;
            Position         = UDim2.fromOffset(swatch.AbsolutePosition.X,
                                                swatch.AbsolutePosition.Y + 18);
            Size             = UDim2.fromOffset(208,
                info.Transparency ~= nil and 248 or 220);
            Visible          = false;
            ZIndex           = 300;
            Parent           = ScreenGui;
        })
        Corner(6, f)
        local pfs = Stroke(Library.OutlineColor, 1, f)
        Library:AddToRegistry(f,   { BackgroundColor3 = "MainColor" })
        Library:AddToRegistry(pfs, { Color = "OutlineColor" })
        swatch:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if f and f.Parent then
                f.Position = UDim2.fromOffset(swatch.AbsolutePosition.X,
                                              swatch.AbsolutePosition.Y + 18)
            end
        end)
        local acc = Library:Create("Frame", {
            BackgroundColor3=Library.AccentColor; BorderSizePixel=0;
            Size=UDim2.new(1,0,0,2); ZIndex=301; Parent=f
        })
        Corner(6, acc); Library:AddToRegistry(acc, { BackgroundColor3 = "AccentColor" })
        local svMap = Library:Create("Frame", {
            BackgroundColor3=Color3.fromHSV(CP.H,1,1); BorderSizePixel=0;
            Position=UDim2.fromOffset(8,10); Size=UDim2.fromOffset(SV_W,SV_H);
            ZIndex=302; Parent=f
        })
        Corner(4, svMap)
        local svGrad = Library:Create("UIGradient", {
            Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(CP.H,1,1))
            }); Parent=svMap
        })
        Library:Create("UIGradient", {
            Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0,0,0,1)),
                ColorSequenceKeypoint.new(1, Color3.new(0,0,0,0))
            }); Rotation=90; Parent=svMap
        })
        local svCursor = Library:Create("Frame", {
            AnchorPoint=Vector2.new(0.5,0.5); BackgroundColor3=Color3.new(1,1,1);
            BorderSizePixel=0; Size=UDim2.fromOffset(8,8); ZIndex=303; Parent=svMap
        })
        Corner(4, svCursor); Stroke(Color3.new(0,0,0), 1, svCursor)
        local hBar = Library:Create("Frame", {
            BackgroundColor3=Color3.new(1,1,1); BorderSizePixel=0;
            Position=UDim2.fromOffset(SV_W+12,10); Size=UDim2.fromOffset(10,SV_H);
            ZIndex=302; Parent=f
        })
        Corner(3, hBar)
        Library:Create("UIGradient", {
            Color=ColorSequence.new({
                ColorSequenceKeypoint.new(0,     Color3.fromHSV(0,    1,1)),
                ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167,1,1)),
                ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333,1,1)),
                ColorSequenceKeypoint.new(0.5,   Color3.fromHSV(0.5,  1,1)),
                ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667,1,1)),
                ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833,1,1)),
                ColorSequenceKeypoint.new(1,     Color3.fromHSV(1,    1,1)),
            }); Rotation=90; Parent=hBar
        })
        local hCursor = Library:Create("Frame", {
            AnchorPoint=Vector2.new(0,0.5); BackgroundColor3=Color3.new(1,1,1);
            BorderSizePixel=0; Size=UDim2.new(1,0,0,2); ZIndex=303; Parent=hBar
        })
        Stroke(Color3.new(0,0,0), 1, hCursor)
        local hexBox = Box(Library.SecondaryColor, UDim2.fromOffset(SV_W,20), f)
        hexBox.Position = UDim2.fromOffset(8, SV_H+14)
        local hexTB = Library:Create("TextBox", {
            BackgroundTransparency=1; Font=Library.Font; TextSize=12;
            Text="#"..CP.Value:ToHex(); TextColor3=Library.FontColor;
            Size=UDim2.new(1,-8,1,0); Position=UDim2.fromOffset(4,0); ZIndex=303; Parent=hexBox
        })
        Library:AddToRegistry(hexTB, { TextColor3 = "FontColor" })
        local aBar, aCursor
        if info.Transparency ~= nil then
            aBar = Library:Create("Frame", {
                BackgroundColor3=CP.Value; BorderSizePixel=0;
                Position=UDim2.fromOffset(8,SV_H+40); Size=UDim2.fromOffset(SV_W,10);
                ZIndex=302; Parent=f
            })
            Corner(3, aBar)
            Library:Create("UIGradient", {
                Color=ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                    ColorSequenceKeypoint.new(1, Color3.new(1,1,1,0))
                }); Parent=aBar
            })
            aCursor = Library:Create("Frame", {
                AnchorPoint=Vector2.new(0.5,0); BackgroundColor3=Color3.new(1,1,1);
                BorderSizePixel=0; Size=UDim2.new(0,2,1,0); ZIndex=303; Parent=aBar
            })
            Stroke(Color3.new(0,0,0), 1, aCursor)
        end
        local function Sync()
            CP.Value = Color3.fromHSV(CP.H, CP.S, CP.V)
            swatch.BackgroundColor3 = CP.Value
            svMap.BackgroundColor3  = Color3.fromHSV(CP.H, 1, 1)
            svGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
                ColorSequenceKeypoint.new(1, Color3.fromHSV(CP.H,1,1))
            })
            svCursor.Position = UDim2.fromOffset(
                math.clamp(CP.S * SV_W, 0, SV_W-1),
                math.clamp((1-CP.V) * SV_H, 0, SV_H-1))
            hCursor.Position = UDim2.new(0, 0, math.clamp(CP.H,0,1), 0)
            hexTB.Text = "#"..CP.Value:ToHex()
            if aBar    then aBar.BackgroundColor3 = CP.Value end
            if aCursor then aCursor.Position = UDim2.new(1-CP.Transparency,-1,0,0) end
            Library:SafeCallback(CP.Callback, CP.Value, CP.Transparency)
            Library:SafeCallback(CP.Changed,  CP.Value, CP.Transparency)
            Library:AttemptSave()
        end
        svMap.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local function D()
                local p, s = svMap.AbsolutePosition, svMap.AbsoluteSize
                CP.S = math.clamp((Mouse.X - p.X) / s.X, 0, 1)
                CP.V = 1 - math.clamp((Mouse.Y - p.Y) / s.Y, 0, 1)
                Sync()
            end
            D()
            while IS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                D(); RunSvc.RenderStepped:Wait()
            end
        end)
        hBar.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local function D()
                local p, s = hBar.AbsolutePosition, hBar.AbsoluteSize
                CP.H = math.clamp((Mouse.Y - p.Y) / s.Y, 0, 1)
                Sync()
            end
            D()
            while IS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                D(); RunSvc.RenderStepped:Wait()
            end
        end)
        if aBar then
            aBar.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local function D()
                    local p, s = aBar.AbsolutePosition, aBar.AbsoluteSize
                    CP.Transparency = 1 - math.clamp((Mouse.X - p.X) / s.X, 0, 1)
                    Sync()
                end
                D()
                while IS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                    D(); RunSvc.RenderStepped:Wait()
                end
            end)
        end
        hexTB.FocusLost:Connect(function()
            local hex = hexTB.Text:gsub("#","")
            local ok, c = pcall(Color3.fromHex, hex)
            if ok then CP.Value = c; CP.H, CP.S, CP.V = c:ToHSV(); Sync() end
        end)
        Library.OpenedFrames[f] = true
        Sync()
        return f
    end 
    swatch.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if open then
            open = false; pf.Visible = false; Library.OpenedFrames[pf] = nil
        else
            if not pf then pf = BuildPicker() end
            open = true; pf.Visible = true
        end
    end)
    Library:GiveSignal(IS.InputBegan:Connect(function(input)
        if Library.Unloaded or not open or not pf then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if not Library:MouseOverFrame(pf) and not Library:MouseOverFrame(swatch) then
            open = false; pf.Visible = false; Library.OpenedFrames[pf] = nil
        end
    end))
    function CP:SetValue(color, transparency)
        CP.Value = color or CP.Value
        if transparency ~= nil then CP.Transparency = transparency end
        CP.H, CP.S, CP.V = CP.Value:ToHSV()
        swatch.BackgroundColor3 = CP.Value
        Library:SafeCallback(CP.Callback, CP.Value, CP.Transparency)
        Library:SafeCallback(CP.Changed,  CP.Value, CP.Transparency)
    end
    CP.SetValueRGB = CP.SetValue
    function CP:OnChanged(f) CP.Changed = f end
    CP.Default = CP.Value
    table.insert(parent.Addons or {}, CP)
    Options[idx] = CP
    return parent  
end
function BaseAddons:AddKeyPicker(idx, info)
    info = info or {}
    assert(info.Default ~= nil, "AddKeyPicker: info.Default required")
    local parent = self
    local lbl    = parent.TextLabel
    local SPECIAL = {
        MB1 = Enum.UserInputType.MouseButton1;
        MB2 = Enum.UserInputType.MouseButton2;
        MB3 = Enum.UserInputType.MouseButton3;
    }
    local SPECIAL_REV = {}
    for k,v in pairs(SPECIAL) do SPECIAL_REV[v] = k end
    local KP = {
        Type            = "KeyPicker";
        Value           = nil;
        Modifiers       = {};
        DisplayValue    = info.Default;
        Mode            = info.Mode or "Toggle";  
        Toggled         = false;
        SyncToggleState = info.SyncToggleState or false;
        Callback        = info.Callback or function() end;
        ChangedCallback = info.ChangedCallback or function() end;
    }
    local picking = false
    local kbox, kbs = Box(Library.BackgroundColor, UDim2.fromOffset(38,16), lbl)
    Library:AddToRegistry(kbox, { BackgroundColor3 = "BackgroundColor" })
    Library:AddToRegistry(kbs,  { Color = "OutlineColor" })
    KP.DisplayFrame = kbox
    local klbl = Library:CreateLabel({
        Size=UDim2.fromScale(1,1); TextSize=11; Text=info.Default; ZIndex=8; Parent=kbox
    })
    local function SetPicking(v)
        picking   = v
        klbl.Text = v and "..." or KP.DisplayValue
        Tw(kbs, TW_FAST, { Color = v and Library.AccentColor or Library.OutlineColor })
    end
    kbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            SetPicking(true)
        end
    end)
    Library:GiveSignal(IS.InputBegan:Connect(function(input)
        if Library.Unloaded then return end
        if picking then
            local keyStr
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keyStr = input.KeyCode.Name; KP.Value = input.KeyCode
            elseif SPECIAL_REV[input.UserInputType] then
                keyStr = SPECIAL_REV[input.UserInputType]; KP.Value = input.UserInputType
            else
                SetPicking(false); return
            end
            KP.DisplayValue = keyStr; klbl.Text = keyStr
            SetPicking(false)
            Library:SafeCallback(KP.ChangedCallback, KP.Value)
            Library:AttemptSave()
            return
        end
        if not KP.Value or IS:GetFocusedTextBox() then return end
        local hit = false
        if typeof(KP.Value) == "EnumItem" then
            if KP.Value.EnumType == Enum.KeyCode then
                hit = input.UserInputType == Enum.UserInputType.Keyboard
                   and input.KeyCode == KP.Value
            else
                hit = input.UserInputType == KP.Value
            end
        end
        if not hit then return end
        if KP.Mode == "Toggle" then
            KP.Toggled = not KP.Toggled
            Library:SafeCallback(KP.Callback, KP.Toggled)
            if KP.SyncToggleState and parent.SetValue then parent:SetValue(KP.Toggled) end
        elseif KP.Mode == "Hold" then
            KP.Toggled = true
            Library:SafeCallback(KP.Callback, true)
            if KP.SyncToggleState and parent.SetValue then parent:SetValue(true) end
        elseif KP.Mode == "Press" or KP.Mode == "Always" then
            Library:SafeCallback(KP.Callback, true)
        end
    end))
    Library:GiveSignal(IS.InputEnded:Connect(function(input)
        if Library.Unloaded or not KP.Value or KP.Mode ~= "Hold" then return end
        local hit = false
        if typeof(KP.Value) == "EnumItem" then
            if KP.Value.EnumType == Enum.KeyCode then
                hit = input.UserInputType == Enum.UserInputType.Keyboard
                   and input.KeyCode == KP.Value
            else hit = input.UserInputType == KP.Value end
        end
        if not hit then return end
        KP.Toggled = false
        Library:SafeCallback(KP.Callback, false)
        if KP.SyncToggleState and parent.SetValue then parent:SetValue(false) end
    end))
    function KP:SetValue(data)
        if type(data) == "table" then
            local keyName = data[1]; KP.Mode = data[2] or KP.Mode
            if SPECIAL[keyName] then
                KP.Value = SPECIAL[keyName]
            else
                local ok, kc = pcall(function() return Enum.KeyCode[keyName] end)
                if ok and kc then KP.Value = kc end
            end
            KP.DisplayValue = keyName or KP.DisplayValue
            if type(data[3]) == "table" then KP.Modifiers = data[3] end
        elseif type(data) == "string" then
            KP.DisplayValue = data
        end
        klbl.Text = KP.DisplayValue
        Library:SafeCallback(KP.ChangedCallback, KP.Value)
    end
    function KP:OnChanged(f) KP.ChangedCallback = f end
    KP.Default = info.Default
    table.insert(parent.Addons or {}, KP)
    Options[idx] = KP
    return parent  
end
function BaseAddons:AddDropdown(idx, info)
    info = info or {}
    local parent = self
    local lbl    = parent.TextLabel
    local DD = {
        Type     = "Dropdown";
        Values   = info.Values or {};
        Value    = info.Multi and {} or nil;
        Multi    = info.Multi or false;
        AllowNull = info.AllowNull or false;
        Callback = info.Callback or function() end;
    }
    local sw, swS = Box(Library.BackgroundColor, UDim2.fromOffset(50, 16), lbl)
    sw.BorderSizePixel = 0
    Library:AddToRegistry(sw, { BackgroundColor3 = "BackgroundColor" })
    Library:AddToRegistry(swS, { Color = "OutlineColor" })
    DD.DisplayFrame = sw
    local sl = Library:CreateLabel({
        Size = UDim2.fromScale(1,1); TextSize = 11;
        Text = info.Default or (info.Values and info.Values[1]) or "";
        ZIndex = 8; Parent = sw
    })
    function DD:SetValue(v)
        DD.Value = v
        sl.Text = type(v) == "string" and v or tostring(v)
        Library:SafeCallback(DD.Callback, v)
        Library:SafeCallback(DD.Changed, v)
    end
    function DD:SetValues(vals)
        DD.Values = vals
        if not DD.Multi then DD.Value = vals[1] end
        sl.Text = DD.Value and tostring(DD.Value) or ""
    end
    function DD:OnChanged(f) DD.Changed = f end
    DD.Default = DD.Value
    table.insert(parent.Addons or {}, DD)
    Options[idx] = DD
    return parent  
end
BaseFuncs.AddColorPicker = BaseAddons.AddColorPicker
BaseFuncs.AddKeyPicker   = BaseAddons.AddKeyPicker
BaseFuncs.AddDropdown    = BaseAddons.AddDropdown  
function Library:CreateWindow(config)
    config = config or {}
    local title     = config.Title or "UILibrary"
    local subtitle  = config.Subtitle
    local toggleKey = config.ToggleKeybind
    local autoShow  = config.AutoShow ~= false
    local center    = config.Center   ~= false
    if config.Theme then
        for k, v in pairs(config.Theme) do
            if Library[k] ~= nil then Library[k] = v end
        end
    end
    Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
    local vp   = workspace.CurrentCamera.ViewportSize
    local W    = config.Size and config.Size.X.Offset
              or config.Width
              or math.clamp(vp.X * (Library.IsMobile and 0.95 or 0.75), 400, 700)
    local H    = config.Size and config.Size.Y.Offset
              or config.Height
              or math.clamp(vp.Y * (Library.IsMobile and 0.90 or 0.65), 280, 700)
    local HDR  = Library.IsMobile and 54 or 60    
    local PAD  = 12
    local FS   = Library.IsMobile and 13 or 14
    local Window = { Tabs = {}; State = "Open"; Title = title }
    Library.Window = Window
    local TAB_H     = 26
    local CONTENT_Y = HDR + 4 + TAB_H + 4
    local wrapper = Library:Create("Frame", {
        AnchorPoint            = Vector2.new(0.5, 0.5);
        BackgroundTransparency = 1;
        Position               = center and UDim2.fromScale(0.5,0.5)
                                         or (config.Position or UDim2.fromScale(0.5,0.5));
        Size                   = UDim2.fromOffset(W, H);
        ZIndex                 = 1;
        Parent                 = ScreenGui;
    })
    local outer = Library:Create("Frame", {
        BackgroundColor3 = Library.BackgroundColor;
        BorderSizePixel  = 0;
        Size             = UDim2.fromOffset(0, 0);   
        ClipsDescendants = true;
        ZIndex           = 1;
        Parent           = wrapper;
    })
    Corner(6, outer)
    Stroke(Library.OutlineColor, 1, outer)
    Library:AddToRegistry(outer, { BackgroundColor3 = "BackgroundColor" })
    Library:MakeDraggable(wrapper, outer, HDR)
    Window.Holder = outer
    local hdr = Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Size=UDim2.new(1,0,0,HDR); ZIndex=2; Parent=outer
    })
    Corner(6, hdr)
    Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Position=UDim2.new(0,0,1,-6); Size=UDim2.new(1,0,0,6); ZIndex=2; Parent=hdr
    })
    local hdrS = Library:Create("UIStroke", {
        Color=Library.OutlineColor; Thickness=1;
        ApplyStrokeMode=Enum.ApplyStrokeMode.Border; Parent=hdr
    })
    Library:AddToRegistry(hdr,  { BackgroundColor3 = "MainColor" })
    Library:AddToRegistry(hdrS, { Color = "OutlineColor" })
    local titleLbl = Library:CreateLabel({
        Position=UDim2.fromOffset(PAD,0); Size=UDim2.new(1,-70,1,0);
        TextSize=Library.IsMobile and 18 or 24; Text=title;
        TextXAlignment=Enum.TextXAlignment.Left; ZIndex=3; Parent=hdr
    })
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = Library.AccentFontColor
    Library:AddToRegistry(titleLbl, { TextColor3 = "AccentFontColor" })
    if subtitle then
        local subLbl = Library:CreateLabel({
            Position=UDim2.fromOffset(PAD,8); Size=UDim2.new(1,-70,0,14);
            TextSize=9; Text=subtitle;
            TextXAlignment=Enum.TextXAlignment.Left; ZIndex=3; Parent=hdr
        })
        Library:AddToRegistry(subLbl, { TextColor3 = "DimColor" })
    end
    local minBtn = Library:Create("TextButton", {
        AnchorPoint=Vector2.new(1,0.5); AutoButtonColor=false;
        BackgroundColor3=Library.SecondaryColor; BorderSizePixel=0;
        Position=UDim2.new(1,-36,0.5,0); Size=UDim2.fromOffset(22,18);
        Font=Library.Font; TextSize=13; Text="–"; TextColor3=Library.DimColor;
        ZIndex=4; Parent=hdr
    })
    Corner(3, minBtn)
    Library:AddToRegistry(minBtn, { BackgroundColor3="SecondaryColor"; TextColor3="DimColor" })
    minBtn.MouseEnter:Connect(function()
        Tw(minBtn, TW_FAST, { BackgroundColor3=Library.SecondaryHoverColor; TextColor3=Library.FontColor })
    end)
    minBtn.MouseLeave:Connect(function()
        Tw(minBtn, TW_FAST, { BackgroundColor3=Library.SecondaryColor; TextColor3=Library.DimColor })
    end)
    local closeBtn = Library:Create("TextButton", {
        AnchorPoint=Vector2.new(1,0.5); AutoButtonColor=false;
        BackgroundColor3=Library.SecondaryColor; BorderSizePixel=0;
        Position=UDim2.new(1,-10,0.5,0); Size=UDim2.fromOffset(22,18);
        Font=Library.Font; TextSize=13; Text="×"; TextColor3=Library.DimColor;
        ZIndex=4; Parent=hdr
    })
    Corner(3, closeBtn)
    Library:AddToRegistry(closeBtn, { BackgroundColor3="SecondaryColor"; TextColor3="DimColor" })
    closeBtn.MouseEnter:Connect(function()
        Tw(closeBtn, TW_FAST, { BackgroundColor3=Library.ErrorColor; TextColor3=Color3.new(1,1,1) })
    end)
    closeBtn.MouseLeave:Connect(function()
        Tw(closeBtn, TW_FAST, { BackgroundColor3=Library.SecondaryColor; TextColor3=Library.DimColor })
    end)
    closeBtn.MouseButton1Click:Connect(function()
        Library:SafeCallback(config.CloseCallback)
        wrapper.Visible = false; Window.State = "Closed"
    end)
    local tabStrip = Library:Create("ScrollingFrame", {
        BackgroundTransparency=1; BorderSizePixel=0;
        Position=UDim2.fromOffset(PAD, HDR+4);
        Size=UDim2.new(1,-PAD*2,0,TAB_H);
        CanvasSize=UDim2.new(0,0,0,0);
        AutomaticCanvasSize=Enum.AutomaticSize.X;
        ScrollBarThickness=0; ZIndex=2; Parent=outer
    })
    Library:Create("UIListLayout", {
        Padding=UDim.new(0,4); FillDirection=Enum.FillDirection.Horizontal;
        VerticalAlignment=Enum.VerticalAlignment.Center;
        SortOrder=Enum.SortOrder.LayoutOrder; Parent=tabStrip
    })
    local tabCont = Library:Create("Frame", {
        BackgroundColor3=Library.MainColor; BorderSizePixel=0;
        Position=UDim2.fromOffset(PAD, CONTENT_Y);
        Size=UDim2.new(1,-PAD*2, 1,-CONTENT_Y-PAD);
        ZIndex=2; Parent=outer
    })
    Corner(5, tabCont)
    local tcS = Stroke(Library.OutlineColor, 1, tabCont)
    Library:AddToRegistry(tabCont, { BackgroundColor3 = "MainColor" })
    Library:AddToRegistry(tcS,     { Color = "OutlineColor" })
    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            minBtn.Text = "□"
            Tw(outer, TW_MED, { Size = UDim2.fromOffset(W, HDR+4) })
            tabStrip.Visible = false; tabCont.Visible = false
            Window.State = "Minimized"
        else
            minBtn.Text = "–"
            Tw(outer, TW_BACK, { Size = UDim2.fromOffset(W, H) })
            tabStrip.Visible = true; tabCont.Visible = true
            Window.State = "Open"
        end
    end)
    function Window:Minimize() if not minimized then minBtn.MouseButton1Click:Fire() end end
    function Window:Restore()  if minimized     then minBtn.MouseButton1Click:Fire() end end
    function Window:Toggle()
        wrapper.Visible = not wrapper.Visible
        Window.State = wrapper.Visible and "Open" or "Closed"
    end
    function Window:Destroy()   Library:Unload() end
    function Window:SetTitle(t) Window.Title = t; titleLbl.Text = t end
    if toggleKey then
        Library:GiveSignal(IS.InputBegan:Connect(function(input)
            if Library.Unloaded or IS:GetFocusedTextBox() then return end
            local match = (typeof(toggleKey) == "EnumItem" and input.KeyCode == toggleKey)
                       or (type(toggleKey)   == "string"   and input.KeyCode.Name == toggleKey)
            if match then Window:Toggle() end
        end))
    end
    function Window:AddTab(name, _tabConfig)
        local Tab = { Groupboxes={}; Name=name }
        local tw = Library:GetTextBounds(name, Library.Font, 13) + 16
        local tabBtn = Library:Create("TextButton", {
            AutoButtonColor=false; BackgroundColor3=Library.BackgroundColor;
            BorderSizePixel=0; Font=Library.Font; TextSize=13;
            Text=name; TextColor3=Library.DimColor;
            Size=UDim2.new(0,tw,1,-2); ZIndex=3; Parent=tabStrip
        })
        Corner(4, tabBtn)
        local tbS = Stroke(Library.OutlineColor, 1, tabBtn)
        Library:AddToRegistry(tabBtn, { BackgroundColor3="BackgroundColor"; TextColor3="DimColor" })
        Library:AddToRegistry(tbS,    { Color="OutlineColor" })
        local tabFrame = Library:Create("Frame", {
            BackgroundTransparency=1; Size=UDim2.fromScale(1,1);
            Visible=false; ZIndex=3; Parent=tabCont
        })
        local function MakeCol(pos, size)
            local sf = Library:Create("ScrollingFrame", {
                BackgroundTransparency=1; BorderSizePixel=0;
                BottomImage=""; TopImage="";
                Position=pos; Size=size;
                CanvasSize=UDim2.fromOffset(0,0);
                ScrollBarThickness=3; ScrollBarImageColor3=Library.OutlineColor;
                ZIndex=3; Parent=tabFrame
            })
            Library:AddToRegistry(sf, { ScrollBarImageColor3 = "OutlineColor" })
            local ll = List(nil, Enum.HorizontalAlignment.Center, 8, sf)
            ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sf.CanvasSize = UDim2.fromOffset(0, ll.AbsoluteContentSize.Y + 8)
            end)
            return sf
        end
        local leftCol  = MakeCol(UDim2.fromOffset(7,7),      UDim2.new(0.5,-11,1,-14))
        local rightCol = MakeCol(UDim2.new(0.5,5,0,7),       UDim2.new(0.5,-12,1,-14))
        Tab.LeftSideFrame  = leftCol
        Tab.RightSideFrame = rightCol
        local function AddGroupbox(gname, side)
            local GB = { Elements={}; Tab=Tab }
            local gOuter = Library:Create("Frame", {
                BackgroundColor3=Library.MainColor; BorderSizePixel=0;
                Size=UDim2.new(1,0,0,40); ZIndex=4; Parent=side
            })
            Corner(5, gOuter)
            local gS = Stroke(Library.OutlineColor, 1, gOuter)
            Library:AddToRegistry(gOuter, { BackgroundColor3 = "MainColor" })
            Library:AddToRegistry(gS,     { Color = "OutlineColor" })
            local stripe = Library:Create("Frame", {
                BackgroundColor3=Library.AccentColor; BorderSizePixel=0;
                Size=UDim2.new(1,0,0,2); ZIndex=5; Parent=gOuter
            })
            Corner(5, stripe)
            Library:Create("Frame", {  
                BackgroundColor3=Library.AccentColor; BorderSizePixel=0;
                Position=UDim2.new(0,0,1,-3); Size=UDim2.new(1,0,0,3); ZIndex=5; Parent=stripe
            })
            Library:AddToRegistry(stripe, { BackgroundColor3 = "AccentColor" })
            Library:CreateLabel({
                Position=UDim2.fromOffset(8,4); Size=UDim2.new(1,-16,0,16);
                TextSize=13; Text=gname;
                TextXAlignment=Enum.TextXAlignment.Left; ZIndex=5; Parent=gOuter
            })
            local cont = Library:Create("Frame", {
                BackgroundTransparency=1; Position=UDim2.fromOffset(6,22);
                Size=UDim2.new(1,-8,1,-24); ZIndex=4; Parent=gOuter
            })
            List(nil, nil, 0, cont)
            GB.Container = cont
            GB.BoxOuter  = gOuter
            function GB:Resize()
                local h = 0
                for _, el in ipairs(cont:GetChildren()) do
                    if not el:IsA("UIListLayout") and el.Visible then
                        h = h + el.Size.Y.Offset
                    end
                end
                gOuter.Size = UDim2.new(1, 0, 0, h + 26)
            end
            function GB:SetDependencies(rules)
                table.insert(Library.DepGroupboxes, { Outer=gOuter; Rules=rules })
                Library:UpdateDepGroupboxes()
            end
            setmetatable(GB, BaseFuncs)
            GB:AddBlank(3); GB:Resize()
            Tab.Groupboxes[gname] = GB
            return GB
        end
        function Tab:AddLeftGroupbox(n)  return AddGroupbox(n, leftCol)  end
        function Tab:AddRightGroupbox(n) return AddGroupbox(n, rightCol) end
        function Tab:AddTabbox(tbConfig)
            tbConfig = tbConfig or {}
            local side   = (tbConfig.Side == "Right") and rightCol or leftCol
            local Tabbox = { SubTabs={} }
            local tbOuter = Library:Create("Frame", {
                BackgroundColor3=Library.MainColor; BorderSizePixel=0;
                Size=UDim2.new(1,0,0,200); ZIndex=4; Parent=side
            })
            Corner(5, tbOuter)
            Stroke(Library.OutlineColor, 1, tbOuter)
            Library:AddToRegistry(tbOuter, { BackgroundColor3 = "MainColor" })
            local miniStrip = Library:Create("Frame", {
                BackgroundColor3=Library.BackgroundColor; BorderSizePixel=0;
                Size=UDim2.new(1,0,0,22); ZIndex=5; Parent=tbOuter
            })
            Library:AddToRegistry(miniStrip, { BackgroundColor3 = "BackgroundColor" })
            List(Enum.FillDirection.Horizontal, nil, 3, miniStrip)
            local tbContent = Library:Create("Frame", {
                BackgroundTransparency=1; Position=UDim2.fromOffset(0,22);
                Size=UDim2.new(1,0,1,-22); ZIndex=5; Parent=tbOuter
            })
            local activeSubTab = nil
            function Tabbox:AddTab(stName)
                local ST = { Elements={} }
                local stW   = Library:GetTextBounds(stName, Library.Font, 12) + 12
                local stBtn = Library:Create("TextButton", {
                    AutoButtonColor=false; BackgroundColor3=Library.BackgroundColor;
                    BorderSizePixel=0; Font=Library.Font; TextSize=12;
                    Text=stName; TextColor3=Library.DimColor;
                    Size=UDim2.new(0,stW,1,-4); ZIndex=6; Parent=miniStrip
                })
                Corner(3, stBtn)
                Library:AddToRegistry(stBtn, { BackgroundColor3="BackgroundColor"; TextColor3="DimColor" })
                local stFrame = Library:Create("Frame", {
                    BackgroundTransparency=1; Size=UDim2.fromScale(1,1);
                    Visible=false; ZIndex=6; Parent=tbContent
                })
                local stCont = Library:Create("Frame", {
                    BackgroundTransparency=1; Size=UDim2.fromScale(1,1); ZIndex=7; Parent=stFrame
                })
                List(nil, nil, 0, stCont)
                ST.Container = stCont
                ST.BoxOuter  = tbOuter
                function ST:Resize()
                    local h = 0
                    for _, el in ipairs(stCont:GetChildren()) do
                        if not el:IsA("UIListLayout") and el.Visible then
                            h = h + el.Size.Y.Offset
                        end
                    end
                    tbOuter.Size = UDim2.new(1,0,0, h + 30)
                end
                setmetatable(ST, BaseFuncs)
                ST:AddBlank(2); ST:Resize()
                stBtn.MouseButton1Click:Connect(function()
                    if activeSubTab then
                        activeSubTab.Frame.Visible = false
                        activeSubTab.Btn.BackgroundColor3 = Library.BackgroundColor
                        activeSubTab.Btn.TextColor3       = Library.DimColor
                    end
                    stFrame.Visible        = true
                    stBtn.BackgroundColor3 = Library.SecondaryColor
                    stBtn.TextColor3       = Library.FontColor
                    activeSubTab = { Frame=stFrame; Btn=stBtn }
                    ST:Resize()
                end)
                if not activeSubTab then
                    stFrame.Visible        = true
                    stBtn.BackgroundColor3 = Library.SecondaryColor
                    stBtn.TextColor3       = Library.FontColor
                    activeSubTab = { Frame=stFrame; Btn=stBtn }
                end
                table.insert(Tabbox.SubTabs, ST)
                return ST
            end
            return Tabbox
        end
        function Tab:ShowTab()
            Library.ActiveTab = name
            for _, t in ipairs(Window.Tabs) do
                if t.Frame then t.Frame.Visible = false end
                if t.Btn then
                    t.Btn.BackgroundColor3 = Library.BackgroundColor
                    t.Btn.TextColor3       = Library.DimColor
                    if Library.RegistryMap[t.Btn] then
                        Library.RegistryMap[t.Btn].Properties.BackgroundColor3 = "BackgroundColor"
                        Library.RegistryMap[t.Btn].Properties.TextColor3       = "DimColor"
                    end
                end
            end
            tabFrame.Visible       = true
            tabBtn.BackgroundColor3 = Library.SecondaryColor
            tabBtn.TextColor3      = Library.FontColor
            if Library.RegistryMap[tabBtn] then
                Library.RegistryMap[tabBtn].Properties.BackgroundColor3 = "SecondaryColor"
                Library.RegistryMap[tabBtn].Properties.TextColor3       = "FontColor"
            end
        end
        function Tab:HideTab()
            tabFrame.Visible       = false
            tabBtn.BackgroundColor3 = Library.BackgroundColor
            tabBtn.TextColor3      = Library.DimColor
        end
        Tab.Show  = Tab.ShowTab
        Tab.Hide  = Tab.HideTab
        Tab.Frame = tabFrame
        Tab.Btn   = tabBtn
        tabBtn.MouseButton1Click:Connect(function() Tab:ShowTab() end)
        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Tab:ShowTab() end
        return Tab
    end
    function Window:AddDialog(_idx, info)
        info = info or {}
        local Dialog = {}
        local overlay = Library:Create("TextButton", {
            AutoButtonColor=false; BackgroundColor3=Color3.new(0,0,0);
            BackgroundTransparency=0.5; Size=UDim2.fromScale(1,1);
            Text=""; ZIndex=500; Parent=outer
        })
        local df = Library:Create("Frame", {
            AnchorPoint=Vector2.new(0.5,0.5); BackgroundColor3=Library.BackgroundColor;
            BorderSizePixel=0; Position=UDim2.fromScale(0.5,0.5);
            Size=UDim2.fromOffset(280,0); AutomaticSize=Enum.AutomaticSize.Y;
            ZIndex=501; Parent=overlay
        })
        Corner(6, df)
        Stroke(Library.OutlineColor, 1, df)
        Library:AddToRegistry(df, { BackgroundColor3 = "BackgroundColor" })
        Pad(12,12,14,14, df)
        List(nil, nil, 8, df)
        local dTitle = Library:CreateLabel({
            AutomaticSize=Enum.AutomaticSize.Y; Size=UDim2.new(1,0,0,18);
            TextSize=15; Text=info.Title or ""; RichText=true;
            TextXAlignment=Enum.TextXAlignment.Left; ZIndex=502; Parent=df
        })
        dTitle.Font = Enum.Font.GothamBold
        dTitle.TextColor3 = Library.AccentFontColor
        Library:AddToRegistry(dTitle, { TextColor3 = "AccentFontColor" })
        Library:CreateLabel({
            AutomaticSize=Enum.AutomaticSize.Y; Size=UDim2.new(1,0,0,14);
            TextSize=13; Text=info.Description or "";
            TextWrapped=true; RichText=true;
            TextXAlignment=Enum.TextXAlignment.Left; ZIndex=502; Parent=df
        })
        local footer = Library:Create("Frame", {
            BackgroundTransparency=1; Size=UDim2.new(1,0,0,26);
            AutomaticSize=Enum.AutomaticSize.Y; ZIndex=502; Parent=df
        })
        Library:Create("UIListLayout", {
            Padding=UDim.new(0,6); FillDirection=Enum.FillDirection.Horizontal;
            HorizontalAlignment=Enum.HorizontalAlignment.Right;
            SortOrder=Enum.SortOrder.LayoutOrder; Parent=footer
        })
        function Dialog:AddFooterButton(cfg)
            cfg = cfg or {}
            local bg = cfg.Primary     and Library.AccentColor
                    or cfg.Destructive and Library.ErrorColor
                    or Library.SecondaryColor
            local tc = (cfg.Primary or cfg.Destructive) and Color3.new(0,0,0) or Library.FontColor
            local tw2 = Library:GetTextBounds(cfg.Text or "OK", Library.Font, 13) + 20
            local fb  = Library:Create("TextButton", {
                AutoButtonColor=false; BackgroundColor3=bg; BorderSizePixel=0;
                Font=Library.Font; TextSize=13; Text=cfg.Text or "OK"; TextColor3=tc;
                Size=UDim2.fromOffset(math.max(60,tw2),24); ZIndex=503; Parent=footer
            })
            Corner(4, fb)
            fb.MouseButton1Click:Connect(function()
                Library:SafeCallback(cfg.Func or cfg.Callback)
                overlay:Destroy()
            end)
            return fb
        end
        overlay.MouseButton1Click:Connect(function() overlay:Destroy() end)
        local sc = Library:Create("UIScale", { Scale=0.9; Parent=df })
        Tw(sc, TW_FAST, { Scale=1 })
        return Dialog
    end
    if autoShow then
        Tw(outer, TW_BACK, { Size = UDim2.fromOffset(W, H) })
    end
    return Window
end
getgenv_().UILibrary  = Library
getgenv_().Toggles    = Toggles
getgenv_().Options    = Options
return Library
