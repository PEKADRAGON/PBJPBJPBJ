local db = Connection( "sqlite", "db.db" )
db:exec( "CREATE TABLE IF NOT EXISTS vehicles(vehid, vinilid, r, g, b)" )

function consoleCreateMarker ( playerSource, commandName, id, r, g, b )
	if isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) or isObjectInACLGroup("user."..getAccountName(getPlayerAccount(playerSource)), aclGetGroup("Console")) then
		if ( playerSource and id ) then

		veh = getPedOccupiedVehicle(playerSource)
       	 removeElementData(veh,"dvo.color")

		if (r and g and b) then
			setElementData(veh, "dvo.color", {r, g, b})
		end
			removeElementData(veh, "dvo.id")
			setElementData(veh, "dvo.id", id)
			triggerClientEvent ( playerSource, "detachNeon", playerSource, source, id, veh )
		for _, v in ipairs (getElementsByType("vehicle")) do
			triggerClientEvent ( veh, "dvo.onStream", veh )
		--	iprint(getElementData(veh, "dvo.id").."сервер")
		end

		-- veh:GetID

    		q = db:query ( "SELECT * FROM vehicles WHERE vehid = ?", veh ):poll ( -1 )
		if q and #q > 0 then
			db:exec( "UPDATE vehicles SET vinilid = ?, r = ?, g = ?, b = ? WHERE vehid = ? ", id, r, g, b, veh )
		else
        	db:exec( "INSERT INTO vehicles VALUES (?, ?, ?, ?, ?)", veh, id, r, g, b )
		end
	end
end
end
addCommandHandler ( "setvinil2", consoleCreateMarker )

function test(playerSource, veh)
    q = db:query ( "SELECT * FROM vehicles WHERE vehid = ?", veh ):poll ( -1 )
	if q and #q > 0 then

	setElementData(veh, "dvo.id", q[1].vinilid)
	if (q[1].r) then
	r = q[1].r
	g = q[1].g
	b = q[1].b
	setElementData(veh, "dvo.color", {r,g,b})
	end
	triggerClientEvent ( playerSource, "detachNeon", playerSource, playerSource, q[1].vinilid, veh )
	triggerClientEvent ( veh, "dvo.onStream", veh )
end
end
addEvent ( "onSpecialViniltest", true )
addEventHandler ( "onSpecialViniltest", root, test)
    