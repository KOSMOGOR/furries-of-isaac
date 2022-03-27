local FurriesOfIsaac = RegisterMod("FurriesOfIsaac", 1)
local CostumeProtector = include("characterCostumeProtector")
CostumeProtector:Init(FurriesOfIsaac)
local SaveState = {}
local function has_value(tab, val)
    for index, value in ipairs(tab) do if value == val then return true end end return false
end

local RebirthOrder = {"Isaac", "Magdalene", "Cain", "Judas", "???", "Eve", "Samson", "Azazel", "Lazarus", "Eden", "The Lost"}
local RebirthSettings = {}
local ABRepOrder = {"Lilith", "Keeper", "Apollyon", "The Forgotten", "Bethany", "J&E"}
local ABRepSettings = {}
local colorCharacters = {"Isaac", "Magdalena", "Cain", "Judas", "Eve", "Samson", "Eden", "Lazarus", "Bethany", "J&E"}
local DefaultColors = {}
local PlayerColor = {-2, -2, -2, -2, -2, -2, -2, -2}
local ColorToStr = {"", "_white", "_black", "_blue", "_red", "_green", "_grey"}
local PogEnabled = true

local TypeToName = {
    [PlayerType.PLAYER_ISAAC] = "Isaac",
    [PlayerType.PLAYER_MAGDALENA] = "Magdalena",
    [PlayerType.PLAYER_CAIN] = "Cain",
    [PlayerType.PLAYER_JUDAS] = "Judas",
    [PlayerType.PLAYER_BLACKJUDAS] = "Judas",
    [PlayerType.PLAYER_XXX] = "???",
    [PlayerType.PLAYER_EVE] = "Eve",
    [PlayerType.PLAYER_SAMSON] = "Samson",
    [PlayerType.PLAYER_AZAZEL] = "Azazel",
    [PlayerType.PLAYER_LAZARUS] = "Lazarus",
    [PlayerType.PLAYER_LAZARUS2] = "Lazarus",
    [PlayerType.PLAYER_EDEN] = "Eden",
    [PlayerType.PLAYER_THELOST] = "The Lost",
    [PlayerType.PLAYER_LILITH] = "Lilith",
    [PlayerType.PLAYER_KEEPER] = "Keeper",
    [PlayerType.PLAYER_APOLLYON] = "Apollyon",
    [PlayerType.PLAYER_THEFORGOTTEN] = "The Forgotten",
    [PlayerType.PLAYER_THESOUL] = "The Forgotten",
    [PlayerType.PLAYER_BETHANY] = "Bethany",
    [PlayerType.PLAYER_JACOB] = "J&E",
    [PlayerType.PLAYER_ESAU] = "J&E",

    [PlayerType.PLAYER_ISAAC_B] = "Isaac",
    [PlayerType.PLAYER_MAGDALENA_B] = "Magdalena",
    [PlayerType.PLAYER_CAIN_B] = "Cain",
    [PlayerType.PLAYER_JUDAS_B] = "Judas",
    [PlayerType.PLAYER_XXX_B] = "???",
    [PlayerType.PLAYER_EVE_B] = "Eve",
    [PlayerType.PLAYER_SAMSON_B] = "Samson",
    [PlayerType.PLAYER_AZAZEL_B] = "Azazel",
    [PlayerType.PLAYER_LAZARUS_B] = "Lazarus",
    [PlayerType.PLAYER_LAZARUS2_B] = "Lazarus",
    [PlayerType.PLAYER_EDEN_B] = "Eden",
    [PlayerType.PLAYER_THELOST_B] = "The Lost",
    [PlayerType.PLAYER_LILITH_B] = "Lilith",
    [PlayerType.PLAYER_KEEPER_B] = "Keeper",
    [PlayerType.PLAYER_APOLLYON_B] = "Apollyon",
    [PlayerType.PLAYER_THEFORGOTTEN_B] = "The Forgotten",
    [PlayerType.PLAYER_THESOUL_B] = "The Forgotten",
    [PlayerType.PLAYER_BETHANY_B] = "Bethany",
    [PlayerType.PLAYER_JACOB_B] = "J&E",
    [PlayerType.PLAYER_JACOB2_B] = "J&E"
}

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

        local allColor = {"standard", "white", "black", "blue", "red", "green", "grey"}
        for _, i in ipairs(colorCharacters) do
            ModConfigMenu.AddSetting(ModName, "Default colors",
                {
                    Type = ModConfigMenu.OptionType.NUMBER,
                    CurrentSetting = function()
                        return DefaultColors[i]
                    end,
                    Display = function()
                        return i .. ": " .. allColor[DefaultColors[i] + 2]
                    end,
                    Minimum = -1,
                    Maximum = 5,
                    OnChange = function(currentNum)
                        DefaultColors[i] = currentNum
                    end
                })
        end

        ModConfigMenu.AddSetting(ModName, "Misc",
            {
                Type = ModConfigMenu.OptionType.BOOLEAN,
                CurrentSetting = function()
                    return PogEnabled
                end,
                Display = function()
                    local onOff = "False"
                    if PogEnabled then
                        onOff = "True"
                    end
                    return "Custom POG animations: " .. onOff
                end,
                OnChange = function(currentBool)
                    PogEnabled = currentBool
                end
            })
    end
end
FurriesOfIsaac:ModConfigInit()

