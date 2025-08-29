local application = {};

function setDiscordRichPresence()
    if (not isDiscordRichPresenceConnected()) then
        return;
    end

    resetDiscordRichPresenceData();
    local connected = setDiscordApplicationID(application.id);
    if (connected) then
        if (application['buttons'][1].use) then setDiscordRichPresenceButton(1, application['buttons'][1].name, application['buttons'][1].link); end
        if (application['buttons'][2].use) then setDiscordRichPresenceButton(2, application['buttons'][2].name, application['buttons'][2].link); end
        setDiscordRichPresenceDetails('Multi Theft Auto: San Andreas');
        setDiscordRichPresenceAsset(application['server'].logo, getPlayerName(localPlayer)..' #'..(getElementData(localPlayer, 'ID') or 0));
        setDiscordRichPresenceState(#getElementsByType("player")..' jogadores on-line');
        setDiscordRichPresenceStartTime(1);
    end
end

addEvent("addPlayerRichPresence", true);
addEventHandler("addPlayerRichPresence", resourceRoot,
    function(data)
        application = data;
        setDiscordRichPresence();
    end
);

addEventHandler("onClientPlayerJoin", root, 
    function()
        if (not isDiscordRichPresenceConnected()) then
            return;
        end
        setDiscordRichPresenceAsset(application['server'].logo, getPlayerName(localPlayer)..' #'..(getElementData(localPlayer, 'ID') or 0))
        setDiscordRichPresenceState(#getElementsByType("player")..' jogadores on-line');
    end
);

addEventHandler("onClientPlayerQuit", root, 
    function()
        if (not isDiscordRichPresenceConnected()) then
            return;
        end
        setDiscordRichPresenceAsset(application['server'].logo, getPlayerName(localPlayer)..' #'..(getElementData(localPlayer, 'ID') or 0))
        setDiscordRichPresenceState(#getElementsByType("player")..' jogadores on-line');
    end
);