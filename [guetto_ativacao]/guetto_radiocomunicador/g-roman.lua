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

configLicense = {
    ["User"] = "User ID (Discord)",
    ["Key"] = "User Key (Site)"
};

--[[
    Caso possua dúvidas de como utilizar o sistema, você poderá utilizar a nossa documentação!
    Porém, caso veja e ainda não sane as suas dúvidas, abra um ticket em nosso Discord.
    https://docs.romanscripter.com.br/

    --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]--

    Si tienes dudas sobre cómo utilizar el sistema, ¡puedes utilizar nuestra documentación!
    Sin embargo, si lo ves y aún no se resuelven tus dudas, abre un ticket en nuestro Discord.
    https://docs.romanscripter.com.br/

    --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]-- --[==]--

    If you have questions about how to use the system, you can use our documentation!
    However, if you see and your doubts are still not resolved, open a ticket on our Discord.
    https://docs.romanscripter.com.br/
]]--

system = {
    ['language'] = "pt-BR", -- Linguagem principal do sistema.
    
    ['attributes'] = {
        hud = { -- Configurações da interface do seu servidor.
            use = true, -- Opção para aparecer / sumir a interface (hud, velocimetro e minimapa) do seu servidor (true para sim e false para não).
            showHud = function(element, state) -- função para aparecer / sumir a interface (hud, velocimetro e minimapa).
                local data = getElementData(element, "guetto.showning.hud" ) or false 
                return setElementData(element, "guetto.showning.hud", not data and true or false)
            end 
        },

        talk = "capslock", -- Tecla que será utilizada para falar no rádio comunicador.
        health = 10, -- Vida mínima para utilizar o rádio comunicador.
        command = "radio", -- Comando para abrir o rádio.

        webhook = { -- Logs de entrada / saída da rádio.
            use = true, -- Opção para utilizar ou não as logs no Discord.
            link = "https://discord.com/api/webhooks/1240192750662455296/yeF014s_xIL7LHy8_8jb3aVxGlTQCjK4cMcujPGHagfyGXAIDOIOp_Mqj-P7qHPam9KO" -- Link da webhook do Discord.
        },

        object = { -- Configurações do objeto.
            use = true, -- Opção para utilizar ou não o objeto do rádio comunicador (true para sim e false para não).
            model = 1429 -- ID do modelo que o objeto do rádio comunicador irá ficar.
        },

        frequencys = { -- Configurações das frequências ([Frequencia] = {"Permissões"}).
            [190] = {"Console", "Corporação"},
            [157] = {"Console", "UT"},
            [777] = {"Console", "GROTA"},
            [121] = {"Console", "YKZ"},
            [442] = {"Console", "TDT"},
            [1] = {"Console", "Staff"},
        }
    }
};

language = {
    ['pt-BR'] = {
        ['panel'] = {

        },

        ['messages'] = {
            ['main'] = {
                ['low health'] = "A sua vida está muito baixa para utilizar o rádio comunicador.",
                ['no has radio'] = "Você não possui um rádio comunicador.",
                ['radio power on'] = "Você entrou na frequência ${frequency}.",
                ['radio power off'] = "Você desligou o rádio comunicador.",
                ['no has permission'] = "Você não possui permissão para entrar nessa frequência.",
                ['frequency not inserted'] = "A frequência não foi inserida.",
                ['you have been disconnected'] = "Você foi desconectado do rádio comunicador e o mesmo foi desligado.",
            }
        }
    }
};

others = {
    ['getPlayerID'] = function(element)
        return getElementData(element, "ID") or "N/A";
    end,

    ['isPlayerHasRadio'] = function(element)
        return true;
    end,

    ['attachObject'] = function(object, element)
        return exports['pAttach']:attach(object, element, 4, -0.15,-0.02,0.09,90,46.8,18);
    end
};

notify = {
    ['success'] = "success",
    ['warning'] = "warning",
    ['error'] = "error",
    ['info'] = "info"
};

geral = {
    ['sNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(player, type, msg);
    end,

    ['cNotify'] = function(element, message, type)
        return exports['guetto_notify']:showInfobox(type, msg)
    end
};

function getSystemLanguage(type, window, index)
    return language[system.language][type][window][index];
end