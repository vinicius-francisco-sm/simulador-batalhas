-- Dependencias

local utils = require("utils")
local player = require("definitions.player")
local colossus = require("definitions.colossus")

-- Habilitar UTF-8 no terminal

utils.enableUtf8()



-- Header

utils.printHeader()

-- Obter definição do monstro

local boss = colossus

-- Apresentar o monstro

utils.printCreature(boss)