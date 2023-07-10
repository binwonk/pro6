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
local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Spells = require(Modules:WaitForChild("Spell"))
local Remote = Modules:WaitForChild("Network"):WaitForChild("RemoteEvent")
local Effects = workspace:FindFirstChild("Effects")

local ROWizardValues = {
	["StoredID"] = nil,
	["Concateno"] = false,
	["RenewID"] = false,
    ["ModWandToggle"] = false,
	["AutoConfringo"] = false,
	["AutoConPlus"] = false,
	["AutoConPlusPlus"] = false,
	["HealLuminus"] = false,
	["InstaKillLuminus"] = false,
	["MegaHelios"] = false,
	["BringPlayerTimeValue"] = 6,
	["Connections"] = {
		HoopAutofarm = nil;
		PotionAutofarm = nil;
		BookLag = nil;
		AntiBookLag = nil;
		FlingAll = nil;
		FlightLag = nil;
	},
	["BooksToRemove"] = 0,
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
	["FakeBring"] = {
		PlayerToFake = nil;
		PlayerToBring = nil;
	},
	["TeleportTable2"] = {
		["Grand Hall"] = "-6.98583317, 3.26444864, -237.789932",
		["Serpents Common Room"] = "345.465912, -58.8441238, 312.809479",
		["Badgers Common Room"] = "26.4316196, -148.428452, -224.473129",
		["Lions Common Room"] = "317.076294, 174.698257, -321.223083",
		["Ravens Common Room"] = "872.183838, 234.559326, -147.583115",
		["Duelling Arena"] = "-748.834106, -107.285576, -444.290924",
		["Azkaban Outside"] = "-938.264771, 973.247803, 2759.89624",
		["Azkaban Inside"] = "-1006.8493, 973.002991, 2906.17676"
	},
	["TeleportTable"] = {
		"Grand Hall",
		"Serpents Common Room",
		"Badgers Common Room",
		"Lions Common Room",
		"Ravens Common Room",
		"Duelling Arena",
		"Azkaban Outside",
		"Azkaban Inside"
	},
	["MegaHeliosModes"] = {
		["Default"] = "default"
	},
	["LocationSelected"] = nil,
	["PlayerToTeleport"] = Player,
	["ROWizardOutfits"] = require(Modules:WaitForChild("Outfits")),
	["ROWizardOutfitsTable"] = {},
	["StoreGemsTable"] = {},
	["CustomSpellsTable"] = {},
	["IncendioHookValue"] = false
}

for i,v in next,ReplicatedStorage:WaitForChild("Outfits"):GetChildren() do
	local ToAddToTable = v.Name:gsub(" ", "")
	table.insert(ROWizardValues["ROWizardOutfitsTable"],ToAddToTable)
end

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

-- HOOKS HERE

ROWizardValues["OldNamecallHook"] = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if not checkcaller() and tostring(self) == "RemoteEvent" and getnamecallmethod() == "FireServer" then
		if args[1] == "ReplicateCast" and ROWizardValues["RenewID"] then
			ROWizardValues["StoredID"] = args[2]["ID"]
		end
		if args[1] == "ReplicateCast" and ROWizardValues["Concateno"] then
			local ID = args[2]["ID"]
			for i,v in next,Players:GetPlayers() do
				if v.Character and v ~= LocalPlayer then
					args = {
						[1] = "ConcatenoHit",
						[2] = v,
						[3] = ID
					}
					ROWizardValues["OldNamecallHook"](self,unpack(args))
				end
			end
		end
		if args[1] == "HandleDamage" and args[2]["Type"] == "Explosive" then
			if args[2]["SpellName"] == "confringo" and ROWizardValues["AutoConfringo"] then
				if not ROWizardValues["AutoConPlus"] then
					args[2]["SpellName"] = "fiendfyre"
					return ROWizardValues["OldNamecallHook"](self,unpack(args))
				else
					args[2]["SpellName"] = "fiendfyre"
					ROWizardValues["OldNamecallHook"](self,unpack(args))
					if ROWizardValues["AutoConPlusPlus"] then
						ROWizardValues["OldNamecallHook"](self,unpack(args))
						ROWizardValues["OldNamecallHook"](self,unpack(args))
						return ROWizardValues["OldNamecallHook"](self,unpack(args))
					end
					return ROWizardValues["OldNamecallHook"](self,unpack(args))
				end
			end
		end
		if args[1] == "SpawnLuminus" then
			if ROWizardValues["HealLuminus"] then
				args[4]["Damage"] = -120
			end
			if ROWizardValues["InstaKillLuminus"] then
				args[4]["Damage"] = 40
			end
			return ROWizardValues["OldNamecallHook"](self,unpack(args))
		end
		if args[1] == "SpawnHelios" and ROWizardValues["MegaHelios"] then
			for i = 1,10 do
				ROWizardValues["OldNamecallHook"](self,unpack(args))
			end
		end
	end
	return ROWizardValues["OldNamecallHook"](self,unpack(args))
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

