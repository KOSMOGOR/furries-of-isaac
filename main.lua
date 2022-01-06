local FurriesOfIsaac = RegisterMod("Furries of Isaac", 1)
local SaveState = {}

local RebirthOrder = {"Isaac", "Magdalene", "Cain", "Judas", "???"," Eve", "Samson", "Azazel", "Lazarus", "Eden", "The Lost"}
local RebirthSettings = {}
local ABRepOrder = {"Lilith", "Keeper", "Apollyon", "The Forgotten", "Bethany", "J&E"}
local ABRepSettings = {}
local PLayerColors = {0, 0, 0, 0}
local ColorToStr = {"", "_black", "_blue", "_red", "_green", "_grey"}

---------------------------------------------------------------
------------------------Mod Config Menu------------------------
function FurriesOfIsaac:ModConfigInit()
    if ModConfigMenu then
        local ModName = "Furries of Isaac"
        ModConfigMenu.SetCategoryInfo(ModName, "Furries of Isaac config")

        for _, i in ipairs(RebirthOrder) do
            ModConfigMenu.AddSetting(ModName, "Rebirth",
                {
                    Type = ModConfigMenu.OptionType.BOOLEAN,
                    CurrentSetting = function()
                        return RebirthSettings[i]
                    end,
                    Display = function()
                        local onOff = "False"
                        if RebirthSettings[i] then
                            onOff = "True"
                        end
                        return i .. ": " .. onOff
                    end,
                    OnChange = function(currentBool)
                        RebirthSettings[i] = currentBool
                    end
                })
        end
        for _, i in ipairs(ABRepOrder) do
            ModConfigMenu.AddSetting(ModName, "AB/Rep",
                {
                    Type = ModConfigMenu.OptionType.BOOLEAN,
                    CurrentSetting = function()
                        return ABRepSettings[i]
                    end,
                    Display = function()
                        local onOff = "False"
                        if ABRepSettings[i] then
                            onOff = "True"
                        end
                        return i .. ": " .. onOff
                    end,
                    OnChange = function(currentBool)
                        ABRepSettings[i] = currentBool
                    end
                })
        end
    end
end
FurriesOfIsaac:ModConfigInit()

---------------------------------------------------------------
---------------------------Savedata----------------------------
local json = require("json")

function FurriesOfIsaac:SaveGame()
	SaveState.Rebirth = {}
	SaveState.ABRep = {}
	for i, v in ipairs(RebirthOrder) do
		SaveState.Rebirth[i] = RebirthSettings[v]
	end
	for i, v in ipairs(ABRepOrder) do
		SaveState.ABRep[i] = ABRepSettings[v]
	end
    FurriesOfIsaac:SaveData(json.encode(SaveState))
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, FurriesOfIsaac.SaveGame)

local loaded = false
function FurriesOfIsaac:OnGameStart(isSave)
    if not loaded then
        if FurriesOfIsaac:HasData() then
            SaveState = json.decode(FurriesOfIsaac:LoadData())
            for i, v in pairs(SaveState.Rebirth) do
                RebirthSettings[RebirthOrder[i]] = v
            end
            for i, v in pairs(SaveState.ABRep) do
                ABRepSettings[ABRepOrder[i]] = v
            end
        else
            for i, v in pairs(RebirthOrder) do
                RebirthSettings[v] = true
            end
            for i, v in pairs(ABRepOrder) do
                ABRepSettings[v] = true
            end
        end
        loaded = true
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FurriesOfIsaac.OnGameStart)

---------------------------------------------------------------
------------------------------Main-----------------------------
function ChangeSprite(sprite, path)
    for i = 0, 12 do
        sprite:ReplaceSpritesheet(i, path)
    end
    sprite:ReplaceSpritesheet(14, path)
end

function LoadCharacter(player, char, color)
    if color < 0 or color > 5 then
        color = 0
    end
    player:GetSprite():Load("gfx1/001.000_player.anm2", false)
    ChangeSprite(player:GetSprite(), "gfx1/characters/costumes/" .. char.Sprite .. ColorToStr[color + 1] .. ".png")
    player:GetSprite():LoadGraphics()
    if char.Costume ~= nil then
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx1/characters/" .. char.Costume))
    end
end

local characters = {
    [PlayerType.PLAYER_ISAAC] = {
        Enabled = function ()
            return RebirthSettings["Isaac"]
        end,
        Sprite = "character_001_isaac"
    },
    [PlayerType.PLAYER_MAGDALENA] = {
        Enabled = function ()
            return RebirthSettings["Isaac"]
        end,
        Sprite = "character_002_magdalene",
        Costume = "character_002_magdalenehead.anm2"
    },
    [PlayerType.PLAYER_LILITH] = {
        Enabled = function ()
            return ABRepSettings["Lilith"]
        end,
        Sprite = "character_014_lilith",
        Costume = "character_lilithhair.anm2"
    },
    [PlayerType.PLAYER_JACOB] = {
        Enabled = function ()
            return ABRepSettings["J&E"]
        end,
        Sprite = "character_002x_jacob",
        Costume = "character_002x_jacobhead.anm2"
    },
    [PlayerType.PLAYER_ESAU] = {
        Enabled = function ()
            return ABRepSettings["J&E"]
        end,
        Sprite = "character_003x_esau",
        Costume = "character_003x_esauhead.anm2"
    },
}

function FurriesOfIsaac:onPlayerInit(player)
    for type, char in pairs(characters) do
        if player:GetPlayerType() == type and char.Enabled() then
            LoadCharacter(player, char, player:GetBodyColor())
        end
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FurriesOfIsaac.onPlayerInit)

function FurriesOfIsaac:onChangeColor(player)
    for i = 0, Game():GetNumPlayers() do
        local player = Game():GetPlayer(i)
        if PLayerColors[i] ~= player:GetBodyColor() then
            PLayerColors[i] = player:GetBodyColor()
            LoadCharacter(player, characters[player:GetPlayerType()], player:GetBodyColor())
        end
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_UPDATE, FurriesOfIsaac.onChangeColor)