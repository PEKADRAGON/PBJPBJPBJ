local tips = {
    {
        text = "➤ Pressione 'O' para abrir falar no chat global."
    },
    {
        text = "➤ Empregos novos, motoboy use a moto da sua garagem."
    },
    {
        text = "➤ Empregos novos, Entregador de cargas, pegue o emprego na prefeitura."
    },
    {
        text = "➤ Você sabia que pode personalizar seus veículos da garagem?"
    },
    {
        text = "➤ Para altearar sua mira, digite /cc + [1/5]"
    },
    {
        text = "➤ Pressione 'F11' para abrir o mapa."
    },
    {
        text = "➤ Dicas: Digite /noite ou /dia para mudar seu tempo."
    },
    {
        text = "➤ Retire o porte de armas para não ser preso."
    },
    {
        text = "➤ Compre o radio e conecte-se nas frequencias [0-999]"
    },
    {
        text = "➤ Pressione 'B' para abrir sua mochila."
    },
    {
        text = "➤ Digite /discord para copiar nosso discord."
    },
    {
        text = "➤ Pressione 'M' para mostrar o cursor do mouse."
    },
    {
        text = "➤ Utilidade: Você pode interagir com veículos e objetos com cursor;"
    },
    {
        text = "➤ Respeite os jogadores, vocês dependem uns dos outros para que haja um bom jogo."
    },
    {
        text = "➤ Contribua com o progresso da cidade, seja vip!"
    },
    {
        text = "➤ Utilidade: Para grudar no veículo digite /glue ou crie um bind"
    },
    {
        text = "➤ Utilidade: Roubar em area verde é passivo de banimento permanente!"
    },
    {
        text = "➤ Utilidade: Evite praticar anti rp, leia as regras!"
    },
    {
        text = "➤ Compre acessorios exclusivos nas lojas, veja o blip no F11."
    },
    {
        text = "➤ Utilize /ufpsboost ou /fpsboost , caso tenha o PC fraco."
    },
    {
        text = "➤ Pressione 'F4' e veja seus veículos."
    },
}

local count = 0

function sendTip()
    count = count + 1
    if count > #tips then
        count = 1
    end

    outputChatBox(tips[count].text, root, 189, 110, 0, true)
   -- triggerClientEvent(root, "showCustomMessage", resourceRoot, "#ffffffDica", ""..tips[count].text, "files/images/system.png")
end

setTimer(sendTip, (60*1000) * 2, 0)