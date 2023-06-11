local StartTime = os.clock()

local ScriptVersion = 1

local game = game
local wait = task.wait

repeat
	wait()
until game:IsLoaded()


-- SERVICES HERE
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- LOCAL VARIABLES HERE
local ROWizardValues = {
    ["ModWandToggle"] = false
}

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Spells = require(Modules:WaitForChild("Spell"))
local Remote = Modules:WaitForChild("Network"):WaitForChild("RemoteEvent")

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

--GAME SCRIPT HERE
local Combat = Tabs.Game:AddLeftGroupbox("Combat")

Combat:AddInput("KillPlayer", {
	Numeric = false,
	Finished = true,
	Text = "Kill Player",
	Tooltip = "Kills a player!",
	Placeholder = "Player name here!"
})

Options.KillPlayer:OnChanged(function(value)
    if tostring(value) == "" then
        return
    end
	local KillPlayer = ChaosFunctions.stringToPlayer(value)
	if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") then
		for i = 1, 6 do
			local args = {
				[1] = "HandleDamage",
				[2] = {
					["Character"] = KillPlayer.Character,
					["Hit"] = KillPlayer.Character.Head,
					["Type"] = "Normal",
					["Norm"] = Vector3.new(0.7755845785140991, 0.035323500633239746, -0.6302545070648193),
					["Pos"] = Vector3.new(-731.4620971679688, -108.57284545898438, -495.60650634765625),
					["SpellName"] = "stupefy"
				}
			}
			Remote:FireServer(unpack(args))
		end
	end
end)

Combat:AddToggle("ModWand", {
    Text = "Mod Wand",
    Default = false
})

local ModWandConnection = nil;
local ModWandTable = {}

Toggles.ModWand:OnChanged(function(value)
    if value then
        ModWandTable = {}
        for i,v in next,Spells.Spells do
			ModWandTable[v] = {}
            for x,d in next,v do
                ModWandTable[v][x] = d
            end
		end
        for i,v in next,Spells.Spells do
			v.MaxCharges = 10000
			v.Charges = 10000
			v.Range = 10000
			v.Safe = true
			v.ChargeCooldown = 0.01
			v.Cooldown = 0
		end
        ModWandConnection = RunService.Stepped:Connect(function()
            for i,v in next,Spells.Spells do
				if v.MaxCharges < 100 then
					v.MaxCharges = 10000
				end
				if v.Charges < 100 then
					v.Charges = 10000
				end
				if v.Safe == false then
					v.Safe = true
				end
				if v.Cooldown > 0 then
					v.Cooldown = 0
				end
				if v.ChargeCooldown > 0.02 then
					v.ChargeCooldown = 0.01
				end
			end
        end)
    else
        if typeof(ModWandConnection) == "RBXScriptConnection" then
            ModWandConnection:Disconnect()
            for i,v in next,ModWandTable do
				Spells.Spells[i] = v
                for x,d in next,v do
                    Spells.Spells[i][x] = d
                end
            end
        end
    end
end)
