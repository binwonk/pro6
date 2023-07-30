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

local CBValues = {
	["Connections"] = {
    },
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
    ["SpoofPing"] = false,
    ["SpoofPingValue"] = 0
}

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

-- HOOKS HERE

CBValues["OldNamecallHook"] = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if not checkcaller() and tostring(self) == "UpdatePing" and getnamecallmethod() == "FireServer" then
        args[1] = CBValues["SpoofPingValue"]
        return CBValues["OldNamecallHook"](self,unpack(args))
	end
	return CBValues["OldNamecallHook"](self,unpack(args))
end)

--GAME SCRIPT HERE
local General = Tabs.Game:AddLeftGroupbox("General")

General:AddToggle("SpoofPing",{
    Text = "Spoof Ping",
    Default = false,
    Tooltip = "Ping is shown as 0! (or slider value)"
})

Toggles.SpoofPing:OnChanged(function(value)
    CBValues["SpoofPing"] = value
end)

General:AddSlider("SpoofPingValue", {
    Text = "Spoof Ping Slider",
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 5,
    Compact = false
})

Options.SpoofPingValue:OnChanged(function(value)
    CBValues["SpoofPingValue"] = value
end)
