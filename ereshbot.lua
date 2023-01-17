local discordia = require('discordia')
local http = require("http")
local spawn = require('coro-spawn')
local split = require('coro-split')
local parse = require('url').parse
local json = require('json')
local client = discordia.Client()
local prefix = ">"

--[[local port = process.env["PORT"]

http.createServer(function(req, res)
	local body = "Hello world\n"
	res:setHeader("Content-Type", "text/plain")
	res:setHeader("Content-Length", #body)
	res:finish(body)
end):listen(port)]]--

local token = ""

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

local streamQueue = {}

--recebe uma mensagem do canal
client:on('messageCreate', function(message)
    local msgPrefix = string.sub(message.content, 1, 1)

    if(msgPrefix == prefix) then
        local answered = false
        --local msgContent = string.lower(string.sub(message.content, 2))
        local msgContent = string.sub(message.content, 2)
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
                            value = "em construção\n",
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
                            value = "`atumalaca`\n`bandido`\n`cavalo`\n`dizerumacoisa`\n`doot`\n`ehmsmeh`\n`eutbm`\n`fdp`\n`irra`\n`kekw`\n`lagarto`\n`miau`\n`naova`\n`pare`\n`pauquebrando`\n`potencia`\n`qdelicia`\n`qisso`\n`rapaz`\n`ratinho`\n`saidesgraca`\n`tamaluco`\n`uepa`\n`xiii`\n",
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
            
        elseif(msgCmd == 'play' or msgCmd == 'p')    then
            if(msgArg == nil or msgArg == '')  then
                message.channel:send('Envie um link junto do comando play')
            elseif (member) then
                local stream = {}

                InitStream(msgArg, stream)
                local status = coroutine.status(Play)

                if(stream == -1)  then
                    message.channel:send('Erro: Vídeo não disponível')
                else
                    local connection = member.voiceChannel:join()

                    stream.connection = connection
                    stream.requester = member
                    stream.channel = message.channel
                    
                    table.insert(streamQueue, stream)
                    print(status)
                    if (status == "dead" or status == "normal" or status == "suspended") then
                        coroutine.resume(Play, streamQueue)
                    end
                end
            end
            answered = true

        elseif(File_exists(msgCmd)) then
            local connection = member.voiceChannel:join()
            coroutine.wrap(function() 
                connection:playFFmpeg('audios/'..msgCmd..'.mp3')
                print('done')
            end)()
            answered = true

        elseif(msgCmd == 'discordia')    then
            message.channel:send('https://github.com/SinisterRectus/Discordia')
            answered = true

        elseif(msgCmd == 'membercount' and guild)    then
            message.channel:send('O servidor está atualmente com '..guild.totalMemberCount..' membros')
            answered = true
        
        elseif(msgCmd == 'region' and guild)    then
            message.channel:send('Região do servidor: '..guild.region)
            answered = true
            
        elseif(answered == false) then
            local result = Dice(msgCmd)
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
Dice = function(message)
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

function File_exists(name)
    local f=io.open('audios/'..name..'.mp3',"r")
    if f~=nil then
        io.close(f)
        return true 
    else 
        return false 
    end
end

function TableLength(table)
    local count = 0
    for x, y in pairs(table) do 
        count = count+1 
    end
    return count
end

function InitStream(url, stream)

    local cmd = 'youtube-dl -j --skip-download -f 251 '..url
    local handle
    local data = {}

    coroutine.wrap( function()
        handle = assert(io.popen(cmd, 'r'))
    end)()
    
    data = json.decode(handle:read())
    handle:close()
    
    if(not data) then
        return -1
    end

    stream.url = data.url
    stream.title = data.title

end
--[[
function playStream(stream)
    if(stream ==  nil) then return -1 end

    coroutine.wrap( function ()
        stream.channel:send("Playing "..stream.title)
        stream.connection:playFFmpeg(stream.url)
        return 1
    end)()
end

function pushQueue(queue, stream)

    print(stream.title.." added in queue on pos "..TableLength(queue))
    queue[TableLength(queue)] = stream

    stream.channel:send("Song "..stream.title.." added in queue on pos #"..TableLength(queue))

end

function removeQueue(queue)
    
    for x=0, TableLength(queue), 1 do
        queue[x] = queue[x+1]
        queue[x+1] = nil
    end
    print("removido")
end
]]--
Play = coroutine.create(function (queue)

    while true do

        if (TableLength(queue) > 0)    then
            print("um eh maior q zero")
            local actualStream = queue[1]
            print(actualStream.title)

            table.remove(queue, 1)
            actualStream.channel:send("Playing "..actualStream.title)
            actualStream.connection:playFFmpeg(actualStream.url)
        else
            break
        end
    end
end)

-- declare local variables
--// exportstring( string )
--// returns a "Lua" portable version of the string
local function exportstring( s )
    return string.format("%q", s)
end

--// The Save Function
function table.save(  tbl,filename )
    local charS,charE = "   ","\n"
    local file,err = io.open( filename, "wb" )
    if err then return err end

    -- initiate variables for save procedure
    local tables,lookup = { tbl },{ [tbl] = 1 }
    file:write( "return {"..charE )

    for idx,t in ipairs( tables ) do
        file:write( "-- Table: {"..idx.."}"..charE )
        file:write( "{"..charE )
        local thandled = {}

        for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
                if not lookup[v] then
                    table.insert( tables, v )
                    lookup[v] = #tables
                end
                file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
                file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
                file:write(  charS..tostring( v )..","..charE )
            end
        end

        for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
                local str = ""
                local stype = type( i )
                -- handle index
                if stype == "table" then
                    if not lookup[i] then
                        table.insert( tables,i )
                        lookup[i] = #tables
                    end
                        str = charS.."[{"..lookup[i].."}]="
                    elseif stype == "string" then
                        str = charS.."["..exportstring( i ).."]="
                    elseif stype == "number" then
                        str = charS.."["..tostring( i ).."]="
                    end
            
                if str ~= "" then
                stype = type( v )
                -- handle value
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert( tables,v )
                            lookup[v] = #tables
                        end
                        file:write( str.."{"..lookup[v].."},"..charE )
                    elseif stype == "string" then
                        file:write( str..exportstring( v )..","..charE )
                    elseif stype == "number" then
                        file:write( str..tostring( v )..","..charE )
                    end
                end
            end
        end
        file:write( "},"..charE )
    end
    file:write( "}" )
    file:close()
    print("table saved in "..filename)
end

client:run("Bot "..token)
