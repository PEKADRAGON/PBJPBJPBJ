local screen = {guiGetScreenSize()};
local x,y = (screen[1]/1366),(screen[2]/768)
local font = dxCreateFont('assets/font.ttf',10)
local font2 = dxCreateFont('assets/font.ttf',9)


createEvent = function(event,element,func)
	addEvent(''..event,true)
	addEventHandler(''..event,root,func)
end;

local codigoBlock  
local animrender = false 
local anim1 = false


createEvent('MD > Receive',root,function(ped,dados,codigoReceive)
	if ped and dados and anim1 == false and animrender == false then 
		pedElement = {}
		table.insert(pedElement,{ped,dados})
		codigoBlock = codigoReceive
		anim1 = true 
		addEventHandler("onClientRender", getRootElement(), render)
		setTimer(function() 
			removeEventHandler("onClientRender", getRootElement(), render)
			anim1 = false
		end,1000*Config['GlobalConfigs']['tempo_ocorrendoabordagem'],1)
	else
		if animrender == false and anim1 == false then
					pedElement = {}
			table.insert(pedElement,{ped}) 
			addEventHandler("onClientRender", getRootElement(), render2)
		    animrender = true 
			setTimer(function() 
				animrender = false
				removeEventHandler("onClientRender", getRootElement(), render2)
			end,1000*Config['GlobalConfigs']['tempo_ocorrendoabordagem'],1)
		end
	end
end)

local text = dxCreateTexture('assets/logo.png')

function render()
	dxDrawTextOnElement(pedElement[1][1], pedElement[1][2], 1, 10, 255, 255, 255, 255, 1.4, "default-bold")
end


function render2()
	dxDrawTextOnElement(pedElement[1][1],'Por por por ... favor nao me me me mate', 1, 10, 255, 255, 255, 255, 1.4, "default-bold")
end




codigo = ""

local buttons = {
	{x*842,y*404,x*88,y*50 , '1'};
	{x*931,y*404,x*88,y*50,'2'};
	{x*1021,y*404,x*88,y*50,'3'};
	{x*842,y*455,x*88,y*50 , '4'};
	{x*931,y*455,x*88,y*50,'5'};
	{x*1021,y*455,x*88,y*50,'6'};
	{x*842,y*506,x*88,y*50 , '7'};
	{x*931,y*506,x*88,y*50,'8'};
	{x*1021,y*506,x*88,y*50,'9'};

}

local visibleCofre = false 
local tickC = 0 

