local discordia = require('discordia')
local client = discordia.Client()
local prefix = ">"

--local file = io.open("token.tkn", "r")
--local token = file:read "*a"
--file:close()
local token = "NzA5MDY1OTEwMDk0MjY2NDI4.XrgfFg.xK1GWGVhQNZny2msEXHKfs-mP-Q"

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
            message:reply {
                embed = {
                    title = "Help Page",
                    description = "Fala fiote, sou a EreshBot (referência  a melhor lancer de fate)",
                    author = {
                        name = client.user.name,
                        icon_url = client.user.avatarURL
                    },
                    fields = { -- array of fields
                        {
                            name = "MUSIC",
                            value = "`play radio:`  Toca a rádio Olimpo Rocks\n`play pause:`  Pausa o player de áudio\n`play resume:`  Reativa o player de áudio caso esteja pausado\n`play stop:`  Para o player de áudio e o desativa\n",
                            inline = false
                        },
                        {
                            name = "RPG",
                            value = "`d4:` Lança um dado de 4 faces\n`d6:` Lança um dado de 6 faces\n`d8:` Lança um dado de 8 faces\n`d10:` Lança um dado de 10 faces\n`d12:` Lança um dado de 12 faces\n`d20:` Lança um dado de 20 faces\n",
                            inline = false
                        },
                        {
                            name = "MISC",
                            value = "`discordia:` Link do github do discordia\n`ereshgit:` Link do github da EreshBot\n`membercount:` Mostra o número de membros do servidor\n`region` Mostra a região do servidor\n",
                            inline = false
                        },
                        {
                            name = "AUDIOS",
                            value = "'atumalaca'\n'cavalo'\n'ehmsmeh'\n'irra'\n'pare'\n'potencia'\n'qisso'\n'rapaz'\n'ratinho'\n'uepa'\n'xiii'\n",
                            inline = false
                        }
                    },
                    footer = {
                        text = "Created with Discordia by Natã Botelho"
                    },
                    color = 0xbd0000 -- hex color code
                }
            }      
            answered = true

        elseif(msgCmd == 'ereshgit') then
            message.channel:send('https://github.com/Nata-botelho/EreshBot')
            
        elseif(msgCmd == 'play')    then
            if(member)  then
                local connection = member.voiceChannel:join()
                if(msgArg == 'radio')   then  
                    coroutine.wrap(function() 
                        message.channel:send('Tocando rádio Olimpo Rocks')
                        connection:playFFmpeg('http://olimpo.rocks:8000/jazz')
                    end)()
                elseif(msgArg == 'pause')   then
                    connection:pauseStream()
                    message.channel:send('Player pausado')
                elseif(msgArg == 'stop')    then
                    connection:stopStream()
                    connection:close()
                    message.channel:send('Player fechado')
                elseif(msgArg == 'resume')  then
                    connection:resumeStream()

                end
            end

        elseif(msgCmd == 'rapaz') then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/rapaz.mp3')
        
        elseif(msgCmd == 'cavalo') then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/cavalo.mp3')

        elseif(msgCmd == 'irra') then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/irra.mp3')

        elseif(msgCmd == 'xiii')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/xiii.mp3')
        
        elseif(msgCmd == 'pare')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/pare.mp3')

        elseif(msgCmd == 'potencia')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/potencia.mp3')

        elseif(msgCmd == 'qisso')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/qisso.mp3')
        
        elseif(msgCmd == 'ratinho')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/ratinho.mp3')

        elseif(msgCmd == 'uepa')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/uepa.mp3')

        elseif(msgCmd == 'ehmsmeh')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/ehmsmeh.mp3')

        elseif(msgCmd == 'atumalaca')    then
            local connection = member.voiceChannel:join()
            connection:playFFmpeg('audios/atumalaca.mp3')

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