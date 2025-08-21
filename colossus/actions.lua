local utils = require "utils"

local actions = {}

actions.list = {}


---Cria uma lista de ações que é armazenada internamente
function actions.build()
  -- Resetar lista
  actions.list = {}

  -- Atacar com espada
  local bodyAttack = {
    description = "Atacar corpo a corpo.",
    requirement = function (playerData, creatureData)
      return playerData.isVisible
    end,
    execute = function (playerData, creatureData)
      -- 1. O ataque tem sempre 100% de chance de sucesso

      -- 2. Calcular dano
      local rawDamage = creatureData.attack - math.random() * playerData.defense
      local damage = math.max(1, math.ceil(rawDamage * 0.3))

      -- 3. Aplicar o dano 
      playerData.health = playerData.health - damage
      
      
      -- 4. Apresentar resultado como print
      print(string.format("%s atacou %s e deu %d pontos de dano!", creatureData.name, playerData.name, damage))
      -- calcula o indice de vida
      local healthRate = math.ceil((playerData.health / playerData.maxHealth) * 10)
      print(string.format("%s: %s", playerData.name, utils.getProgressBar(healthRate)))
      
    end
  }

  -- Atacar com sonar
  local sonarAttack = {
    description = "Atacar com sonar.",
    requirement = nil,
    execute = function (playerData, creatureData)
      -- 1. O ataque tem sempre 100% de chance de sucesso

      -- 2. Calcular dano
      local rawDamage = creatureData.attack - math.random() * playerData.defense
      local damage = math.max(1, math.ceil(rawDamage * 0.3))

      -- 3. Aplicar o dano 
      playerData.health = playerData.health - damage
      
      
      -- 4. Apresentar resultado como print
      print(string.format("%s atacou %s com um sonar e deu %d pontos de dano!", creatureData.name, playerData.name, damage))
      -- calcula o indice de vida
      local healthRate = math.ceil((playerData.health / playerData.maxHealth) * 10)
      print(string.format("%s: %s", playerData.name, utils.getProgressBar(healthRate)))
      
    end
  }
  
  -- Aguardar
  local waitAction = {
    description = "Aguardar.",
    requirement = nil,
    execute = function (playerData, creatureData)
      -- 1. Apresentar resultado como print
      print(string.format("%s errou!", creatureData.name))
    end
  }

  -- Popular lista
  actions.list[#actions.list + 1] = bodyAttack
  actions.list[#actions.list + 1] = sonarAttack
  actions.list[#actions.list + 1] = waitAction
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