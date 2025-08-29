--=============================================   Prostitutas   =============================================--    |                 

local ped1 = createPed ( 63, -2670.89819, 1427.52246, 907.36041, 200)
        setElementFrozen(ped1, true)
        setVehicleDamageProof(ped1, true)
        setPedAnimation(ped1, "STRIP", "STR_Loop_A")
        setElementInterior(ped1, 3)
    function cancelPedDamage ( attacker, source )
    cancelEvent()
end
addEventHandler ( "onClientPedDamage", ped1, cancelPedDamage )

local ped2 = createPed ( 64, -2660.78027, 1427.01379, 907.36041, 200)
        setElementFrozen(ped2, true)
        setVehicleDamageProof(ped2, true)
        setPedAnimation(ped2, "STRIP", "STR_Loop_B")
        setElementInterior(ped2, 3)
    function cancelPedDamage ( attacker, source )
    cancelEvent()
end
addEventHandler ( "onClientPedDamage", ped2, cancelPedDamage )

local ped3 = createPed ( 178, -2654.44678, 1427.01501, 907.36035, 200)
        setElementFrozen(ped3, true)
        setVehicleDamageProof(ped3, true)
        setPedAnimation(ped3, "STRIP", "STR_Loop_C")
        setElementInterior(ped3, 3)
    function cancelPedDamage ( attacker, source )
    cancelEvent()
end
addEventHandler ( "onClientPedDamage", ped3, cancelPedDamage )

local ped4 = createPed ( 85, -2678.26050, 1405.94141, 907.57031, 260)
        setElementFrozen(ped4, true)
        setVehicleDamageProof(ped4, true)
        setPedAnimation(ped4, "STRIP", "strip_E")
        setElementInterior(ped4, 3)
    function cancelPedDamage ( attacker, source )
    cancelEvent()
end
addEventHandler ( "onClientPedDamage", ped4, cancelPedDamage )

local ped5 = createPed ( 152, -2678.04199, 1414.72913, 907.57367, 260)
        setElementFrozen(ped5, true)
        setVehicleDamageProof(ped5, true)
        setPedAnimation(ped5, "STRIP", "STR_B2C")
        setElementInterior(ped5, 3)
    function cancelPedDamage ( attacker, source )
    cancelEvent()
end
addEventHandler ( "onClientPedDamage", ped5, cancelPedDamage )

--===========================================================================================================-- 
