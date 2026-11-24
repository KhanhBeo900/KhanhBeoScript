-- ============================================
-- APPLE HUB 🍎 - CTD VISUAL SPOOFER (SAFE)
-- Cre By Khanh Beo (Dựa trên logic của Duc)
-- ============================================

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local isVietnamese = true
local Themes = {
    AppleRed = Color3.fromRGB(230, 40, 50),
    Cyberpunk = Color3.fromRGB(0, 255, 200),
    Ocean = Color3.fromRGB(0, 150, 255),
    Toxic = Color3.fromRGB(150, 255, 0),
    Purple = Color3.fromRGB(180, 0, 255)
}
local CurrentTheme = Themes.AppleRed

local Locales = {
    VN = {
        Title = "Apple Hub 🍎 (Spoofer)", TabUnit = "Unit", TabCurrency = "Tiền Tệ", TabTrade = "Trade (Ảo)", TabMisc = "Cài Đặt",
        LangBtn = "Ngôn Ngữ: Tiếng Việt", ThemeBtn = "Đổi Màu UI", Unload = "Tắt Script", Panic = "PANIC MODE",
        Scan = "Quét Unit", Add = "Thêm Unit (Ảo)", Restore = "Khôi Phục Túi Đồ", RemoveAll = "Xóa Hết Unit Ảo",
        SetCoins = "Đặt Coins (Ảo)", SetGems = "Đặt Gems (Ảo)", EnableCur = "Bật Hiển Thị Ảo"
    },
    EN = {
        Title = "Apple Hub 🍎 (Spoofer)", TabUnit = "Unit", TabCurrency = "Currency", TabTrade = "Trade (Fake)", TabMisc = "Settings",
        LangBtn = "Language: English", ThemeBtn = "Change UI Theme", Unload = "Unload Script", Panic = "PANIC MODE",
        Scan = "Scan Units", Add = "Add Unit (Fake)", Restore = "Restore Inventory", RemoveAll = "Remove All Fake Units",
        SetCoins = "Set Coins (Fake)", SetGems = "Set Gems (Fake)", EnableCur = "Enable Fake Display"
    }
}

local Units, Names, AddedUnits, AddedSlots, SlotOriginals = {}, {}, {}, {}, {}
local Selected, SearchQuery = nil, ""
local MoneyLabel, GemsLabel, InfoFrame
local RarityGradients = RS:FindFirstChild("Assets") and RS.Assets:FindFirstChild("RaritiesGradients")
local Library, Tabs, UI_Elements = {}, {}, {}

-- ============================================
-- UI KHỞI TẠO (APPLE HUB)
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AppleHubSpoofer"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45); ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15,15,15); ToggleBtn.Text = "🍎"; ToggleBtn.TextSize = 22; ToggleBtn.Visible = false
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)
local TS = Instance.new("UIStroke", ToggleBtn); TS.Thickness = 3; TS.Color = Color3.new(1,1,1)

local function MakeRainbow(stroke)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 127, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(148, 0, 211))
    })
    gradient.Parent = stroke
    task.spawn(function()
        while stroke.Parent do
            TweenService:Create(gradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Rotation = gradient.Rotation + 180}):Play()
            task.wait(1.5)
        end
    end)
end
MakeRainbow(TS)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 380)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(12,12,12); MainFrame.Active = true; MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MS = Instance.new("UIStroke", MainFrame); MS.Thickness = 3; MS.Color = Color3.new(1,1,1)
MakeRainbow(MS)

local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40); Header.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1; Title.Text = Locales.VN.Title; Title.TextColor3 = CurrentTheme; Title.Font = Enum.Font.GothamBlack; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left
table.insert(UI_Elements, {Type = "Title", Obj = Title})

local MinBtn = Instance.new("TextButton", Header)
MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, -35, 0.5, -12.5)
MinBtn.BackgroundColor3 = CurrentTheme; MinBtn.Text = "−"; MinBtn.TextColor3 = Color3.fromRGB(255,255,255); MinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 6)
table.insert(UI_Elements, {Type = "ThemeBtn", Obj = MinBtn})

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 35); TabBar.Position = UDim2.new(0, 0, 0, 40); TabBar.BackgroundColor3 = Color3.fromRGB(12,12,12)

