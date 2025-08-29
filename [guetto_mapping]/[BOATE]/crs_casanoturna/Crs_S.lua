
-------Senhas-------

casanoturna = "b2702" -- Senha da entrada principal do Puteiro

quarto = "q2702" -- Senha da entrada Dos quartos

escritorio = "e2702" -- Senha da entrada Do local onde ficara as skins

--=============================================   Marker's   =============================================--


------- Entrar e sair -------
local markerJoin = createMarker(1522.487, -1506.187, 12.023 -1,"cylinder",1.1, 255, 0, 0, 50)
varToggle = false 
local markerQuit = createMarker(-2636.75928, 1402.80432, 906.46094 -1,"cylinder",1.1, 16, 102, 231, 50) 
setElementInterior(markerQuit,3)
local markerquartoent = createMarker(-2689.29248, 1423.48108, 906.46094 -1,"cylinder",1.1, 255, 0, 0, 50) 
setElementInterior(markerquartoent,3)
varToggle2 = false 
local markerquartosair = createMarker(965.79565, -53.27551, 1001.12457 -1,"cylinder",1.1, 16, 102, 231, 50) 
setElementInterior(markerquartosair,3)
local markerecr = createMarker(-2688.09106, 1430.97217, 906.46094 -1,"cylinder",1.1,  255, 0, 0, 50)
setElementInterior(markerecr,3)
varToggle1 = false 
local markerecrsair = createMarker(412.03015, -54.24107, 1001.89844 -1,"cylinder",1.1,  16, 102, 231, 50)
setElementInterior(markerecrsair,12)

------- Entrar Sexo -------
local markermen = createMarker(954.28119, -44.05214, 1001.12457 -1,"cylinder",1.1, 16, 102, 231, 50)
setElementInterior(markermen,3)
local markerwom = createMarker(950.67480, -44.05214, 1001.11719 -1,"cylinder",1.1, 16, 102, 231, 50) 
setElementInterior(markerwom,3)
local markerwomglub = createMarker(947.28284, -43.61607, 1001.11664 -1,"cylinder",1.1, 16, 102, 231, 50) 
setElementInterior(markerwomglub,3)
local markermenglub = createMarker(947.27155, -45.40409, 1001.11664 -1,"cylinder",1.1, 16, 102, 231, 50)
setElementInterior(markermenglub,3)
local markerpunheta = createMarker(947.00488, -61.31997, 1001.12457 -1,"cylinder",1.1, 16, 102, 231, 50)
setElementInterior(markerpunheta,3)

------- Pickups -------
local mensex = createPickup(954.28119, -44.05214, 1001.12457, 3, 1240, 1)
setElementInterior(mensex,3)
local womsex = createPickup(950.67480, -44.05214, 1001.11719, 3, 1240, 1)
setElementInterior(womsex,3)
local menglub = createPickup(947.27155, -45.40409, 1001.11664, 3, 1240, 1)
setElementInterior(menglub,3)
local womglub = createPickup(947.28284, -43.61607, 1001.11664, 3, 1240, 1)
setElementInterior(womglub,3)
local menpunheta = createPickup(947.00488, -61.31997, 1001.12457, 3, 1240, 1)
setElementInterior(menpunheta,3)


--============================================= Marker Entrar =============================================--

function toggleMarker(source) 

    if varToggle == false then
		varToggle = true
		setMarkerColor ( markerJoin, 16, 102, 231, 50 ) 
		outputChatBox("#1E90FFA Casa Noturna agora está #00FF00Aberta#1E90FF!",player,0,0,0,true )  
	elseif varToggle == true then
		varToggle = false  
		setMarkerColor ( markerJoin, 255, 0, 0, 50 )  
		outputChatBox("#1E90FFA Casa Noturna agora está #FF0000Fechada#1E90FF!",player,0,0,0,true )  
    end
end
addCommandHandler(casanoturna, toggleMarker)


function markerHit (player)
	if varToggle == false then
		outputChatBox("#1E90FFA Casa Noturna está #ff0000Fechada#1E90FF! Volte mais Tarde.",player,0,0,0,true )
	elseif varToggle == true then
		setElementPosition(player, -2636.75586, 1404.41309, 906.46094)
		setElementInterior(player, 3)
		setElementRotation(player,0,0,0)
		setCameraTarget(player, player)
	   
    end
end
addEventHandler("onMarkerHit", markerJoin, markerHit)

------------ sair ----------------

function sairput (source)

    setElementPosition(source, 1522.446, -1504.008, 13.045)
	setElementInterior(source, 0)
	setElementRotation(source,0,0,90)
	setCameraTarget(source,source)

end
addEventHandler("onMarkerHit",markerQuit,sairput)


--=============================================  Marker Escritório  =============================================--


function toggleMarker1(source) 
    if varToggle1 == false then
		varToggle1 = true
		outputChatBox("#1E90FFO Escritório agora está #00ff00Aberto#1E90FF!",source,0,0,0,true )
		setMarkerColor ( markerecr, 16, 102, 231, 50 )  
	elseif varToggle1 == true then
		varToggle1 = false  
		outputChatBox("#1E90FFO Escritório agora está #ff0000Fechado#1E90FF!",source,0,0,0,true )
		setMarkerColor ( markerecr, 255, 0, 0, 50 )    
    end
