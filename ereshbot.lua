local discordia = require('discordia')
local client = discordia.Client()
local prefix = ">"

local file = io.open("token.tkn", "r")
local token = file:read "*a"
file:close()

--initialize random number generation for dices
math.randomseed(os.time())
math.random(); math.random(); math.random()

--recebe uma mensagem do canal
client:on('messageCreate', function(message)
    answered = false

    if(message.content == prefix..'help')   then
        message.channel:send('Lista de comandos:')
        message.channel:send('>D4: lança um dado de 4 faces')
        message.channel:send('>D6: lança um dado de 6 faces')
        message.channel:send('>D8: lança um dado de 8 faces')
        message.channel:send('>D10: lança um dado de 10 faces')
        message.channel:send('>D12: lança um dado de 12 faces')
        message.channel:send('>D20: lança um dado de 20 faces')

        message.channel:send('>bot feito por natã/wolfgan/bnegão :D')
        answered = true

    elseif(answered == false) then
        result = dice(message)
        if(type(result) == "number")  then 
            if(message.member) then
                message.channel:send(message.member.nickname..' tirou: '..result)
            else
                message.channel:send(message.author.name..' tirou: '..result)
            end
            answered = true
        end

    elseif (string.sub(message.content, 1, 1) == prefix and answered == false) then
        message.channel:send('Comando não encontrado! Digite >help para ver a lista de comandos')
        answered = true
    end
end)

--função que retorna o valor do dado
dice = function(message)
    if (message.content == prefix..'d4' or message.content == prefix..'D4') then
        return(math.random(1, 4))
    elseif (message.content == prefix..'d6' or message.content == prefix..'D6') then
        return(math.random(1, 6))
    elseif (message.content == prefix..'d8' or message.content == prefix..'D8') then
        return(math.random(1, 8))
    elseif (message.content == prefix..'d10' or message.content == prefix..'D10') then
        return(math.random(1, 10))
    elseif (message.content == prefix..'d12' or message.content == prefix..'D12') then
        return(math.random(1, 12))
    elseif (message.content == prefix..'d20' or message.content == prefix..'D20') then
        return(math.random(1, 20))
    else    return "error"
    end
end

client:run("Bot "..token)