---------------------------------------------------------------
---------------------------Savedata----------------------------
local json = require("json")

function FurriesOfIsaac:SaveGame()
	SaveState.Rebirth = {}
	SaveState.ABRep = {}
    SaveState.DefaultColors = DefaultColors
    SaveState.PogEnabled = PogEnabled
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
function FurriesOfIsaac:LoadSave()
    if not loaded then
        if FurriesOfIsaac:HasData() then
            SaveState = json.decode(FurriesOfIsaac:LoadData())
            for i, v in pairs(SaveState.Rebirth) do
                RebirthSettings[RebirthOrder[i]] = v
            end
            for i, v in pairs(SaveState.ABRep) do
                ABRepSettings[ABRepOrder[i]] = v
            end
            PogEnabled = SaveState.PogEnabled
            DefaultColors = SaveState.DefaultColors
        else
            for i, v in ipairs(RebirthOrder) do
                RebirthSettings[v] = true
            end
            for i, v in ipairs(ABRepOrder) do
                ABRepSettings[v] = true
            end
            for i, v in ipairs(colorCharacters) do
                DefaultColors[v] = -1
            end
        end
        loaded = true
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FurriesOfIsaac.LoadSave)

---------------------------------------------------------------
------------------------------Main-----------------------------
function ChangeSprite(sprite, path)
    for i = 0, 12 do
        sprite:ReplaceSpritesheet(i, path)
    end
    sprite:ReplaceSpritesheet(14, path)
end

function LoadCharacter(player, char, color)
    if color < -1 or color > 5 then
        color = DefaultColors[TypeToName[player:GetPlayerType()]]
    end
    player:GetSprite():Load("gfx1/001.000_player.anm2", false)
    if has_value(colorCharacters, TypeToName[player:GetPlayerType()]) then
        ChangeSprite(player:GetSprite(), "gfx1/characters/costumes/" .. char.Sprite .. ColorToStr[color + 2] .. ".png")
    else
        ChangeSprite(player:GetSprite(), "gfx1/characters/costumes/" .. char.Sprite .. ".png")
    end
    player:GetSprite():LoadGraphics()
    if char.Costume ~= nil then
        for _, c in ipairs(char.Costume) do
            local costume = Isaac.GetCostumeIdByPath("gfx1/characters/" .. c .. ".anm2")
            local itemConfig = Isaac.GetItemConfig():GetNullItem(costume)
            local costumePath = "gfx1/characters/costumes/" .. c
            player:AddNullCostume(costume)
            player:ReplaceCostumeSprite(itemConfig, costumePath .. ColorToStr[color + 2] .. ".png", 0)
        end
    end
end

local characters = {
    [PlayerType.PLAYER_ISAAC] = {
        Enabled = function ()
            return RebirthSettings["Isaac"]
        end,
        Sprite = "character_001_isaac",
		Costume = {"costume_isaac_body", "costume_isaac_head"}
    },
    [PlayerType.PLAYER_MAGDALENA] = {
        Enabled = function ()
            return RebirthSettings["Magdalene"]
        end,
        Sprite = "character_002_magdalene",
        Costume = {"costume_maggy"}
    },
    [PlayerType.PLAYER_LILITH] = {
        Enabled = function ()
            return ABRepSettings["Lilith"]
        end,
        Sprite = "character_014_lilith",
        Costume = {"character_lilithhair"}
    },
    [PlayerType.PLAYER_JACOB] = {
        Enabled = function ()
            return ABRepSettings["J&E"]
        end,
        Sprite = "character_002x_jacob",
        Costume = {"character_002x_jacobhair"}
    },
    [PlayerType.PLAYER_ESAU] = {
        Enabled = function ()
            return ABRepSettings["J&E"]
        end,
        Sprite = "character_003x_esau",
        Costume = {"character_003x_esauhair"}
    },
}

function FurriesOfIsaac:onPlayerInit(player)
    for type, char in pairs(characters) do
        if player:GetPlayerType() == type and char.Enabled() then
            LoadCharacter(player, char, DefaultColors[TypeToName[player:GetPlayerType()]])
            CostumeProtector:AddPlayer(
                player,
                type,
                "gfx1/characters/costumes/" .. char.Sprite
            )
        end
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FurriesOfIsaac.onPlayerInit)

function FurriesOfIsaac:onChangeColor()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Game():GetPlayer(i)
        if player == nil then
            break
        end
        if characters[player:GetPlayerType()] and characters[player:GetPlayerType()].Enabled() and has_value(colorCharacters, TypeToName[player:GetPlayerType()]) and PlayerColor[i + 1] ~= player:GetBodyColor() then
            if player:GetBodyColor() ~= PlayerColor[i + 1] then
                LoadCharacter(player, characters[player:GetPlayerType()], DefaultColors[TypeToName[player:GetPlayerType()]])
            end
            PlayerColor[i + 1] = player:GetBodyColor()
        end
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_UPDATE, FurriesOfIsaac.onChangeColor)

function FurriesOfIsaac:onGameStart(IsContinued)
    if not IsContinued then
        PlayerColor = {-2, -2, -2, -2, -2, -2, -2, -2}
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, FurriesOfIsaac.onGameStart)
CostumeProtector.AddCallback("MC_POST_COSTUME_RESET", function (player)
    LoadCharacter(player, characters[player:GetPlayerType()], DefaultColors[TypeToName[player:GetPlayerType()]])
end)