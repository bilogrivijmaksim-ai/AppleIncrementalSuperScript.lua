--[[
[SWILL] Delta Exploit Script for Apple Incremental
Features:
1. Auto Collect Apples
2. Auto Buy Upgrades
3. Auto Sell Apples
4. Multi-tab GUI
5. Other customizable functions
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaExploitGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.Parent = ScreenGui

-- Tab buttons
local tabs = {}
local functionsTab = Instance.new("Frame", MainFrame)
functionsTab.Size = UDim2.new(1,0,1,0)
functionsTab.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- Feature toggles
local autoCollect = false
local autoBuy = false

-- Auto Collect Apples
local function collectApples()
    for i, apple in pairs(workspace.Apples:GetChildren()) do
        if apple:IsA("Part") then
            player.Character.HumanoidRootPart.CFrame = apple.CFrame
            wait(0.1)
        end
    end
end

-- Auto Buy Upgrades
local function buyUpgrades()
    for i, upgrade in pairs(ReplicatedStorage.Upgrades:GetChildren()) do
        local success, err = pcall(function()
            game:GetService("ReplicatedStorage").Events.BuyUpgrade:FireServer(upgrade.Name)
        end)
    end
end

-- Run loops
RunService.RenderStepped:Connect(function()
    if autoCollect then collectApples() end
    if autoBuy then buyUpgrades() end
end)

-- GUI Buttons
local collectButton = Instance.new("TextButton")
collectButton.Size = UDim2.new(0, 180, 0, 40)
collectButton.Position = UDim2.new(0, 10, 0, 10)
collectButton.Text = "Toggle Auto Collect"
collectButton.Parent = functionsTab

collectButton.MouseButton1Click:Connect(function()
    autoCollect = not autoCollect
    collectButton.Text = autoCollect and "Auto Collect: ON" or "Auto Collect: OFF"
end)

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(0, 180, 0, 40)
buyButton.Position = UDim2.new(0, 10, 0, 60)
buyButton.Text = "Toggle Auto Buy"
buyButton.Parent = functionsTab

buyButton.MouseButton1Click:Connect(function()
    autoBuy = not autoBuy
    buyButton.Text = autoBuy and "Auto Buy: ON" or "Auto Buy: OFF"
end)

-- You can expand: Auto Sell, Multi Tabs, etc.
-- Example: add new frames and toggle visibility for multiple tabs.
