local entrada = createMarker(932.839, -1743.473, 15.367, 'cylinder', 1.0, 0, 255, 255, 0 )


function entrar( hitElement, matchingDimension )
    if getElementType( hitElement ) == "player" and not isPedInVehicle(hitElement)    
       then
        setElementPosition(hitElement, 839.167, -1739.51, 1739.252)
        end
end
addEventHandler( "onMarkerHit", entrada , entrar ) 
--------------------------------------------------
local saida = createMarker(889.107, -1712.254, 1743.4, 'cylinder', 1.0, 0, 255, 255, 0 )

function sair( hitElement, matchingDimension )
    if getElementType( hitElement ) == "player" and not isPedInVehicle(hitElement)    
       then
        setElementPosition(hitElement, 930.681, -1742.81, 14.955)
        end
end
addEventHandler( "onMarkerHit", saida , sair ) 


