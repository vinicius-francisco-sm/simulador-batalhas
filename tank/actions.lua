local utils = require "utils"

local actions = {}

actions.list = {}


---Cria uma lista de ações que é armazenada internamente
function actions.build()
  -- Resetar lista
  actions.list = {}

  -- Atacar com o escudo
  local shieldAttack = {
    description = "Atacar com o escudo.",
    requirement = nil,
    execute = function (playerData, creatureData)
      -- 1. Definir chance de sucesso
      local successChance = creatureData.speed == 0 and 1 or playerData.speed / creatureData.speed
      local success = math.random() <= successChance

      -- 2. Calcular dano
      local rawDamage = playerData.attack - math.random() * creatureData.defense
      local damage = math.max(1, math.ceil(rawDamage))

      -- 3. Aplicar o dano em caso de sucesso
      if success then
        creatureData.health = creatureData.health - damage
        
        
        -- 4. Apresentar resultado como print
        print(string.format("%s atacou %s e deu %d pontos de dano!", playerData.name, creatureData.name, damage))
        -- calcula o indice de vida
        local healthRate = math.ceil((creatureData.health / creatureData.maxHealth) * 10)
        print(string.format("%s: %s", creatureData.name, utils.getProgressBar(healthRate)))
      else
        print(string.format("%s tentou atacar, mas errou!", playerData.name))
      end
    end
  }

  -- Aumentar sua defesa
  local defenseBuff = {
    description = "Roubar capacidade de defesa.",
    requirement = function (playerData, creatureData)
      return playerData.mana > 0
    end,
    execute = function (playerData, creatureData)
      -- 1. Calcular chance de sucesso
      local success = math.random() <= 0.3
      local defensePoints = 2

      if success then
        print(string.format("%s roubou %d pontos de defesa de %s", playerData.name, defensePoints, creatureData.name))

        playerData.mana = playerData.mana - 1
        playerData.defense = playerData.defense + defensePoints
        creatureData.defense = math.max(1, creatureData.defense - defensePoints)
      else
        print(string.format("A habilidade de %s falhou!", playerData.name))
        playerData.mana = playerData.mana - 1
      end
    end
  }

  -- Esquivar
  local dodge = {
    description = "Tentar se esquivar.",
    requirement = function (playerData, creatureData)
      return playerData.isVisible and playerData.dodgeChances > 0
    end,
    execute = function (playerData, creatureData)
      -- 1. Baseado na velocidade do player e da criatura, calcular chance de sucesso
      local successChance = creatureData.speed == 0 and 1 or playerData.speed / creatureData.speed
      local success = math.random() <= successChance

      -- 2. Printar na tela sucesso ou falha
      if success then
        print(string.format("%s conseguiu se esquivar! Não receberá dano direto.", playerData.name))
        
        -- 3. Atualizar visibilidade do jogador
        playerData.isVisible = false
        playerData.dodgeChances = playerData.dodgeChances - 1
      else
        print(string.format("%s tentou se esquivar, mas foi muito lento...", playerData.name))
      end
    end
  }

  -- Usar poção de regeneração
  local regenPotion = {
    description = "Tomar uma poção de regeneração.",
    requirement = function (playerData, creatureData)
      return playerData.potions >= 1
    end,
    execute = function (playerData, creatureData)
      -- Tirar poção do inventário
      playerData.potions = playerData.potions - 1

      -- Recuperar vida
      local regenPoints = 10
      playerData.health = math.min(playerData.maxHealth, playerData.health + regenPoints)
      print(string.format("%s usou uma poção e recuperou alguns pontos de vida!", playerData.name))
    end
  }

  -- Popular lista
  actions.list[#actions.list + 1] = shieldAttack
  actions.list[#actions.list + 1] = defenseBuff
  actions.list[#actions.list + 1] = dodge
  actions.list[#actions.list + 1] = regenPotion
end


---Retorna uma lista de ações válidas
---@param playerData table
---@param creatureData table
---@return table
function actions.getValidActions(playerData, creatureData)
  local validActions = {}

  for _, action in pairs(actions.list) do
    local requirement = action.requirement
    local isValid = requirement == nil or requirement(playerData, creatureData)

    if isValid then
      validActions[#validActions + 1] = action
    end
  end
  return validActions
end

return actions