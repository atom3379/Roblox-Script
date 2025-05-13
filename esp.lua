local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- สร้าง Highlight และ BillboardGui สำหรับผู้เล่น
local function setupDisplay(character)
	if not character then return end
	local player = Players:GetPlayerFromCharacter(character)
	if not player or player == localPlayer then return end

	local head = character:WaitForChild("Head", 3)
	local root = character:WaitForChild("HumanoidRootPart", 3)
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")

	if not head or not root or not humanoid then return end

	-- สร้าง Highlight ถ้ายังไม่มี
	if not character:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.FillColor = Color3.fromRGB(255, 255, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.FillTransparency = 0.5
		highlight.OutlineTransparency = 0
		highlight.Adornee = character
		highlight.Parent = character
	end

	-- สร้าง BillboardGui ถ้ายังไม่มี
	if not character:FindFirstChild("NameTag") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "NameTag"
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, 200, 0, 70)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = character

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "Username"
		nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
		nameLabel.Position = UDim2.new(0, 0, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextStrokeTransparency = 0
		nameLabel.Font = Enum.Font.SourceSansBold
		nameLabel.TextScaled = true
		nameLabel.Text = player.Name
		nameLabel.Parent = billboard

		local healthLabel = Instance.new("TextLabel")
		healthLabel.Name = "HealthText"
		healthLabel.Size = UDim2.new(1, 0, 0.33, 0)
		healthLabel.Position = UDim2.new(0, 0, 0.33, 0)
		healthLabel.BackgroundTransparency = 1
		healthLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		healthLabel.TextStrokeTransparency = 0
		healthLabel.Font = Enum.Font.SourceSans
		healthLabel.TextScaled = true
		healthLabel.Text = ""
		healthLabel.Parent = billboard

		local distanceLabel = Instance.new("TextLabel")
		distanceLabel.Name = "DistanceText"
		distanceLabel.Size = UDim2.new(1, 0, 0.34, 0)
		distanceLabel.Position = UDim2.new(0, 0, 0.66, 0)
		distanceLabel.BackgroundTransparency = 1
		distanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
		distanceLabel.TextStrokeTransparency = 0
		distanceLabel.Font = Enum.Font.SourceSans
		distanceLabel.TextScaled = true
		distanceLabel.Text = ""
		distanceLabel.Parent = billboard

		-- อัปเดตเลือดและระยะ
		RunService.RenderStepped:Connect(function()
			if humanoid and humanoid.Parent and root and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
				healthLabel.Text = string.format("%d / %d", humanoid.Health, humanoid.MaxHealth)

				local dist = (root.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
				distanceLabel.Text = string.format("%.1f m", dist)
			end
		end)
	end
end

-- เมื่อ character spawn
local function onCharacterAdded(character)
	setupDisplay(character)
end

-- เชื่อมต่อผู้เล่นที่มีอยู่แล้ว
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= localPlayer then
		if player.Character then
			setupDisplay(player.Character)
		end
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end

-- เมื่อมีผู้เล่นใหม่
Players.PlayerAdded:Connect(function(player)
	if player ~= localPlayer then
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end)
