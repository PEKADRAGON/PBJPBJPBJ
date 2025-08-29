---[[
    --» sᴄʀɪᴘᴛ ғᴇɪᴛᴏ ᴘᴏʀ » Pedrooooo#1554
--]]

config = {
                
    vips_acls = {
        "Marginal de grife", "Visionário", "Criminoso", "Luxuria"
    }, 
    
    markers = {
        prison = 1, 
        bail = 1, 
        hacking = 1, 
    }, 
    
    blips = {
        prison = 60, 
    }, 

    peds = {

        {2477.612, 2393.657, 7.807, 270}; -- Delegacia LV 0, 0, 270.128
        {2040.819, -1869.005, 13.71, 265 }; -- PF 0, 0, 273.193
    }; 

    prison = {
        prisoner_pos = {152.953, 1410.7, 12.406}, 
        free_pos = {258.797, 1401.019, 12.008}, 
        max_years = 60, -- tempo maximo preso
        arrest_police = true, -- true caso policiais possam ser presos
        acls = {    
            'Corporação', 
        }, 
    }, 

    articles = { -- ARTIGO, tempo 
        {16, 15}, -- ᴀʀᴛɪɢᴏ 16 - ᴘᴏʀᴛᴇ ɪʟᴇɢᴀʟ ᴅᴇ ᴀʀᴍᴀ [15 ᴍɪɴᴜᴛᴏs]
        {33, 25}, -- ᴀʀᴛɪɢᴏ 33 - ᴛʀᴀғɪᴄᴏ ᴅᴇ ᴅʀᴏɢʀᴀs [25 ᴍɪɴᴜᴛᴏs]
        {87, 25}, -- ᴀʀᴛɪɢᴏ 87 - ᴛʀᴀғɪᴄᴏ ᴅᴇ ᴀʀᴍᴀs [25 ᴍɪɴᴜᴛᴏs]
        {121, 40}, -- ᴀʀᴛɪɢᴏ 121- ʜᴏᴍɪᴄɪᴅɪᴏ ᴄᴜʟᴘᴏsᴏ [40 ᴍɪɴᴜᴛᴏs]
        {129, 10}, -- ᴀʀᴛɪɢᴏ 129 - ᴀɢʀᴇssãᴏ [10 ᴍɪɴᴜᴛᴏs]
        {131, 20}, -- ᴀʀᴛɪɢᴏ 131 - ᴛᴇɴᴛᴀᴛɪᴠᴀ ᴅᴇ ʜᴏᴍɪᴄɪᴅɪᴏ [20 ᴍɪɴᴜᴛᴏs]
        {147, 5}, -- ᴀʀᴛɪɢᴏ 147 - ᴀᴍᴇᴀçᴀ ᴄɪᴠɪʟ [5 ᴍɪɴᴜᴛᴏs]
        {148, 35}, -- ᴀʀᴛɪɢᴏ 148 - sᴇǫᴜᴇsᴛʀᴏ [35 ᴍɪɴᴜᴛᴏs]
        {150, 15}, -- ᴀʀᴛɪɢᴏ 150 - ɪɴᴠᴀsãᴏ ᴅᴇ ᴘᴀᴛʀɪᴍôɴɪᴏ ᴘʀɪᴠᴀᴅᴏ [15 ᴍɪɴᴜᴛᴏs]
        {155, 20}, -- ᴀʀᴛɪɢᴏ 155" sᴜʙᴛʀᴀɪʀ, ᴘᴀʀᴀ sɪ, ᴄᴏɪsᴀ ᴀʟʜᴇɪᴀ ᴍóᴠᴇʟ [20 ᴍɪɴᴜᴛᴏs]
        {157, 25}, -- ᴀʀᴛɪɢᴏ 157 - sᴜʙᴛʀᴀɪʀ ᴄᴏɪsᴀ ᴍᴏᴠᴇʟ ᴀʟʜᴇɪᴀ, ᴍᴇᴅɪᴀɴᴛᴇ ɢʀᴀᴠᴇ ᴀᴍᴇᴀçᴀ ᴏᴜ ᴠɪᴏʟᴇɴᴄɪᴀ ᴀ ᴘᴇssᴏᴀ/ᴅɪɴʜᴇɪʀᴏ sᴜᴊᴏ [25 ᴍɪɴᴜᴛᴏs]
        {161, 25}, -- ARTIG0 161 – INVASÃO DE PATRIMONIO PUBLICO [25 MINUTOS]
        {163, 10}, -- ᴀʀᴛɪɢᴏ 163 - ᴅᴇsᴛʀᴜɪʀ ᴘᴀᴛʀɪᴍᴏɴɪᴏ ᴘᴜʙʟɪᴄᴏ ᴇ ᴘʀɪᴠᴀᴅᴏ [10 ᴍɪɴᴜᴛᴏs]
        {173, 20}, -- ᴀʀᴛɪɢᴏ 173 - ᴄᴏʀʀɪᴅᴀ ɪʟᴇɢᴀʟ/ʀᴀᴄʜᴀ. [20 minutos]
        {175, 15}, -- ᴀʀᴛɪɢᴏ 175 - ᴅɪʀᴇçᴀᴏ ᴘᴇʀɪɢᴏsᴀ [15 minutos]
        {181, 5}, -- ᴀʀᴛɪɢᴏ 181 - ᴇsᴛᴀᴄɪᴏɴᴀʀ ᴀʀᴇᴀ ᴘʀᴏɪʙɪᴅᴏ [05 MINUTOS]
        {218, 15}, -- ᴀʀᴛɪɢᴏ 218 - ᴀʟᴛᴀ ᴠᴇʟᴏᴄɪᴅᴀᴅᴇ [15 MINUTOS]
        {246, 10}, -- ᴀʀᴛɪɢᴏ 246 - ᴏʙsᴛʀᴜçãᴏ ᴅᴇ ᴠɪᴀ ᴘᴜʙʟɪᴄᴀ [10 MINUTOS]
        {287, 10}, -- Artigo 287 – Apologia ao Trafico de drogas ou atos Crminosos [ 10 minutos ]
        {288, 15}, -- Artigo 288 – Formação de Quadrilha ou Associação Criminosa . OBS: 3 ou mais pessoas [ 15 minutos ]
        {309, 10}, -- ᴀʀᴛɪɢᴏ 309 - DIRIGIR SEM CARTEIRA [10 MINUTOS]
        {329, 15}, -- ᴀʀᴛɪɢᴏ 329 ʀᴇsɪsᴛêɴᴄɪᴀ ᴘʀɪsãᴏ/ғᴜɢᴀ [15 ᴍɪɴᴜᴛᴏs] OBS: SE INFRINGIR OS 2 A PENA SERA DUPLICADA PORTANTO [30 MINUTOS]
        {331, 25}, -- ᴀʀᴛɪɢᴏ 331 - ᴅᴇsᴀᴄᴀᴛᴏ ᴀᴜᴛᴏʀɪᴅᴀᴅᴇ [25 ᴍɪɴᴜᴛᴏs]
        {333, 25}, -- ᴀʀᴛɪɢᴏ 333 - sᴜʙᴏʀɴᴏ [25 ᴍɪɴᴜᴛᴏs]
        {340, 20}, -- ᴀʀᴛɪɢᴏ 340 - ᴛʀᴏᴛᴇ [20 ᴍɪɴᴜᴛᴏs]

        {11.1, 5}, -- PROCURADO PELA JUSTIÇA - ARTIGO 11
        {11.2, 10},
        {11.3, 15},
        {11.4, 20},
        {11.5, 25},
        {11.6, 30},
    }, 

    bail = {
        marker_position = {247.741, 1400.408, 12.016-1}, 
        price_per_second = 300,
        acls = {
            'Everyone', 
        }, 
    },
    
    hacking = {
        gate_id = 2930, 
        gate_position = {240.524+0.5, 1409.632-0.3, 11.11-5, 0, 180}, --- PORTAO
        marker_position = {230.829-1, 1411.444, 12.016-0.8}, -- HACKER
        delay_time = 10, 
        acls = {
            'Everyone', 
        }, 

        time_open_prison = 1, -- minutos
        delay = 1, 
    },
    
    job = {
        delivery_box_markers = {
            {194.309, 1440.999, 12.008}, 
        }, 
    },

    gates = {
        id_object_principal = 16773,  
        position_principal = {243.234, 1432.759, 12.008, 0, 0, 90}, 

        id_gate_in_prison = 1915, 
        position_in_prison = {245.60000610352, 1427.0999755859, 11, 0, 0, 90}, 
        position_in_prison2 = {217.69999694824, 1427.0999755859, 11, 0, 0, 90}, 
    }, 
}

r, g, b, a = 255, 255, 255, 255

function getPlayerFromID(id)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'ID') == tonumber(id) then
            return v
        end
    end
    return false
end

function messageC(text, type)
   return
end

function message(player, text, type) 
    return triggerClientEvent(player, 'showInfobox', player, type, text)
end