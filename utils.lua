local utils = {}

---
--- Habilita o modo UTF-8 no terminal, 
--- para retornar carcteres acentuados e emojis.
--- 
function utils.enableUtf8()
  os.execute("chcp 65001")
end


---
--- Faz o print da apresentação do simulador no terminal.
---
function utils.printHeader()
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
end

---
---Calcula uma barra de progresso ASCII baseada em um atributo.
---@param attribute number Número de 0 a 10.
---@return string
---
function utils.getProgressBar(attribute)
    local fullChar = "💀"
    local emptyChar = "🖤"

    local result = ""
    for i = 1, 10, 1 do
        result = result .. (i <= attribute and fullChar or emptyChar) -- funciona como operador ternário
    end
    return result
end

---
---Faz o print das informações de uma criatura.
---@param creature table
---
function utils.printCreature(creature)
  -- calcula o indice de vida
  local healthRate = math.ceil((creature.health / creature.maxHealth) * 10)

  -- cartão
  print(" | " .. creature.name)
  print(" | ")
  print(" | " .. creature.description)
  print(" | ")
  print(" | Atributos")
  print(" |    Vida:          " .. utils.getProgressBar(healthRate))
  print(" |    Ataque:        " .. utils.getProgressBar(creature.attack))
  print(" |    Defesa:        " .. utils.getProgressBar(creature.defense))
  print(" |    Velocidade:    " .. utils.getProgressBar(creature.speed))
end

---Pergunta ao usuário por um número e retorna este valor
---@return any
function utils.ask(message)
  local text = message or ''
  io.write(text .. "> ")
  local answer = io.read()
  answer = tonumber(answer)
  os.execute("cls")
  return answer
end

return utils