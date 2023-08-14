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
local Client = require(ReplicatedStorage.Library.Client)
local Framework = require(ReplicatedStorage.Framework.Library)
local Orbs = getsenv(Player:FindFirstChild("PlayerScripts"):FindFirstChild("Scripts"):FindFirstChild("Game"):FindFirstChild("Orbs"))

local PSXValues = {
	["Connections"] = {
        ["OrbsConnect"] = nil;
    },
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
    ["PSXRemoteHook"] = nil,
    ["PSXAutofarm"] = false,
    ["DeleteBelowPower"] = 10000,
    ["Remotes"] = {
        FreeReward = "Redeem Free Gift"
    },
    ["GetEquippedPets"] = function()
        return Client.PetCmds.GetEquipped()
    end,
    ["FindPet"] = function(id)
        for i,v in next,ReplicatedStorage["__DIRECTORY"].Pets:GetChildren() do
            if string.match(v.Name, "^"..id.." ") then
                for x,d in next,v:GetChildren() do
                    if d:IsA("ModuleScript") then
                        return require(d)
                    end
                end
            end
        end
    end,
    ["GetCoins"] = function(a)
        local Coins = {}
        for i,v in next,Client.Network.Invoke("Get Coins") do
            if v.a == a then
                Coins[i] = v
            end
        end
        return Coins
    end,
    ["SelectedArea"] = "Town"
}

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

-- HOOKS HERE

PSXValues["OldNamecallHook"] = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if not checkcaller() and tostring(self) == "RemoteEvent" and getnamecallmethod() == "FireServer" then
	end
	return PSXValues["OldNamecallHook"](self,unpack(args))
end)

--GAME SCRIPT HERE
local Autofarm = Tabs.Game:AddLeftGroupbox("Autofarms")

debug.setupvalue(Client.Network.Invoke, 1, function() return true end)
debug.setupvalue(Client.Network.Fire, 1, function() return true end)

Autofarm:AddToggle("AutoFreeRewards",{
    Text = "Auto Claim Free Gifts",
    Tooltip = "Automatically claims free rewards for you!",
    Default = false
})

Toggles.AutoFreeRewards:OnChanged(function(value)
    if value then
        spawn(function()
            while true do
                if value then
                    for i=1,12 do
                        Client.Network.Invoke(PSXValues["Remotes"]["FreeReward"],i)
                        task.wait()
                    end
                    wait(2)
                else
                    break
                end
            end
        end)
    end
end)

Autofarm:AddToggle("AutoFarm",{
    Text = "Auto Farm",
    Tooltip = "Set area below!",
    Default = false
})

Toggles.AutoFarm:OnChanged(function(value)
    if value then
        PSXValues["PSXAutofarm"] = true
        if typeof(PSXValues["Connections"]["OrbsConnect"]) == "RBXScriptConnection" then
            PSXValues["Connections"]["OrbsConnect"]:Disconnect()
        end
        for i,v in pairs(workspace.__THINGS.Orbs:GetChildren()) do
            Orbs.Collect(v)
        end
        PSXValues["Connections"]["OrbsConnect"] = workspace.__THINGS.Orbs.ChildAdded:Connect(function(v)
            Orbs.Collect(v)
        end)
        while PSXValues["PSXAutofarm"] do
            local Pets = PSXValues["GetEquippedPets"]()
            local Coins = PSXValues["GetCoins"](PSXValues["SelectedArea"] or "Town")
            for i,v in next,Coins do
                if workspace.__THINGS.Coins:FindFirstChild(i) and PSXValues["PSXAutofarm"] then
                    for _,pet in next,Pets do
                        spawn(function()
                            Client.Network.Invoke("Join Coin", i, {pet.uid})
                            Client.Network.Fire("Farm Coin", i, {pet.uid})
                        end)
                    end
                end
                repeat task.wait() until not workspace.__THINGS.Coins:FindFirstChild(i)
            end
            task.wait()
        end
    else
        if typeof(PSXValues["Connections"]["OrbsConnect"]) == "RBXScriptConnection" then
            PSXValues["Connections"]["OrbsConnect"]:Disconnect()
        end
        PSXValues["PSXAutofarm"] = false
    end
end)

Autofarm:AddInput("AutoDeleteBelowPower",{
    Text = "Auto Delete Below Power",
    Numeric = true,
    Finished = true,
    Tooltip = "Numbers only! Automatically deletes pets below specified \"power\" level!",
    Placeholder = "Number here!"
})

Options.AutoDeleteBelowPower:OnChanged(function(value)
    if tonumber(value) ~= nil then
        PSXValues["DeleteBelowPower"] = tonumber(value)
    end
end)

Autofarm:AddInput("AutoDeleteToggle",{
    Text = "Auto Delete Below Power Toggle",
    Default = false,
    Tooltip = "Automatically deletes pets below specified power level!"
})

Toggles.AutoDeleteToggle:OnChanged(function(value)
    if value then
        
    else

    end
end)
