local StartTime = os.clock()

local ScriptVersion = "0.0.1"

local game = game
local wait = task.wait

repeat wait() until game:IsLoaded()

math.randomseed(tick())


if not isfile("BinsploitMike.lua") then
--mikecash here (https://github.com/x0581/MikeCash/)

local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(game:GetService("CoreGui"))
local MD5 = loadstring(game:HttpGet("https://raw.githubusercontent.com/kikito/md5.lua/master/md5.lua"))()

local LINKVERTISE_ID = 668430

local DONT_RENDER_CONFIRMATION_WINDOW = false
local CREATOR_DISCORD_SERVER = "https://discord.gg/zgHy6TsYcQ"
local API_HOST = "linkvertise.thisisusedfornothingotherthantohostafewscripts.xyz"

local Solved = Iris.State(false)
local Continue = Iris.State(DONT_RENDER_CONFIRMATION_WINDOW)
local SupportTheCreator = Iris.State(true)
local LearnMore = Iris.State(false)

local TaskID = "NONE"
local ExpireIn = 0
local APIVersion = game:HttpGet(("https://%s/tasks/version"):format(API_HOST))
local Rand = 0


local function CreateTask()
    Rand = math.random(1, 100000)
    Rand = Rand + math.random(1, 100000)
    Rand = Rand + math.random(1, 100000)
    Rand = Rand + Random.new():NextNumber()
    local Resp = game:HttpGet(("https://%s/tasks/create/%s/%s"):format(API_HOST, tostring(LINKVERTISE_ID), tostring(Rand)))

    local Data = game:GetService("HttpService"):JSONDecode(Resp)
    TaskID = Data.task_id
    ExpireIn = Data.expire_in

    task.spawn(function()
        while task.wait(1) do
            ExpireIn = ExpireIn - 1
        end
    end)
end

if DONT_RENDER_CONFIRMATION_WINDOW then
    CreateTask()
end

local function RenderMainWindow()
    Iris.Window({"Mike Cash - Support The Creator", [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoResize] = true, [Iris.Args.Window.NoScrollbar] = true, [Iris.Args.Window.NoCollapse] = true}, {size = Iris.State(Vector2.new(450, 100))}) do
        Iris.Text({("Task ID: %s"):format(TaskID)})
        Iris.Text({("Task Expires In: %s second(s)"):format(tostring(ExpireIn))})
        -- Iris.Text({("API Version: %s"):format(APIVersion)})
        -- Iris.Text({("Host: %s"):format(API_HOST)})

        Iris.SameLine() do
            if Iris.Button({"I have visited the Website"}).clicked then
                task.spawn(function()
                    local Response = game:GetService("HttpService"):JSONDecode(game:HttpGet(("https://%s/tasks/validate/%s"):format(API_HOST, TaskID)))
                    if Response.exists and Response.solved and Response.rand_hash == MD5.sumhexa(tostring(Rand)) then
                        Solved.value = true
                    end
                end)
            end
            if Iris.Button({"Copy Website"}).clicked then
                setclipboard(("https://%s/tasks/begin/%s"):format(API_HOST, TaskID))
            end
            if Iris.Button({"Learn More"}).clicked then
                LearnMore.value = true
            end
            Iris.End()
        end
        Iris.End()
    end
end

local function RenderConfirmation()
    local Loading = Iris.State(false)

    Iris.Window({"Mike Cash - Support The Creator", [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoResize] = true, [Iris.Args.Window.NoScrollbar] = true, [Iris.Args.Window.NoCollapse] = true}, {size = Iris.State(Vector2.new(300, 75))}) do
        if not Continue.value then
            Iris.Checkbox({"I wish to support the creator."}, {isChecked = SupportTheCreator})
            Iris.SameLine() do
                if Iris.Button({Loading.value and "Please wait.." or "Continue"}).clicked then
                    if SupportTheCreator.value then
                        if not Loading.value then
                            task.spawn(function()
                                Loading.value = true
                                CreateTask()
                                Continue.value = true
                            end)
                        end
                    else
                        Solved.value = true
                    end
                end
                if Iris.Button({"Learn More"}).clicked then
                    LearnMore.value = true
                end
                Iris.End()
            end
        end
        Iris.End()
    end
end

local function RenderLearnMore()
    Iris.Window({"Mike Cash - Support The Creator", [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoResize] = true, [Iris.Args.Window.NoScrollbar] = true, [Iris.Args.Window.NoCollapse] = true}, {size = Iris.State(Vector2.new(600, 275))}) do
        Iris.Text({"Mike Cash is created to let script creators easily monetize their script"})
        Iris.Text({"without them having to pay for some sort of a license or hosting so they"})
        Iris.Text({"can host their own \"Key System\" of some sorts."})
        Iris.Text({""})
        Iris.Text({"Mike Cash does not use keys, instead it uses Task IDs, which allow us"})
        Iris.Text({"to identify if you have visited or have not visited the linkvertise yet."})
        Iris.Text({""})
        Iris.SameLine() do
            Iris.Text({"Join the Creators Discord Server!"})
            if Iris.Button({"Copy Invite"}).clicked then
                setclipboard(CREATOR_DISCORD_SERVER)
            end
            Iris.End()
        end
        Iris.SameLine() do
            Iris.Text({"Use MikeCash yourself!"})
            if Iris.Button({"Copy GitHub Link"}).clicked then
                setclipboard("https://github.com/x0581/MikeCash")
            end
            Iris.End()
        end
        Iris.Text({""})
        if Iris.Button({"Close"}).clicked then
            LearnMore.value = false
        end
        Iris.End()
    end
end

-- Pcall because errors on finish and i aint gonna bother
pcall(function()
    Iris:Connect(function()
        if not Solved.value then
            if Continue.value then
                RenderMainWindow()
            else
                RenderConfirmation()
            end
        end
        if LearnMore.value then
            RenderLearnMore()
        end
    end)
end)

repeat task.wait() until Solved.value

writefile("BinsploitMike.lua","true")

end

--mikecash end, script can start now!

-- SERVICES HERE
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- LOCAL VARIABLES HERE
local Player = Players.LocalPlayer

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local ChaosFunctions = loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/misc/ChaosFunctions2.lua"))()
local Notifications = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sw1ndlerScripts/RobloxScripts/main/Notification%20Library/main.lua"))()

getgenv().BinsploitValues = {
    ["Spoofs"] = {
        ["SpoofWSJP"] = {
            Value = false,
            WalkSpeed = 16,
            JumpPower = 50
        }
    },
    ["ChatSpam"] = {
        ChatSpamDelay = 1;
    },
    ["ToJoin"] = {
        JobId = game.JobId,
        PlaceId = game.PlaceId
    },
    ["AutoRejoin"] = nil,
    ["ChatSpy"] = nil;
}

getgenv().BinsploitNotify = function(Title,Text,Time,Prompt,PromptY,PromptN)
    if not Time then Time = 3 end
    if Prompt then
        Notifications:CreatePromptNotif({
            TweenSpeed = 1,
            Title = "Placeholder",
            Text = "Placeholder",
            Duration = 3,
            Callback = function(value)
                print(value)
            end
        })
    else
        Notifications:CreateDefaultNotif({
            TweenSpeed = 1,
            Title = Title,
            Text = Text,
            Duration = Time
        })
    end
end

--HOOKS HERE

local oldnc;
local oldind;
local oldnind;

oldnind = hookmetamethod(game,"__newindex",function(self,...)
    local args = {...}
    if (not checkcaller() and self:IsA("Humanoid")) and (args[1] == "WalkSpeed" or args[1] == "JumpPower") and BinsploitValues.Spoofs.SpoofWSJP.Value == true then
        BinsploitValues.Spoofs.SpoofWSJP[args[1]] = args[2]
        return
    end
    return oldnind(self,...)
end)

oldind = hookmetamethod(game, "__index", function(self,...)
    local args = {...}
    if (not checkcaller() and self:IsA("Humanoid")) and (args[1] == "WalkSpeed" or args[1] == "JumpPower") and BinsploitValues.Spoofs.SpoofWSJP.Value == true then
        return BinsploitValues.Spoofs.SpoofWSJP[args[1]]
    end
    return oldind(self,...)
end)

-- MAIN SCRIPT HERE
getgenv().V6 = Library:CreateWindow({
    Title = "Pioneer - Version 0.0.2 - Alpha",
    Center = true,
    AutoShow = true,
    TabPadding = 8
})

getgenv().Tabs = {
    Universal = V6:AddTab("Universal"),
    Game = V6:AddTab("Game"),
    ["UI Settings"] = V6:AddTab("UI Settings")
}

local UniversalMisc = Tabs.Universal:AddLeftGroupbox("Misc")

UniversalMisc:AddButton({
    Text = "Rejoin",
    Tooltip = "Rejoins the server you're currently in!",
    Func = function()
        if #(Players:GetPlayers()) > 1 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
        else
            Player:Kick("Rejoining, please wait!")
            wait()
            TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
        end
    end
})

UniversalMisc:AddButton({
    Text = "Serverhop",
    Tooltip = "Finally a serverhop I didn't skid!",
    Func = function()
        local Servers = {}
        local ServerData = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"))
        for i,v in next,ServerData.data do
            if v.id ~= game.JobId and v.playing ~= v.maxPlayers then
                Servers[#Servers+1] = v.id
            end
        end
        if #Servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1,#Servers)], Player)
        end
    end
})

UniversalMisc:AddToggle("AutoRejoin",{
    Text = "Auto Rejoin",
    Tooltip = "With this enabled, you'll rejoin everytime you get kicked!",
    Default = false
})

Toggles.AutoRejoin:OnChanged(function(value)
    if value then
        if typeof(BinsploitValues["AutoRejoin"]) == "RBXScriptConnection" then
            BinsploitValues["AutoRejoin"]:Disconnect()
        end
        BinsploitValues["AutoRejoin"] = CoreGui:FindFirstChild("RobloxPromptGui"):FindFirstChild("promptOverlay").ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child:FindFirstChild("MessageArea"):FindFirstChild("ErrorFrame") then
                TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,Player)
            end
        end)
    else
        if typeof(BinsploitValues["AutoRejoin"]) == "RBXScriptConnection" then
            BinsploitValues["AutoRejoin"]:Disconnect()
        end
    end
end)