Combat:AddToggle("AutoCon",{
	Text = "Auto 40 Damage Confringo",
	Default = false,
	Tooltip = "All your confringos will automatically deal 40 damage, rather than the normal 20!"
})

Toggles.AutoCon:OnChanged(function(value)
	ROWizardValues["AutoConfringo"] = value
end)

local ConfringoDepbox = Combat:AddDependencyBox()

ConfringoDepbox:AddToggle("AutoConPlus",{
	Text = "Auto 80 Damage Confringo",
	Default = false,
	Tooltip = "Now your confringos will do even MORE damage!"
})

Toggles.AutoConPlus:OnChanged(function(value)
	ROWizardValues["AutoConPlus"] = value
end)

local ConfringoDepboxPlus = ConfringoDepbox:AddDependencyBox()

ConfringoDepboxPlus:AddToggle("AutoConPlusPlus",{
	Text = "Auto 160 Damage Confringo",
	Default = false,
	Tooltip = "Now your confringos will do EVEN MORE damage! Can we get much higher?"
})

Toggles.AutoConPlusPlus:OnChanged(function(value)
	ROWizardValues["AutoConPlusPlus"] = value
end)

ConfringoDepbox:SetupDependencies({
	{Toggles.AutoCon, true}
})

ConfringoDepboxPlus:SetupDependencies({
	{Toggles.AutoConPlus, true}
})

Combat:AddToggle("HealLuminus",{
	Text = "Heal Luminus",
	Default = false,
	Tooltip = "Makes your Luminuses heal players rather than damage them!"
})

Combat:AddToggle("InstaKillLuminus",{
	Text = "40 Damage Luminus",
	Default = false,
	Tooltip = "Makes your Luminuses do 40 damage!"
})

Toggles.HealLuminus:OnChanged(function(value)
	ROWizardValues["HealLuminus"] = value
	if Toggles.InstaKillLuminus.Value == true then
		Toggles.InstaKillLuminus:SetValue(false)
	end
end)

Toggles.InstaKillLuminus:OnChanged(function(value)
	ROWizardValues["InstaKillLuminus"] = value
	if Toggles.HealLuminus.Value == true then
		Toggles.HealLuminus:SetValue(false)
	end
end)

Combat:AddToggle("MegaHelios",{
	Text = "Mega Helios",
	Default = false,
	Tooltip = "Makes your helios... mega?"
})

