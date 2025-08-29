config = {

    general = {
        ['wallDistance'] = 200, --| Distancia que o wallHack irá captar os jogadores.
    },

    names = {
        ['showName'] = false, --| Se você quer que apareça o nome do jogador, deixe como 'true', caso queira apenas o ID, deixe como 'false'
        ['drawDistance'] = 20, --| Distancia maxima de renderização do cracha.
        ['scale'] = {
            font = 1.0,
            height = 0.42,
        },
    },

    elements = {
        ["id"] = "ID", --| elementData do seu sistema de ID.
        ["hunger"] = "fome", --| elementData do seu sistema de fome.
        ["thirst"] = "sede", --| elementData do seu sistema de sede.
        ["fuel"] = "fuel", --| elementData do seu sistema de gasolina.
    },

    idle = {
        ['kickPlayer'] = false, --| Habilitar a expulsão do jogador em caso de inatividade.
        ['idleMin'] = 15, --| Tempo que é reconhecido como inatividade.
        ['toleranceTime'] = 320, --| Tempo de tolerancia para expulsão.
        ['verifyTimer'] = 5, --| Tempo de verificação de inatividade ( Tempos menores que '5' podem causar lag no servidor ).
        ["kickMessage"] = "Você ficou muito tempo inativo no servidor e foi expulso.", --| Mensagem de expulsão do jogador.
    },

    commands = {
        ['adminRoles'] = {
            { acl = "Fundador", role = "fundador" },
            { acl = "Staff", role = "staff" },
            { acl = "Developer", role = "developer" },
            { acl = "Influencer", role = "influencer" },
            { acl = "Patrocinador", role = "patrocinador" },
            { acl = "Marginal de grife", role = "Marginal de grife" },
            { acl = "Visionário", role = "visionário" },
            { acl = "Criminoso", role = "criminoso" },
            { acl = "Luxuria", role = "luxuria" },
            { acl = "Corporação", role = "policial" },
        },
    },
    
    roles = {
        ['fundador'] = { name = "Fundador", color = "9E3227"},
        ['developer'] = { name = "Desenvolvedor", color = "358D90"},
        ['influencer'] = { name = "Influencer", color = "A83232"},
        ['staff'] = { name = "Staff", color = "B26433"},
        ['patrocinador'] = { name = "Patrocinador", color = "4232A8"},
        ['Marginal de grife'] = { name = "VIP Marginal de grife", color = "7332A8"},
        ['visionário'] = { name = "VIP Visionário", color = "3240A8"},
        ['criminoso'] = { name = "VIP Criminoso", color = "329DA8"},
        ['luxuria'] = { name = "VIP Luxuria", color = "38A832"},
        ['policial'] = { name = "Policial", color = "3262A8"},
        ['criminoso'] = { name = "Criminoso", color = "#ff0000"},
        ['luxuria'] = { name = "Luxuria", color = "#eddb18"},
        ['Visionário'] = { name = "Visionário", color = "#9408ff"},
        ['marginal de grife'] = { name = "Marginal de Grife", color = "#ff8b0f"},
    },
}

message = function(element, message, style)
    if (element and isElement(element) and getElementType(element) == "player") then 
        triggerClientEvent(element, "addBox", element, message, style)
    end
end