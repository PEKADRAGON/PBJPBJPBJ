function createTheGate ()
 
         myGate1 = createObject ( 980, 927.29998779297,-1690.1999511719 ,15.60000038147 , 0, 0, 90 )

 
      end
 
      addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource () ), createTheGate )
 
 
 
 
 
 function openMyGate ( )
 moveObject ( myGate1, 500, 927.79998779297,-1697 ,14.199999809265 )
 end
 addCommandHandler("SKOLMTA001",openMyGate)
 
 
 function movingMyGateBack ()
 moveObject ( myGate1, 500, 927.29998779297,-1690.1999511719 ,15.60000038147 )
 end
 addCommandHandler("SKOLMTA002",movingMyGateBack)