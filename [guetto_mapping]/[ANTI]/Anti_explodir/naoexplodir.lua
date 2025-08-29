function ImpedirDeLigar ( playerSource )
   if math.floor ( getElementHealth( source ) + 0.5 ) > 350 then 
    setVehicleDamageProof( source, false )
    else 
    setVehicleEngineState( source, false )
    end 
end 
addEventHandler ( "onVehicleEnter", root, ImpedirDeLigar )


addEventHandler("onVehicleDamage", getRootElement(),function(loss)
	if getElementType ( source ) == "vehicle" then
		if not isVehicleDamageProof(source) then
			local HP = getElementHealth(source)-loss		
			if HP <= 350 then 
				HP = 350 
				setElementHealth(source,350)
				setVehicleEngineState(source,false)
				setVehicleDamageProof(source,true)
				if isVehicleBlown(source) then
					fixVehicle(source)	
					setElementHealth(source,350)
					setVehicleDamageProof(source,true)
				end 
			end
		end	
	end	
end)