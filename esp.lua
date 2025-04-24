local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- ฟังก์ชันสร้าง Highlight และ NameTag
local function addHighlightAndNameTag(character)
	if not character then return end
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end

	-- สร้าง Highlight ถ้ายังไม่มี
	if not character:FindFirstChild("Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "Highlight"
		highlight.FillColor = Color3.fromRGB(255, 255, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0
		highlight.Adornee = character
		highlight.Parent = character
	end

	-- สร้าง NameTag ถ้ายังไม่มี
	if not character:FindFirstChild("NameTag") then
		local head = character:FindFirstChild("Head")
		if head then
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "NameTag"
			billboard.Adornee = head
			billboard.Size = UDim2.new(0, 100, 0, 25)
			billboard.StudsOffset = Vector3.new(0, 2, 0)
			billboard.AlwaysOnTop = true
			billboard.Parent = character

			local textLabel = Instance.new("TextLabel")
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = player.DisplayName
			textLabel.TextColor3 = Color3.new(1, 1, 1)
			textLabel.TextStrokeTransparency = 0
			textLabel.Font = Enum.Font.SourceSansBold
			textLabel.TextScaled = false
			textLabel.TextSize = 14 -- ขนาดพอดี ไม่ใหญ่เกิน
			textLabel.Parent = billboard
		end
	end
end

-- ฟังก์ชันเมื่อมีตัวละคร
local function onCharacterAdded(character)
	addHighlightAndNameTag(character)
end

-- ทำกับผู้เล่นทุกคน (ยกเว้นตัวเรา)
for _, player in pairs(Players:GetPlayers()) do
	if player ~= localPlayer then
		if player.Character then
			addHighlightAndNameTag(player.Character)
		end
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end

-- เฝ้ารอผู้เล่นใหม่เข้าเกม
Players.PlayerAdded:Connect(function(player)
	if player ~= localPlayer then
		player.CharacterAdded:Connect(onCharacterAdded)
	end
end)