Toggles.MegaHelios:OnChanged(function(value)
	ROWizardValues["MegaHelios"] = value
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
			if Player.Character and Player.Character:FindFirstChild("Humanoid") then
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

Combat:AddButton({
	Text = "No Safe Zones",
	Tooltip = "All of your spells can now shoot in safezones!",
	Func = function()
		for i,v in next,Spells.Spells do
			v.Safe = true
		end
	end
})

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
			for i,v in next,Effects:GetChildren() do
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

Autofarming:AddToggle("PotionAutofarm",{
	Text = "Potion Autofarm",
	Default = false,
	Tooltip = "Autofarms potions to get XP!"
})

Toggles.PotionAutofarm:OnChanged(function(value)
	if value then
		if typeof(ROWizardValues["Connections"]["PotionAutofarm"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["PotionAutofarm"]:Disconnect()
		end
		ROWizardValues["Connections"]["PotionAutofarm"] = RunService.Heartbeat:Connect(function()
			local args = {[1] = "Bottle", [2] = {[1] = {["Color"] = nil --[[Color3]],["MaxAmount"] = 5,["Name"] = "Filofia Mushroom",["Amount"] = 5},[2] = {} --[[DUPLICATE]],[3] = {["Color"] = nil --[[Color3]],["MaxAmount"] = 10,["Name"] = "Pumpkin Juice",["Amount"] = 7},[4] = {["Color"] = nil --[[Color3]],["MaxAmount"] = 5,["Name"] = "Honey",["Amount"] = 5}}}
			args[2][2] = args[2][1]
			Remote:FireServer(unpack(args))
		end)
	else
		if typeof(ROWizardValues["Connections"]["PotionAutofarm"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["PotionAutofarm"]:Disconnect()
		end
	end
end)

local Misc = Tabs.Game:AddRightGroupbox("Misc")

Misc:AddToggle("RenewID",{
	Text = "Renew ID",
	Default = false,
	Tooltip = "Whenever you cast a spell, ID will renew! (required for some functions!)"
})

Toggles.RenewID:OnChanged(function(value)
	ROWizardValues["RenewID"] = value
end)

Misc:AddButton({
	Text = "Unlock all spells",
	Tooltip = "Unlocks all spells! Doesn't save when you leave game.",
	Func = function()
		for _,v in next,getgc(true) do
			if typeof(v) == "table" and rawget(v,"RPName") then
				for x = 1,100 do
					table.insert(v["KnownSpells"], {
						Unlocked = true,
						Id = x
					})
				end
				for x, d in pairs(v["KnownSpells"]) do
					if d.Unlocked == false then
						d.Unlocked = true
					end
				end
			end
		end
	end
})

Misc:AddButton({
	Text = "Unlock all unobtainables",
	Tooltip = "Unlocks all known unobtainables! Changes tarantallegra (F3F2) to Incarcerous!",
	Func = function()
		local todupe = 0
		for i,v in next,Spells.Spells do
			if v.Name == "tarantallegra" then
				v.Function = require(game:GetService("ReplicatedStorage").Modules.Spell.SpellFunctions).Incarcerous
				todupe = v.Id
			end
		end
		for i,v in next,getgc(true) do
			if typeof(v) == "table" and rawget(v,"RPName") then
				table.insert(v["KnownSpells"],{Unlocked = true,Id = 4})
			end
			if typeof(v) == "table" and rawget(v,"RPName") then
				table.insert(v["KnownSpells"],{Unlocked = true,Id = todupe})
			end
		end
	end
})

Misc:AddButton({
	Text = "Custom Spells",
	Tooltip = "Gives you multiple custom spells! FEATURE IN DEVELOPMENT",
	Func = function()
		
	end
})

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
						Remote:FireServer(unpack(args))
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
		for i = 1,6 do
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
							v114.Position = Vector3.new(0,workspace.FallenPartsDestroyHeight + 1,0)
						end
					end)
					wait(6);
					u34:Disconnect();
					v114:Destroy();
						if v109 then
							local args = {
								[1] = "WingardiumToggle",
								[2] = v109,
								[3] = false
							}
							Remote:FireServer(unpack(args))
						end
					end
				end
			end)
		end
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
		ROWizardValues["BooksToRemove"] = 0
		ROWizardValues["Connections"]["BookLag"] = RunService.Heartbeat:Connect(function()
			if Player.Character then
				Remote:FireServer(unpack({[1] = "ToggleBook",[2] = {["Name"] = "binsploit on TOP",["Color"] = nil},[3] = true}))
			end
			ROWizardValues["BooksToRemove"] = ROWizardValues["BooksToRemove"] + 1;
		end)
	else
		if typeof(ROWizardValues["Connections"]["BookLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["BookLag"]:Disconnect()
		end
		for i = 1,ROWizardValues["BooksToRemove"] do
			Remote:FireServer(unpack({[1] = "ToggleBook",[2] = {["Name"] = "binsploit on TOP",["Color"] = nil},[3] = false}))
			task.wait()
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

Misc:AddToggle("FlightLag",{
	Text = "Flight Lag",
	Default = false,
	Tooltip = "Lags the server! (requires flight gamepass)"
})

Toggles.FlightLag:OnChanged(function(value)
	if value then
		if typeof(ROWizardValues["Connections"]["FlightLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["FlightLag"]:Disconnect()
		end
		ROWizardValues["Connections"]["FlightLag"] = RunService.Heartbeat:Connect(function()
			if Player.Character and Player.Character:FindFirstChild("Flight") then
				Player.Character:FindFirstChild("Flight").FlightToggle:FireServer(true)
			end
		end)
	else
		if typeof(ROWizardValues["Connections"]["FlightLag"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["FlightLag"]:Disconnect()
		end
	end
end)

Misc:AddToggle("FlingAll",{
	Text = "Fling All",
	Default = false,
	Tooltip = "Flings everyone in the server!"
})

Toggles.FlingAll:OnChanged(function(value)
	if value then
		if typeof(ROWizardValues["Connections"]["FlingAll"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["FlingAll"]:Disconnect()
		end
		ROWizardValues["Connections"]["FlingAll"] = RunService.Heartbeat:Connect(function()
			for i, v in next,game:GetService("Players"):GetPlayers() do
				if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game:GetService("Players").LocalPlayer then
					local args = {
						[1] = "HandleDamage",
						[2] = {
							["Type"] = "Normal",
							["Hit"] = v.Character.HumanoidRootPart,
							["Norm"] = Vector3.new(math.huge, math.huge, math.huge),
							["Pos"] = v.Character.HumanoidRootPart.Position,
							["SpellName"] = "levicorpus"
						}
					}
					game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent:FireServer(unpack(args))
				end
			end
		end)
	else
		if typeof(ROWizardValues["Connections"]["FlingAll"]) == "RBXScriptConnection" then
			ROWizardValues["Connections"]["FlingAll"]:Disconnect()
		end
	end
end)

Misc:AddToggle("FlingAllAlt",{
	Text = "Fling All (Alt)",
	Default = false,
	Tooltip = "An alternate way of flinging everyone!"
})

Toggles.FlingAllAlt:OnChanged(function(value)
	if value then
		BinsploitNotify("Feature currently in development!", "Try again later!", 3)
	end
end)

Misc:AddInput("FlingPlayerAlt",{
	Text = "Fling Player",
	Tooltip = "Flings a player!",
	Placeholder = "Player name here!",
	Numeric = false,
	Finished = true
})

Options.FlingPlayerAlt:OnChanged(function(value)
	if tostring(value) == "" then
        return
    end
	local KillPlayer = ChaosFunctions.stringToPlayer(value)
	local TrollPlayer = ChaosFunctions.stringToPlayer(value)
	if KillPlayer and TrollPlayer then
		if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") and TrollPlayer.Character and TrollPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
							if TrollPlayer.Character:FindFirstChild("HumanoidRootPart") and v109 then
								v114.Position = TrollPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,0,-5)
							end
						end)
						wait(6);
						u34:Disconnect();
						v114:Destroy();
						if v109 then
							local args = {
								[1] = "WingardiumToggle",
								[2] = v109,
								[3] = false
							}
							Remote:FireServer(unpack(args))
						end
					end
				end
			end)
		end
	end
end)

Misc:AddToggle("Concateno",{
	Text = "Concateno All",
	Tooltip = "Requires a valid ID!",
	Default = false
})

Toggles.Concateno:OnChanged(function(value)
	ROWizardValues["Concateno"] = value
end)

local Blame = Tabs.Game:AddRightGroupbox("PLACEHOLDER NAME")

Blame:AddInput("FakeUser",{
	Numeric = false,
	Finished = true,
	Text = "Player to bring to!",
	Tooltip = "PLACEHOLDER",
	Placeholder = "Player name here!"
})

Options.FakeUser:OnChanged(function(value)
	if tostring(value) == "" then
        return
    end
	local FakeBring = ChaosFunctions.stringToPlayer(value)
	if FakeBring then
		ROWizardValues["FakeBring"]["PlayerToFake"] = FakeBring
	end
end)

Blame:AddInput("FakeUserBring",{
	Numeric = false,
	Finished = true,
	Text = "Player to bring!",
	Tooltip = "PLACEHOLDER",
	Placeholder = "Player name here!"
})

Options.FakeUserBring:OnChanged(function(value)
	if tostring(value) == "" then
        return
    end
	local FakeBring = ChaosFunctions.stringToPlayer(value)
	if FakeBring then
		ROWizardValues["FakeBring"]["PlayerToBring"] = FakeBring
	end
end)

Blame:AddButton({
	Text = "Do the thing!",
	Tooltip = "DON'T DO THIS UNLESS MY FEATURE NAMES ARE CLEAR ENOUGH",
	Func = function()
		local KillPlayer = ROWizardValues["FakeBring"]["PlayerToBring"]
		local TrollPlayer = ROWizardValues["FakeBring"]["PlayerToFake"]
		if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") and TrollPlayer.Character and TrollPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
						if TrollPlayer.Character:FindFirstChild("HumanoidRootPart") and v109 then
							v114.Position = TrollPlayer.Character:FindFirstChild("HumanoidRootPart").Position + Vector3.new(0,0,-5)
						end
					end)
					wait(6);
					u34:Disconnect();
					v114:Destroy();
						if v109 then
							local args = {
								[1] = "WingardiumToggle",
								[2] = v109,
								[3] = false
							}
							Remote:FireServer(unpack(args))
						end
					end
				end
			end)
		end
	end
})

local Teleport = Tabs.Game:AddRightGroupbox("Teleports")

Teleport:AddDropdown("TeleportsDropdown",{
	Values = ROWizardValues["TeleportTable"],
	Text = "Teleports Dropdown",
	Tooltip = "Select a location, then click the teleport button below!",
	AllowNull = true
})

Options.TeleportsDropdown:OnChanged(function(str)
	if str ~= "" then
		str = ROWizardValues["TeleportTable2"][str]
		if typeof(str) == "string" then
			str = Vector3.new(table.unpack(str:gsub(" ",""):split(",")))
			ROWizardValues["LocationSelected"] = str
		end
	else
		return
	end
end)

Teleport:AddButton({
	Text = "Teleport!",
	Tooltip = "Teleports to the location selected above! Doesn't work with other players YET!",
	Func = function()
		if ROWizardValues["PlayerToTeleport"].Character and ROWizardValues["PlayerToTeleport"].Character:FindFirstChild("HumanoidRootPart") then
			if ROWizardValues["PlayerToTeleport"] == Player then
				ROWizardValues["PlayerToTeleport"].Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(ROWizardValues["LocationSelected"])
			else
				local KillPlayer = ROWizardValues["PlayerToTeleport"]
				local TrollPlayer = ROWizardValues["PlayerToTeleport"]
				if KillPlayer.Character and KillPlayer.Character:FindFirstChild("Head") and TrollPlayer.Character and TrollPlayer.Character:FindFirstChild("HumanoidRootPart") then
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
								if TrollPlayer.Character:FindFirstChild("HumanoidRootPart") and v109 then
									v114.Position = ROWizardValues["LocationSelected"]
								end
							end)
							wait(6);
							u34:Disconnect();
							v114:Destroy();
								if v109 then
									local args = {
										[1] = "WingardiumToggle",
										[2] = v109,
										[3] = false
									}
									Remote:FireServer(unpack(args))
								end
							end
						end
					end)
				end
			end
		end
	end
})

Teleport:AddInput("TeleportSelector",{
	Text = "Player to teleport",
	Tooltip = "Optional! Leave blank for self/type in self/type in your own username to teleport yourself! (autofills)",
	Placeholder = "Player name here!",
	Numeric = false,
	Finished = true
})

Options.TeleportSelector:OnChanged(function(value)
	if value == "" or value == "self" then
		ROWizardValues["PlayerToTeleport"] = Player
		return
	end
	TOTP = ChaosFunctions.stringToPlayer(value)
	if TOTP then
		ROWizardValues["PlayerToTeleport"] = TOTP
	end
end)

local Store = Tabs.Game:AddLeftGroupbox("Store")

--[[Store:AddButton({
	Text = "Free Store",
	Tooltip = "When pressed, all prices in the store are ALMOST free! (You need 1 gem to purchase.)",
	Func = function()
		for i, v in next,getgc(true) do
			if type(v) == "table" and rawget(v, "Gems") and rawget(v, "Rarity") then
				v.Gems = 0.00000001
			end
		end
	end
})
]]--

Store:AddToggle("FreeStoreToggle",{
	Text = "Free Store",
	Tooltip = "When enabled, all prices in the store are ALMOST free! (You need 1 gem to purchase.)",
	Default = false
})

Toggles.FreeStoreToggle:OnChanged(function(value)
	if value then
		ROWizardValues["StoreGemsTable"] = {}
		for i, v in next,getgc(true) do
			if type(v) == "table" and rawget(v, "Gems") and rawget(v, "Rarity") then
				ROWizardValues["StoreGemsTable"][v.Name] = v.Gems
				v.Gems = 0.00000001
			end
		end
	else
		for i, v in next,getgc(true) do
			if type(v) == "table" and rawget(v, "Gems") and rawget(v, "Rarity") then
				if ROWizardValues["StoreGemsTable"][v.Name] then
					v.Gems = ROWizardValues["StoreGemsTable"][v.Name]
				end
			end
		end
	end
end)


Store:AddDropdown("SelectOutfit",{
	Text = "Equip Outfit",
	Tooltip = "Equips an outfit! (some unobtainable outfits in there too)",
	Values = ROWizardValues["ROWizardOutfitsTable"],
	AllowNull = true
})

Options.SelectOutfit:OnChanged(function(value)
	if value ~= "--" and value ~= "" and value ~= nil and value ~= "nil" then
		local args = {
			[1] = "Equip",
			[2] = {
				["HouseColor"] = true,
				["Name"] = "School Uniform",
				["Owner"] = Player,
				["OutfitName"] = value,
				["Gems"] = 0.0000001,
				["Type"] = "Outfit",
				["Rarity"] = "Common"
			}
		}
		Remote:FireServer(unpack(args))
	end
end)
