-- Dependencias

local player = require("definitions.player")
local colossus = require("definitions.colossus")

-- Habilitar UTF-8 no terminal

os.execute("chcp 65001")



-- Header

print([[
=========================================================================

                  _
       _         | |
      | | _______| |---------------------------------------------\
      |:-)_______|==[]============================================>
      |_|        | |---------------------------------------------/
                 |_|

                 ----------------------------------------

                        ⚔️  SIMULADOR DE BATALHA ⚔️

=========================================================================

                Você empunha sua espada e se prepara para lutar.
                                É hora da batalha!

]])

-- Obter definição do jogador

print(string.format("A vida do jogador é %d/%d", player.health, player.maxHealth))

-- Obter definição do monstro

local boss = colossus