local TabScroll = Instance.new("ScrollingFrame", TabBar)
TabScroll.Size = UDim2.new(1, 0, 1, 0); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0); TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
local TabList = Instance.new("UIListLayout", TabScroll); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.Padding = UDim.new(0, 8)
Instance.new("UIPadding", TabScroll).PaddingLeft = UDim.new(0, 10); Instance.new("UIPadding", TabScroll).PaddingTop = UDim.new(0, 6)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -90); ContentFrame.Position = UDim2.new(0, 10, 0, 80); ContentFrame.BackgroundTransparency = 1

local CreditLabel = Instance.new("TextLabel", MainFrame)
CreditLabel.Size = UDim2.new(1, 0, 0, 20); CreditLabel.Position = UDim2.new(0, 0, 1, -20)
CreditLabel.BackgroundTransparency = 1; CreditLabel.Text = "Cre By Khanh Beo (Logic: Duc)"; CreditLabel.TextColor3 = Color3.fromRGB(100,100,100); CreditLabel.Font = Enum.Font.GothamBold; CreditLabel.TextSize = 10

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; ToggleBtn.Visible = true end)
ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; ToggleBtn.Visible = false end)

local CurrentTab = nil
function Library:AddTab(nameKey)
    local TabBtn = Instance.new("TextButton", TabScroll)
    TabBtn.Size = UDim2.new(0, 100, 0, 24); TabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35); TabBtn.Text = Locales[isVietnamese and "VN" or "EN"][nameKey]; TabBtn.TextColor3 = Color3.fromRGB(150,150,150); TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    local TabContent = Instance.new("ScrollingFrame", ContentFrame)
    TabContent.Size = UDim2.new(1, 0, 1, 0); TabContent.BackgroundTransparency = 1; TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 3; TabContent.ScrollBarImageColor3 = CurrentTheme
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0); TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y; TabContent.Visible = false
    local layout = Instance.new("UIListLayout", TabContent); layout.Padding = UDim.new(0, 8); layout.SortOrder = Enum.SortOrder.LayoutOrder
    table.insert(Tabs, {Button = TabBtn, Content = TabContent, NameKey = nameKey})
    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in ipairs(Tabs) do tab.Content.Visible = false; TweenService:Create(tab.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35,35,35), TextColor3 = Color3.fromRGB(150,150,150)}):Play() end
        TabContent.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        CurrentTab = TabContent
    end)
    if not CurrentTab then
        TabContent.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        CurrentTab = TabContent
    end
    return TabContent
end

function Library:AddButton(parent, textStr, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 35); btn.BackgroundColor3 = CurrentTheme; btn.Text = textStr; btn.TextColor3 = Color3.fromRGB(255,255,255); btn.Font = Enum.Font.GothamBold; btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    parent.Size = UDim2.new(1, 0, 0, parent.Size.Y.Offset + 41)
    table.insert(UI_Elements, {Type = "ThemeBtn", Obj = btn})
    return btn
end

function Library:AddInput(parent, placeholder, callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1, 0, 0, 35); box.BackgroundColor3 = Color3.fromRGB(45,45,45); box.TextColor3 = Color3.fromRGB(255,255,255); box.PlaceholderText = placeholder; box.Font = Enum.Font.Gotham; box.TextSize = 12
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    box.FocusLost:Connect(function() callback(box.Text) end)
    parent.Size = UDim2.new(1, 0, 0, parent.Size.Y.Offset + 41)
end

-- ============================================
-- LOGIC GỐC TỪ SCRIPT CỦA DUC (GIỮ NGUYÊN)
-- ============================================
local function FindPath(root, path)
    local current = root
    for _, name in ipairs(path) do
        current = current and current:FindFirstChild(name)
        if not current then return nil end
    end
    return current
end

local function ApplyRarityBackground(clone, rarity)
    if not RarityGradients then return end
    rarity = tostring(rarity or "Basic")
    local gradient = RarityGradients:FindFirstChild(rarity) or RarityGradients.Others:FindFirstChild(rarity) or RarityGradients:FindFirstChild("Basic")
    if not gradient then return end
    local troop = clone:FindFirstChild("TroopsFrame", true)
    local background = troop and troop:FindFirstChild("Background", true)
    if not background then return end
    for _, child in ipairs(background:GetChildren()) do if child:IsA("UIGradient") then child:Destroy() end end
    gradient:Clone().Parent = background
end

local function GetInventory() return FindPath(PlayerGui, {"Main", "Main", "Inventory", "InventoryFrame", "List", "ScrollingFrame"}) end
local function GetInventoryFrame() return FindPath(PlayerGui, {"Main", "Main", "Inventory", "InventoryFrame"}) end
local function GetSlotFrame(number) local slot = FindPath(PlayerGui, {"HUD", "Slots", "Slot" .. number}); return slot and slot:FindFirstChild("TroopFrame") end

