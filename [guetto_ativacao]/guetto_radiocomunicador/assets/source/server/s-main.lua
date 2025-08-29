local functions = {};
local object = {};

----          ---- ----          ---- ----          ----
---- Proteção ---- ---- Proteção ---- ---- Proteção ----
----          ---- ----          ---- ----          ----

functions.isResourceProtected = function()
    -- return isAuthenticad[1];
    return true;
end

----       ---- ----       ---- ----       ----
---- Rádio ---- ---- Rádio ---- ---- Rádio ----
----       ---- ----       ---- ----       ----

addEvent("Radio Comunicador >> Add animations", true);
addEventHandler("Radio Comunicador >> Add animations", resourceRoot, 
    function(element)    
        triggerClientEvent(element, "Radio Comunicador >> Add client animations", root, element);
    end
);

addEvent("Radio Comunicador >> Remove animations", true)
addEventHandler("Radio Comunicador >> Remove animations", resourceRoot, 
    function(element)
        triggerClientEvent(element, "Radio Comunicador >> Remove client animations", root, element);
    end
);

addEvent("Radio Comunicador >> Change frequency", true)
addEventHandler("Radio Comunicador >> Change frequency", resourceRoot, 
    function(element, frequency)
        if (frequency == 0) then
            if (system['attributes']['object'].use) then
                if (object[element] and isElement(object[element])) then 
                    destroyElement(object[element]);
                    object[element] = false;
                end
            end

            geral.sNotify(element, getSystemLanguage("messages", "main", "radio power off"), "info");
            removeElementData(element, "frequency");
            return;
        end

        if (system['attributes']['frequencys'][frequency]) then
            if (not isPlayerHavePermission(element, system['attributes']['frequencys'][frequency])) then
                geral.sNotify(element, getSystemLanguage("messages", "main", "no has permission"), "error");
                return;
            end
        end

        if (system['attributes']['object'].use) then
            object[element] = createObject(system['attributes']['object'].model, Vector3(getElementPosition(element)));
            others.attachObject(object[element], element);
        end

        if (system['attributes']['webhook'].use) then
            createDiscordLogs(
                "Rádio Comunicador",
                "> O(A) "..(getPlayerName(element)).." (**"..(others.getPlayerID(element)).."**) entrou em uma frequência.",
                {
                    {
                        name = "`🚩` Frequência:",
                        value = "> "..(frequency and frequency or "Frequência não encontrada!"),
                        inline = true
                    }
                },
            system['attributes']['webhook'].link);
        end

        geral.sNotify(element, getSystemLanguage("messages", "main", "radio power on"):gsub("${frequency}", frequency), "success");
        setElementData(element, "frequency", frequency);
        return;
    end
);


----        ---- ----        ---- ----        ----
---- Outros ---- ---- Outros ---- ---- Outros ----
----        ---- ----        ---- ----        ----

addEventHandler("onPlayerDamage", root, 
    function()
        if (getElementHealth(source) < system['attributes'].health) then
            geral.sNotify(source, getSystemLanguage("messages", "main", "you have been disconnected"), "info");
            removeElementData(source, "frequency");

            if (object[source] and isElement(object[source])) then 
                destroyElement(object[source]);
            end
        end
    end
);

addEventHandler("onPlayerWasted", root, 
    function()
        geral.sNotify(source, getSystemLanguage("messages", "main", "you have been disconnected"), "info");
        removeElementData(source, "frequency");

        if (object[source] and isElement(object[source])) then 
            destroyElement(object[source]);
        end
    end
);

addEventHandler("onPlayerQuit", root, 
    function()
        if (object[source] and isElement(object[source])) then 
            destroyElement(object[source]);
        end
    end
);

function resourceStart()

end
addEventHandler("onResourceStart", resourceRoot, resourceStart);