calculadora = function()
	local anim = interpolateBetween(x*0, 0, 0, x*267, 0, 0, (getTickCount() - tickC)/(Config['GlobalConfigs']['tempo_senha']*1000), "Linear")
	dxDrawRectangle(x*842,y*325,x*267,y*298,tocolor(21,21,21,255))
	dxDrawRectangle(x*842,y*325,x*267,y*34,tocolor(41,41,41,255))
	
	dxDrawRectangle(x*842,y*591,x*267,y*32,tocolor(41,41,41,255))
	dxDrawRectangle(x*842,y*591,anim,y*32,tocolor(132,113,247,255))
	
	dxDrawRectangle(x*842,y*361,x*267,y*42,tocolor(46,46,46,255))

	dxDrawImage(x*850,y*329,x*30,y*25,text)
  	dxDrawText('TRANCA DE SEGURANÇA',x*910*2,y*335,x*137,y*14, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
  	if codigo ~= "" then 
  		dxDrawText(codigo,x*852,y*375,x*137,y*14, tocolor(255, 255, 255, 255), 1.00, font2,  "left", "top", false, false, true, true, false)
	else
  		dxDrawText('DIGITE A SENHA PARA ABRIR O COFRE',x*852,y*375,x*137,y*14, tocolor(255, 255, 255, 255), 1.00, font2,  "left", "top", false, false, true, true, false)
  	end
	dxDrawRectangle(x*842,y*404,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*931,y*404,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*1021,y*404,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*842,y*455,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*931,y*455,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*1021,y*455,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*842,y*506,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*931,y*506,x*88,y*50,tocolor(41,41,41,255))
	dxDrawRectangle(x*1021,y*506,x*88,y*50,tocolor(41,41,41,255))
	dxDrawText('1',x*881*2,y*420,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('2',x*971*2,y*420,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('3',x*1060*2,y*420,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)	
	dxDrawText('4',x*881*2,y*470,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('5',x*971*2,y*470,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('6',x*1060*2,y*470,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)	
	dxDrawText('7',x*881*2,y*521,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('8',x*971*2,y*521,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	dxDrawText('9',x*1060*2,y*521,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)
	if QueryPosition(x*842,y*557,x*267,y*33) then 
		dxDrawRectangle(x*842,y*557,x*267,y*33,tocolor(198,240,144,255))
	else
		dxDrawRectangle(x*842,y*557,x*267,y*33,tocolor(159,190,120,255))
	end
	dxDrawText('ACEITAR',x*962*2,y*566,x*10,y*20, tocolor(255, 255, 255, 255), 1.00, font,  "center", "top", false, false, true, true, false)

end

function cancelDamage()
    if (getElementData (source, "imortal")) then
        cancelEvent()
    end
end
addEventHandler ("onClientPedDamage", root, cancelDamage)


local tentativas = 0
addEventHandler( "onClientClick", getRootElement(), 
function (button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld) 
	if visibleCofre == true and button == 'left' and state == 'down' then
		for i = 1 , #buttons do 
			if QueryPosition(buttons[i][1],buttons[i][2],buttons[i][3],buttons[i][4]) then 
				if #codigo < 4 then 
					codigo = codigo..buttons[i][5]
				end
				break
			end
		end 
		if QueryPosition(x*842,y*557,x*267,y*33) then 
			if codigo == codigoBlock then 
				openCofre()
				triggerServerEvent('MAD > TakeMoneySHOP',localPlayer,localPlayer)
			else
				codigo = ''
				tentativas = tentativas + 1 
				if tentativas > Config['GlobalConfigs']['tentativa'] then 
					removeEventHandler('onClientRender',root,calculadora)	
					showCursor(false)
					visibleCofre = false
					codigo = ''
					setElementData(localPlayer,'Digitando',nil)
					triggerServerEvent('MAD:ATIVARALARME',localPlayer,localPlayer)
					msgClient('Voce Errou a quantidade de tentativas a policia Foi acionada','info')
					return 
				end
			end
		end
	end
end)


timer = {}
openCofre = function()
	if getElementData(localPlayer,'Digitando') then
		if tentativas <  Config['GlobalConfigs']['tentativa'] then 
			if visibleCofre then 
				removeEventHandler('onClientRender',root,calculadora)	
				showCursor(false)
				visibleCofre = false
				codigo = ''
				setElementData(localPlayer,'Digitando',nil)
				if isTimer(timer[localPlayer]) then 
					killTimer(timer[localPlayer])
				end
			else
				visibleCofre = true 
				codigo = ''
				addEventHandler('onClientRender',root,calculadora)	
				showCursor(true)
				tickC = getTickCount()
				timer[localPlayer] = setTimer(function()
					removeEventHandler('onClientRender',root,calculadora)	
					showCursor(false)
					visibleCofre = false
					codigo = ''
					setElementData(localPlayer,'Digitando',nil)
				end,Config['GlobalConfigs']['tempo_senha']*1000,1)
			end
		else
			msgClient('o sistema de codificação esta travado','info')	
		end
	end
end
createEvent('MAD:OPENCOFRE',root,openCofre)


createEvent('MAD:PLAYALARM',root,function(element)
	local pos = {getElementPosition(element)}
	local sound = playSound3D('assets/alarm.mp3',pos[1],pos[2],pos[3])
	setSoundMaxDistance(sound, 150)
	setSoundVolume(sound,Config['GlobalConfigs']['volumeSound'])
end)


----------UTILS----------

function QueryPosition( x, y, width, height )
    if ( not isCursorShowing( ) ) then
        return false
    end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    
    return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end




function dxDrawTextOnElement(TheElement,text,height,distance,R,G,B,alpha,size,font,...)
	local x, y, z = getElementPosition(TheElement)
	local x2, y2, z2 = getCameraMatrix()
	local distance = distance or 20
	local height = height or 1

	if (isLineOfSightClear(x, y, z+2, x2, y2, z2, ...)) then
		local sx, sy = getScreenFromWorldPosition(x, y, z+height)
		if(sx) and (sy) then
			local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if(distanceBetweenPoints < distance) then
				dxDrawText(text, sx+1, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
			end
		end
	end
end

setDevelopmentMode(true)