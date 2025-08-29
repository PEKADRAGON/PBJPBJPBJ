--[[
──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
──────╔╦╗╔╗   ╔╗╔╗      ╔═╗      ╔╗   ╔╗       ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
──────║╔╝╠╣╔╦╗╠╣║╚╗╔═╗  ║═╣╔═╗╔╦╗╠╣╔═╗║╚╗╔═╗╔╦╗───────────◆Site: *EM BREVE*──────────────────────────────────────────────────────────────────────────────────────────────────
──────║╚╗║║║╔╝║║║╔╣║╬║  ╠═║║═╣║╔╝║║║╬║║╔╣║╩╣║╔╝───────────◆Youtube: www.youtube.com/channel/UCQUhptTJ4ltr3RsmXozPX_A─────────────────────────────────────────────────────────
──────╚╩╝╚╝╚╝ ╚╝╚═╝╚═╝  ╚═╝╚═╝╚╝─╚╝║╔╝╚═╝╚═╝╚╝ ───────────◆Discord: discord.gg/f5Rpf4y7zX────────────────────────────────────────────────────────────────────────────────────
───────────────────────────────────╚╝─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────  
────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 
]]
Info = {
	["Chave"] = "quebrei",
	["IP"] = "167.114.217.206", -- | Pon la ip de tu servidor aqui
}

ACLs = {
	"Everyone", -- aqui el acl requerido para utilizar el sistema
}

distanciaAgarrar = 3 --distacia que debe tener la persona para ejecutar la accion

bindMatar = "e" --tecla para matar
bindSoltar = "q" --tecla para soltar
bindAgarrar = "h" --tecla para agarrar la persona o ponga "nil" sin las comillas para no usar tecla
comandoAgarrar = "refem" --comando para agarrar con el arma en mano ponga "nil" sin las comillas para no usar comando

idsArmas = { --Id de las armas para poder ejecutar la accion, solo ponga pistola para que no se bugee
22,
24,
23,
4,
28,
32,
}

terTexto = true -- deje True para que aparezca el texto de soltar o matar, o ponga False para que no aparezca
textoSoltar = '"'..bindSoltar..'" - Soltar' -- texto que aparece en el lado de soltar
textoMatar = '"'..bindMatar..'" - Matar' --texto que aparece en el lado de matar
corSoltar = tocolor(0,255,0,255) --Cor em RGB do texto "Soltar" | tocolor(RED, GREEN, BLUE, TRANSPARENCIA)
corMatar = tocolor(255,0,0,255) --Cor em RGB do texto "Matar" | tocolor(RED, GREEN, BLUE, TRANSPARENCIA)
