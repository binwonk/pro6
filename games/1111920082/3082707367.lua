local StartTime = os.clock()

local ScriptVersion = 1

local game = game
local wait = task.wait

repeat wait() until game:IsLoaded()


-- SERVICES HERE
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- LOCAL VARIABLES HERE
local Player = Players.LocalPlayer
local Modules = ReplicatedStorage.Modules
local Remote = Modules:FindFirstChild("Network"):FindFirstChild("RemoteEvent")

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

--GAME SCRIPT HERE
local Combat = Tabs.Game:AddLeftGroupbox("Combat")

Combat:AddInput("KillPlayer",{
    Numeric = false,
    Finished = true,
    Text = "Kill Player",
    Tooltip = "Kills a player!",
    Placeholder = "Player name here!"
})

Options.KillPlayer:OnChanged(function(value)
    local KillPlayer = ChaosFunctions.stringToPlayer(value)
    print(KillPlayer.Name)
    if KillPlayer.Character and KillPlayer:FindFirstChild("HumanoidRootPart") then
        for i = 1,6 do
        local args = {[1] = "HandleDamage",[2] = {Character = KillPlayer.Character,Hit = KillPlayer.Character:FindFirstChild("HumanoidRootPart"),Type = "Normal",Norm = Vector3.new(0,0,0),Pos = Vector3.new(0,0,0),SpellName = "stupefy"}}
        Remote:FireServer(unpack(args))
        end
    end
end)
