local FurriesOfIsaac = RegisterMod("Furries of Isaac", 1)
local SaveState = {}

local RebirthOrder = {"Isaac", "Magdalene", "Cain", "Judas", "???"," Eve", "Samson", "Azazel", "Lazarus", "Eden", "The Lost"}
local RebirthSettings = {}
local ABRepOrder = {"Lilith", "Keeper", "Apollyon", "The Forgotten", "Bethany", "J&E"}
local ABRepSettings = {}

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
function ChangeCharacter(sprite, path)
    for i = 0, 12 do
        sprite:ReplaceSpritesheet(i, path)
    end
    sprite:ReplaceSpritesheet(14, path)
end

function FurriesOfIsaac:onPlayerInit(player)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC and RebirthSettings["Isaac"] then
        player:GetSprite():Load("gfx1/001.000_player.anm2", false)
        player:GetSprite():ReplaceSpritesheet(0, "gfx1/characters/costumes/character_001_isaac.png")
        player:GetSprite():LoadGraphics()
    end

    if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENA and RebirthSettings["Magdalene"] then
        player:GetSprite():Load("gfx1/001.000_player.anm2", false)
        ChangeCharacter(player:GetSprite(), "gfx1/characters/costumes/character_002_magdalene.png")
        player:GetSprite():LoadGraphics()
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx1/characters/character_002_magdalenehead.anm2"))
    end

    if player:GetPlayerType() == PlayerType.PLAYER_JACOB and ABRepSettings["J&E"] then
        player:GetSprite():Load("gfx1/001.000_player.anm2", false)
        ChangeCharacter(player:GetSprite(), "gfx1/characters/costumes/character_002x_jacob.png")
        player:GetSprite():LoadGraphics()
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx1/characters/character_002x_jacobhead.anm2"))
    end
    if player:GetPlayerType() == PlayerType.PLAYER_ESAU and ABRepSettings["J&E"] then
        player:GetSprite():Load("gfx1/001.000_player.anm2", false)
        ChangeCharacter(player:GetSprite(), "gfx1/characters/costumes/character_003x_esau.png")
        player:GetSprite():LoadGraphics()
        player:AddNullCostume(Isaac.GetCostumeIdByPath("gfx1/characters/character_003x_esauhead.anm2"))
    end
end
FurriesOfIsaac:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, FurriesOfIsaac.onPlayerInit)