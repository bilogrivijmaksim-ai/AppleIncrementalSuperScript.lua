--[[
[SWILL] Apple Incremental Super Script
Author: SWILL
Lines: ~2000
Description: Full-featured super exploit script for Apple Incremental
Features:
- Auto Collect Apples (normal & rare)
- Auto Buy Upgrades
- Auto Sell Apples
- Auto Click / Multi Click / Critical Clicks
- Teleport to Apples / Rare Apples / Missions
- Auto Missions / Quests
- Multi-tab GUI with 10 tabs
- Stats / Logs
- GUI Customization
- Settings for all features
- Debug / Extra functions
]]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- VARIABLES
local AutoCollect = false
local AutoBuy = false
local AutoSell = false
local AutoClick = false
local MultiClick = false
local TeleportToApples = false
local TeleportToRare = false
local AutoMissions = false
local DebugMode = false

local CollectedApples = 0
local BoughtUpgrades = 0
local SoldApples = 0
local ClicksDone = 0

-- GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AppleIncrementalSuperGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- CLOSE BUTTON
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- TAB BUTTONS
local Tabs = {}
local function CreateTab(name, position)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = position
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = MainFrame
    return btn
end

Tabs["Functions"] = CreateTab("Functions", UDim2.new(0, 10, 0, 40))
Tabs["Click"] = CreateTab("Click", UDim2.new(0, 120, 0, 40))
Tabs["Teleport"] = CreateTab("Teleport", UDim2.new(0, 230, 0, 40))
Tabs["Missions"] = CreateTab("Missions", UDim2.new(0, 340, 0, 40))
Tabs["Stats"] = CreateTab("Stats", UDim2.new(0, 10, 0, 450))
Tabs["Settings"] = CreateTab("Settings", UDim2.new(0, 120, 0, 450))
Tabs["Debug"] = CreateTab("Debug", UDim2.new(0, 230, 0, 450))
Tabs["Misc"] = CreateTab("Misc", UDim2.new(0, 340, 0, 450))
Tabs["AutoFarm"] = CreateTab("AutoFarm", UDim2.new(0, 10, 0, 480))
Tabs["Extra"] = CreateTab("Extra", UDim2.new(0, 120, 0, 480))

-- FRAMES
local Frames = {}
local function CreateFrame(name)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 430, 0, 350)
    f.Position = UDim2.new(0, 10, 0, 80)
    f.BackgroundColor3 = Color3.fromRGB(45,45,45)
    f.Visible = false
    f.Parent = MainFrame
    return f
end

for k,v in pairs(Tabs) do
    Frames[k] = CreateFrame(k)
end

-- TAB SWITCH LOGIC
for tabName, btn in pairs(Tabs) do
    btn.MouseButton1Click:Connect(function()
        for k,f in pairs(Frames) do f.Visible = false end
        if Frames[tabName] then
            Frames[tabName].Visible = true
        end
    end)
end

-- FUNCTION TO CREATE TOGGLE BUTTONS
local function CreateToggleButton(frame, name, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = position
    btn.Text = name..": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        local state = callback()
        btn.Text = name..(state and ": ON" or ": OFF")
    end)
end

-- FUNCTIONS TAB BUTTONS
CreateToggleButton(Frames["Functions"], "Auto Collect", UDim2.new(0,10,0,10), function()
    AutoCollect = not AutoCollect
    return AutoCollect
end)
CreateToggleButton(Frames["Functions"], "Auto Buy", UDim2.new(0,10,0,60), function()
    AutoBuy = not AutoBuy
    return AutoBuy
end)
CreateToggleButton(Frames["Functions"], "Auto Sell", UDim2.new(0,10,0,110), function()
    AutoSell = not AutoSell
    return AutoSell
end)

-- CLICK TAB BUTTONS
CreateToggleButton(Frames["Click"], "Auto Click", UDim2.new(0,10,0,10), function()
    AutoClick = not AutoClick
    return AutoClick
end)
CreateToggleButton(Frames["Click"], "Multi Click", UDim2.new(0,10,0,60), function()
    MultiClick = not MultiClick
    return MultiClick
end)

-- TELEPORT TAB BUTTONS
CreateToggleButton(Frames["Teleport"], "Teleport Apples", UDim2.new(0,10,0,10), function()
    TeleportToApples = not TeleportToApples
    return TeleportToApples
end)
CreateToggleButton(Frames["Teleport"], "Teleport Rare", UDim2.new(0,10,0,60), function()
    TeleportToRare = not TeleportToRare
    return TeleportToRare
end)

-- MISSIONS TAB BUTTONS
CreateToggleButton(Frames["Missions"], "Auto Missions", UDim2.new(0,10,0,10), function()
    AutoMissions = not AutoMissions
    return AutoMissions
end)

-- STATS LABELS
local StatsLabels = {}
local function CreateStatLabel(frame, name, position)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200, 0, 30)
    lbl.Position = position
    lbl.Text = name..": 0"
    lbl.BackgroundColor3 = Color3.fromRGB(60,60,60)
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Parent = frame
    return lbl
end

StatsLabels["CollectedApples"] = CreateStatLabel(Frames["Stats"], "Collected Apples", UDim2.new(0,10,0,10))
StatsLabels["BoughtUpgrades"] = CreateStatLabel(Frames["Stats"], "Bought Upgrades", UDim2.new(0,10,0,50))
StatsLabels["SoldApples"] = CreateStatLabel(Frames["Stats"], "Sold Apples", UDim2.new(0,10,0,90))
StatsLabels["ClicksDone"] = CreateStatLabel(Frames["Stats"], "Clicks Done", UDim2.new(0,10,0,130))

-- FUNCTIONS IMPLEMENTATION
local function CollectApples()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Apple" and obj:IsA("Part") then
            player.Character.HumanoidRootPart.CFrame = obj.C
