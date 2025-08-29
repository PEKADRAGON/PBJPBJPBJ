function _call(_called, ...)
	local co = coroutine.create(_called);
	coroutine.resume(co, ...);
end

function sleep(time)
	local co = coroutine.running();
	local function resumeThisCoroutine()
		coroutine.resume(co);
	end
	setTimer(resumeThisCoroutine, time, 1);
	coroutine.yield();
end

function UpdateStates()
	_call(updateStates); 
end

function updateStates()
	_call(updateStates); 
end
addCommandHandler("salvarresources", UpdateStates)

function startResources ()
	local _connection = dbConnect("sqlite", "main.db");
	dbExec(_connection, "CREATE TABLE IF NOT EXISTS tblStartResources (nomeResource)");
	if(_connection) then
		local query = dbQuery(_connection, "SELECT nomeResource FROM tblStartResources");
		
		local result = dbPoll(query, -1);
		if(#result > 0) then
			for i = 1, #result do
				local resource = getResourceFromName(result[i]["nomeResource"]);
				local start  = startResource(resource);
			end
		end
		dbFree(query);
	else
	
	end
	destroyElement(_connection);
end
addEventHandler ( "onResourceStart", resourceRoot, startResources );

function updateStates()
	local _connection = dbConnect("sqlite", "main.db");
	if(_connection) then
		local query = dbQuery(_connection, "DELETE FROM tblStartResources");
		local result = dbPoll(query, -1);
		dbFree(query);
		for index, resources in ipairs(getResources()) do
			local state = getResourceState(resources);
			if(state == "running") then
				local query1 = dbQuery(_connection, "INSERT INTO tblStartResources (nomeResource) VALUES ('"..tostring(getResourceName(resources)).."')");
				local result1 = dbPoll(query1, -1);
				dbFree(query1);
			end
			print("Resource: " .. getResourceName(resources) .. " STATUS DO MOD SALVO!");
			sleep(200);
		end
	end
	destroyElement(_connection);
	print("Backup de Resources feito com sucesso!");
end