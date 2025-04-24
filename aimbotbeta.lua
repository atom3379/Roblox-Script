local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ตัวแปรจับเวลาจ้อง
local lookingAtPlayer = nil
local lookStartTime = 0
local lockEndTime = 0
local isLookingLocked = false

-- เช็กว่ากำลังมองผู้เล่นคนไหนอยู่
local function getLookedAtPlayer()
	local origin = camera.CFrame.Position
	local direction = camera.CFrame.LookVector * 100 -- ยิง ray ไปข้างหน้า

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = {localPlayer.Character}

	local rayResult = workspace:Raycast(origin, direction, raycastParams)

	if rayResult and rayResult.Instance then
		local hitPart = rayResult.Instance
		local char = hitPart:FindFirstAncestorOfClass("Model")
		if char and Players:GetPlayerFromCharacter(char) then
			return Players:GetPlayerFromCharacter(char)
		end
	end

	return nil
end

-- หันตัวละครไปยังตำแหน่ง
local function rotateToLookAt(targetPosition)
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	local hrp = character.HumanoidRootPart
	local direction = (targetPosition - hrp.Position).Unit
	local lookRotation = CFrame.new(hrp.Position, hrp.Position + direction)
	hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, lookRotation.Y - hrp.Orientation.Y, 0)
end

-- loop ตรวจสอบ
RunService.RenderStepped:Connect(function(deltaTime)
	local character = localPlayer.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then return end

	-- ถ้าล็อกทิศทางอยู่ ก็ไม่ต้องทำอะไร
	if isLookingLocked then
		if tick() > lockEndTime then
			isLookingLocked = false
		end
		return
	end

	local targetPlayer = getLookedAtPlayer()
	if targetPlayer and targetPlayer ~= localPlayer then
		if lookingAtPlayer == targetPlayer then
			-- จ้องคนเดิม
			if tick() - lookStartTime >= 3 then
				-- หันไปหาหลังจากจ้องเกิน 3 วินาที
				local targetChar = targetPlayer.Character
				if targetChar and targetChar:FindFirstChild("Head") then
					local targetPos = targetChar.Head.Position
					rotateToLookAt(targetPos)
					isLookingLocked = true
					lockEndTime = tick() + 5
				end
				-- reset ตัวจับเวลา
				lookingAtPlayer = nil
				lookStartTime = 0
			end
		else
			-- เปลี่ยนคนที่จ้องใหม่
			lookingAtPlayer = targetPlayer
			lookStartTime = tick()
		end
	else
		-- ไม่ได้มองใครเลย
		lookingAtPlayer = nil
		lookStartTime = 0
	end
end)
