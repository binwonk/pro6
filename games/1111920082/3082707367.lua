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
	["BringPlayerTimeValue"] = 6,
	["Connections"] = {
		HoopAutofarm = nil;
		BookLag = nil;
		AntiBookLag = nil;
	}
}

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Spells = require(Modules:WaitForChild("Spell"))
local Remote = Modules:WaitForChild("Network"):WaitForChild("RemoteEvent")
local Effects = workspace:FindFirstChild("Effects")

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

Autofarming:AddToggle("HoopAutofarm",{
	Text = "Hoop Autofarm",
    Default = false,
	Tooltip = "Autofarms hoops to get XP!"
})

Toggles.HoopAutofarm:OnChanged(function(value)
	if value then
		if typeof(ROWizardValues["Connections"]["HoopAutofarm"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["HoopAutofarm"]:Disconnect()
		end
		ROWizardValues["Connections"]["HoopAutofarm"] = RunService.Heartbeat:Connect(function()
			for i,v in next,workspace:FindFirstChild("Effects"):GetChildren() do
				if v.Name == "Hoop" and Player.Character and Player.Character:FindFirstChild("Head") then
					firetouchinterest(Player.Character:FindFirstChild("Head"),v,0)
					task.wait()
					firetouchinterest(Player.Character:FindFirstChild("Head"),v,1)
				end
			end
		end)
	else
		if typeof(ROWizardValues["Connections"]["HoopAutofarm"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["HoopAutofarm"]:Disconnect()
		end
	end
end)

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
				local v109 = KillPlayer.Character:FindFirstChild("Head")
				if v109 then
				local args = {
					[1] = "WingardiumToggle",
					[2] = v109,
					[3] = true
				}
				Remote:FireServer(unpack(args))
				local v114 = Instance.new("BodyPosition");
				v114.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				v114.Position = v109.Parent:FindFirstChild("HumanoidRootPart").Position
				v114.Parent = v109;
				v114.D = 100;
				local u34 = RunService.Stepped:Connect(function()
					if Player.Character:FindFirstChild("HumanoidRootPart") and v109 then
						v114.Position = Player.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,0,-5)
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
				local v109 = KillPlayer.Character:FindFirstChild("Head")
				if v109 then
				local args = {
					[1] = "WingardiumToggle",
					[2] = v109,
					[3] = true
				}
				Remote:FireServer(unpack(args))
				local v114 = Instance.new("BodyPosition");
				v114.MaxForce = Vector3.new(math.huge, math.huge, math.huge);
				v114.Position = v109.Parent:FindFirstChild("HumanoidRootPart").Position
				v114.Parent = v109;
				v114.D = 100;
				local u34 = RunService.Stepped:Connect(function()
					if v114 and v109 then
						v114.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 5,0)
					end
				end)
				wait(1.5);
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

Misc:AddToggle("BookLag",{
	Text = "Lag Server",
    Default = false,
	Tooltip = "Spam equips books to lag the server!"
})

Toggles.BookLag:OnChanged(function(value)
	if value then
		if typeof(ROWizardValues["Connections"]["BookLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["BookLag"]:Disconnect()
		end
		ROWizardValues["Connections"]["BookLag"] = RunService.Heartbeat:Connect(function()
			if Player.Character then
				Remote:FireServer(unpack({[1] = "ToggleBook",[2] = {["Name"] = "binsploit on TOP",["Color"] = nil},[3] = true}))
			end
		end)
	else
		if typeof(ROWizardValues["Connections"]["BookLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["BookLag"]:Disconnect()
		end
	end
end)

Misc:AddToggle("AntiBL",{
	Text = "Anti-Book Lag",
	Default = false,
	Tooltip = "Prevents people including yourself lagging your game! (CLIENT)"
})

Toggles.AntiBL:OnChanged(function(value)
	if value then
		for i,v in next,Players:GetPlayers() do
			if v.Character and v.Character:FindFirstChild("BookHolding") then
				for x,d in next,v.Character:GetChildren() do
					if d.Name == "BookHolding" then
						d:Destroy()
					end
				end
			end
		end
		if typeof(ROWizardValues["Connections"]["AntiBookLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["AntiBookLag"]:Disconnect()
		end
		ROWizardValues["Connections"]["AntiBookLag"] = RunService.Heartbeat:Connect(function()
			for i,v in next,Players:GetPlayers() do
				if v.Character and v.Character:FindFirstChild("BookHolding") then
					v.Character:FindFirstChild("BookHolding"):Destroy()
				end
			end
		end)
	else
		if typeof(ROWizardValues["Connections"]["AntiBookLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["AntiBookLag"]:Disconnect()
		end
		for i,v in next,Players:GetPlayers() do
			if v.Character and v.Character:FindFirstChild("BookHolding") then
				for x,d in next,v.Character:GetChildren() do
					if d.Name == "BookHolding" then
						d:Destroy()
					end
				end
			end
		end
	end
end)
