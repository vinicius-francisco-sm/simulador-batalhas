-- Dependencias
local utils = require("utils")
local fencer = require("fencer.fencer")
local fencerActions = require("fencer.actions")
local gunslinger = require("gunslinger.gunslinger")
local gunslingerActions = require("gunslinger.actions")
local tank = require("tank.tank")
local tankActions = require("tank.actions")
local colossus = require("colossus.colossus")
local colossusActions = require("colossus.actions")

-- Habilitar UTF-8 no terminal
utils.enableUtf8()

-- Header
utils.printHeader()

-- Obter definição do player
local player = {}
local playerActions = {}

while true do
  -- 1. Mostrar personagens jogaveis
  local characterList = {}

  characterList[#characterList+1] = {
    character = fencer,
    actions = fencerActions
  }
  characterList[#characterList+1] = {
    character = gunslinger,
    actions = gunslingerActions
  }
  characterList[#characterList+1] = {
    character = tank,
    actions = tankActions
  }

  -- 2. Permitir entrada do usuário para escolha
  for i, option in pairs(characterList) do
    utils.printCreature(option.character, string.format("%d: Para escolher este personagem", i))
  end
  local chosenOption = utils.ask("Escolha um personagem")

  if characterList[chosenOption] ~= nil then
    -- 3. Atribuir o personagem escolhido ao player
    player = characterList[chosenOption].character
    playerActions = characterList[chosenOption].actions
    break
  end
end

-- Obter definição do monstro
local boss = colossus
local bossActions = colossusActions

-- Apresentar o monstro
utils.printCreature(boss, "Seu adversário:")
utils.ask("Qualquer tecla para continuar")

-- Buildar a lista de ações
playerActions.build()
bossActions.build()

-- Começar o loop de batalha
while true do
  
  -- Mostrar ações para o jogador
  print()
  print(string.format("Qual será a próxima ação de %s?", player.name))
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
    print(string.format("Sua escolha é inválida. %s perdeu a vez!", player.name))
  end

  -- Ponto de saída: Criatura ficou sem vida
  if boss.health <= 0 then
    break
  end
  
  -- Simular o turno da criatura
  print()
  local validBossActions = bossActions.getValidActions(player, boss)
  local bossAction = validBossActions[math.random(#validBossActions)]
  bossAction.execute(player, boss)

  -- Ponto de saída: Jogador ficou sem vida
  if player.health <= 0 then
    break
  end
end

-- Processar condições de derrota e vitória
if player.health <= 0 then
    print()
    print("-------------------------------------------------------------------------")
    print()
    print("😭💀")
    print(string.format("%s não foi capaz de vencer %s!", player.name, boss.name))
    print("Quem sabe na próxima vez...")
    print()
elseif boss.health <= 0 then
    print()
    print("-------------------------------------------------------------------------")
    print()
    print("🥳🎉")
    print(string.format("%s prevaleceu e venceu %s!", player.name, boss.name))
    print("Parabéns!!!")
    print()
end