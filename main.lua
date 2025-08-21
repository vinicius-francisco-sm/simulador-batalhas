-- Dependencias
local utils = require("utils")
local player = require("player.player")
local playerActions = require("player.actions")
local colossus = require("colossus.colossus")

-- Habilitar UTF-8 no terminal
utils.enableUtf8()

-- Header
utils.printHeader()

-- Obter definição do monstro
local boss = colossus

-- Apresentar o monstro
utils.printCreature(boss)

-- Buildar a lista de ações
playerActions.build()

-- Começar o loop de batalha
while true do
  
  -- Mostrar ações para o jogador
  print()
  print("O que você deseja fazer em seguida?")
  local validPlayerActions = playerActions.getValidActions(player, boss)
  for i, action in pairs(validPlayerActions) do
    print(string.format("%d: %s", i, action.description))
  end
  local chosenIndex = utils.ask()
  local chosenAction = validPlayerActions[chosenIndex]
  local isActionValid = chosenAction ~= nil

  -- Simular o turno do jogador
  if isActionValid then
    chosenAction.execute(player, boss)
  else
    print("Sua ação é inválida. Você perdeu a vez!")
  end

  -- Ponto de saída: Criatura ficou sem vida
  if boss.health <= 0 then
    break
  end
  
  -- Simular o turno da criatura
  -- TODO

  -- Ponto de saída: Jogador ficou sem vida
  if player.health <= 0 then
    break
  end
end

-- Fim