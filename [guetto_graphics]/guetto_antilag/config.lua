--[[
      ______                        __      __                       ______   __    __               
 /      \                      |  \    |  \                     /      \ |  \  |  \              
|  $$$$$$\ __    __   ______  _| $$_  _| $$_     ______        |  $$$$$$\ \$$ _| $$_    __    __ 
| $$ __\$$|  \  |  \ /      \|   $$ \|   $$ \   /      \       | $$   \$$|  \|   $$ \  |  \  |  \
| $$|    \| $$  | $$|  $$$$$$\\$$$$$$ \$$$$$$  |  $$$$$$\      | $$      | $$ \$$$$$$  | $$  | $$
| $$ \$$$$| $$  | $$| $$    $$ | $$ __ | $$ __ | $$  | $$      | $$   __ | $$  | $$ __ | $$  | $$
| $$__| $$| $$__/ $$| $$$$$$$$ | $$|  \| $$|  \| $$__/ $$      | $$__/  \| $$  | $$|  \| $$__/ $$
 \$$    $$ \$$    $$ \$$     \  \$$  $$ \$$  $$ \$$    $$       \$$    $$| $$   \$$  $$ \$$    $$
  \$$$$$$   \$$$$$$   \$$$$$$$   \$$$$   \$$$$   \$$$$$$         \$$$$$$  \$$    \$$$$  _\$$$$$$$
                                                                                       |  \__| $$
                                                                                        \$$    $$
                                                                                         \$$$$$$
]]
config = {

    ["others"] = {
        ["key"] = "f3"
    };

    ["settings"] = {

        {title = "Limitar FPS", description = "Ajuste o FPS de acordo com o seu Hardware.", type = "slidebar"},
        {title = "Renderização do mapa", description = "Ajuda a melhorar a suavidade do mapa na jogatina.", type = "slidebar"},
        {title = "Tamanho do sol/lua", description = "Recomendamos diminuir no maximo.", type = "slidebar"},
        {title = "Remover fumaça", description = "Deixa o Jogo mais leve.", type = "checkbox"},
        {title = "Disparo realista", description = "Veja os disparo das armas com mais qualidade.", type = "checkbox"},
        {title = "Ruas", description = "Uma textura HD, Para PC Médio.", type = "checkbox"},
        {title = "Vegetação do ambiente", description = "Remover arvores padrão.", type = "checkbox"},
        {title = "FXAA (Anti-aliasing)", description = "antisserrilhamento", type = "checkbox"},
        {title = "Plotagem", description = "Veículos plotados (VTR's & Carros Gang)", type = "checkbox"},
        {title = "Chat", description = "Chat do servidor, topo esquerdo.", type = "checkbox"},
        {title = "Céu Realista", description = "Ceú Ultra real (PC Médio)", type = "checkbox"},
        {title = "Reflexo realista", description = "Reflexo 3D Ambientado.", type = "checkbox"},
        {title = "Àgua Realista", description = "Agua ultra realista (PC Médio)", type = "checkbox"},
        {title = "Pallet FX", description = "Correção Pallet", type = "checkbox"},
        --{title = "Shine FX", description = "Brilho Focado.", type = "checkbox"},
        {title = "Vignette FX", description = "Bordas escuras.", type = "checkbox"},
       -- {title = "Light FX", description = "Ambiente luminoso", type = "checkbox"},
        {title = "Depth FX", description = "Desfoque ao fundo (PC Médio)", type = "checkbox"},
        --{title = "Vegetação FX", description = "Vegetação HD, efeito realista.", type = "checkbox"},
        {title = "Blur", description = "Efeito especial (PC Médio)", type = "checkbox"},
        {title = "LUT", description = "Correção de cores padrão.", type = "checkbox"},
        {title = "SSAO", description = "Ambient occlusion (PC Médio).", type = "checkbox"},
        {title = "Contrast HDR", description = "Efeito HDR (PC Médio)", type = "checkbox"},
        {title = "Folhas Effects", description = "Folhas de maconha caindo.", type = "checkbox"},
        {title = "Hud", description = "Informações do personagem.", type = "checkbox"},
        {title = "Modo streaming", description = "Desligar musicas de script's.", type = "checkbox"},
            
    };

    ["miras"] = {
        {"assets/miras/1.png"};
        {"assets/miras/2.png"};
        {"assets/miras/3.png"};
        {"assets/miras/4.png"};
        {"assets/miras/5.png"};
        {"assets/miras/6.png"};
        {"assets/miras/7.png"};
    };

    sendMessageClient = function(message, type)
        return exports['guetto_notify']:showInfobox(type, message)
    end;
 
    sendMessageServer = function(player, message, type)
        return exports['guetto_notify']:showInfobox(player, type, message)
    end;

}

function registerEventHandler ( event, ... )
    addEvent( event, true )
    addEventHandler( event, ... )
end;

--[[
    {title = "Ocultar interface 4", description = "Desligar musicas do servidor.", type = "checkbox"},
    {title = "Ocultar interface 5", description = "Desligar musicas do servidor.", type = "checkbox"},
    {title = "Ocultar interface 6", description = "Desligar musicas do servidor.", type = "checkbox"},
    {title = "Ocultar interface 7", description = "Desligar musicas do servidor.", type = "slidebar"},
    {title = "Ocultar interface 8", description = "Desligar musicas do servidor.", type = "slidebar"},
    {title = "Ocultar interface 9", description = "Desligar musicas do servidor.", type = "slidebar"},
]]