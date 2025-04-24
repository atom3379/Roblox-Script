-- WARNING DON'T USE 'loadstring' TO LOAD THIS BECAUSE YOU NEED TO REPLACE 'rbxassetid://1234567890' WITH YOUR SOUND ID
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- สร้าง RemoteEvent ใน ReplicatedStorage สำหรับส่งคำสั่งจาก Client ไป Server
local remote = Instance.new("RemoteEvent")
remote.Name = "PlaySongEvent"
remote.Parent = ReplicatedStorage

-- ฟังก์ชันเล่นเพลง
local function playSongForAllPlayers(songID)
    -- สร้าง Sound Object
    local sound = Instance.new("Sound")
    sound.SoundId = songID
    sound.Volume = 0.5  -- ตั้งค่าเสียง (สามารถปรับได้)
    sound.Looped = true  -- ทำให้เพลงเล่นซ้ำ
    sound.Parent = workspace  -- หรือสามารถเปลี่ยนเป็นส่วนอื่นๆ ที่ต้องการให้เพลงดัง

    -- เล่นเพลง
    sound:Play()

    -- ส่งเพลงให้ผู้เล่นทุกคน
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            -- ให้ Sound ดังจากตำแหน่งของ HumanoidRootPart ของตัวละครผู้เล่น
            local soundClone = sound:Clone()
            soundClone.Parent = player.Character.HumanoidRootPart
            soundClone:Play()
        end
    end
end

-- กำหนด ID เพลงที่ต้องการเล่นที่นี่
local songID = "rbxassetid://1234567890"  -- เปลี่ยนเป็น ID ของเพลงที่ต้องการ

-- เล่นเพลงให้ทุกคน
playSongForAllPlayers(songID)
