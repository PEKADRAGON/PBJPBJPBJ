
---------------------------- PORTAO LIVRE -------------------------------------------------

local vagos1 = createObject(17951, 2533.1000976562, -1224.9000244141, 44.5, 0, 0, 0.96148681640625) 

-- local marke = createMarker(2566.839, -882.741, 95.409, "cylinder", 1.5, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if isObjectInACLGroup ( "user." .. getAccountName(getPlayerAccount(thePlayer)), aclGetGroup( "Console" )) then  
          moveObject(vagos1, 3000, 2533.1000976562, -1220.1999511719, 44.5) 
     end 
end 
addCommandHandler("h1", moveGate3) 
  
function move_back_gate3() 
     moveObject(vagos1, 3000, 2533.1000976562, -1224.9000244141, 44.5) 
end 
addCommandHandler("h2", move_back_gate3)


---------------------------- PORTAO LIVRE -------------------------------------------------

local mansao1 = createObject(985, 2075.1999511719, -174, -0.69999998807907, 0, 0, 310.50012207031) 

-- local marke = createMarker(2566.839, -882.741, 95.409, "cylinder", 1.5, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if isObjectInACLGroup ( "user." .. getAccountName(getPlayerAccount(thePlayer)), aclGetGroup( "Staff" )) then  
          moveObject(mansao1, 3000,  2075.1999511719, -174, -5.6999998092651) 
     end 
end 
addCommandHandler("mansao1", moveGate3) 
  
function move_back_gate3() 
     moveObject(mansao1, 3000,  2075.1999511719, -174, -0.69999998807907) 
end 
addCommandHandler("mansao2", move_back_gate3)



---------------------------- PORTAO GROVE -------------------------------------------------

local grove2 = createObject(17566, 2520.6000976562, -1673.8399658203, 15.60000038147, 0, 0, 0.37051391601562) 

-- local marke = createMarker(2566.839, -882.741, 95.409, "cylinder", 1.5, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if isObjectInACLGroup ( "user." .. getAccountName(getPlayerAccount(thePlayer)), aclGetGroup( "DPZ" )) then  
          moveObject(grove2, 3000, 2520.6000976562, -1673.8399658203, 11.800000190735) 
     end 
end 
addCommandHandler("dpz1", moveGate3) 
  
function move_back_gate3() 
     moveObject(grove2, 3000, 2520.6000976562, -1673.8399658203, 15.60000038147) 
end 
addCommandHandler("dpz2", move_back_gate3)

---------------------------- PORTAO -------------------------------------------------

---------------------------- PORTAO -------------------------------------------------

local Mecanica1 = createObject(2938, 2267.3999023438, -1983.5, 13.89999961853, 0, 0, 90) -- fabrica de drogas

-- local marke = createMarker(2566.839, -882.741, 95.409, "cylinder", 1.5, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if isObjectInACLGroup ( "user." .. getAccountName(getPlayerAccount(thePlayer)), aclGetGroup( "Everyone" )) then  
          moveObject(Mecanica1, 3000, 2267.3999023438,-1983.5, 9.8999996185303) 
     end 
end 
addCommandHandler("abrirmec", moveGate3) 
  
function move_back_gate3() 
     moveObject(Mecanica1, 3000, 2267.3999023438, -1983.5, 13.89999961853) 
end 
addCommandHandler("fecharmec", move_back_gate3)

---------------------------- PORTAO -------------------------------------------------

---------------------------- PORTAO -------------------------------------------------

local Escoria = createObject(2938, 838.70001220703, -1687.0999755859,14.699999809265, 0, 0, 90) -- fabrica de drogas

-- local marke = createMarker(2566.839, -882.741, 95.409, "cylinder", 1.5, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if isObjectInACLGroup ( "user." .. getAccountName(getPlayerAccount(thePlayer)), aclGetGroup( "MOTOCLUB" )) then  
          moveObject(Escoria, 3000, 838.70001220703,-1687.0999755859, 9.5) 
     end 
end 
addCommandHandler("mc1", moveGate3) 
  
function move_back_gate3() 
     moveObject(Escoria, 3000, 838.70001220703, -1687.0999755859, 14.699999809265) 
end 
addCommandHandler("mc2", move_back_gate3)

---------------------------- PORTAO -------------------------------------------------





