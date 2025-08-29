--[[

  __   __ __   ______   __   ______   __   __       ______   ______   _____    ______   ______    
  /\ \ / //\ \ /\  ___\ /\ \ /\  __ \ /\ "-.\ \     /\  ___\ /\  __ \ /\  __-. /\  ___\ /\  ___\   
  \ \ \'/ \ \ \\ \___  \\ \ \\ \ \/\ \\ \ \-.  \    \ \ \____\ \ \/\ \\ \ \/\ \\ \  __\ \ \___  \  
   \ \__|  \ \_\\/\_____\\ \_\\ \_____\\ \_\\"\_\    \ \_____\\ \_____\\ \____- \ \_____\\/\_____\ 
    \/_/    \/_/ \/_____/ \/_/ \/_____/ \/_/ \/_/     \/_____/ \/_____/ \/____/  \/_____/ \/_____/ 

    System developed by Guh#1074
    Desing developed by 𝐌𝐚𝐭𝐭𝐞𝐎#8349
    Store: https://discord.gg/TE3753XcPW

]]

config = {
    musics = { -- Lista de todas as múscias da loadscreen
        [1] = {
            author = "Loading...",
            path = "https://cdn.discordapp.com/attachments/1237888694292058194/1267196790059303013/WIU_-_Vidigal.mp3?ex=66a9e2ba&is=66a8913a&hm=10110903ac1e1e089f783e6aa9d166efa40f4089f5f52758b2c3a943e319719f&"
        },
        [2] = {
            author = "Loading...",
            path = "https://cdn.discordapp.com/attachments/1237888694292058194/1267196790059303013/WIU_-_Vidigal.mp3?ex=66a9e2ba&is=66a8913a&hm=10110903ac1e1e089f783e6aa9d166efa40f4089f5f52758b2c3a943e319719f&"
        }, 
        [3] = {
            author = "Loading...",
            path = "https://cdn.discordapp.com/attachments/1237888694292058194/1267196790059303013/WIU_-_Vidigal.mp3?ex=66a9e2ba&is=66a8913a&hm=10110903ac1e1e089f783e6aa9d166efa40f4089f5f52758b2c3a943e319719f&"
        },
        [4] = {
            author = "Loading...",
            path = "https://cdn.discordapp.com/attachments/1237888694292058194/1267196790059303013/WIU_-_Vidigal.mp3?ex=66a9e2ba&is=66a8913a&hm=10110903ac1e1e089f783e6aa9d166efa40f4089f5f52758b2c3a943e319719f&"
        },
    },
    images = { -- Lista de todas as imagens / background que vão aparecer na loadscreen
        {
            background = "me/assets/background/1/B1.png",
        },
        {
            background = "me/assets/background/1/B2.png",
        },
        {
            background = "me/assets/background/1/B3.png",
        },
        {
            background = "me/assets/background/1/B4.png",
        },
        {
            background = "me/assets/background/1/B5.png",
        },
        {
            background = "me/assets/background/1/B6.png",
        },
        {
            background = "me/assets/background/1/B7.png",
        },
    },
  
}

formatNumber = function(number)   
    local formatted = number   
    while true do       
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2')     
        if ( k==0 ) then       
            break   
        end   
    end   
    return formatted 
end 