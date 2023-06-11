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
    ["ModWandToggle"] = false,
	["BringPlayerTimeValue"] = 6
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
			BinsploitNotify("Toggle currently work in progress!","Try again soon.",3)
            --[[for i,v in next,ModWandTable do
				Spells.Spells[i] = v
                for x,d in next,v do
                    Spells.Spells[i][x] = d
                end
            ]]--
        end
    end
end)

local Autofarming = Tabs.Game:AddLeftGroupbox("Autofarms")

local Misc = Tabs.Game:AddRightGroupbox("Misc")

Misc:AddInput("BringPlayer", {
	Numeric = false,
	Finished = true,
	Text = "Bring Player",
	Tooltip = "Brings a player!",
	Placeholder = "Player name here!"
})

Options.BringPlayer:OnChanged(function(value)
	if value == "" then
		return
	end
	local KillPlayer = ChaosFunctions.stringToPlayer(value)
	if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		spawn(function()
			if KillPlayer.Character then
				local v109 = KillPlayer.Character:FindFirstChildOfClass("Model"):FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart")
				if v109 then
				local args = {
					[1] = "WingardiumToggle",
					[2] = v109,
					[3] = true
				}
				Remote:FireServer(unpack(args))
				local v114 = Instance.new("BodyPosition");
				v114.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				v114.Position = v109.Parent.Parent.Parent:FindFirstChild("HumanoidRootPart").Position
				v114.Parent = v109;
				v114.D = 100;
				local u34 = RunService.Stepped:Connect(function()
					if Player.Character:FindFirstChild("HumanoidRootPart") and v109 then
						v114.CFrame = Player.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,0,-3)
					end
				end)
				wait(ROWizardValues["BringPlayerTimeValue"]);
				u34:Disconnect();
				v114:Destroy();
					if v109 then
						local args = {
							[1] = "WingardiumToggle",
							[2] = v109,
							[3] = false
						}
						game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer(unpack(args))
					end
				end
			end
		end)
	end
end)

Misc:AddSlider("BringPlayerTime", {
	Text = "Bring Player Length",
	Default = 6,
	Min = 0,
	Max = 120,
	Rounding = 0,
	Compact = false,
	Tooltip = "In seconds!"
})

Options.BringPlayerTime:OnChanged(function(value)
    ROWizardValues["BringPlayerTimeValue"] = value
end)

Misc:AddInput("KillPlayerAlt", {
	Numeric = false,
	Finished = true,
	Text = "Kill Player Alternate",
	Tooltip = "Kills a player in a different way!",
	Placeholder = "Player name here!"
})

Options.KillPlayerAlt:OnChanged(function(value)
	if value == "" then
		return
	end
	local KillPlayer = ChaosFunctions.stringToPlayer(value)
	if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		spawn(function()
			if KillPlayer.Character then
				local v109 = KillPlayer.Character:FindFirstChildOfClass("Model"):FindFirstChildOfClass("Model"):FindFirstChildOfClass("MeshPart")
				if v109 then
				local args = {
					[1] = "WingardiumToggle",
					[2] = v109,
					[3] = true
				}
				Remote:FireServer(unpack(args))
				local v114 = Instance.new("BodyPosition");
				v114.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				v114.Position = v109.Parent.Parent.Parent:FindFirstChild("HumanoidRootPart").Position
				v114.Parent = v109;
				v114.D = 100;
				local u34 = RunService.Stepped:Connect(function()
					if Player.Character:FindFirstChild("HumanoidRootPart") and v109 then
						v114.Position = Vector3.new(0,-4999,0)
					end
				end)
				wait(0.1);
				u34:Disconnect();
				v114:Destroy();
					if v109 then
						local args = {
							[1] = "WingardiumToggle",
							[2] = v109,
							[3] = false
						}
						game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer(unpack(args))
					end
				end
			end
		end)
	end
end)