local function Scan()
    table.clear(Units); table.clear(Names)
    local module = RS:FindFirstChild("ModuleLoader")
    module = module and module:FindFirstChild("Configs")
    module = module and module:FindFirstChild("Config")
    if not module then return false end
    local success, config = pcall(require, module)
    if success and config.Towers then
        for configName, data in pairs(config.Towers) do
            if type(configName) == "string" and type(data) == "table" and data.Upgrades then
                local infoData = table.clone(data); infoData.Name = configName
                Units[configName] = {Name = configName, ConfigName = configName, InfoData = infoData, Icon = tostring(data.Icon or ""), Rarity = tostring(data.Rarity or "Basic"), Upgrades = data.Upgrades}
                table.insert(Names, configName)
            end
        end
        table.sort(Names)
        return true
    end
    return false
end

local function CreateAddedUnitFrame(entry, scrolling)
    if entry.Frame and entry.Frame.Parent then return end
    local template = scrolling:FindFirstChild("TroopFrame")
    if not template then return end
    local clone = template:Clone()
    clone.Name = "Added_" .. entry.Id; clone.Visible = true; clone:SetAttribute("AddedUnit", true)
    local troop = clone:FindFirstChild("TroopsFrame", true)
    if troop then
        local icon = troop:FindFirstChild("TroopIcon", true); local price = troop:FindFirstChild("Price", true); local equipped = troop:FindFirstChild("Equipped", true)
        if icon then icon.Image = entry.Data.Icon end
        if price then price.Text = "$" .. tostring(entry.Data.Upgrades[1].Price or 0) end
        if equipped then equipped.Visible = entry.Equipped end
    end
    ApplyRarityBackground(clone, entry.Data.Rarity)
    clone.Parent = scrolling; entry.Frame = clone
end

local function RestoreInventory()
    local scrolling = GetInventory()
    if not scrolling then return end
    for _, entry in ipairs(AddedUnits) do
        if not entry.Frame or not entry.Frame.Parent then entry.Frame = nil; CreateAddedUnitFrame(entry, scrolling) end
    end
end

local function CreateAddedUnitEntry(data)
    local entry = {Id = "Unit_" .. math.random(1000, 9999), Data = data, InfoData = data.InfoData, Equipped = false, Frame = nil}
    table.insert(AddedUnits, entry)
    local scrolling = GetInventory()
    if scrolling then CreateAddedUnitFrame(entry, scrolling) end
    return entry
end

-- ============================================
-- UI TABS & CHỨC NĂNG
-- ============================================
local TabUnit = Library:AddTab("TabUnit")
local TabCur = Library:AddTab("TabCurrency")
local TabMisc = Library:AddTab("TabMisc")

