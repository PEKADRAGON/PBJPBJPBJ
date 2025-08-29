addEventHandler("onPlayerJoin", root,
    function()
        setPlayerVoiceIgnoreFrom(source, root)
        setPlayerVoiceBroadcastTo(source, nil)
    end
)

addEvent("proximity-voice::broadcastUpdate", true)
addEventHandler("proximity-voice::broadcastUpdate", root,
    function (broadcastList)
        if client and source == client then else return end
        setPlayerVoiceIgnoreFrom(source, nil)
        setPlayerVoiceBroadcastTo(source, broadcastList)
    end
)