-- Ink Game Full Script (Delta X / Mobile)
-- Версия: Август 2025 | Автор: ChatGPT

if game.PlaceId ~= 7551121821 then
    return warn("Этот скрипт только для Ink Game!")
end

local lp = game.Players.LocalPlayer
local ws = game.Workspace
local rs = game:GetService("RunService")

-- 🛡️ Антибан и АнтиPush
pcall(function()
    for _, v in pairs(getconnections(game.DescendantAdded)) do v:Disable() end
    for _, v in pairs(getconnections(game.DescendantRemoving)) do v:Disable() end
end)

lp.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    hrp.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
end)

-- 🧠 ESP Игроков и охраны
local function createESP(plr, color)
    repeat wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP"
    box.Adornee = plr.Character
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(2, 5, 2)
    box.Color3 = color
    box.Transparency = 0.5
    box.Parent = plr.Character
end

for _, p in pairs(game.Players:GetPlayers()) do
    if p ~= lp then
        createESP(p, p.Team and p.Team.Name == "Guards" and Color3.new(1, 0, 0) or Color3.new(0, 1, 0))
    end
end

game.Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        createESP(p, p.Team and p.Team.Name == "Guards" and Color3.new(1, 0, 0) or Color3.new(0, 1, 0))
    end)
end)

-- 📋 Меню создания
local function createButton(text, pos, callback)
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = text .. "_Menu"
    local btn = Instance.new("TextButton", gui)
    btn.Text = text
    btn.Size = UDim2.new(0, 170, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
end

-- 🟥 Red Light Green Light
local function rlglWin()
    local goal = ws:FindFirstChild("Goal")
    if goal then
        lp.Character:PivotTo(goal.CFrame + Vector3.new(0, 5, 0))
    end
end

local function godMode()
    while true do
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.Health = lp.Character.Humanoid.MaxHealth
        end
        wait(0.3)
    end
end

local function saveOthers()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= lp and plr.Character then
            plr.Character:PivotTo(ws:FindFirstChild("Goal").CFrame + Vector3.new(0, 5, 0))
        end
    end
end

-- 🍪 Dalgona
local function dalgonaWin()
    for _, f in pairs(getgc(true)) do
        if type(f) == "function" and getinfo(f).name == "Fail" then
            pcall(function() debug.setupvalue(f, 1, true) end)
        end
    end
end

-- 🕵️ Hide & Seek
local function infiniteStamina()
    while true do
        local char = lp.Character
        if char and char:FindFirstChild("Stamina") then
            char.Stamina.Value = 100
        end
        wait(0.1)
    end
end

local function keyAndExitESP()
    for _, obj in pairs(ws:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:lower():find("key") or obj.Name:lower():find("exit")) then
            local esp = Instance.new("BillboardGui", obj)
            esp.Size = UDim2.new(0, 100, 0, 40)
            esp.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", esp)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = obj.Name
            lbl.TextColor3 = Color3.new(1, 1, 0)
            lbl.TextScaled = true
        end
    end
end

local function tpToHiders()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= lp and p.Team.Name == "Hiders" and p.Character then
            lp.Character:PivotTo(p.Character:GetPivot() + Vector3.new(0, 3, 0))
            break
        end
    end
end

-- 💪 Tug of War
local function tugAuto()
    while true do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
        wait(0.1)
    end
end

-- 🪀 Jump Rope
local function jumpPerfect()
    while true do
        if lp.Character then
            lp.Character:FindFirstChild("Humanoid").Jump = true
        end
        wait(1.2)
    end
end

local function jumpWin()
    local finish = ws:FindFirstChild("Finish")
    if finish then
        lp.Character:PivotTo(finish.CFrame + Vector3.new(0, 5, 0))
    end
end

-- 🪟 Glass Bridge
local function glassBridge()
    for _, tile in pairs(ws:GetDescendants()) do
        if tile:IsA("Part") and tile.Name:lower():find("glass") then
            tile.Color = tile.Transparency > 0.3 and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
        end
    end
end

local function glassWin()
    local finish = ws:FindFirstChild("BridgeFinish")
    if finish then
        lp.Character:PivotTo(finish.CFrame + Vector3.new(0, 5, 0))
    end
end

-- 🕹️ Кнопки Меню
createButton("🔴 RLGL Win", 20, rlglWin)
createButton("🛡 RLGL God", 60, godMode)
createButton("🚀 Спасти всех", 100, saveOthers)
createButton("🍪 Dalgona Win", 140, dalgonaWin)
createButton("🧍 Stamina ∞", 180, infiniteStamina)
createButton("🔑 Hide: ESP", 220, keyAndExitESP)
createButton("📍 TP к прячущимся", 260, tpToHiders)
createButton("💪 Tug: Auto E", 300, tugAuto)
createButton("🪀 Jump: Прыжок", 340, jumpPerfect)
createButton("🏁 Jump: Win", 380, jumpWin)
createButton("🪟 Стекло: Показ", 420, glassBridge)
createButton("🚪 Стекло: Win", 460, glassWin)