-- TAB UNIT
local UnitDropdownBtn = Library:AddButton(TabUnit, "Chọn Unit Ngẫu Nhiên", function()
    if #Names == 0 then Scan() end
    if #Names > 0 then
        Selected = Names[math.random(1, #Names)]
        UnitDropdownBtn.Text = "Đang Chọn: " .. Selected
    end
end)
Library:AddInput(TabUnit, "Nhập tên Unit cần tìm...", function(text)
    SearchQuery = string.lower(text)
    if SearchQuery == "" then return end
    for _, name in ipairs(Names) do
        if string.find(string.lower(name), SearchQuery, 1, true) then Selected = name; UnitDropdownBtn.Text = "Đang Chọn: " .. Selected; break end
    end
end)
Library:AddButton(TabUnit, Locales.VN.Scan, function() Scan(); UnitDropdownBtn.Text = "Đã Quét " .. #Names .. " Units" end)
Library:AddButton(TabUnit, Locales.VN.Add, function()
    if Selected and Units[Selected] then
        CreateAddedUnitEntry(Units[Selected])
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Spoofer", Text="Đã thêm "..Selected.." (Ảo)"})
    end
end)
Library:AddButton(TabUnit, Locales.VN.Restore, function() RestoreInventory() end)
Library:AddButton(TabUnit, Locales.VN.RemoveAll, function()
    for _, entry in ipairs(AddedUnits) do if entry.Frame then entry.Frame:Destroy() end end
    table.clear(AddedUnits)
end)

-- TAB CURRENCY
local function FormatCurrency(number)
    local formatted = tostring(math.floor(number))
    while true do local result, count = formatted:gsub("^(-?%d+)(%d%d%d)", "%1,%2"); formatted = result; if count == 0 then break end end
    return formatted
end
local fakeCoins, fakeGems, curEnabled = 0, 0, false
MoneyLabel = FindPath(PlayerGui, {"HUD", "Currencies", "Money", "CurrencyFrame", "AmountLabel"})
GemsLabel = FindPath(PlayerGui, {"HUD", "Currencies", "Gems", "CurrencyFrame", "AmountLabel"})

Library:AddInput(TabCur, Locales.VN.SetCoins, function(val)
    fakeCoins = tonumber(val) or 0
    if curEnabled and MoneyLabel then MoneyLabel.Text = FormatCurrency(fakeCoins) end
end)
Library:AddInput(TabCur, Locales.VN.SetGems, function(val)
    fakeGems = tonumber(val) or 0
    if curEnabled and GemsLabel then GemsLabel.Text = FormatCurrency(fakeGems) end
end)
Library:AddButton(TabCur, Locales.VN.EnableCur, function()
    curEnabled = not curEnabled
    if curEnabled then
        if MoneyLabel then MoneyLabel.Text = FormatCurrency(fakeCoins) end
        if GemsLabel then GemsLabel.Text = FormatCurrency(fakeGems) end
    else
        if MoneyLabel then MoneyLabel.Text = "0" end
        if GemsLabel then GemsLabel.Text = "0" end
    end
end)

-- TAB MISC (Settings)
local GroupMisc = Instance.new("Frame", TabMisc)
GroupMisc.Size = UDim2.new(1, 0, 0, 35); GroupMisc.BackgroundColor3 = Color3.fromRGB(22,22,22)
Instance.new("UICorner", GroupMisc).CornerRadius = UDim.new(0, 8)
local titleLabel = Instance.new("TextLabel", GroupMisc); titleLabel.Size = UDim2.new(1, 0, 0, 25); titleLabel.Position = UDim2.new(0, 10, 0, 5); titleLabel.BackgroundTransparency = 1; titleLabel.Text = "Hệ Thống"; titleLabel.TextColor3 = CurrentTheme; titleLabel.Font = Enum.Font.GothamBold; titleLabel.TextSize = 13; titleLabel.TextXAlignment = Enum.TextXAlignment.Left
local layout = Instance.new("UIListLayout", GroupMisc); layout.Padding = UDim.new(0, 6)
local padding = Instance.new("UIPadding", GroupMisc); padding.PaddingBottom = UDim.new(0, 10); padding.PaddingLeft = UDim.new(0, 10); padding.PaddingRight = UDim.new(0, 10); padding.PaddingTop = UDim.new(0, 35)

local ThemeBtn = Library:AddButton(GroupMisc, Locales.VN.ThemeBtn, function()
    local ThemeList = {Themes.AppleRed, Themes.Cyberpunk, Themes.Ocean, Themes.Toxic, Themes.Purple}
    local CurrentIndex = 1
    for i, theme in ipairs(ThemeList) do if theme == CurrentTheme then CurrentIndex = i break end end
    CurrentTheme = ThemeList[(CurrentIndex % #ThemeList) + 1]
    for _, el in ipairs(UI_Elements) do
        if el.Type == "ThemeBtn" then TweenService:Create(el.Obj, TweenInfo.new(0.3), {BackgroundColor3 = CurrentTheme}):Play()
        end
    end
    Title.TextColor3 = CurrentTheme
end)
table.insert(UI_Elements, {Type = "ThemeBtn", Obj = ThemeBtn})

Library:AddButton(GroupMisc, Locales.VN.Panic, function()
    MainFrame.Visible = false; ToggleBtn.Visible = false
end)
Library:AddButton(GroupMisc, Locales.VN.Unload, function() ScreenGui:Destroy() end)

-- Loop theo dõi túi đồ
task.spawn(function()
    while ScreenGui.Parent do
        task.wait(0.5)
        pcall(function()
            local invFrame = GetInventoryFrame()
            if invFrame and invFrame.Visible then RestoreInventory() end
        end)
    end
end)

Scan()
game:GetService("StarterGui"):SetCore("SendNotification", {Title="Apple Spoofer", Text="Đã tải xong! Đây là đồ Ảo (FE).", Duration=3})
print("✅ Apple Hub Spoofer - Cre By Khanh Beo")