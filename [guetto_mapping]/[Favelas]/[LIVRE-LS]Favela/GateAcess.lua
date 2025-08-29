
---------------------------- PORTAO BOPE -------------------------------------------------

local Port1 = createObject(2990, -752.29998779297, -1122.0999755859, 61.299999237061, 0, 0, 30) 

local marke = createMarker(-752.22, -1122.117, 60.964, "cylinder", 6, 0, 0, 0, 0) 
  
function moveGate3(thePlayer) 
if getElementType( thePlayer ) ~= 'player' then return end
     if aclGetGroup('Everyone') and isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Everyone")) then
          moveObject(Port1, 200, -752.29998779297, -1122.0999755859, 56.299999237061) 
     end 
end 
addEventHandler("onMarkerHit", marke, moveGate3)

  
function move_back_gate3() 
     moveObject(Port1, 200, -752.29998779297, -1122.0999755859, 61.299999237061) 
end 
addEventHandler("onMarkerLeave", marke, move_back_gate3)

