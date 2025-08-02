-- Ink Game ESP + Safe Boost + Teleport Script

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Anti‑AFK
local vu = game:GetService("VirtualUser")
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- Safe WalkSpeed / JumpPower Ramp
local function ramp(prop, toVal, step, waitT)
    local cur = hum[prop]
    for i = cur, toVal, step do
        hum[prop] = i
        wait(waitT)
    end
end
ramp("WalkSpeed", 30, 1, 0.1)
ramp("JumpPower", 80, 1, 0.1)

-- Safe teleport via Lerp
local function safeTP(pos)
    local steps = 20
    local start = root.Position
    for i = 1, steps do
        local p = start:Lerp(pos + Vector3.new(0,5,0), i/steps)
        root.CFrame = CFrame.new(p)
        wait(0.05)
    end
end

-- ESP on players
for _, other in pairs(game.Players:GetPlayers()) do
    if other ~= plr and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
        local h = Instance.new("Highlight")
        h.Name = "PlayerESP"
        h.Adornee = other.Character
        h.FillColor = Color3.fromRGB(255, 50, 50)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 1
        h.Parent = other.Character
    end
end

-- ESP on guards (guards, security, enforcer NPCs)
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Model") then
        local lname = obj.Name:lower()
        if lname:find("guard") or lname:find("security") or lname:find("enforcer") then
            if not obj:FindFirstChild("Highlight") then
                local h = Instance.new("Highlight")
                h.Name = "GuardESP"
                h.Adornee = obj
                h.FillColor = Color3.fromRGB(0, 100, 255)
                h.FillTransparency = 0.25
                h.OutlineColor = Color3.new(1, 1, 1)
                h.OutlineTransparency = 0
                h.Parent = obj
            end
        end
    end
end

-- Auto-teleport to finish/exit
local finish = workspace:FindFirstChild("Finish") or workspace:FindFirstChild("Exit")
if finish and finish:IsA("BasePart") then
    safeTP(finish.Position)
else
    warn("⚠️ Finish/Exit not found.")
end
