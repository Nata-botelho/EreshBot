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
    local msgPrefix = string.sub(message.content, 1, 1)

    if(msgPrefix == prefix) then
        local answered = false
        local msgContent = string.lower(string.sub(message.content, 2))
        local msgCmd, msgArg = string.match(msgContent, '(%S+) (.*)')
        msgCmd = msgCmd or msgContent
        local msgMember = message.member
        local msgAuthor = message.author
        local msgGuild = message.guild
        local msgMentioned = message.mentionedUsers
        
        if(msgCmd == 'help')   then
            message.channel:send('Lista de comandos:\n>D4: lança um dado de 4 faces\n>D6: lança um dado de 6 faces\n>D8: lança um dado de 8 faces\n>D10: lança um dado de 10 faces\n>D12: lança um dado de 12 faces\n>D20: lança um dado de 20 faces\n\nbot feito por natã/wolfgan/bnegão :D')
            answered = true

        elseif(msgCmd == 'move')    then
            if(#msgMentioned == 1)  then
                local mentionedMember = msgGuild:getMember(msgMentioned[1][1])
                mentionedMember:setVoiceChannel(msgMember.voiceChannel.id)
                message.channel:send(mentionedMember.nickname..' foi movido para o canal '..msgMember.voiceChannel.name..' por '..msgMember.nickname)
                answered = true
            end

        elseif(answered == false) then
            local result = dice(msgCmd)
            if(type(result) == "number")  then 
                if(msgMember and msgMember.nickname ~= nil) then
                    message.channel:send(msgMember.nickname..' tirou: '..result)
                else
                    message.channel:send(msgAuthor.name..' tirou: '..result)
                end
                answered = true
            end

        elseif (answered == false) then
            message.channel:send('Comando não encontrado! Digite >help para ver a lista de comandos')
            answered = true
        end
    end
end)

--função que retorna o valor do dado
dice = function(message)
    if (message == 'd4') then
        return(math.random(1, 4))
    elseif (message =='d6') then
        return(math.random(1, 6))
    elseif (message == 'd8') then
        return(math.random(1, 8))
    elseif (message == 'd10') then
        return(math.random(1, 10))
    elseif (message == 'd12') then
        return(math.random(1, 12))
    elseif (message == 'd20') then
        return(math.random(1, 20))
    else    return "error"
    end
end 

client:run("Bot "..token)