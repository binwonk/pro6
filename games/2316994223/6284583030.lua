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

local PSXValues = {
	["Connections"] = {

    },
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
    ["PSXRemoteHook"] = nil;
    ["Remotes"] = {
        FreeReward = "Redeem Free Gift"
    }
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
local Autofarm = Tabs.Game:AddLeftGroupbox("Auto-Stuff")

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
            while value do
                for i=1,12 do
                    Client.Network.Invoke(PSXValues["FreeReward"],i)
                end
                wait(2)
            end
        end)
    end
end)
