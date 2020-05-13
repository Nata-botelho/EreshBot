local discordia = require('discordia')
local client = discordia.Client()
local prefix = ">"

local file = io.open("token.tkn", "r")
local token = file:read "*a"
file:close()

--initialize random number generation for dices
math.randomseed(os.time())
math.random(); math.random(); math.random()

client:on('ready', function()
    client:setGame('Fate/Grand Order')
    print("Logged as "..client.user.username)
end)

client:on('memberJoin', function(member)
    member.guild.systemChannel:send('Fala fiote '..member.name)
end)

client:on('memberLeave', function(member)
    member.guild.systemChannel:send('Valeeeeu falooooou '..member.name)
end)

client:on('memberUpdate', function(member)
    if(string.lower(member.highestRole.name) == 'inclusão social')  then
        member.guild.systemChannel:send(member.name..' entrou no programa de cotas!')
    end
end)

--recebe uma mensagem do canal
client:on('messageCreate', function(message)
    local msgPrefix = string.sub(message.content, 1, 1)

    if(message.content == 'dadinho')    then
        message.channel:send('dadinho é o krl meu nome agr é zé pequeno porra!')
    end

    if(msgPrefix == prefix) then
        local answered = false
        local msgContent = string.lower(string.sub(message.content, 2))
        local msgCmd, msgArg = string.match(msgContent, '(%S+) (.*)')
        msgCmd = msgCmd or msgContent
        local member = message.member
        local author = message.author
        local guild = message.guild
        local mentioned = message.mentionedUsers
        
        if(msgCmd == 'help')   then
            message.channel:send('Lista de comandos:\nDados:\n>D4: lança um dado de 4 faces\n>D6: lança um dado de 6 faces\n>D8: lança um dado de 8 faces\n>D10: lança um dado de 10 faces\n>D12: lança um dado de 12 faces\n>D20: lança um dado de 20 faces\n\n>Discordia: Github Discordia\n>MemberCount: número de membros no server\n>Move @(usuario): move o usuário mencionado para o seu canal\n>Region: mostra a região atual do servidor\n\nbot feito por natã/wolfgan/bnegão :D')
            answered = true

        elseif(msgCmd == 'move' and guild)    then
            if(#mentioned == 1)  then
                local mentionedMember = guild:getMember(mentioned[1][1])
                mentionedMember:setVoiceChannel(member.voiceChannel.id)
                message.channel:send(mentionedMember.nickname..' foi movido para o canal '..member.voiceChannel.name..' por '..member.nickname)
                answered = true
            end

        elseif(msgCmd == 'discordia')    then
            message.channel:send('https://github.com/SinisterRectus/Discordia')
            answered = true

        elseif(msgCmd == 'membercount' and guild)    then
            message.channel:send('O servidor está atualmente com '..guild.totalMemberCount..' membros')
            answered = true
        
        elseif(msgCmd == 'region' and guild)    then
            message.channel:send('Região do servidor: '..guild.region)
            answered = true

        elseif(msgCmd == 'ban' and guild)    then
            if(#mentioned == 1)  then
                local mentionedMember = guild:getMember(mentioned[1][1])
                message.channel:send('Banindo '..mentionedMember.nickname..' em 10 segundos')
                answered = true
            end
            
            
        elseif(answered == false) then
            local result = dice(msgCmd)
            if(type(result) == "number")  then 
                if(member and member.nickname ~= nil) then
                    message.channel:send(member.nickname..' tirou: '..result)
                else
                    message.channel:send(author.name..' tirou: '..result)
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