UniversalMisc:AddButton({
    Text = "Invite players",
    Tooltip = "Sets your clipboard to a script that people can execute to join your game!",
    Func = function()
        setclipboard("-- Use this script to join me ingame!\n" .. [[game:GetService("TeleportService"):TeleportToPlaceInstance(]] .. tostring(game.PlaceId) .. "," .. [["]] .. tostring(game.JobId) .. [["]] .. [[,game:GetService("Players").LocalPlayer)]])
    end
})

UniversalMisc:AddButton({
    Text = "Invite players (Javascript)",
    Tooltip = "Sets your clipboard to Javascript people can execute in their browser's console (CTRL+Shift+I) to join your game!",
    Func = function()
        setclipboard("Roblox.GameLauncher.joinGameInstance(" .. tostring(game.PlaceId) .. ",".. [["]] .. tostring(game.JobId) .. [["]] .. ")")
    end
})

UniversalMisc:AddInput("JobIdJoin",{
    Text = "Join By JobId",
    Numeric = false,
    Finished = true,
    Tooltip = "Requires PlaceId to be entered below! (unless it's the same game, in which case just click join server!)",
    Placeholder = "Enter JobId here!"
})

Options.JobIdJoin:OnChanged(function(value)
    if value ~= "" then
        BinsploitValues["ToJoin"]["JobId"] = value
    else
        BinsploitValues["ToJoin"]["JobId"] = game.JobId
    end
end)

