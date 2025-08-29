local gate = createObject(2938, 2492.1000976562, 2350.8000488281, 12.39999961853, 0, 0, 90) 
local marker = createMarker(2492.1000976562, 2350.8000488281, 12.39999961853, "cylinder", 8, 0, 0, 0, 0) 
  
function moveGate(thePlayer) 
     if thePlayer and getElementType(thePlayer) == 'player' then
          if aclGetGroup('Everyone') and isObjectInACLGroup ("user."..getAccountName(getPlayerAccount(thePlayer)), aclGetGroup("Everyone")) then
               moveObject(gate, 600, 2492.1000976562, 2350.8000488281, 5.39999961853) 
          end
      end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 600, 2492.1000976562, 2350.8000488281, 12.39999961853)  
end 
addEventHandler("onMarkerLeave", marker, move_back_gate) 