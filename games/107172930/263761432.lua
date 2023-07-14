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

local HouseValues = {
	["Connections"] = {
    },
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
}

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

-- HOOKS HERE

HouseValues["OldNamecallHook"] = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if not checkcaller() and tostring(self) == "RemoteEvent" and getnamecallmethod() == "FireServer" then
	end
	return HouseValues["OldNamecallHook"](self,unpack(args))
end)

--GAME SCRIPT HERE
local General = Tabs.Game:AddLeftGroupbox("General")

General:AddLabel("HouseColor"):AddColorPicker("HouseColorPicker",{
    Default = Color3.new(1,0,0),
    Title = "House Color Picker"
})

Options.HouseColorPicker:OnChanged(function()
    game:GetService("ReplicatedStorage").HouseColour:FireServer(Options.HouseColorPicker.Value)
end)