UniversalMisc:AddInput("PlaceIdJoin",{
    Text = "Join By PlaceId",
    Numeric = false,
    Finished = true,
    Tooltip = "Requires JobId to be entered above! (click join server when you're done!)",
    Placeholder = "Enter PlaceId here!"
})

Options.PlaceIdJoin:OnChanged(function(value)
    if value ~= "" then
        BinsploitValues["ToJoin"]["PlaceId"] = tonumber(value)
    else
        BinsploitValues["ToJoin"]["PlaceId"] = game.PlaceId
    end
end)

UniversalMisc:AddButton({
    Text = "Join Server",
    Tooltip = "Make sure you've entered the JobId and PlaceId above!",
    Func = function()
        TeleportService:TeleportToPlaceInstance(BinsploitValues["ToJoin"]["PlaceId"],BinsploitValues["ToJoin"]["PlaceId"],Player)
    end
})

local UniversalLocalPlayer = Tabs.Universal:AddRightGroupbox("LocalPlayer")

UniversalLocalPlayer:AddSlider("WalkSpeed", {
    Text = "WalkSpeed Slider",
    Default = 16,
    Min = 0,
    Max = 1024,
    Rounding = 0,
    Compact = false
})

Options.WalkSpeed:OnChanged(function(value)
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

UniversalLocalPlayer:AddInput("CustomWalkSpeed", {
    Text = "WalkSpeed Textbox",
    Numeric = true,
    Finished = true,
    Tooltip = "Numbers only!",
    Placeholder = "Custom WalkSpeed here!"
})

Options.CustomWalkSpeed:OnChanged(function(value)
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        Options.WalkSpeed:SetValue(value)
        Player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
    end
end)

Options.WalkSpeed:SetValue(16)
Options.CustomWalkSpeed:SetValue(16)

UniversalLocalPlayer:AddSlider("JumpPower",{
    Text = "JumpPower Slider",
    Default = 50,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = false
})

Options.JumpPower:OnChanged(function(value)
    if Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") then
        if Player.Character:FindFirstChildOfClass("Humanoid").UseJumpPower == false then
            Player.Character:FindFirstChildOfClass("Humanoid").UseJumpPower = true
        end
        Player.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
    end
end)

UniversalLocalPlayer:AddInput("GotoPlayer",{
    Text = "Teleport To Player",
    Numeric = false,
    Finished = true,
    Tooltip = "Teleports you to a player!",
    Placeholder = "Enter player name here!"
})

Options.GotoPlayer:OnChanged(function(value)
    if value == "" then
        return
    end
    value = ChaosFunctions.stringToPlayer(value)
    if value then
        if value.Character and value.Character:FindFirstChild("HumanoidRootPart") and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:FindFirstChild("HumanoidRootPart").CFrame = value.Character:FindFirstChild("HumanoidRootPart").Position
        end
    end
end)

local UniversalSpoofs = Tabs.Universal:AddRightGroupbox("Spoofs & Bypasses")

UniversalSpoofs:AddToggle("SpoofWSJP",{
    Text = "Spoof WalkSpeed & JumpPower",
    Default = false
})

Toggles.SpoofWSJP:OnChanged(function(value)
    BinsploitValues.Spoofs.SpoofWSJP.Value = value
end)

local UniversalChatSpam = Tabs.Universal:AddRightGroupbox("Chat Spam")

UniversalChatSpam:AddSlider("ChatSpamDelay",{
    Text = "ChatSpam Delay",
    Default = 1,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Tooltip = "How long should ChatSpam wait before sending the next message?"
})

Options.ChatSpamDelay:OnChanged(function(value)
    BinsploitValues["ChatSpam"]["ChatSpamDelay"] = value
end)

local UniversalChatSpy = Tabs.Universal:AddRightGroupbox("ChatSpy")

UniversalChatSpy:AddToggle("CSEnabled",{
    Text = "ChatSpy Enabled",
    Default = false,
    Tooltip = "Disables/Enables chatspy!"
})

Toggles.CSEnabled:OnChanged(function(value)
    if value then
        
    else

    end
end)

-- load game specific script

local suc,err = pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/binwonk/pro6/main/games/" .. tostring(game.GameId) .. "/" .. tostring(game.PlaceId) .. ".lua"))()
end)

if err then print(err) end

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- yes, i copypasted that, and i will not edit it either

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("Quintessence")
SaveManager:SetFolder("Quintessence/testing")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

local EndTime = os.clock() - StartTime
