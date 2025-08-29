local entrada = createMarker(1199.736, -893.099, 43.1, 'arrow', 1, 0, 255, 255, 255 ) -----Entrada

function entrar( hitElement, matchingDimension )
    if getElementType( hitElement ) == "player" and not isPedInVehicle(hitElement) then
        setElementPosition(hitElement, 1209.594, -887.444, 23.492) -----Saida da entrada
    end
end
addEventHandler( "onMarkerHit", entrada , entrar ) 
--------------------------------------------------
local saida = createMarker(1208.886, -884.56, 23.492, 'arrow', 1, 0, 255, 255, 255 ) -----Saida

function sair( hitElement, matchingDimension )
    if getElementType( hitElement ) == "player" and not isPedInVehicle(hitElement) then
        setElementPosition(hitElement, 1199.738, -890.897, 43.096) -----Saida Da Saida
    end
end
addEventHandler( "onMarkerHit", saida , sair )