local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- ฟังก์ชันสร้างชื่อและ highlight
local function highlightPlayer(character)
	if not character then return end
	
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- สร้าง Highlight ถ้ายังไม่มี
	if not character:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.FillColor = Color3.fromRGB(255, 255, 0)
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0
		highlight.FillTransparency = 0.5
		highlight.Adornee = character
		highlight.Parent = character
	end

	-- สร้าง BillboardGui ชื่อและเลือด
	if not character:FindFirstChild("NameTag") then
		local head = character:FindFirstChild("Head")
		if head then
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "NameTag"
			billboard.Adornee = head
			billboard.Size = UDim2.new(0, 200, 0, 60)
			billboard.StudsOffset = Vector3.new(0, 2, 0)
			billboard.AlwaysOnTop = true
			billboard.Parent = character

			-- TextLabel สำหรับชื่อ
			local nameLabel = Instance.new("TextLabel")
			nameLabel.Name = "Username"
			nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
			nameLabel.Position = UDim2.new(0, 0, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Text = player.Name
			nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			nameLabel.TextStrokeTransparency = 0
			nameLabel.Font = Enum.Font.SourceSansBold
			nameLabel.TextScaled = true
			nameLabel.Parent = billboard

			-- TextLabel สำหรับเลือด
			local healthLabel = Instance.new("TextLabel")
			healthLabel.Name = "HealthText"
			healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
			healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
			healthLabel.BackgroundTransparency = 1
			healthLabel.Text = ""
			healthLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			healthLabel.TextStrokeTransparency = 0
			healthLabel.Font = Enum.Font.SourceSans
			healthLabel.TextScaled = true
			healthLabel.Parent = billboard

			-- อัปเดตเลือดทุก frame
			local humanoid = character:FindFirstChildWhichIsA("Humanoid")
			if humanoid then
				RunService.RenderStepped:Connect(function()
					if character.Parent and humanoid.Health > 0 then
						healthLabel.Text = string.format("%d / %d", humanoid.Health, humanoid.MaxHealth)
					end
				end)
			end
		end
	end
end

-- ฟังก์ชันเมื่อมีตัวละครใหม่
local function onCharacterAdded(character)
	highlightPlayer(character)
end

-- ตรวจสอบผู้เล่นที่มีอยู่แล้ว
for _, player in pairs(Players:GetPlayers()) do
	if player ~= localPlayer then
		if player.Character then
			highlightPlayer(player.Character)
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
