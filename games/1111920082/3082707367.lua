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

-- LOCAL VARIABLES HERE
local ROWizardValues = {
    ["ModWandToggle"] = false,
    ["ModWandSpoofs"] = {}
}

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Spells = require(Modules:WaitForChild("Spells"))
local Remote = Modules:WaitForChild("Network"):WaitForChild("RemoteEvent")

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

local oldnindspells;
local oldindspells;
oldnindspells = hookmetamethod(Spells.Spells,"__newindex",function(self,...)
    local args = {...}

    if not checkcaller() and ROWizardValues["ModWandToggle"] then
        ROWizardValues["ModWandSpoofs"][args[1]] = args[2]
        return
    end

    return oldnindspells(self,...)
end)
oldindspells = hookmetamethod(Spells.Spells,"__index",function(self,...)
    local args = {...}

    if not checkcaller() and ROWizardValues["ModWandToggle"] then
        if ROWizardValues["ModWandSpoofs"][args[1]] then
            return ROWizardValues["ModWandSpoofs"][args[1]]
        end
    end

    return oldindspells(self,...)
end)

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

Toggles.ModWand:OnChanged(function(value)
    if value then
        for i,v in pairs(Spells.Spells) do
			v.MaxCharges = 10000
			v.Charges = 10000
			v.Range = 10000
			v.Safe = true
			v.ChargeCooldown = 0.01
			v.Cooldown = 0
		end
    end
    ROWizardValues["ModWandToggle"] = value
end)