end
addCommandHandler(escritorio, toggleMarker1)


function markerHit1 (player)
	if varToggle1 == false then
		outputChatBox("#1E90FFO Escritório está #ff0000Fechado#1E90FF!",player,0,0,0,true )
		
	elseif varToggle1 == true then
		setElementPosition(player, 412.10077, -53.06142, 1001.89844)
		setElementInterior(player, 12)
		setElementRotation(player,0,0,0)
		setCameraTarget(player, player)

    end
end
addEventHandler("onMarkerHit", markerecr, markerHit1)
 
------------ sair ----------------

function sairescr (source)

	setElementPosition(source, -2688.21753, 1429.36157, 906.46094)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,180)
	setCameraTarget(source,source)

end
addEventHandler("onMarkerHit",markerecrsair,sairescr)


--=============================================  Marker Quarto Sexo =============================================--


function toggleMarker2(source) 
    if varToggle2 == false then
		varToggle2 = true
		setMarkerColor ( markerquartoent, 16, 102, 231, 50 ) 
		outputChatBox("#1E90FFOs Quartos agora estão #00FF00Abertos#1E90FF!",source,0,0,0,true )  
	elseif varToggle2 == true then
		varToggle2 = false  
		setMarkerColor ( markerquartoent, 255, 0, 0, 50 )  
		outputChatBox("#1E90FFOs Quartos agora estão #FF0000Fechados#1E90FF!",source,0,0,0,true )  
    end
end
addCommandHandler(quarto, toggleMarker2)


function markerHit2 (player)
	if varToggle2 == false then
		outputChatBox("#1E90FFOs Quartos estão #ff0000Fechados#1E90FF#1E90FF!",player,0,0,0,true )
	elseif varToggle2 == true then
		setElementPosition(player, 963.21039, -53.03334, 1001.12457)
		setElementInterior(player, 3)
		setElementRotation(player,0,0,180)
	   
    end
end
addEventHandler("onMarkerHit", markerquartoent, markerHit2)

------------ sair ----------------

function sairquarto (source)

    setElementPosition(source, -2687.12866, 1423.89526, 906.46094)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,270)
	setCameraTarget(source,source)
	
end
addEventHandler("onMarkerHit",markerquartosair,sairquarto)


--=============================================   Funçao sexo   =============================================--


function sexowom (source)

    setElementPosition(source, 952.615234375, -43.8564453125, 1001.8737792969)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,180)
	setCameraTarget(source,source)
	setPedAnimation ( source, "sex", "sex_1_cum_w", -1, true, false, false )

end
addEventHandler("onMarkerHit",markerwom,sexowom)


function sexomen (source)

    setElementPosition(source, 952.6279296875, -44.8916015625, 1001.8737792969)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,0)
	setCameraTarget(source,source)
	setPedAnimation ( source,"sex", "sex_1_cum_p", -1, true, false, false )

end
addEventHandler("onMarkerHit",markermen,sexomen)


--=============================================   Funçao Glub Glub   =============================================--


function glubwom (source)

    setElementPosition(source, 945.0556640625, -42.451171875, 1001.7656860352)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,0)
	setCameraTarget(source,source)
	setPedAnimation ( source, "BLOWJOBZ", "BJ_STAND_LOOP_W", -1, true, false, false )

end
addEventHandler("onMarkerHit",markerwomglub,glubwom)


function glubmen (source)

    setElementPosition(source, 944.9833984375, -41.4833984375, 1001.7658081055)
	setElementInterior(source, 3)
	setElementRotation(source,0,0,180)
	setCameraTarget(source,source)
	setPedAnimation ( source,"BLOWJOBZ", "BJ_STAND_LOOP_P", -1, true, false, false )

end
addEventHandler("onMarkerHit",markermenglub,glubmen)


--=============================================  Punheta  =============================================--

function punhetamen (source)

	setElementPosition(source, 942.49670, -61.18823, 1002.01563 )
	setElementInterior(source, 3)
	setElementRotation(source,0,0,270)
	setCameraTarget(source,source)
	setPedAnimation ( source, "paulnmac", "wank_loop", -1, true, false, false )

end
addEventHandler("onMarkerHit",markerpunheta,punhetamen)


--=============================================  Parar Animaçao   =============================================--


---------stop animation-----------

function animstop (source)
    setPedAnimation (source)
end
bindKey(source,"space", "down", animstop)

-------Setar Key--------

function loginkey ()
    bindKey(source, "space", "down", animstop)
end
addEventHandler("onPlayerJoin", root, loginkey)

-------Setar Key Online-------

for i, p in ipairs(getElementsByType("player")) do
    bindKey(p, "space", "down", animstop)
end
 
function addBindOn()
    bindKey(p, "space", "down", animstop)
end
addBindOn()