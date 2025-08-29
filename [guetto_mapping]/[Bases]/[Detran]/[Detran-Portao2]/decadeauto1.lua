local gate = createObject(9625, 1223.5999755859, -890.03430175781, 44.599999237061, 0, 0, 279.99755859375) 
local marker = createMarker(1223.5999755859, -890.03430175781, 44.599999237061, "cylinder", 8, 0, 0, 0, 0) 
  
function moveGate(thePlayer) 
     if thePlayer and isElement(thePlayer) then 
          if getElementType(thePlayer) == 'player' then 
               if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)) , aclGetGroup("DETRAN")) then 
                    moveObject(gate, 3000, 1223.5999755859, -890.03430175781, 38.899999237061) 
               end 
          end
     end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 3000, 1223.5999755859, -890.03430175781, 44.599999237061) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate) 
