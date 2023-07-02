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
local Remote = nil;
for i,v in next,getgc(true) do
    if typeof(v) == "table" and rawget(v,"FireServer") and typeof(rawget(v,"FireServer")) == "function" then
        Remote = v
    end
end

local JailbreakValues = {
	["Connections"] = {
        AutoPunch = nil;
    },
    ["FallDamageValue"] = false,
    ["AutoPunchToggle"] = false,
	["OldIndexHook"] = nil,
	["OldNamecallHook"] = nil,
    ["JailbreakRemoteHook"] = nil;
    ["Remotes"] = {
        Punch = "jkhe0isj",
        Team = "lcoet4e8",
        FallDamage = "nngy46bk"
    }
}

local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()

-- HOOKS HERE

JailbreakValues["OldNamecallHook"] = hookmetamethod(game,"__namecall",function(self,...)
	local args = {...}
	if not checkcaller() and tostring(self) == "RemoteEvent" and getnamecallmethod() == "FireServer" then
	end
	return JailbreakValues["OldNamecallHook"](self,unpack(args))
end)

JailbreakValues["JailbreakRemoteHook"] = hookfunction(Remote.FireServer,function(self,...)
    local args = {...}

    if args[1] == JailbreakValues["Remotes"]["FallDamage"] then
        if JailbreakValues["FallDamageValue"] then
            return
        end
    end

    return JailbreakValues["JailbreakRemoteHook"](self,...)
end)

--GAME SCRIPT HERE
local General = Tabs.Game:AddLeftGroupbox("General")

General:AddToggle("AutoPunch",{
    Text = "Auto Punch",
    Default = false,
    Tooltip = "Automatically punches! (No animation)"
})

Toggles.AutoPunch:OnChanged(function(value)
    if value then
        if typeof(JailbreakValues["Connections"]["AutoPunch"]) == true then
            JailbreakValues["Connections"]["AutoPunch"]:Disconnect()
        end
        JailbreakValues["Connections"]["AutoPunch"] = RunService.Stepped:Connect(function()
            Remote:FireServer(JailbreakValues["Remotes"]["Punch"])
        end)
    else
        if typeof(JailbreakValues["Connections"]["AutoPunch"]) == "RBXScriptConnection" then
            JailbreakValues["Connections"]["AutoPunch"]:Disconnect()
        end
    end
end)

General:AddToggle("NoFallDamage",{
    Text = "No Fall Damage",
    Default = false,
    Tooltip = "Disables fall damage when enabled!"
})

Toggles.NoFallDamage:OnChanged(function(value)
    JailbreakValues["FallDamageValue"] = value
end)
