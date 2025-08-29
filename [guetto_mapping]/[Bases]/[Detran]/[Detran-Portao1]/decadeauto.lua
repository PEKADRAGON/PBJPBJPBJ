local gate = createObject(975, 1212.4000244141, -925.29998779297, 43.599998474121, 0, 0, 190.00006103516) 
local marker = createMarker(1212.4000244141, -925.29998779297, 43.599998474121, "cylinder", 8, 0, 0, 0, 0) 
  
function moveGate(thePlayer) 
     if thePlayer and isElement(thePlayer) then 
          if getElementType(thePlayer) == 'player' then 
               if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(thePlayer)) , aclGetGroup("Everyone")) then 
                    moveObject(gate, 3000, 1207.2000244141, -926.1234567890, 43.599998474121) 
               end 
          end
     end
end 
addEventHandler("onMarkerHit", marker, moveGate) 
  
function move_back_gate() 
     moveObject(gate, 3000, 1212.4000244141, -925.29998779297, 43.599998474121) 
end 
addEventHandler("onMarkerLeave", marker, move_back_gate) 
