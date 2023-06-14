--[[
    hi welcome to most skidded script ever hope you enjoy reading the great code :pray:
]]--

local game = game

--services here
local Players = game:GetService("Players")

--other variables here idk bro
local LocalPlayer = Players.LocalPlayer

--chaosfunctions variables/tables whatever
local ChaosFunctions = {}
ChaosFunctions.table = {}
ChaosFunctions.string = {}

function ChaosFunctions.checkType(Value,Expected,IsInstance) -- if no expected then it just gives the type (also supports instances with isinstance (true/false)))
    if Expected then
        if typeof(Value) == "Instance" and Value.ClassName == Expected then
            return true
        elseif typeof(Value) == Expected then
            return true
        end
    else
        if typeof(Value) == "Instance" then
            return tostring(Value.ClassName)
        else
            return typeof(Value)
        end
    end
    return nil
end

function ChaosFunctions.stringToPlayer(PlayerString)
    if not ChaosFunctions.checkType(PlayerString,"string") then
        return "Expected string!"
    end
    PlayerString = tostring(PlayerString):lower()
    for _,v in next, Players:GetPlayers() do
        if (string.sub(v.Name:lower(), 1, PlayerString:len()) == PlayerString:lower()) or (string.sub(v.DisplayName:lower(), 1, PlayerString:len()) == PlayerString:lower()) then
            return v
        end
    end
    return nil
end

function ChaosFunctions.checkForCharacter(Player, IsString) -- only use isstring if you're lazy XDD
    if IsString and ChaosFunctions.checkType(Player, "string") and ChaosFunctions.stringToPlayer(Player) and ChaosFunctions.checkType(ChaosFunctions.stringToPlayer(Player), "Player") and ChaosFunctions.stringToPlayer(Player).Character then
        return true
    elseif ChaosFunctions.checkType(Player,"Player") and Player.Character then
        return true
    end
    return false
end

function ChaosFunctions.checkForRootPart(Player) -- supports string, character too
    if ChaosFunctions.checkType(Player,"Player") and ChaosFunctions.checkForCharacter(Player) and Player.Character:FindFirstChild("HumanoidRootPart") then
        return true,Player.Character:FindFirstChild("HumanoidRootPart")
    elseif ChaosFunctions.checkType(Player,"Model") and Players:GetPlayerFromCharacter(Player) and Player:FindFirstChild("HumanoidRootPart") then
        return true,Player:FindFirstChild("HumanoidRootPart")
    elseif ChaosFunctions.checkType(Player,"string") and ChaosFunctions.stringToPlayer(Player) and ChaosFunctions.checkForCharacter(ChaosFunctions.stringToPlayer(Player)) and ChaosFunctions.stringToPlayer(Player).Character:FindFirstChild("HumanoidRootPart") then
        return true,ChaosFunctions.stringToPlayer(Player).Character:FindFirstChild("HumanoidRootPart")
    end
    return false
end

function ChaosFunctions.getClosestPlayer()
    local ClosestDistance = math.huge
    local ClosestPlayer = nil;
    for i,v in next, Players:GetPlayers() do
        if v~=LocalPlayer and ChaosFunctions.checkForRootPart(v) then
            if ChaosFunctions.checkForRootPart(LocalPlayer) and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < ClosestDistance then
                ClosestDistance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - v.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
                ClosestPlayer = v
            end
        end
    end
    return ClosestPlayer
end

function ChaosFunctions.getClosestCharacter()
    return ChaosFunctions.getClosestPlayer().Character
end

function ChaosFunctions.string.random(Length)
    math.randomseed(os.time() * tick())
    for i = 1,157 do
        math.random()
    end
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789~!@#$%^&*()-_=+[{]}|;:,<.>/?"
    local rstring = ""
    for i = 1,Length do
        local num = math.random(1,chars:len())
        rstring = rstring .. string.sub(chars,num,num)
    end
    return rstring
end

return ChaosFunctions -- returns the table with the functions on god cuh no cap fr fr
