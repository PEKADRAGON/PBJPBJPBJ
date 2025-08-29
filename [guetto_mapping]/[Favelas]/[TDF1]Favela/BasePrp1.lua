function createTheGate ()
   myGate1 = createObject ( 2930, 2659.2998046875, -758.400390625, 94.599998474121, 0, 0, 120.24536132812 )
end
 
addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )
 
function openMyGate ( )
   moveObject ( myGate1, 2500, 2659.2998046875, -758.400390625, 94.599998474121 )
end

addCommandHandler("e2",openMyGate)
 
function movingMyGateBack ()
   moveObject ( myGate1, 2500, 2659.2998046875, -758.400390625, 91.300003051758 )
end
addCommandHandler("e1",movingMyGateBack)