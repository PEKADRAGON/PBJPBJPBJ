--[[
            █▅▃▃▃▃▃▃▃▅█ https://discord.gg/SQUDj3DVU7 █▅▃▃▃▃▃▃▃▅█ 

    ██████╗  ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗██████╗ ███████╗██╗   ██╗
    ██╔══██╗██╔═══██╗████╗ ████║██╔══██╗████╗  ██║██╔══██╗██╔════╝██║   ██║
    ██████╔╝██║   ██║██╔████╔██║███████║██╔██╗ ██║██║  ██║█████╗  ██║   ██║
    ██╔══██╗██║   ██║██║╚██╔╝██║██╔══██║██║╚██╗██║██║  ██║██╔══╝  ╚██╗ ██╔╝
    ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║  ██║██║ ╚████║██████╔╝███████╗ ╚████╔╝ 
    ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝  ╚═══╝  

            █▅▃▃▃▃▃▃▃▅█ https://discord.gg/SQUDj3DVU7 █▅▃▃▃▃▃▃▃▅█ 
]]--

system = {
    ['attributes'] = {
        skin = 0, -- Skin do jogador ao trabalhar.
        object = 1220, -- ID do objeto.
        vehicle = 440, -- Veículo que será utilizado para entrega.

        ped = {
            skin = 147, -- Skin do PED.
            name = "#E1A244[NPC] #FFFFFFSupervisor", -- Nome do PED.

            animation = {
                use = false, -- Opção para usar ou não animação no ped (vísivel somente para o jogador).
                anim = "XPRESSscratch", -- Nome da animação.
                block = "ped" -- Bloco da animação.
            }
        },

        marker = { -- Configurações do marker.
            color = {225, 162, 68, 110}, -- Cor do marker.
            size = 1.5 -- Tamanho do marker.
        },

        positions = { -- Posições para iniciar o emprego.
            {
                veh = {915.894, -1221.695, 16.977, 260}, -- Posição de spawn do veículo.
                pos = {919.453, -1251.859, 16.211}, -- Posição de spawn do PED.
                rot = 90, -- Rotação do PED.
                
                blip = {
                    use = true, -- Opção para usar ou não blip.
                    icon = 42 -- Ícone do BLIP.
                }
            },
        }
    },

    ['routes'] = {
        payment = { -- Valor aleatório em os valores abaixo.
            min = 300, -- Pagamento minimo.
            max = 600 -- Pagamento máximo.
        }, 

        spawns = { -- Posições de rotas aleatórias.
            {1894.243, -2134.216, 15.466},
            {1840.771, -1720.139, 13.581},
            {1938.923, -1114.989, 27.452},
            {2068.22, -1628.977, 13.876},
            {1915.824, -1635.977, 14.078},
            {337.069, -1358.988, 14.508},
            {1567.9, -1897.438, 13.561},
            {1059.653, -344.957, 73.992},
            {1024.34, -983.152, 42.649},
        }
        
    };
}

others = {
    ['attachElement'] = function(object, element, bone, pX, pY, pZ, rX, rY, rZ)
        return exports['bone_attach']:attachElementToBone(object, element, bone, pX, pY, pZ, rX, rY, rZ);
    end,

    ['isAttachedElement'] = function(object)
        return exports["bone_attach"]:isElementAttachedToBone(object);
    end,

    ['createRadarBlip'] = function(x, y, z, icon, ...)
        return createBlip(x, y, z, icon, ...);
    end,

    ['detachElement'] = function(object)
        return exports['bone_attach']:detachElementFromBone(object);
    end,

    ['getPlayerJob'] = function(element)
        return true;
    end,
};

notify = {
    ['success'] = "success",
    ['warning'] = "warning",
    ['error'] = "error",
    ['info'] = "info"
};

geral = {
    ['sNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(element, type, message)
    end,

    ['cNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end
};